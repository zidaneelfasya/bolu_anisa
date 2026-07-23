"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Plus, Search, Edit, Trash2 } from "lucide-react";
import { Textarea } from "@/components/ui/textarea";
import { addBahanBaku, deleteBahanBaku, updateBahanBaku } from "./actions";
import { toast } from "sonner";

export function BahanBakuClient({ initialData }: { initialData: any[] }) {
  const [search, setSearch] = useState("");
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [editingItem, setEditingItem] = useState<any | null>(null);

  const filteredData = initialData.filter(item => 
    item.nama.toLowerCase().includes(search.toLowerCase()) ||
    item.kategori.toLowerCase().includes(search.toLowerCase())
  );

  async function handleSubmit(formData: FormData) {
    setIsSubmitting(true);
    const result = editingItem 
      ? await updateBahanBaku(editingItem.id, formData)
      : await addBahanBaku(formData);
    setIsSubmitting(false);

    if (result.error) {
      toast.error(`Gagal ${editingItem ? 'memperbarui' : 'menambahkan'} bahan baku: ` + result.error);
    } else {
      toast.success(`Bahan baku berhasil ${editingItem ? 'diperbarui' : 'ditambahkan'}!`);
      setIsDialogOpen(false);
      setEditingItem(null);
    }
  }

  async function handleDelete(id: string, nama: string) {
    if (!confirm(`Apakah Anda yakin ingin menghapus bahan baku ${nama}?`)) return;

    const result = await deleteBahanBaku(id);
    if (result.error) {
      toast.error("Gagal menghapus: " + result.error);
    } else {
      toast.success("Bahan baku berhasil dihapus!");
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Master Bahan Baku</h2>
          <p className="text-muted-foreground mt-1">Kelola data seluruh bahan produksi toko.</p>
        </div>
        
        <Dialog open={isDialogOpen} onOpenChange={(open) => {
          setIsDialogOpen(open);
          if (!open) setEditingItem(null);
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-primary/90" onClick={() => setEditingItem(null)}>
              <Plus className="mr-2 h-4 w-4" /> Tambah Bahan
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[550px]">
            <DialogHeader>
              <DialogTitle className="text-xl font-semibold">{editingItem ? "Edit" : "Tambah"} Bahan Baku</DialogTitle>
            </DialogHeader>
            <form action={handleSubmit} className="grid gap-5 py-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="nama">Nama Bahan Baku</Label>
                  <Input id="nama" name="nama" defaultValue={editingItem?.nama || ""} placeholder="Contoh: Terigu Cakra" required className="w-full" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="kategori">Kategori</Label>
                  <Input id="kategori" name="kategori" defaultValue={editingItem?.kategori || ""} placeholder="Contoh: Tepung" required className="w-full" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="satuan">Satuan</Label>
                  <Input id="satuan" name="satuan" defaultValue={editingItem?.satuan || ""} placeholder="Contoh: Kg, Liter, Butir" required className="w-full" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="min_stok">Minimal Stok</Label>
                  <Input id="min_stok" name="min_stok" type="number" step="0.1" defaultValue={editingItem?.minimum_stok || ""} placeholder="0" required className="w-full" />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="supplier">Supplier <span className="text-muted-foreground text-sm font-normal">(Opsional)</span></Label>
                <Input id="supplier" name="supplier" defaultValue={editingItem?.supplier || ""} placeholder="Nama Supplier" className="w-full" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="keterangan">Keterangan <span className="text-muted-foreground text-sm font-normal">(Opsional)</span></Label>
                <Textarea id="keterangan" name="keterangan" defaultValue={editingItem?.keterangan || ""} placeholder="Catatan tambahan" className="resize-none w-full" rows={3} />
              </div>
              <div className="flex justify-end gap-3 mt-2">
                <Button type="button" variant="outline" onClick={() => { setIsDialogOpen(false); setEditingItem(null); }} className="px-6">Batal</Button>
                <Button type="submit" disabled={isSubmitting} className="px-6">
                  {isSubmitting ? "Menyimpan..." : "Simpan Data"}
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
            type="text" 
            placeholder="Cari bahan baku..." 
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
              <TableHead>Nama Bahan</TableHead>
              <TableHead>Kategori</TableHead>
              <TableHead className="text-right">Stok</TableHead>
              <TableHead>Satuan</TableHead>
              <TableHead className="text-right">Harga Terakhir</TableHead>
              <TableHead>Supplier</TableHead>
              <TableHead className="text-right">Aksi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                  Bahan baku tidak ditemukan atau belum ada data.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">
                    {item.nama}
                    {item.stok <= item.minimum_stok && (
                      <span className="ml-2 inline-flex items-center rounded-full bg-red-100 px-2 py-0.5 text-xs font-medium text-red-800">
                        Stok Menipis
                      </span>
                    )}
                  </TableCell>
                  <TableCell>{item.kategori}</TableCell>
                  <TableCell className={`text-right font-bold ${item.stok <= item.minimum_stok ? 'text-red-600' : ''}`}>
                    {item.stok}
                  </TableCell>
                  <TableCell>{item.satuan}</TableCell>
                  <TableCell className="text-right">Rp {(item.harga_terakhir || 0).toLocaleString('id-ID')}</TableCell>
                  <TableCell>{item.supplier || "-"}</TableCell>
                  <TableCell className="text-right">
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-blue-600 hover:text-blue-700 hover:bg-blue-50"
                      onClick={() => {
                        setEditingItem(item);
                        setIsDialogOpen(true);
                      }}
                    >
                      <Edit className="h-4 w-4" />
                    </Button>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="h-8 w-8 text-red-600 hover:text-red-700 hover:bg-red-50"
                      onClick={() => handleDelete(item.id, item.nama)}
                    >
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
  );
}
