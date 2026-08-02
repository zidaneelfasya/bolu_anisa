"use server";

import { createClient } from "@/utils/supabase/server";

export async function getLaporanData(startDate: string, endDate: string) {
  const supabase = await createClient();

  // 1. Get Initial Balance (Saldo Awal Kas)
  // Semua cash flow sebelum startDate
  const { data: earlyCashFlow, error: earlyErr } = await supabase
    .from("cash_flow")
    .select("jenis, nominal")
    .lt("tanggal", startDate)
    .is("deleted_at", null);

  let saldoAwalKas = 0;
  if (!earlyErr && earlyCashFlow) {
    earlyCashFlow.forEach(cf => {
      if (cf.jenis === "Pemasukan") saldoAwalKas += Number(cf.nominal);
      else if (cf.jenis === "Pengeluaran") saldoAwalKas -= Number(cf.nominal);
    });
  }

  // 2. Get Cash Flow in Range
  // Abaikan Pembelian Barang, Biaya Gaji Karyawan, dan Penjualan Produk karena akan di-fetch secara spesifik
  const { data: cashFlowData, error: cfErr } = await supabase
    .from("cash_flow")
    .select("*")
    .gte("tanggal", startDate)
    .lte("tanggal", endDate)
    .is("deleted_at", null)
    .not("kategori", "eq", "Pembelian Barang")
    .not("kategori", "eq", "Biaya Gaji Karyawan")
    .not("kategori", "eq", "Penjualan Produk");

  // 3. Get Gaji Harian in Range
  const { data: gajiData, error: gajiErr } = await supabase
    .from("gaji_harian")
    .select("*, karyawan(nama)")
    .gte("tanggal", startDate)
    .lte("tanggal", endDate)
    .is("deleted_at", null);

  // 4. Get Pembelian in Range with all details
  const { data: pembelianData, error: pembelianErr } = await supabase
    .from("pembelian")
    .select(`
      id, tanggal, total,
      pembelian_bahan_detail( jumlah, subtotal, bahan_baku(nama, satuan) ),
      pembelian_packaging_detail( jumlah, subtotal, packaging(nama) ),
      pembelian_produk_detail( jumlah, subtotal, produk(nama) )
    `)
    .gte("tanggal", startDate)
    .lte("tanggal", endDate)
    .is("deleted_at", null);

  // 5. Get Penjualan in Range with details
  const { data: penjualanData, error: penjualanErr } = await supabase
    .from("penjualan")
    .select(`
      id, tanggal, total, keterangan,
      penjualan_detail( jumlah, subtotal, produk(nama) )
    `)
    .gte("tanggal", startDate)
    .lte("tanggal", endDate)
    .is("deleted_at", null);

  return {
    success: true,
    saldoAwalKas,
    cashFlow: cashFlowData || [],
    gaji: gajiData || [],
    pembelian: pembelianData || [],
    penjualan: penjualanData || [],
    errors: {
      earlyErr: earlyErr?.message,
      cfErr: cfErr?.message,
      gajiErr: gajiErr?.message,
      pembelianErr: pembelianErr?.message,
      penjualanErr: penjualanErr?.message
    }
  };
}
