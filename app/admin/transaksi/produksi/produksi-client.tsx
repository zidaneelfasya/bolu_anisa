"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Input } from "@/components/ui/input";
import { Search, Plus, Eye, CheckCircle2, Factory } from "lucide-react";
import Link from "next/link";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Card, CardContent } from "@/components/ui/card";

export function ProduksiClient({ data }: { data: any[] }) {
  const [search, setSearch] = useState("");
  const [selectedDetail, setSelectedDetail] = useState<any>(null);

  // Fungsi kalkulasi untuk meringkas data
  const processedData = data.map((item) => {
    const totalBahan = item.produksi_bahan?.reduce((acc: number, curr: any) => acc + (curr.subtotal || 0), 0) || 0;
    const totalPackaging = item.produksi_packaging?.reduce((acc: number, curr: any) => acc + (curr.subtotal || 0), 0) || 0;
    const totalGaji = item.gaji_harian?.reduce((acc: number, curr: any) => acc + (curr.nominal || 0), 0) || 0;
    
    const hppTotal = totalBahan + totalPackaging + totalGaji;

    let omsetTotal = 0;
    let qtyProduk = 0;
    item.produksi_hasil?.forEach((h: any) => {
      qtyProduk += h.jumlah;
      omsetTotal += (h.jumlah * (h.produk?.harga_jual || 0));
    });

    const grossProfit = omsetTotal - hppTotal;

    return {
      ...item,
      kalkulasi: {
        totalBahan,
        totalPackaging,
        totalGaji,
        hppTotal,
        omsetTotal,
        qtyProduk,
        grossProfit
      }
    };
  });

  const filteredData = processedData.filter(item => 
    item.nomor_produksi?.toLowerCase().includes(search.toLowerCase()) ||
    item.tanggal_produksi?.includes(search)
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Rekap Harian Produksi</h2>
          <p className="text-muted-foreground mt-1">Daftar riwayat produksi dan perhitungan Gross Profit.</p>
        </div>
        
        <Link href="/admin/transaksi/produksi/create">
          <Button className="bg-primary hover:bg-primary/90">
            <Plus className="mr-2 h-4 w-4" /> Produksi Baru
          </Button>
        </Link>
      </div>

      <div className="flex items-center gap-2 max-w-sm">
        <div className="relative w-full">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input 
            type="date" 
            className="pl-8"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-white rounded-md border">
        <Table>
          <TableHeader className="bg-slate-50">
            <TableRow>
              <TableHead>No. Produksi</TableHead>
              <TableHead>Tanggal</TableHead>
              <TableHead className="text-right">Biaya HPP</TableHead>
              <TableHead className="text-right">Potensi Omset</TableHead>
              <TableHead className="text-right">Gross Profit</TableHead>
              <TableHead className="text-center">Status</TableHead>
              <TableHead className="text-right">Aksi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                  Belum ada data produksi.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium text-blue-600">{item.nomor_produksi}</TableCell>
                  <TableCell>
                    {new Date(item.tanggal_produksi).toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'})}
                  </TableCell>
                  <TableCell className="text-right text-red-600 font-medium">
                    Rp {item.kalkulasi.hppTotal.toLocaleString('id-ID')}
                  </TableCell>
                  <TableCell className="text-right text-green-600 font-bold">
                    Rp {item.kalkulasi.omsetTotal.toLocaleString('id-ID')}
                  </TableCell>
                  <TableCell className="text-right font-bold text-primary">
                    Rp {item.kalkulasi.grossProfit.toLocaleString('id-ID')}
                  </TableCell>
                  <TableCell className="text-center">
                    {item.status === 'Selesai' ? (
                      <span className="inline-flex items-center rounded-full bg-green-100 px-2 py-0.5 text-xs font-medium text-green-800">
                        Selesai
                      </span>
                    ) : (
                      <span className="inline-flex items-center rounded-full bg-yellow-100 px-2 py-0.5 text-xs font-medium text-yellow-800">
                        {item.status}
                      </span>
                    )}
                  </TableCell>
                  <TableCell className="text-right">
                    <Button 
                      variant="outline" 
                      size="sm"
                      onClick={() => setSelectedDetail(item)}
                    >
                      <Eye className="h-4 w-4 mr-1" /> Detail
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {/* MODAL DETAIL (Meniru Excel Recap) */}
      <Dialog open={!!selectedDetail} onOpenChange={(open) => !open && setSelectedDetail(null)}>
        <DialogContent className="sm:max-w-[800px] max-h-[85vh] overflow-y-auto">
          {selectedDetail && (
            <>
              <DialogHeader>
                <DialogTitle className="flex items-center text-2xl text-primary border-b pb-4">
                  <Factory className="mr-3 h-6 w-6" />
                  Rincian Produksi: {selectedDetail.nomor_produksi}
                </DialogTitle>
              </DialogHeader>

              <div className="grid grid-cols-2 gap-4 mb-6 mt-2 text-sm">
                <div>
                      <div className="text-sm font-medium text-muted-foreground mb-1">Tanggal</div>
                      <div className="font-semibold text-slate-800">
                        {new Date(selectedDetail.tanggal_produksi).toLocaleDateString('id-ID', {day: 'numeric', month: 'long', year: 'numeric'})}
                      </div>
                </div>
                <div>
                  <p className="text-muted-foreground">PIC</p>
                  <p className="font-semibold">{selectedDetail.pic_produksi || selectedDetail.pic || 'Tidak ada PIC'}</p>
                </div>
              </div>

              <div className="space-y-6">
                {/* PENGELUARAN BAHAN */}
                <Card className="border-red-200">
                  <div className="bg-red-50 px-4 py-2 font-bold text-red-900 border-b border-red-200">
                    A. PENGELUARAN BAHAN BAKU
                  </div>
                  <CardContent className="p-0">
                    <Table>
                      <TableHeader>
                        <TableRow className="hover:bg-transparent">
                          <TableHead className="h-8 py-1">Nama Bahan</TableHead>
                          <TableHead className="h-8 py-1 text-right">Pemakaian</TableHead>
                          <TableHead className="h-8 py-1 text-right">Harga Satuan</TableHead>
                          <TableHead className="h-8 py-1 text-right">Total Biaya</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {selectedDetail.produksi_bahan?.map((b: any) => (
                          <TableRow key={b.id}>
                                <TableCell>{b.bahan_baku?.nama}</TableCell>
                                <TableCell className="text-right">{b.jumlah} {b.bahan_baku?.satuan}</TableCell>
                                <TableCell className="text-right">Rp {b.harga_satuan.toLocaleString('id-ID')}</TableCell>
                                <TableCell className="text-right font-medium">Rp {b.subtotal.toLocaleString('id-ID')}</TableCell>
                          </TableRow>
                        ))}
                        <TableRow className="bg-red-50/50">
                          <TableCell colSpan={3} className="py-2 font-bold text-right">TOTAL BAHAN</TableCell>
                          <TableCell className="py-2 font-bold text-right text-red-600">
                            Rp {selectedDetail.kalkulasi.totalBahan.toLocaleString('id-ID')}
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>

                {/* PENGELUARAN PACKAGING */}
                <Card className="border-orange-200">
                  <div className="bg-orange-50 px-4 py-2 font-bold text-orange-900 border-b border-orange-200">
                    B. PENGELUARAN PACKAGING
                  </div>
                  <CardContent className="p-0">
                    <Table>
                      <TableHeader>
                        <TableRow className="hover:bg-transparent">
                          <TableHead className="h-8 py-1">Nama Kemasan</TableHead>
                          <TableHead className="h-8 py-1 text-right">Pemakaian</TableHead>
                          <TableHead className="h-8 py-1 text-right">Harga Satuan</TableHead>
                          <TableHead className="h-8 py-1 text-right">Total Biaya</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {selectedDetail.produksi_packaging?.map((p: any) => (
                          <TableRow key={p.id}>
                                <TableCell>{p.packaging?.nama}</TableCell>
                                <TableCell className="text-right">{p.jumlah} Pcs</TableCell>
                                <TableCell className="text-right">Rp {p.harga_satuan.toLocaleString('id-ID')}</TableCell>
                                <TableCell className="text-right font-medium">Rp {p.subtotal.toLocaleString('id-ID')}</TableCell>
                          </TableRow>
                        ))}
                        <TableRow className="bg-orange-50/50">
                          <TableCell colSpan={3} className="py-2 font-bold text-right">TOTAL KEMASAN</TableCell>
                          <TableCell className="py-2 font-bold text-right text-orange-600">
                            Rp {selectedDetail.kalkulasi.totalPackaging.toLocaleString('id-ID')}
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>

                {/* GAJI PEKERJA */}
                {selectedDetail.kalkulasi.totalGaji > 0 && (
                  <Card className="border-blue-200">
                    <div className="bg-blue-50 px-4 py-2 font-bold text-blue-900 border-b border-blue-200">
                      C. PENGELUARAN TENAGA KERJA (BORONGAN)
                    </div>
                    <CardContent className="p-0">
                      <Table>
                        <TableBody>
                          {selectedDetail.gaji_harian?.map((g: any) => (
                            <TableRow key={g.id}>
                              <TableCell className="py-2">{g.karyawan?.nama} ({g.keterangan})</TableCell>
                              <TableCell className="py-2 text-right">Rp {(g.nominal||0).toLocaleString('id-ID')}</TableCell>
                            </TableRow>
                          ))}
                          <TableRow className="bg-blue-50/50">
                            <TableCell className="py-2 font-bold text-right">TOTAL GAJI</TableCell>
                            <TableCell className="py-2 font-bold text-right text-blue-600">
                              Rp {selectedDetail.kalkulasi.totalGaji.toLocaleString('id-ID')}
                            </TableCell>
                          </TableRow>
                        </TableBody>
                      </Table>
                    </CardContent>
                  </Card>
                )}

                {/* GRAND TOTAL HPP */}
                <div className="flex justify-between items-center bg-slate-900 text-white p-4 rounded-lg">
                  <span className="font-bold">TOTAL PENGELUARAN (HPP)</span>
                  <span className="text-xl font-black">Rp {selectedDetail.kalkulasi.hppTotal.toLocaleString('id-ID')}</span>
                </div>

                {/* HASIL PRODUKSI */}
                <Card className="border-green-200">
                  <div className="bg-green-50 px-4 py-2 font-bold text-green-900 border-b border-green-200 flex justify-between">
                    <span>HASIL PRODUKSI (OMSET)</span>
                    <span>Total Kue: {selectedDetail.kalkulasi.qtyProduk} Pcs</span>
                  </div>
                  <CardContent className="p-0">
                    <Table>
                      <TableHeader>
                        <TableRow className="hover:bg-transparent">
                          <TableHead className="h-8 py-1">Nama Produk</TableHead>
                          <TableHead className="h-8 py-1 text-right">Hasil Jadi</TableHead>
                          <TableHead className="h-8 py-1 text-right">Harga Jual/Pcs</TableHead>
                          <TableHead className="h-8 py-1 text-right">Potensi Omset</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {selectedDetail.produksi_hasil?.map((h: any) => (
                          <TableRow key={h.id}>
                                <TableCell>{h.produk?.nama}</TableCell>
                                <TableCell className="text-right">{h.jumlah} Pcs</TableCell>
                                <TableCell className="text-right">Rp {(h.produk?.harga_jual || 0).toLocaleString('id-ID')}</TableCell>
                                <TableCell className="text-right font-medium">Rp {(h.jumlah * (h.produk?.harga_jual || 0)).toLocaleString('id-ID')}</TableCell>
                          </TableRow>
                        ))}
                        <TableRow className="bg-green-50/50">
                          <TableCell colSpan={3} className="py-3 font-bold text-right text-lg">TOTAL POTENSI OMSET</TableCell>
                          <TableCell className="py-3 font-black text-right text-green-700 text-lg">
                            Rp {selectedDetail.kalkulasi.omsetTotal.toLocaleString('id-ID')}
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>

                {/* GROSS PROFIT CALCULATION */}
                <div className="flex justify-between items-center bg-primary/10 border border-primary/20 p-4 rounded-lg">
                  <div>
                    <span className="font-bold text-primary block">ESTIMASI GROSS PROFIT</span>
                    <span className="text-xs text-muted-foreground">(Total Omset dikurangi Total HPP)</span>
                  </div>
                  <span className="text-3xl font-black text-primary">Rp {selectedDetail.kalkulasi.grossProfit.toLocaleString('id-ID')}</span>
                </div>

              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
