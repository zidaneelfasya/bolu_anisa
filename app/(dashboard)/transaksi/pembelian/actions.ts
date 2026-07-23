"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getRiwayatPembelian() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("pembelian")
    .select(`
      *,
      pembelian_bahan_detail(id, jumlah, harga, subtotal, bahan_baku(id, nama, satuan)),
      pembelian_packaging_detail(id, jumlah, harga, subtotal, packaging(id, nama))
    `)
    .order("tanggal", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) {
    return [];
  }

  return data || [];
}

export async function submitPembelian(payload: any) {
  const supabase = await createClient();

  // 1. Insert ke tabel pembelian (Draf awal, total 0)
  const { data: pembelianData, error: pembelianErr } = await supabase
    .from("pembelian")
    .insert({
      tanggal: payload.tanggal,
      supplier: payload.supplier,
      total: 0 // Akan diupdate di RPC
    })
    .select("id")
    .single();

  if (pembelianErr || !pembelianData) {
    console.error("pembelianErr", pembelianErr);
    return { error: "Gagal membuat draf pembelian." };
  }

  const pembelianId = pembelianData.id;

  // 2. Insert Bahan Baku
  if (payload.bahanBaku && payload.bahanBaku.length > 0) {
    const bahanToInsert = payload.bahanBaku.map((b: any) => ({
      pembelian_id: pembelianId,
      bahan_id: b.id,
      jumlah: b.jumlah,
      harga: b.harga,
      subtotal: b.jumlah * b.harga
    }));
    const { error: bahanErr } = await supabase.from("pembelian_bahan_detail").insert(bahanToInsert);
    if (bahanErr) {
      console.error("bahanErr", bahanErr);
      return { error: "Gagal menyimpan detail bahan baku." };
    }
  }

  // 3. Insert Packaging
  if (payload.packaging && payload.packaging.length > 0) {
    const packToInsert = payload.packaging.map((p: any) => ({
      pembelian_id: pembelianId,
      packaging_id: p.id,
      jumlah: p.jumlah,
      harga: p.harga,
      subtotal: p.jumlah * p.harga
    }));
    const { error: packErr } = await supabase.from("pembelian_packaging_detail").insert(packToInsert);
    if (packErr) {
      console.error("packErr", packErr);
      return { error: "Gagal menyimpan detail packaging." };
    }
  }

  // 4. Jalankan RPC untuk menyelesaikan transaksi
  const { error: rpcErr } = await supabase.rpc("selesaikan_pembelian", {
    p_pembelian_id: pembelianId,
    p_user_id: null // TODO: pass actual user ID when auth is ready
  });

  if (rpcErr) {
    console.error("RPC Error:", rpcErr);
    return { error: "Gagal memproses stok dan cash flow: " + rpcErr.message };
  }

  revalidatePath("/transaksi/pembelian");
  return { success: true };
}
