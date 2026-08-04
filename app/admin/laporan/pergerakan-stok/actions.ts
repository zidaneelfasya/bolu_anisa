"use server";

import { createClient } from "@/utils/supabase/server";

export async function getStockMovements(startDate?: string, endDate?: string, kategori?: string) {
  const supabase = await createClient();

  let query = supabase
    .from("stock_movements")
    .select("*")
    .order("created_at", { ascending: false });

  if (startDate) {
    query = query.gte("tanggal", startDate);
  }
  if (endDate) {
    query = query.lte("tanggal", endDate);
  }
  if (kategori && kategori !== "Semua") {
    query = query.eq("kategori_barang", kategori);
  }

  const { data: movements, error } = await query.limit(500); // Limit 500 for performance

  if (error || !movements) {
    console.error("Error fetching stock movements:", error);
    return [];
  }

  // Ambil data referensi nama barang
  const [produkRes, bahanRes, packRes] = await Promise.all([
    supabase.from("produk").select("id, nama"),
    supabase.from("bahan_baku").select("id, nama"),
    supabase.from("packaging").select("id, nama")
  ]);

  const mapNamaBarang = new Map<string, string>();
  if (produkRes.data) produkRes.data.forEach((p: any) => mapNamaBarang.set(p.id, p.nama));
  if (bahanRes.data) bahanRes.data.forEach((b: any) => mapNamaBarang.set(b.id, b.nama));
  if (packRes.data) packRes.data.forEach((p: any) => mapNamaBarang.set(p.id, p.nama));

  // Ambil nama user (karyawan / admin)
  const { data: usersData } = await supabase.from("karyawan").select("id, nama");
  const mapUser = new Map<string, string>();
  if (usersData) usersData.forEach((u: any) => mapUser.set(u.id, u.nama));

  return movements.map(m => ({
    ...m,
    nama_barang: mapNamaBarang.get(m.barang_id) || "Barang Tidak Ditemukan",
    nama_user: m.user_id ? (mapUser.get(m.user_id) || "Sistem") : "Sistem"
  }));
}
