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

