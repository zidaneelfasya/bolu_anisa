"use client";

import { useState } from "react";
import { useProduksi, PackagingItem } from "../context/produksi-context";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Plus, Trash2 } from "lucide-react";

export function Step3Packaging() {
  const { packaging, setPackaging, masterData } = useProduksi();
  
  const [selectedPack, setSelectedPack] = useState<string>("");
  const [jumlah, setJumlah] = useState<string>("");

  const handleAdd = () => {
    if (!selectedPack || !jumlah || parseInt(jumlah) <= 0) return;
    
    const pack = masterData.packaging.find((p: any) => p.id === selectedPack);
    if (!pack) return;

    if (packaging.some((p: any) => p.id === pack.id)) {
      alert("Packaging ini sudah ditambahkan!");
      return;
    }

    const newItem: PackagingItem = {
      id: pack.id,
      nama: pack.nama,
      jumlah: parseInt(jumlah),
      harga_satuan: pack.harga_per_pcs || 0,
      subtotal: parseInt(jumlah) * (pack.harga_per_pcs || 0)
    };

    setPackaging([...packaging, newItem]);
    setSelectedPack("");
    setJumlah("");
  };

  const handleRemove = (id: string) => {
    setPackaging(packaging.filter((p: any) => p.id !== id));
  };

  const totalBiaya = packaging.reduce((acc, curr) => acc + curr.subtotal, 0);

  return (
    <div className="space-y-6">
      <div className="mb-6">
        <h3 className="text-xl font-semibold">Packaging yang Digunakan</h3>
        <p className="text-sm text-muted-foreground mt-1">Tambahkan Box, Stiker, atau Plastik yang dipakai.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end bg-slate-50 p-4 rounded-lg border">
        <div className="space-y-2 md:col-span-2">
          <Label>Pilih Packaging</Label>
          <Select value={selectedPack} onValueChange={setSelectedPack}>
            <SelectTrigger>
              <SelectValue placeholder="-- Pilih Packaging --" />
            </SelectTrigger>
            <SelectContent>
              {masterData.packaging.map((p: any) => (
                <SelectItem key={p.id} value={p.id}>
                  {p.nama} (Stok: {p.stok} pcs)
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2">
          <Label>Jumlah Pemakaian</Label>
          <Input 
            type="number" 
            min="1" 
            placeholder="0"
            value={jumlah}
            onChange={(e) => setJumlah(e.target.value)}
          />
        </div>

        <Button onClick={handleAdd} className="w-full" disabled={!selectedPack || !jumlah}>
          <Plus className="h-4 w-4 mr-2" />
          Tambah
        </Button>
      </div>

      <div className="border rounded-md overflow-hidden">
        <Table>
          <TableHeader className="bg-muted">
            <TableRow>
              <TableHead>Nama Packaging</TableHead>
              <TableHead className="text-right">Jumlah</TableHead>
              <TableHead className="text-right">Harga Satuan</TableHead>
              <TableHead className="text-right">Subtotal</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {packaging.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                  Belum ada packaging yang ditambahkan.
                </TableCell>
              </TableRow>
            ) : (
              packaging.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">{item.nama}</TableCell>
                  <TableCell className="text-right">{item.jumlah} pcs</TableCell>
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

      {packaging.length > 0 && (
        <div className="flex justify-end pt-4">
          <div className="bg-primary/10 px-6 py-3 rounded-lg border border-primary/20 text-right">
            <p className="text-sm text-primary mb-1 font-semibold">Total Biaya Packaging</p>
            <p className="text-2xl font-bold text-primary">Rp {totalBiaya.toLocaleString('id-ID')}</p>
          </div>
        </div>
      )}
    </div>
  );
}
