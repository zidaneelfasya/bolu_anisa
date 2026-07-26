"use server";

import { createClient } from "@/utils/supabase/server";

export async function getRiwayatProduksi() {
  const supabase = await createClient();

  // 1. Ambil data produksi beserta relasi bahan, packaging, dan hasil
  const { data: produksiData, error } = await supabase
    .from("produksi")
    .select(`
      id, 
      nomor_produksi, 
      tanggal_produksi, 
      shift, 
      pic_produksi, 
      status, 
      keterangan,
      produksi_bahan (
        id, jumlah, harga_satuan, subtotal,
        bahan_baku ( id, nama, satuan )
      ),
      produksi_packaging (
        id, jumlah, harga_satuan, subtotal,
        packaging ( id, nama, jenis )
      ),
      produksi_hasil (
        id, jumlah, catatan,
        produk ( id, nama, kategori, harga_jual )
      )
    `)
    .order("tanggal_produksi", { ascending: false })
    .order("created_at", { ascending: false });

  if (error || !produksiData) {
    // Return empty array gracefully without triggering Next.js error overlay
    return [];
  }
  
  if (produksiData.length === 0) return [];

  // 2. Ambil data gaji borongan secara terpisah karena referensi_id tidak di-join secara eksplisit di skema
  const produksiIds = produksiData.map((p) => p.id);
  const { data: gajiData } = await supabase
    .from("gaji_harian")
    .select("id, karyawan_id, nominal, keterangan, referensi_id, karyawan ( id, nama )")
    .in("referensi_id", produksiIds);

  // 3. Gabungkan data gaji ke dalam produksiData
  const combinedData = produksiData.map((prod) => {
    return {
      ...prod,
      gaji_harian: gajiData ? gajiData.filter(g => g.referensi_id === prod.id) : []
    };
  });

  return combinedData;
}

import { revalidatePath } from "next/cache";
import { submitProduksi } from "./create/actions";

export async function getProduksiById(id: string) {
  const supabase = await createClient();
  const { data: prod, error } = await supabase
    .from("produksi")
    .select(`
      *,
      produksi_bahan ( id, jumlah, harga_satuan, subtotal, bahan_id, bahan_baku(id, nama, satuan) ),
      produksi_packaging ( id, jumlah, harga_satuan, subtotal, packaging_id, packaging(id, nama) ),
      produksi_hasil ( id, jumlah, catatan, produk_id, produk(id, nama) )
    `)
    .eq("id", id)
    .single();

  if (error || !prod) {
    console.error("Error fetching produksi by id:", error);
    return null;
  }

  // Ambil data gaji terkait
  const { data: gajiData } = await supabase
    .from("gaji_harian")
    .select("id, karyawan_id, nominal, keterangan, jenis_gaji, referensi_id, karyawan ( id, nama )")
    .eq("referensi_id", id);

  return { ...prod, gaji_harian: gajiData || [] };
}

export async function deleteProduksi(id: string) {
  const supabase = await createClient();

  const { error } = await supabase.rpc("hapus_produksi", {
    p_produksi_id: id,
    p_user_id: null
  });

  if (error) {
    console.error("Delete Produksi Error:", error);
    return { error: error.message || "Gagal menghapus produksi." };
  }

  revalidatePath("/admin/transaksi/produksi");
  return { success: true };
}

export async function updateProduksi(id: string, payload: any) {
  // 1. Hapus yang lama (kembalikan stok)
  const delRes = await deleteProduksi(id);
  if (delRes.error) return delRes;

  // 2. Buat yang baru (dengan nomor yang sama)
  const submitRes = await submitProduksi(payload);
  if (submitRes.error) return submitRes;

  return { success: true };
}
