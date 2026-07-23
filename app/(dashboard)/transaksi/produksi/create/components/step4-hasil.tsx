"use client";

import { useState } from "react";
import { useProduksi, HasilProduksiItem } from "../context/produksi-context";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Plus, Trash2 } from "lucide-react";

export function Step4Hasil() {
  const { hasil, setHasil, masterData } = useProduksi();
  
  const [selectedProduk, setSelectedProduk] = useState<string>("");
  const [jumlah, setJumlah] = useState<string>("");
  const [catatan, setCatatan] = useState<string>("");

  const handleAdd = () => {
    if (!selectedProduk || !jumlah || parseInt(jumlah) <= 0) return;
    
    const produk = masterData.produk.find((p: any) => p.id === selectedProduk);
    if (!produk) return;

    if (hasil.some((h: any) => h.id === produk.id)) {
      alert("Produk ini sudah ditambahkan!");
      return;
    }

    const newItem: HasilProduksiItem = {
      id: produk.id,
      nama: produk.nama,
      jumlah: parseInt(jumlah),
      catatan: catatan
    };

    setHasil([...hasil, newItem]);
    setSelectedProduk("");
    setJumlah("");
    setCatatan("");
  };

  const handleRemove = (id: string) => {
    setHasil(hasil.filter((h: any) => h.id !== id));
  };

  const totalProduk = hasil.reduce((acc, curr) => acc + curr.jumlah, 0);

  return (
    <div className="space-y-6">
      <div className="mb-6">
        <h3 className="text-xl font-semibold">Hasil Produksi Jadi</h3>
        <p className="text-sm text-muted-foreground mt-1">Masukkan data jumlah kue yang berhasil diproduksi.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-12 gap-4 items-end bg-slate-50 p-4 rounded-lg border">
        <div className="space-y-2 md:col-span-4">
          <Label>Pilih Produk</Label>
          <Select value={selectedProduk} onValueChange={setSelectedProduk}>
            <SelectTrigger>
              <SelectValue placeholder="-- Pilih Produk --" />
            </SelectTrigger>
            <SelectContent>
              {masterData.produk.map((p: any) => (
                <SelectItem key={p.id} value={p.id}>
                  {p.nama}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2 md:col-span-3">
          <Label>Jumlah Jadi (Pcs)</Label>
          <Input 
            type="number" 
            min="1" 
            placeholder="0"
            value={jumlah}
            onChange={(e) => setJumlah(e.target.value)}
          />
        </div>

        <div className="space-y-2 md:col-span-3">
          <Label>Catatan (Opsional)</Label>
          <Input 
            placeholder="Kondisi, bentuk, dll"
            value={catatan}
            onChange={(e) => setCatatan(e.target.value)}
          />
        </div>

        <div className="md:col-span-2">
          <Button onClick={handleAdd} className="w-full" disabled={!selectedProduk || !jumlah}>
            <Plus className="h-4 w-4 mr-2" />
            Tambah
          </Button>
        </div>
      </div>

      <div className="border rounded-md overflow-hidden">
        <Table>
          <TableHeader className="bg-muted">
            <TableRow>
              <TableHead>Nama Produk Kue</TableHead>
              <TableHead className="text-right">Jumlah Jadi</TableHead>
              <TableHead>Catatan</TableHead>
              <TableHead className="w-[80px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {hasil.length === 0 ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-8 text-muted-foreground">
                  Belum ada produk hasil yang ditambahkan.
                </TableCell>
              </TableRow>
            ) : (
              hasil.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">{item.nama}</TableCell>
                  <TableCell className="text-right font-medium">{item.jumlah} Pcs</TableCell>
                  <TableCell className="text-muted-foreground text-sm">{item.catatan || "-"}</TableCell>
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

      {hasil.length > 0 && (
        <div className="flex justify-end pt-4">
          <div className="bg-primary/10 px-6 py-3 rounded-lg border border-primary/20 text-right">
            <p className="text-sm text-primary mb-1 font-semibold">Total Kue Dibuat</p>
            <p className="text-2xl font-bold text-primary">{totalProduk} Pcs</p>
          </div>
        </div>
      )}
    </div>
  );
}
