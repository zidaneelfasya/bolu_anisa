"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Plus, Search, Edit, Trash2 } from "lucide-react";
import { Textarea } from "@/components/ui/textarea";
import { addProduk, deleteProduk } from "./actions";
import { toast } from "sonner";

export function ProdukClient({ initialData }: { initialData: any[] }) {
  const [data, setData] = useState(initialData);
  const [search, setSearch] = useState("");
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const filteredData = data.filter(item => 
    item.nama.toLowerCase().includes(search.toLowerCase()) ||
    (item.kategori && item.kategori.toLowerCase().includes(search.toLowerCase()))
  );

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsSubmitting(true);
    
    const formData = new FormData(e.currentTarget);
    const result = await addProduk(formData);
    
    setIsSubmitting(false);
    
    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success("Produk berhasil ditambahkan");
      setIsDialogOpen(false);
      window.location.reload();
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Yakin ingin menghapus produk ini?")) return;
    
    const result = await deleteProduk(id);
    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success("Produk berhasil dihapus");
      setData(data.filter(item => item.id !== id));
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Master Produk Kue</h2>
          <p className="text-muted-foreground mt-1">Kelola data produk kue jadi yang akan dijual.</p>
        </div>
        
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-primary/90">
              <Plus className="mr-2 h-4 w-4" /> Tambah Produk
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[500px] max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>Tambah Produk Baru</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleSubmit}>
              <div className="grid gap-4 py-4">
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="nama" className="text-right">Nama Kue</Label>
                  <Input id="nama" name="nama" required className="col-span-3" placeholder="Contoh: Bolu Pandan" />
                </div>
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="kategori" className="text-right">Kategori</Label>
                  <Input id="kategori" name="kategori" className="col-span-3" placeholder="Contoh: Bolu" />
                </div>
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="harga_jual" className="text-right">Harga Jual</Label>
                  <Input id="harga_jual" name="harga_jual" type="number" required className="col-span-3" placeholder="0" />
                </div>
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="hpp" className="text-right">HPP (Opsional)</Label>
                  <Input id="hpp" name="hpp" type="number" className="col-span-3" placeholder="0" />
                </div>
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="berat" className="text-right">Berat/Ukuran</Label>
                  <Input id="berat" name="berat" className="col-span-3" placeholder="Contoh: 500g, 1 Loyang" />
                </div>
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="stok" className="text-right">Stok Awal</Label>
                  <Input id="stok" name="stok" type="number" required className="col-span-3" placeholder="0" />
                </div>
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="keterangan" className="text-right">Keterangan</Label>
                  <Textarea id="keterangan" name="keterangan" className="col-span-3" placeholder="Catatan tambahan (opsional)" />
                </div>
              </div>
              <div className="flex justify-end gap-2 mt-4">
                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                  Batal
                </Button>
                <Button type="submit" disabled={isSubmitting}>
                  {isSubmitting ? "Menyimpan..." : "Simpan"}
                </Button>
              </div>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex items-center gap-2 max-w-sm">
        <div className="relative w-full">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input 
            placeholder="Cari produk..." 
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
              <TableHead>Nama Produk</TableHead>
              <TableHead>Kategori</TableHead>
              <TableHead className="text-right">Harga Jual</TableHead>
              <TableHead className="text-right">Stok</TableHead>
              <TableHead className="text-center">Status</TableHead>
              <TableHead className="text-right">Aksi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
                  Tidak ada data produk.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell>
                    <div className="font-medium">{item.nama}</div>
                    {item.berat && <div className="text-xs text-muted-foreground">{item.berat}</div>}
                  </TableCell>
                  <TableCell>{item.kategori}</TableCell>
                  <TableCell className="text-right font-medium text-green-600">
                    Rp {(item.harga_jual || 0).toLocaleString('id-ID')}
                  </TableCell>
                  <TableCell className="text-right">
                    <span className={`inline-flex items-center justify-center px-2.5 py-0.5 rounded-full text-xs font-medium
                      ${item.stok <= 0 ? 'bg-red-100 text-red-800' : 'bg-green-100 text-green-800'}
                    `}>
                      {item.stok}
                    </span>
                  </TableCell>
                  <TableCell className="text-center">
                    {item.status_aktif !== false ? (
                      <span className="inline-flex items-center rounded-full bg-blue-100 px-2 py-0.5 text-xs font-medium text-blue-800">
                        Aktif
                      </span>
                    ) : (
                      <span className="inline-flex items-center rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-800">
                        Nonaktif
                      </span>
                    )}
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex justify-end gap-2">
                      <Button variant="ghost" size="icon" className="h-8 w-8 text-blue-600 hover:text-blue-800 hover:bg-blue-50">
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="h-8 w-8 text-red-600 hover:text-red-800 hover:bg-red-50"
                        onClick={() => handleDelete(item.id)}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
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
