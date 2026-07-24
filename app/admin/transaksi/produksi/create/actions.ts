"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getProduksiMasterData() {
  const supabase = await createClient();

  const [bahanRes, packRes, produkRes, karRes] = await Promise.all([
    supabase.from("bahan_baku").select("id, nama, satuan, stok, harga_terakhir").is("deleted_at", null).order("nama"),
    supabase.from("packaging").select("id, nama, jenis, stok, harga_per_pcs").is("deleted_at", null).order("nama"),
    supabase.from("produk").select("id, nama, kategori").is("deleted_at", null).order("nama"),
    supabase.from("karyawan").select("id, nama, jenis_gaji").eq("status", "Aktif").is("deleted_at", null).order("nama"),
  ]);

  return {
    bahanBaku: bahanRes.data || [],
    packaging: packRes.data || [],
    produk: produkRes.data || [],
    karyawan: karRes.data || [],
  };
}

export async function submitProduksi(payload: any) {
  const supabase = await createClient();
  
  // Auto-generate nomor_produksi (format: PRD-YYYYMMDD-HHMMSS)
  const dateObj = new Date();
  const nomorProduksi = `PRD-${dateObj.getFullYear()}${(dateObj.getMonth()+1).toString().padStart(2, '0')}${dateObj.getDate().toString().padStart(2, '0')}-${dateObj.getHours().toString().padStart(2, '0')}${dateObj.getMinutes().toString().padStart(2, '0')}${dateObj.getSeconds().toString().padStart(2, '0')}`;

  // 1. Insert ke tabel produksi (Draft)
  const { data: produksiDraft, error: prodErr } = await supabase
    .from("produksi")
    .insert({
      nomor_produksi: nomorProduksi,
      tanggal_produksi: payload.info.tanggal,
      pic_produksi: payload.info.pic,
      keterangan: payload.info.keterangan,
      status: "Sedang Diproses", // Akan diupdate oleh RPC menjadi Selesai
    })
    .select("id")
    .single();

  if (prodErr || !produksiDraft) {
    console.error("ProdErr", prodErr);
    return { error: "Gagal membuat draft produksi." };
  }

  const produksiId = produksiDraft.id;

  try {
    // 2. Insert bahan
    if (payload.bahanBaku.length > 0) {
      const bahanToInsert = payload.bahanBaku.map((b: any) => ({
        produksi_id: produksiId,
        bahan_id: b.id,
        jumlah: b.jumlah,
        harga_satuan: b.harga_satuan,
        subtotal: b.subtotal,
      }));
      const { error: bahanErr } = await supabase.from("produksi_bahan").insert(bahanToInsert);
      if (bahanErr) {
        console.error("bahanErr", bahanErr);
        throw new Error("Gagal menyimpan data bahan.");
      }
    }

    // 3. Insert packaging
    if (payload.packaging.length > 0) {
      const packToInsert = payload.packaging.map((p: any) => ({
        produksi_id: produksiId,
        packaging_id: p.id,
        jumlah: p.jumlah,
        harga_satuan: p.harga_satuan,
        subtotal: p.subtotal,
      }));
      const { error: packErr } = await supabase.from("produksi_packaging").insert(packToInsert);
      if (packErr) {
        console.error("packErr", packErr);
        throw new Error("Gagal menyimpan data packaging.");
      }
    }

    // 4. Insert hasil
    if (payload.hasil.length > 0) {
      const hasilToInsert = payload.hasil.map((h: any) => ({
        produksi_id: produksiId,
        produk_id: h.id,
        jumlah: h.jumlah,
        catatan: h.catatan,
      }));
      const { error: hasilErr } = await supabase.from("produksi_hasil").insert(hasilToInsert);
      if (hasilErr) {
        console.error("hasilErr", hasilErr);
        throw new Error("Gagal menyimpan data hasil.");
      }
    }

    // 5. Jalankan RPC untuk menyelesaikan transaksi
    // Untuk saat ini kita passing NULL sebagai user_id karena auth belum ada, 
    // sesuaikan dengan kebutuhan atau biarkan UUID default jika constraint mengizinkan.
    const { error: rpcErr } = await supabase.rpc("selesaikan_produksi", {
      p_produksi_id: produksiId,
      p_user_id: null
    });

    if (rpcErr) {
      console.error("RPC Error:", rpcErr);
      throw new Error(rpcErr.message || "Gagal menyelesaikan produksi (Stock tidak cukup / Error Server).");
    }

    revalidatePath("/admin/transaksi/produksi");
    return { success: true };

  } catch (err: any) {
    // Jika gagal, kembalikan error. 
    // Note: Anda mungkin perlu membuat logic kompensasi delete draft produksi jika gagal sebelum RPC dipanggil.
    // Tetapi karena ini tahap awal, kembalikan pesan error ke UI.
    return { error: err.message };
  }
}
