"use client";

import { useState } from "react";
import { useProduksi, BahanBakuItem } from "../context/produksi-context";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Plus, Trash2 } from "lucide-react";

export function Step2Bahan() {
  const { bahanBaku, setBahanBaku, masterData } = useProduksi();
  
  const [selectedBahan, setSelectedBahan] = useState<string>("");
  const [jumlah, setJumlah] = useState<string>("");

  const handleAdd = () => {
    if (!selectedBahan || !jumlah || parseFloat(jumlah) <= 0) return;
    
    const bahan = masterData.bahanBaku.find((b: any) => b.id === selectedBahan);
    if (!bahan) return;

    // Cek duplikat
    if (bahanBaku.some((b: any) => b.id === bahan.id)) {
      alert("Bahan ini sudah ditambahkan!");
      return;
    }

    const newItem: BahanBakuItem = {
      id: bahan.id,
      nama: bahan.nama,
      satuan: bahan.satuan,
      jumlah: parseFloat(jumlah),
      harga_satuan: bahan.harga_terakhir || 0,
      subtotal: parseFloat(jumlah) * (bahan.harga_terakhir || 0)
    };

    setBahanBaku([...bahanBaku, newItem]);
    setSelectedBahan("");
    setJumlah("");
  };

  const handleRemove = (id: string) => {
    setBahanBaku(bahanBaku.filter((b: any) => b.id !== id));
  };

  const totalBiaya = bahanBaku.reduce((acc, curr) => acc + curr.subtotal, 0);

  return (
    <div className="space-y-6">
      <div className="mb-6">
        <h3 className="text-xl font-semibold">Bahan Baku yang Digunakan</h3>
        <p className="text-sm text-muted-foreground mt-1">Tambahkan semua bahan yang dipakai untuk produksi ini.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end bg-slate-50 p-4 rounded-lg border">
        <div className="space-y-2 md:col-span-2">
          <Label>Pilih Bahan Baku</Label>
          <Select value={selectedBahan} onValueChange={setSelectedBahan}>
            <SelectTrigger>
              <SelectValue placeholder="-- Pilih Bahan Baku --" />
            </SelectTrigger>
            <SelectContent>
              {masterData.bahanBaku.map((b: any) => (
                <SelectItem key={b.id} value={b.id}>
                  {b.nama} (Stok: {b.stok} {b.satuan})
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2">
          <Label>Jumlah Pemakaian</Label>
          <Input 
            type="number" 
            min="0.1" 
            step="0.1"
            placeholder="0"
            value={jumlah}
            onChange={(e) => setJumlah(e.target.value)}
          />
        </div>

        <Button onClick={handleAdd} className="w-full" disabled={!selectedBahan || !jumlah}>
          <Plus className="h-4 w-4 mr-2" />
          Tambah
        </Button>
      </div>

      <div className="border rounded-md overflow-hidden">
        <Table>
          <TableHeader className="bg-muted">
            <TableRow>
              <TableHead>Nama Bahan</TableHead>
              <TableHead className="text-right">Jumlah</TableHead>
              <TableHead className="text-right">Harga Satuan</TableHead>
              <TableHead className="text-right">Subtotal</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {bahanBaku.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                  Belum ada bahan baku yang ditambahkan.
                </TableCell>
              </TableRow>
            ) : (
              bahanBaku.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">{item.nama}</TableCell>
                  <TableCell className="text-right">{item.jumlah} {item.satuan}</TableCell>
                  <TableCell className="text-right">Rp {item.harga_satuan.toLocaleString('id-ID')}</TableCell>
                  <TableCell className="text-right font-medium">Rp {item.subtotal.toLocaleString('id-ID')}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleRemove(item.id)} className="text-destructive hover:bg-destructive/10">
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {bahanBaku.length > 0 && (
        <div className="flex justify-end pt-4">
          <div className="bg-primary/10 px-6 py-3 rounded-lg border border-primary/20 text-right">
            <p className="text-sm text-primary mb-1 font-semibold">Total Biaya Bahan</p>
            <p className="text-2xl font-bold text-primary">Rp {totalBiaya.toLocaleString('id-ID')}</p>
          </div>
        </div>
      )}
    </div>
  );
}
