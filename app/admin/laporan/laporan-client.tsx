"use client";

import { useState, useEffect, useMemo } from "react";
import { format, parseISO } from "date-fns";
import { id } from "date-fns/locale";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Printer, Loader2 } from "lucide-react";
import { getLaporanData } from "./actions";

export function LaporanClient() {
  const [startDate, setStartDate] = useState(new Date().toISOString().split("T")[0]);
  const [endDate, setEndDate] = useState(new Date().toISOString().split("T")[0]);
  const [isLoading, setIsLoading] = useState(false);
  const [loadingState, setLoadingState] = useState("");
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      setLoadingState("Memuat data laporan dari server...");
      try {
        const result = await getLaporanData(startDate, endDate);
        setLoadingState("Membuat baris rekapitulasi...");
        // Sedikit jeda buatan agar user experience pergantian state terlihat mulus
        await new Promise(r => setTimeout(r, 300));
        setData(result);
      } catch (err) {
        console.error("Failed to load laporan", err);
      } finally {
        setIsLoading(false);
      }
    };
    
    if (startDate && endDate && startDate <= endDate) {
      fetchData();
    }
  }, [startDate, endDate]);

  const {
    saldoAwalKas,
    pemasukanGrouped,
    pengeluaranGrouped,
    totalPemasukan,
    totalPengeluaran,
    saldoAkhirKas,
    selisih,
    statusSelisih
  } = useMemo(() => {
    if (!data) return {
      saldoAwalKas: 0, pemasukanGrouped: [], pengeluaranGrouped: [],
      totalPemasukan: 0, totalPengeluaran: 0, saldoAkhirKas: 0,
      selisih: 0, statusSelisih: "Seimbang"
    };

    const saldoAwalKas = data.saldoAwalKas;
    const pemasukanRaw: any[] = [];
    const pengeluaranRaw: any[] = [];

    // 1. Masukkan Cash Flow General
    data.cashFlow.forEach((cf: any) => {
      const item = {
        kategori: cf.kategori || "Lainnya",
        keterangan: cf.deskripsi || "-",
        nominal: Number(cf.nominal) || 0,
        qtyDesc: "1x", // default 1x transaksi
      };
      if (cf.jenis === "Pemasukan") pemasukanRaw.push(item);
      else if (cf.jenis === "Pengeluaran") pengeluaranRaw.push(item);
    });

    // 2. Masukkan Penggajian ke Pengeluaran
    data.gaji.forEach((g: any) => {
      pengeluaranRaw.push({
        kategori: `Penggajian - ${g.jenis_gaji}`,
        keterangan: `Pembayaran ${g.jenis_gaji}`,
        nominal: Number(g.nominal) || 0,
        qtyDesc: "1x", // Akan digabung menjadi Frekuensi nantinya
      });
    });

    // 3. Masukkan Pembelian ke Pengeluaran (Bahan, Packaging, Produk)
    data.pembelian.forEach((p: any) => {
      // Bahan Baku
      p.pembelian_bahan_detail?.forEach((d: any) => {
        const nama = d.bahan_baku?.nama || "Bahan Tidak Diketahui";
        pengeluaranRaw.push({
          kategori: `Pembelian Bahan Baku - ${nama}`,
          prefixKeterangan: `Pembelian bahan: ${nama}`,
          keteranganDetail: p.keterangan ? p.keterangan.trim() : "",
          nominal: Number(d.subtotal) || 0,
          qtyVal: Number(d.jumlah) || 0,
          qtySatuan: d.bahan_baku?.satuan || "Unit"
        });
      });
      // Packaging
      p.pembelian_packaging_detail?.forEach((d: any) => {
        const nama = d.packaging?.nama || "Packaging Tidak Diketahui";
        pengeluaranRaw.push({
          kategori: `Pembelian Packaging - ${nama}`,
          prefixKeterangan: `Pembelian packaging: ${nama}`,
          keteranganDetail: p.keterangan ? p.keterangan.trim() : "",
          nominal: Number(d.subtotal) || 0,
          qtyVal: Number(d.jumlah) || 0,
          qtySatuan: "Pcs"
        });
      });
      // Produk Jadi
      p.pembelian_produk_detail?.forEach((d: any) => {
        const nama = d.produk?.nama || "Produk Tidak Diketahui";
        pengeluaranRaw.push({
          kategori: `Pembelian Produk - ${nama}`,
          prefixKeterangan: `Pembelian produk: ${nama}`,
          keteranganDetail: p.keterangan ? p.keterangan.trim() : "",
          nominal: Number(d.subtotal) || 0,
          qtyVal: Number(d.jumlah) || 0,
          qtySatuan: "Pcs"
        });
      });
    });

    // 4. Masukkan Penjualan ke Pemasukan (Produk)
    if (data.penjualan) {
      data.penjualan.forEach((p: any) => {
        if (!p.penjualan_detail || p.penjualan_detail.length === 0) {
          // Jika tidak ada detail (data lama/manual), masukkan totalnya saja
          pemasukanRaw.push({
            kategori: `Penjualan Produk`,
            keterangan: `Pendapatan Penjualan (Tanpa Detail)`,
            nominal: Number(p.total) || 0,
            qtyDesc: "1x",
          });
        } else {
          p.penjualan_detail.forEach((d: any) => {
            const nama = d.produk?.nama || "Produk Tidak Diketahui";
            const ketPenjualan = p.keterangan ? p.keterangan.trim() : "";
            pemasukanRaw.push({
              kategori: `Penjualan Produk - ${nama}`,
              prefixKeterangan: nama,
              keteranganDetail: ketPenjualan,
              nominal: Number(d.subtotal) || 0,
              qtyVal: Number(d.jumlah) || 0,
              qtySatuan: "Pcs"
            });
          });
        }
      });
    }

    // Fungsi Pengelompokan & Penjumlahan
    const groupByCategory = (items: any[]) => {
      const grouped: Record<string, any> = {};
      items.forEach(item => {
        const cat = item.kategori;
        
        // Handle logic pemisahan keterangan
        const detail = item.keteranganDetail !== undefined ? item.keteranganDetail : item.keterangan;
        const prefix = item.prefixKeterangan || "";

        if (!grouped[cat]) {
          grouped[cat] = {
            kategori: cat,
            waktu: "-",
            prefix: prefix,
            ketList: detail ? [detail] : [],
            jumlah: 0,
            frekuensi: 0,
            totalQty: 0,
            satuan: item.qtySatuan || ""
          };
        } else {
          // Hanya masukkan jika ada dan belum ada di array list
          if (detail && !grouped[cat].ketList.includes(detail)) {
            grouped[cat].ketList.push(detail);
          }
        }
        
        grouped[cat].jumlah += item.nominal;
        grouped[cat].frekuensi += 1;
        if (item.qtyVal) {
          grouped[cat].totalQty += item.qtyVal;
        }
      });

      return Object.values(grouped).map((g: any) => {
        let finalKeterangan = "";
        
        if (g.prefix) {
          const validList = g.ketList.filter(Boolean);
          if (validList.length > 0) {
            finalKeterangan = `${g.prefix} - ${validList.join(", ")}`;
          } else {
            // Fallback
            finalKeterangan = g.kategori.includes("Penjualan") 
              ? `Penjualan produk: ${g.prefix}` 
              : g.prefix; 
          }
        } else {
          finalKeterangan = g.ketList.join(", ") || "-";
        }

        // Limit keterangan to 60 characters so it doesn't break the PDF table layout
        if (finalKeterangan.length > 60) {
          finalKeterangan = finalKeterangan.substring(0, 60) + "...";
        }

        return {
          ...g,
          keterangan: finalKeterangan,
          qtyDisplay: g.totalQty > 0 
            ? `${g.totalQty.toLocaleString('id-ID')} ${g.satuan} (${g.frekuensi}x)`
            : `${g.frekuensi}x transaksi`
        };
      });
    };

    const pemasukanGrouped = groupByCategory(pemasukanRaw);
    const pengeluaranGrouped = groupByCategory(pengeluaranRaw);

    const totalPemasukan = pemasukanGrouped.reduce((acc, curr) => acc + curr.jumlah, 0);
    const totalPengeluaran = pengeluaranGrouped.reduce((acc, curr) => acc + curr.jumlah, 0);
    const finalSaldoAkhir = saldoAwalKas + totalPemasukan - totalPengeluaran;
    const selisih = totalPemasukan - totalPengeluaran;
    
    let statusSelisih = "Seimbang";
    if (selisih > 0) statusSelisih = "Surplus";
    else if (selisih < 0) statusSelisih = "Defisit";

    return {
      saldoAwalKas,
      pemasukanGrouped,
      pengeluaranGrouped,
      totalPemasukan,
      totalPengeluaran,
      saldoAkhirKas: finalSaldoAkhir,
      selisih,
      statusSelisih
    };
  }, [data]);

  useEffect(() => {
    // Update document title so that "Save as PDF" uses this filename
    const isSameDay = startDate === endDate;
    let titleDate = "";
    if (isSameDay && startDate) {
      titleDate = startDate;
    } else if (startDate && endDate) {
      titleDate = `${startDate}_sd_${endDate}`;
    }
    document.title = `Laporan_Bolu_Anisa_${titleDate}`;
    
    // Cleanup on unmount
    return () => {
      document.title = "Bolu Anisa"; 
    };
  }, [startDate, endDate]);

  const handlePrint = () => {
    window.print();
  };

  const isSameDay = startDate === endDate;
  const tglDisplay = isSameDay 
    ? (startDate ? format(parseISO(startDate), "dd MMMM yyyy", { locale: id }) : "-")
    : (startDate && endDate ? `${format(parseISO(startDate), "dd MMM yyyy", { locale: id })} s/d ${format(parseISO(endDate), "dd MMM yyyy", { locale: id })}` : "-");

  return (
    <div className="space-y-6">
      {/* Kontrol UI */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 print:hidden">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Laporan Cashflow</h2>
          <p className="text-muted-foreground mt-1">
            Laporan Harian / Periode Cashflow (Otomatis direkap)
          </p>
        </div>
        <div className="flex items-center gap-2 bg-slate-50 p-2 rounded-md border">
          <div className="flex flex-col">
            <span className="text-xs text-muted-foreground mb-1">Mulai Tanggal</span>
            <Input 
              type="date" 
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              className="w-auto h-8 text-sm"
            />
          </div>
          <div className="flex flex-col">
            <span className="text-xs text-muted-foreground mb-1">Sampai Tanggal</span>
            <Input 
              type="date" 
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              className="w-auto h-8 text-sm"
            />
          </div>
          <div className="flex flex-col self-end ml-2">
            <Button onClick={handlePrint} variant="outline" className="h-8 gap-2 bg-white" disabled={isLoading}>
              <Printer className="w-4 h-4" /> Cetak
            </Button>
          </div>
        </div>
      </div>

      <Card className="print:shadow-none print:border-none relative min-h-[500px]">
        {/* Loading Overlay */}
        {isLoading && (
          <div className="absolute inset-0 bg-white/80 z-10 flex flex-col items-center justify-center rounded-md">
            <Loader2 className="w-8 h-8 animate-spin text-primary mb-4" />
            <p className="text-sm font-medium text-slate-600 animate-pulse">{loadingState}</p>
          </div>
        )}

        <CardContent className="p-8 print:p-0">
          {/* Header Laporan */}
          <div className="text-center mb-8">
            <h1 className="text-xl font-bold uppercase">LAPORAN HARIAN CASHFLOW</h1>
            <h2 className="text-lg font-bold text-red-600">BOLU ANISA</h2>
          </div>

          <div className="mb-6 space-y-2">
            <div className="flex items-center">
              <div className="w-48 font-bold text-sm">Tanggal Laporan</div>
              <div className="mr-2">:</div>
              <div className="text-sm font-medium">{tglDisplay}</div>
            </div>
            <div className="flex items-center">
              <div className="w-48 font-bold text-sm">Saldo Awal Kas</div>
              <div className="mr-2">:</div>
              <div className="text-sm font-semibold">Rp {saldoAwalKas.toLocaleString('id-ID')}</div>
            </div>
          </div>

          {/* A. PEMASUKAN */}
          <div className="mb-6">
            <h3 className="font-bold text-sm mb-2">A. PEMASUKAN (KAS MASUK)</h3>
            <Table className="border print:border-black">
              <TableHeader className="bg-slate-100 print:bg-gray-200">
                <TableRow className="print:border-black">
                  <TableHead className="w-[50px] border print:border-black font-bold text-black text-center">No</TableHead>
                  <TableHead className="w-[120px] border print:border-black font-bold text-black text-center">Waktu/Qty</TableHead>
                  <TableHead className="border print:border-black font-bold text-black text-center">Kategori</TableHead>
                  <TableHead className="border print:border-black font-bold text-black text-center">Keterangan</TableHead>
                  <TableHead className="w-[150px] text-center border print:border-black font-bold text-black">Jumlah</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {pemasukanGrouped.length === 0 ? (
                  Array.from({ length: 6 }).map((_, i) => (
                    <TableRow key={`empty-in-${i}`} className="print:border-black">
                      <TableCell className="border print:border-black text-center py-3"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                    </TableRow>
                  ))
                ) : (
                  <>
                    {pemasukanGrouped.map((item, index) => (
                      <TableRow key={`in-${index}`} className="print:border-black">
                        <TableCell className="border print:border-black text-center">{index + 1}</TableCell>
                        <TableCell className="border print:border-black text-sm text-center">{item.qtyDisplay}</TableCell>
                        <TableCell className="border print:border-black font-medium">{item.kategori}</TableCell>
                        <TableCell className="border print:border-black text-sm">{item.keterangan}</TableCell>
                        <TableCell className="text-right border print:border-black font-medium">
                          Rp {item.jumlah.toLocaleString('id-ID')}
                        </TableCell>
                      </TableRow>
                    ))}
                    {/* Empty padding rows to match PDF structure */}
                    {Array.from({ length: Math.max(0, 6 - pemasukanGrouped.length) }).map((_, i) => (
                      <TableRow key={`pad-in-${i}`} className="print:border-black">
                        <TableCell className="border print:border-black text-center py-3"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                      </TableRow>
                    ))}
                  </>
                )}
                <TableRow className="bg-slate-50 print:bg-gray-100 print:border-black">
                  <TableCell colSpan={4} className="border print:border-black font-bold text-right uppercase">Total Pemasukan</TableCell>
                  <TableCell className="border print:border-black font-bold text-right text-green-700 print:text-black">
                    Rp {totalPemasukan.toLocaleString('id-ID')}
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>

          {/* B. PENGELUARAN */}
          <div className="mb-6">
            <h3 className="font-bold text-sm mb-2">B. PENGELUARAN (KAS KELUAR)</h3>
            <Table className="border print:border-black">
              <TableHeader className="bg-slate-100 print:bg-gray-200">
                <TableRow className="print:border-black">
                  <TableHead className="w-[50px] border print:border-black font-bold text-black text-center">No</TableHead>
                  <TableHead className="w-[120px] border print:border-black font-bold text-black text-center">Waktu/Qty</TableHead>
                  <TableHead className="border print:border-black font-bold text-black text-center">Kategori</TableHead>
                  <TableHead className="border print:border-black font-bold text-black text-center">Keterangan</TableHead>
                  <TableHead className="w-[150px] text-center border print:border-black font-bold text-black">Jumlah</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {pengeluaranGrouped.length === 0 ? (
                  Array.from({ length: 6 }).map((_, i) => (
                    <TableRow key={`empty-out-${i}`} className="print:border-black">
                      <TableCell className="border print:border-black text-center py-3"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                      <TableCell className="border print:border-black"></TableCell>
                    </TableRow>
                  ))
                ) : (
                  <>
                    {pengeluaranGrouped.map((item, index) => (
                      <TableRow key={`out-${index}`} className="print:border-black">
                        <TableCell className="border print:border-black text-center">{index + 1}</TableCell>
                        <TableCell className="border print:border-black text-sm text-center">{item.qtyDisplay}</TableCell>
                        <TableCell className="border print:border-black font-medium">{item.kategori}</TableCell>
                        <TableCell className="border print:border-black text-sm">{item.keterangan}</TableCell>
                        <TableCell className="text-right border print:border-black font-medium">
                          Rp {item.jumlah.toLocaleString('id-ID')}
                        </TableCell>
                      </TableRow>
                    ))}
                    {Array.from({ length: Math.max(0, 6 - pengeluaranGrouped.length) }).map((_, i) => (
                      <TableRow key={`pad-out-${i}`} className="print:border-black">
                        <TableCell className="border print:border-black text-center py-3"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                        <TableCell className="border print:border-black"></TableCell>
                      </TableRow>
                    ))}
                  </>
                )}
                <TableRow className="bg-slate-50 print:bg-gray-100 print:border-black">
                  <TableCell colSpan={4} className="border print:border-black font-bold text-right uppercase">Total Pengeluaran</TableCell>
                  <TableCell className="border print:border-black font-bold text-right text-red-700 print:text-black">
                    Rp {totalPengeluaran.toLocaleString('id-ID')}
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>

          {/* C. RINGKASAN HARIAN */}
          <div className="mb-8 break-inside-avoid">
            <h3 className="font-bold text-sm mb-2">C. RINGKASAN HARIAN</h3>
            <Table className="border print:border-black border-black w-full">
              <TableBody>
                <TableRow className="print:border-black border-black">
                  <TableCell className="border print:border-black border-black w-2/3">Saldo Awal Kas</TableCell>
                  <TableCell className="border print:border-black border-black text-right w-1/3">Rp {saldoAwalKas.toLocaleString('id-ID')}</TableCell>
                </TableRow>
                <TableRow className="print:border-black border-black">
                  <TableCell className="border print:border-black border-black">Total Pemasukan</TableCell>
                  <TableCell className="border print:border-black border-black text-right">Rp {totalPemasukan.toLocaleString('id-ID')}</TableCell>
                </TableRow>
                <TableRow className="print:border-black border-black">
                  <TableCell className="border print:border-black border-black">Total Pengeluaran</TableCell>
                  <TableCell className="border print:border-black border-black text-right">Rp {totalPengeluaran.toLocaleString('id-ID')}</TableCell>
                </TableRow>
                <TableRow className="print:border-black border-black">
                  <TableCell className="border print:border-black border-black">
                    Nett / Selisih ({statusSelisih})
                  </TableCell>
                  <TableCell className={`border print:border-black border-black text-right font-medium ${selisih > 0 ? 'text-green-600 print:text-black' : selisih < 0 ? 'text-red-600 print:text-black' : ''}`}>
                    {selisih < 0 ? "-" : ""}Rp {Math.abs(selisih).toLocaleString('id-ID')}
                  </TableCell>
                </TableRow>
                <TableRow className="bg-gray-200 print:bg-gray-200 font-bold print:border-black border-black">
                  <TableCell className="border print:border-black border-black">Saldo Akhir Kas (Saldo Awal + Pemasukan - Pengeluaran)</TableCell>
                  <TableCell className="border print:border-black border-black text-right">Rp {saldoAkhirKas.toLocaleString('id-ID')}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </div>

          {/* D. CATATAN TAMBAHAN & TTD */}
          <div className="break-inside-avoid mt-8">
            <h3 className="font-bold text-sm mb-2">D. CATATAN TAMBAHAN</h3>
            <div className="flex text-sm mb-6">
              <div className="w-32">Catatan lain</div>
              <div>: ...........................................................................................</div>
            </div>

            <div className="border border-black print:border-black flex text-center text-sm">
              <div className="flex-1 py-4">
                <div className="mb-20">Mengetahui,</div>
                <div>( ..................................... )</div>
                <div className="mt-1">Kurnia Dwi Lestari</div>
              </div>
              <div className="w-[1px] bg-black print:bg-black"></div>
              <div className="flex-1 py-4">
                <div className="mb-20">Dibuat oleh,</div>
                <div>( ..................................... )</div>
                <div className="mt-1">Yanti</div>
              </div>
            </div>
          </div>

        </CardContent>
      </Card>
    </div>
  );
}
