"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Trash2, ShoppingCart, ArrowLeft, Plus } from "lucide-react";
import Link from "next/link";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { submitPembelian } from "../actions";

type Props = {
  masterBahan: any[];
  masterPackaging: any[];
};

export function CreatePembelianClient({ masterBahan, masterPackaging }: Props) {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const [tanggal, setTanggal] = useState(new Date().toISOString().split("T")[0]);
  const [supplier, setSupplier] = useState("");
  
  const [bahanList, setBahanList] = useState<any[]>([]);
  const [packList, setPackList] = useState<any[]>([]);

  // Handlers for Bahan Baku
  const addBahanRow = () => {
    setBahanList([...bahanList, { id: "", jumlah: 0, harga: 0 }]);
  };
  const updateBahanRow = (index: number, field: string, value: any) => {
    const newArr = [...bahanList];
    newArr[index][field] = value;
    if (field === "id") {
      const selected = masterBahan.find(b => b.id === value);
      if (selected) newArr[index].harga = selected.harga_terakhir || 0;
    }
    setBahanList(newArr);
  };
  const removeBahanRow = (index: number) => setBahanList(bahanList.filter((_, i) => i !== index));

  // Handlers for Packaging
  const addPackRow = () => {
    setPackList([...packList, { id: "", jumlah: 0, harga: 0 }]);
  };
  const updatePackRow = (index: number, field: string, value: any) => {
    const newArr = [...packList];
    newArr[index][field] = value;
    if (field === "id") {
      const selected = masterPackaging.find(p => p.id === value);
      if (selected) newArr[index].harga = selected.harga_per_pcs || 0;
    }
    setPackList(newArr);
  };
  const removePackRow = (index: number) => setPackList(packList.filter((_, i) => i !== index));

  // Calc Total
  const totalBahan = bahanList.reduce((acc, curr) => acc + (Number(curr.jumlah) * Number(curr.harga)), 0);
  const totalPack = packList.reduce((acc, curr) => acc + (Number(curr.jumlah) * Number(curr.harga)), 0);
  const grandTotal = totalBahan + totalPack;

  const handleSubmit = async () => {
    if (bahanList.length === 0 && packList.length === 0) {
      toast.error("Minimal harus ada 1 item yang dibeli");
      return;
    }

    if (bahanList.some(b => !b.id || b.jumlah <= 0 || b.harga < 0)) {
      toast.error("Ada data bahan baku yang belum lengkap/valid");
      return;
    }

    if (packList.some(p => !p.id || p.jumlah <= 0 || p.harga < 0)) {
      toast.error("Ada data packaging yang belum lengkap/valid");
      return;
    }

    setIsSubmitting(true);
    
    const payload = {
      tanggal,
      supplier,
      bahanBaku: bahanList,
      packaging: packList
    };

    const result = await submitPembelian(payload);
    
    if (result.error) {
      toast.error(result.error);
      setIsSubmitting(false);
    } else {
      toast.success("Transaksi pembelian berhasil disimpan!");
      router.push("/admin/transaksi/pembelian");
    }
  };

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-12">
      <div className="flex items-center gap-4">
        <Link href="/admin/transaksi/pembelian">
          <Button variant="outline" size="icon"><ArrowLeft className="h-4 w-4" /></Button>
        </Link>
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Input Pembelian Baru</h2>
          <p className="text-muted-foreground mt-1">Catat kulakan bahan dan packaging dari supplier.</p>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-6 bg-white p-6 rounded-md border shadow-sm">
        <div className="space-y-2">
          <Label>Tanggal Pembelian</Label>
          <Input 
            type="date" 
            value={tanggal}
            onChange={(e) => setTanggal(e.target.value)}
          />
        </div>
        <div className="space-y-2">
          <Label>Nama Supplier / Toko</Label>
          <Input 
            placeholder="Contoh: Toko Bahan Kue Maju Jaya"
            value={supplier}
            onChange={(e) => setSupplier(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-white rounded-md border shadow-sm overflow-hidden">
        <div className="bg-slate-50 p-4 border-b flex justify-between items-center">
          <h3 className="font-semibold text-lg flex items-center">
            <ShoppingCart className="mr-2 h-5 w-5 text-primary" />
            Item Bahan Baku
          </h3>
          <Button size="sm" variant="outline" onClick={addBahanRow}>
            <Plus className="mr-2 h-4 w-4" /> Tambah Bahan
          </Button>
        </div>
        <div className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nama Bahan</TableHead>
                <TableHead className="w-[120px]">Qty</TableHead>
                <TableHead className="w-[180px]">Harga Satuan (Rp)</TableHead>
                <TableHead className="w-[180px] text-right">Subtotal</TableHead>
                <TableHead className="w-[60px]"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {bahanList.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="text-center py-6 text-muted-foreground italic">
                    Belum ada bahan baku yang dipilih.
                  </TableCell>
                </TableRow>
              ) : (
                bahanList.map((item, index) => (
                  <TableRow key={index}>
                    <TableCell>
                      <Select value={item.id} onValueChange={(val) => updateBahanRow(index, "id", val)}>
                        <SelectTrigger>
                          <SelectValue placeholder="Pilih Bahan..." />
                        </SelectTrigger>
                        <SelectContent>
                          {masterBahan.map(b => (
                            <SelectItem key={b.id} value={b.id}>{b.nama}</SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell>
                      <Input type="number" min="0" step="0.1" value={item.jumlah} onChange={(e) => updateBahanRow(index, "jumlah", e.target.value)} />
                    </TableCell>
                    <TableCell>
                      <Input type="number" min="0" value={item.harga} onChange={(e) => updateBahanRow(index, "harga", e.target.value)} />
                    </TableCell>
                    <TableCell className="text-right font-medium text-slate-700">
                      Rp {(Number(item.jumlah) * Number(item.harga)).toLocaleString('id-ID')}
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon" className="text-red-500 hover:text-red-700" onClick={() => removeBahanRow(index)}>
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

      <div className="bg-white rounded-md border shadow-sm overflow-hidden">
        <div className="bg-orange-50 p-4 border-b flex justify-between items-center">
          <h3 className="font-semibold text-lg flex items-center text-orange-800">
            <ShoppingCart className="mr-2 h-5 w-5 text-orange-600" />
            Item Packaging
          </h3>
          <Button size="sm" variant="outline" className="border-orange-200 text-orange-700 hover:bg-orange-100" onClick={addPackRow}>
            <Plus className="mr-2 h-4 w-4" /> Tambah Packaging
          </Button>
        </div>
        <div className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nama Packaging</TableHead>
                <TableHead className="w-[120px]">Qty</TableHead>
                <TableHead className="w-[180px]">Harga Satuan (Rp)</TableHead>
                <TableHead className="w-[180px] text-right">Subtotal</TableHead>
                <TableHead className="w-[60px]"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {packList.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="text-center py-6 text-muted-foreground italic">
                    Belum ada packaging yang dipilih.
                  </TableCell>
                </TableRow>
              ) : (
                packList.map((item, index) => (
                  <TableRow key={index}>
                    <TableCell>
                      <Select value={item.id} onValueChange={(val) => updatePackRow(index, "id", val)}>
                        <SelectTrigger>
                          <SelectValue placeholder="Pilih Packaging..." />
                        </SelectTrigger>
                        <SelectContent>
                          {masterPackaging.map(p => (
                            <SelectItem key={p.id} value={p.id}>{p.nama}</SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell>
                      <Input type="number" min="0" value={item.jumlah} onChange={(e) => updatePackRow(index, "jumlah", e.target.value)} />
                    </TableCell>
                    <TableCell>
                      <Input type="number" min="0" value={item.harga} onChange={(e) => updatePackRow(index, "harga", e.target.value)} />
                    </TableCell>
                    <TableCell className="text-right font-medium text-slate-700">
                      Rp {(Number(item.jumlah) * Number(item.harga)).toLocaleString('id-ID')}
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon" className="text-red-500 hover:text-red-700" onClick={() => removePackRow(index)}>
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
          <p className="text-slate-300 text-sm mb-1">Total Pembelian (Otomatis masuk Pengeluaran Kas)</p>
          <p className="text-3xl font-bold text-green-400">Rp {grandTotal.toLocaleString('id-ID')}</p>
        </div>
        <Button 
          size="lg" 
          className="bg-green-600 hover:bg-green-700 text-white font-bold px-8 text-lg"
          onClick={handleSubmit}
          disabled={isSubmitting || grandTotal === 0}
        >
          {isSubmitting ? "Menyimpan..." : "Simpan Pembelian"}
        </Button>
      </div>
    </div>
  );
}
