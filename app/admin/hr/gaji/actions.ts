"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getGajiData() {
  const supabase = await createClient();

  const [gajiRes, karRes, rateRes] = await Promise.all([
    supabase.from("gaji_harian").select(`*, karyawan(nama)`).is("deleted_at", null).order("created_at", { ascending: false }),
    supabase.from("karyawan").select("id, nama").eq("status", "Aktif").is("deleted_at", null).order("nama"),
    supabase.from("rate_borongan").select("*").is("deleted_at", null)
  ]);

  return {
    riwayatGaji: gajiRes.data || [],
    karyawan: karRes.data || [],
    rates: rateRes.data || []
  };
}

export async function bayarGaji(payload: {
  tanggal: string,
  karyawan_id: string,
  jenis_gaji: string,
  nominal: number,
  keterangan: string
}) {
  const supabase = await createClient();

  // 1. Insert ke tabel gaji_harian
  const { data: gajiData, error: gajiErr } = await supabase
    .from("gaji_harian")
    .insert({
      tanggal: payload.tanggal,
      karyawan_id: payload.karyawan_id,
      jenis_gaji: payload.jenis_gaji,
      nominal: payload.nominal,
      keterangan: payload.keterangan
    })
    .select("id")
    .single();

  if (gajiErr) {
    return { error: "Gagal mencatat gaji: " + gajiErr.message };
  }

  // 2. Insert ke cash_flow sebagai pengeluaran
  const { error: cashErr } = await supabase
    .from("cash_flow")
    .insert({
      tanggal: payload.tanggal,
      kategori: "Biaya Gaji Karyawan",
      jenis: "Pengeluaran",
      deskripsi: payload.keterangan,
      nominal: payload.nominal,
      referensi_id: gajiData.id
    });

  if (cashErr) {
    return { error: "Gaji tercatat, tapi gagal mencatat ke cash flow: " + cashErr.message };
  }

  revalidatePath("/admin/hr/gaji");
  return { success: true };
}
