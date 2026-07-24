"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Plus, Search, TrendingUp, TrendingDown, Wallet } from "lucide-react";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { addManualCashFlow } from "./actions";
import { toast } from "sonner";
import { format } from "date-fns";
import { id } from "date-fns/locale";

type Props = {
  data: any[];
};

export function CashFlowClient({ data }: Props) {
  const [search, setSearch] = useState("");
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Form State
  const [tanggal, setTanggal] = useState(new Date().toISOString().split("T")[0]);
  const [kategori, setKategori] = useState("");
  const [jenis, setJenis] = useState("");
  const [nominalStr, setNominalStr] = useState("");
  const [deskripsi, setDeskripsi] = useState("");

  const filteredData = data.filter(item => 
    item.kategori?.toLowerCase().includes(search.toLowerCase()) ||
    item.deskripsi?.toLowerCase().includes(search.toLowerCase())
  );

  // Kalkulasi Dashboard (Bulan Berjalan)
  const currentDate = new Date();
  const currentMonth = currentDate.getMonth();
  const currentYear = currentDate.getFullYear();

  let totalPemasukanBulanIni = 0;
  let totalPengeluaranBulanIni = 0;
  
  // Total Saldo (All time)
  let totalSaldo = 0;

  data.forEach(item => {
    const itemDate = new Date(item.tanggal);
    const nominal = Number(item.nominal) || 0;

    // Kalkulasi all time untuk saldo
    if (item.jenis === "Pemasukan") totalSaldo += nominal;
    else if (item.jenis === "Pengeluaran") totalSaldo -= nominal;

    // Kalkulasi bulan ini
    if (itemDate.getMonth() === currentMonth && itemDate.getFullYear() === currentYear) {
      if (item.jenis === "Pemasukan") totalPemasukanBulanIni += nominal;
      else if (item.jenis === "Pengeluaran") totalPengeluaranBulanIni += nominal;
    }
  });

  const resetForm = () => {
    setTanggal(new Date().toISOString().split("T")[0]);
    setKategori("");
    setJenis("");
    setNominalStr("");
    setDeskripsi("");
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const nominal = parseInt(nominalStr.replace(/[^0-9]/g, "")) || 0;
    
    if (nominal <= 0) {
      toast.error("Nominal tidak valid");
      return;
    }

    setIsSubmitting(true);
    const result = await addManualCashFlow({
      tanggal,
      kategori,
      jenis,
      deskripsi,
      nominal
    });
    setIsSubmitting(false);

    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success("Transaksi kas berhasil dicatat!");
      setIsDialogOpen(false);
      resetForm();
      window.location.reload();
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Buku Kas (Cash Flow)</h2>
          <p className="text-muted-foreground mt-1">Pantau seluruh arus kas masuk dan keluar perusahaan.</p>
        </div>
        
        <Dialog open={isDialogOpen} onOpenChange={(open) => {
          setIsDialogOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-primary/90">
              <Plus className="mr-2 h-4 w-4" /> Transaksi Manual
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[500px]">
            <DialogHeader>
              <DialogTitle>Input Kas Manual</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleSubmit} className="space-y-4 py-4">
              
              <div className="space-y-2">
                <Label>Tanggal</Label>
                <Input 
                  type="date" 
                  value={tanggal}
                  onChange={(e) => setTanggal(e.target.value)}
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Jenis Transaksi</Label>
                  <Select value={jenis} onValueChange={setJenis} required>
                    <SelectTrigger>
                      <SelectValue placeholder="Pilih Jenis" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="Pemasukan">Pemasukan (+)</SelectItem>
                      <SelectItem value="Pengeluaran">Pengeluaran (-)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Nominal (Rp)</Label>
                  <Input 
                    placeholder="0"
                    value={nominalStr}
                    onChange={(e) => setNominalStr(e.target.value)}
                    required
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label>Kategori Transaksi</Label>
                <Select value={kategori} onValueChange={setKategori} required>
                  <SelectTrigger>
                    <SelectValue placeholder="Pilih Kategori" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Biaya Operasional">Biaya Operasional (Listrik, Air, dll)</SelectItem>
                    <SelectItem value="Beli ATK & Perlengkapan">Beli ATK & Perlengkapan</SelectItem>
                    <SelectItem value="Pemeliharaan Aset">Pemeliharaan Aset</SelectItem>
                    <SelectItem value="Tambahan Modal">Tambahan Modal</SelectItem>
                    <SelectItem value="Lainnya">Lainnya</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label>Keterangan / Deskripsi</Label>
                <Textarea 
                  placeholder="Penjelasan detail pengeluaran/pemasukan..."
                  value={deskripsi}
                  onChange={(e) => setDeskripsi(e.target.value)}
                />
              </div>

              <div className="flex justify-end gap-2 pt-4 border-t">
                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                  Batal
                </Button>
                <Button type="submit" disabled={isSubmitting}>
                  {isSubmitting ? "Menyimpan..." : "Simpan Transaksi"}
                </Button>
              </div>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <Card className="bg-primary/5 border-primary/20">
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Total Saldo Kas</CardTitle>
            <Wallet className="h-4 w-4 text-primary" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-primary">Rp {totalSaldo.toLocaleString('id-ID')}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Akumulasi seluruh waktu
            </p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Pemasukan Bulan Ini</CardTitle>
            <TrendingUp className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">Rp {totalPemasukanBulanIni.toLocaleString('id-ID')}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Periode {format(currentDate, "MMMM yyyy", { locale: id })}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Pengeluaran Bulan Ini</CardTitle>
            <TrendingDown className="h-4 w-4 text-red-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">Rp {totalPengeluaranBulanIni.toLocaleString('id-ID')}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Periode {format(currentDate, "MMMM yyyy", { locale: id })}
            </p>
          </CardContent>
        </Card>
      </div>

      <div className="flex items-center gap-2 max-w-sm">
        <div className="relative w-full">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input 
            placeholder="Cari transaksi..." 
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
              <TableHead>Tanggal</TableHead>
              <TableHead>Kategori</TableHead>
              <TableHead>Deskripsi</TableHead>
              <TableHead className="text-right">Pemasukan</TableHead>
              <TableHead className="text-right">Pengeluaran</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                  Belum ada catatan transaksi kas.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell>
                    {format(new Date(item.tanggal), "dd MMM yyyy", { locale: id })}
                  </TableCell>
                  <TableCell>
                    <span className="font-medium text-slate-800">{item.kategori}</span>
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm max-w-[300px] truncate">
                    {item.deskripsi || "-"}
                  </TableCell>
                  <TableCell className="text-right font-semibold text-green-600">
                    {item.jenis === "Pemasukan" ? `Rp ${item.nominal.toLocaleString('id-ID')}` : "-"}
                  </TableCell>
                  <TableCell className="text-right font-semibold text-red-600">
                    {item.jenis === "Pengeluaran" ? `Rp ${item.nominal.toLocaleString('id-ID')}` : "-"}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
