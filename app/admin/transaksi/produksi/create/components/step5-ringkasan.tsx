"use client";

import { useProduksi } from "../context/produksi-context";
import { Table, TableBody, TableCell, TableRow } from "@/components/ui/table";
import { Card, CardContent } from "@/components/ui/card";
import { CheckCircle2, AlertCircle } from "lucide-react";

export function Step5Ringkasan() {
  const { info, bahanBaku, packaging, hasil } = useProduksi();

  const totalBahan = bahanBaku.reduce((acc, curr) => acc + curr.subtotal, 0);
  const totalPackaging = packaging.reduce((acc, curr) => acc + curr.subtotal, 0);
  
  const grandTotal = totalBahan + totalPackaging;
  const totalKue = hasil.reduce((acc, curr) => acc + curr.jumlah, 0);
  
  const estimasiHPP = totalKue > 0 ? Math.round(grandTotal / totalKue) : 0;

  const isValid = bahanBaku.length > 0 && hasil.length > 0;

  return (
    <div className="space-y-6">
      <div className="mb-6 text-center">
        <h3 className="text-2xl font-bold text-primary">Ringkasan Produksi</h3>
        <p className="text-sm text-muted-foreground mt-1">Periksa kembali seluruh data sebelum menyimpan.</p>
      </div>

      {!isValid && (
        <div className="bg-destructive/10 border-destructive/20 border text-destructive px-4 py-3 rounded-lg flex items-center gap-3">
          <AlertCircle className="h-5 w-5" />
          <p className="text-sm font-medium">Data belum lengkap! Pastikan Anda sudah menambahkan minimal 1 Bahan Baku dan 1 Hasil Produksi.</p>
        </div>
      )}

      <div className="grid md:grid-cols-2 gap-6">
        <Card>
          <CardContent className="p-0">
            <Table>
              <TableBody>
                <TableRow>
                  <TableCell className="font-medium text-muted-foreground w-[150px]">Tanggal</TableCell>
                  <TableCell className="font-semibold">{info.tanggal}</TableCell>
                </TableRow>

                <TableRow>
                  <TableCell className="font-medium text-muted-foreground">PIC</TableCell>
                  <TableCell className="font-semibold">{info.pic || "-"}</TableCell>
                </TableRow>
                <TableRow>
                  <TableCell className="font-medium text-muted-foreground">Jumlah Kue Jadi</TableCell>
                  <TableCell className="font-bold text-green-600">{totalKue} Pcs</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-0">
            <Table>
              <TableBody>
                <TableRow>
                  <TableCell className="font-medium text-muted-foreground">Total Bahan Baku</TableCell>
                  <TableCell className="text-right font-medium">Rp {totalBahan.toLocaleString('id-ID')}</TableCell>
                </TableRow>
                <TableRow>
                  <TableCell className="font-medium text-muted-foreground">Total Packaging</TableCell>
                  <TableCell className="text-right font-medium">Rp {totalPackaging.toLocaleString('id-ID')}</TableCell>
                </TableRow>
                <TableRow className="bg-primary/5">
                  <TableCell className="font-bold text-primary text-base">Grand Total Biaya (HPP)</TableCell>
                  <TableCell className="text-right font-bold text-primary text-lg">Rp {grandTotal.toLocaleString('id-ID')}</TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>

      {totalKue > 0 && (
        <div className="flex items-center justify-center p-6 border-2 border-dashed border-primary/30 rounded-xl bg-primary/5">
          <div className="text-center space-y-2">
            <div className="text-sm font-medium text-muted-foreground uppercase tracking-wider">Estimasi HPP per Pcs</div>
            <div className="text-4xl font-black text-primary">Rp {estimasiHPP.toLocaleString('id-ID')}</div>
            <div className="text-xs text-muted-foreground">*(Total Biaya Bahan & Packaging dibagi Jumlah Produk Jadi)</div>
          </div>
        </div>
      )}

      {isValid && (
         <div className="flex items-center justify-center gap-2 text-green-600 bg-green-50 py-3 rounded-lg border border-green-200 mt-8">
           <CheckCircle2 className="h-5 w-5" />
           <span className="font-medium text-sm">Data produksi siap untuk disimpan ke database.</span>
         </div>
      )}
    </div>
  );
}
