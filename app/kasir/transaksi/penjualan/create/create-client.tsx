"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Trash2, Store, ArrowLeft, Plus } from "lucide-react";
import Link from "next/link";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { submitPenjualan } from "../actions";

type Props = {
  masterProduk: any[];
};

export function CreatePenjualanClient({ masterProduk }: Props) {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const [tanggal, setTanggal] = useState(new Date().toISOString().split("T")[0]);
  const [keterangan, setKeterangan] = useState("");
  const [produkList, setProdukList] = useState<any[]>([]);

  // Handlers for Produk
  const addProdukRow = () => {
    setProdukList([...produkList, { id: "", jumlah: 1, harga: 0, hpp: 0, maxStok: 0 }]);
  };

  const updateProdukRow = (index: number, field: string, value: any) => {
    const newArr = [...produkList];
    newArr[index][field] = value;
    
    if (field === "id") {
      const selected = masterProduk.find(p => p.id === value);
      if (selected) {
        newArr[index].harga = selected.harga_jual || 0;
        newArr[index].hpp = selected.hpp || 0;
        newArr[index].maxStok = selected.stok || 0;
      }
    }
    
    // Validasi stok saat ubah jumlah
    if (field === "jumlah") {
      const num = Number(value);
      if (num > newArr[index].maxStok) {
        toast.warning(`Maksimal stok tersedia hanya ${newArr[index].maxStok}`);
        newArr[index].jumlah = newArr[index].maxStok;
      }
    }

    setProdukList(newArr);
  };
  const removeProdukRow = (index: number) => setProdukList(produkList.filter((_, i) => i !== index));

  // Calc Total
  const grandTotal = produkList.reduce((acc, curr) => acc + (Number(curr.jumlah) * Number(curr.harga)), 0);

  const handleSubmit = async () => {
    if (produkList.length === 0) {
      toast.error("Keranjang belanja masih kosong");
      return;
    }

    if (produkList.some(p => !p.id || p.jumlah <= 0 || p.harga < 0)) {
      toast.error("Ada item produk yang belum lengkap atau jumlah 0");
      return;
    }

    setIsSubmitting(true);
    
    const payload = {
      tanggal,
      keterangan,
      produkList
    };

    const result = await submitPenjualan(payload);
    
    if (result.error) {
      toast.error(result.error);
      setIsSubmitting(false);
    } else {
      toast.success("Penjualan berhasil dicatat!");
      router.push("/transaksi/penjualan");
    }
  };

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-12">
      <div className="flex items-center gap-4">
        <Link href="/transaksi/penjualan">
          <Button variant="outline" size="icon"><ArrowLeft className="h-4 w-4" /></Button>
        </Link>
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Kasir Penjualan</h2>
          <p className="text-muted-foreground mt-1">Catat struk penjualan produk ke pelanggan.</p>
        </div>
      </div>

      <div className="bg-white p-6 rounded-md border shadow-sm flex flex-col sm:flex-row gap-6">
        <div className="w-full sm:max-w-xs space-y-2">
          <Label>Tanggal Transaksi</Label>
          <Input 
            type="date" 
            value={tanggal}
            onChange={(e) => setTanggal(e.target.value)}
          />
        </div>
        <div className="w-full space-y-2 flex-1">
          <Label>Keterangan Penjualan (Opsional)</Label>
          <Input 
            type="text" 
            placeholder="Contoh: Bpk A - Pesanan Grosir"
            value={keterangan}
            onChange={(e) => setKeterangan(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-white rounded-md border shadow-sm overflow-hidden">
        <div className="bg-slate-50 p-4 border-b flex justify-between items-center">
          <h3 className="font-semibold text-lg flex items-center">
            <Store className="mr-2 h-5 w-5 text-primary" />
            Keranjang Belanja
          </h3>
          <Button size="sm" variant="outline" onClick={addProdukRow}>
            <Plus className="mr-2 h-4 w-4" /> Tambah Produk
          </Button>
        </div>
        <div className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Pilih Produk Jadi</TableHead>
                <TableHead className="w-[150px]">Qty Terjual</TableHead>
                <TableHead className="w-[180px]">Harga Jual (Rp)</TableHead>
                <TableHead className="w-[180px] text-right">Subtotal</TableHead>
                <TableHead className="w-[60px]"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {produkList.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="text-center py-12 text-muted-foreground italic">
                    Keranjang kosong. Klik "Tambah Produk" untuk mulai.
                  </TableCell>
                </TableRow>
              ) : (
                produkList.map((item, index) => (
                  <TableRow key={index}>
                    <TableCell>
                      <Select value={item.id} onValueChange={(val) => updateProdukRow(index, "id", val)}>
                        <SelectTrigger>
                          <SelectValue placeholder="Pilih Kue/Bolu..." />
                        </SelectTrigger>
                        <SelectContent>
                          {masterProduk.map(p => (
                            <SelectItem key={p.id} value={p.id}>
                              {p.nama} (Stok: {p.stok})
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell>
                      <Input 
                        type="number" 
                        min="1" 
                        max={item.maxStok || 999}
                        value={item.jumlah} 
                        onChange={(e) => updateProdukRow(index, "jumlah", e.target.value)} 
                      />
                    </TableCell>
                    <TableCell>
                      <Input 
                        type="number" 
                        min="0" 
                        value={item.harga} 
                        onChange={(e) => updateProdukRow(index, "harga", e.target.value)} 
                        className="bg-white font-medium"
                      />
                    </TableCell>
                    <TableCell className="text-right font-bold text-slate-700">
                      Rp {(Number(item.jumlah) * Number(item.harga)).toLocaleString('id-ID')}
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon" className="text-red-500 hover:text-red-700" onClick={() => removeProdukRow(index)}>
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      </div>

      <div className="bg-slate-800 text-white p-6 rounded-md shadow-lg flex justify-between items-center sticky bottom-6 z-10">
        <div>
          <p className="text-slate-300 text-sm mb-1">Total Pembayaran (Otomatis masuk Pemasukan Kas)</p>
          <p className="text-3xl font-bold text-green-400">Rp {grandTotal.toLocaleString('id-ID')}</p>
        </div>
        <Button 
          size="lg" 
          className="bg-blue-600 hover:bg-blue-700 text-white font-bold px-8 text-lg"
          onClick={handleSubmit}
          disabled={isSubmitting || grandTotal === 0}
        >
          {isSubmitting ? "Memproses..." : "Selesaikan Penjualan"}
        </Button>
      </div>
    </div>
  );
}
