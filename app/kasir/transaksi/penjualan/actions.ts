"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getRiwayatPenjualan() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("penjualan")
    .select(`
      *,
      penjualan_detail(id, jumlah, harga, subtotal, produk(id, nama))
    `)
    .order("tanggal", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) {
    return [];
  }

  return data || [];
}

export async function submitPenjualan(payload: any) {
  const supabase = await createClient();

  // 1. Insert ke tabel penjualan (Draf awal, total 0)
  const { data: penjualanData, error: penjualanErr } = await supabase
    .from("penjualan")
    .insert({
      tanggal: payload.tanggal,
      keterangan: payload.keterangan || null,
      total: 0 // Akan diupdate di RPC
    })
    .select("id")
    .single();

  if (penjualanErr || !penjualanData) {
    console.error("penjualanErr", penjualanErr);
    return { error: "Gagal membuat struk penjualan awal." };
  }

  const penjualanId = penjualanData.id;

  // 2. Insert Detail Penjualan
  if (payload.produkList && payload.produkList.length > 0) {
    const pToInsert = payload.produkList.map((p: any) => ({
      penjualan_id: penjualanId,
      produk_id: p.id,
      jumlah: p.jumlah,
      harga: p.harga,
      hpp_satuan: p.hpp || 0,
      subtotal: p.jumlah * p.harga
    }));
    const { error: detailErr } = await supabase.from("penjualan_detail").insert(pToInsert);
    if (detailErr) {
      console.error("detailErr", detailErr);
      return { error: "Gagal menyimpan detail produk terjual." };
    }
  }

  // 3. Jalankan RPC untuk menyelesaikan transaksi (kurangi stok, nambah cashflow)
  const { error: rpcErr } = await supabase.rpc("selesaikan_penjualan", {
    p_penjualan_id: penjualanId,
    p_user_id: null // TODO
  });

  if (rpcErr) {
    console.error("RPC Error:", rpcErr);
    return { error: "Gagal memproses stok dan cash flow: " + rpcErr.message };
  }

  revalidatePath("/kasir/transaksi/penjualan");
  return { success: true };
}
