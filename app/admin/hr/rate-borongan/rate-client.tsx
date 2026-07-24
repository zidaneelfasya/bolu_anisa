"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Search, Save, Plus, Trash2, Edit } from "lucide-react";
import { saveRateBorongan, deleteRateBorongan } from "./actions";
import { toast } from "sonner";

export function RateBoronganClient({ initialData }: { initialData: { produksi: any[], packaging: any[] } }) {
  const [data, setData] = useState(initialData);
  const [search, setSearch] = useState("");
  const [loadingId, setLoadingId] = useState<string | null>(null);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Form State
  const [editId, setEditId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    nama: "",
    jenis: "Produksi",
    rate: ""
  });

  const resetForm = () => {
    setEditId(null);
    setFormData({ nama: "", jenis: "Produksi", rate: "" });
  };

  const handleEdit = (item: any) => {
    setEditId(item.id);
    setFormData({
      nama: item.nama,
      jenis: item.jenis,
      rate: item.rate.toString()
    });
    setIsDialogOpen(true);
  };

  const handleDelete = async (id: string, jenis: string) => {
    if (!confirm("Apakah Anda yakin ingin menghapus rate ini?")) return;
    
    setLoadingId(id);
    const result = await deleteRateBorongan(id);
    setLoadingId(null);

    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success("Rate berhasil dihapus");
      setData(prev => {
        const key = jenis === "Produksi" ? "produksi" : "packaging";
        return {
          ...prev,
          [key]: prev[key as keyof typeof prev].filter((i: any) => i.id !== id)
        };
      });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const rateVal = parseInt(formData.rate.replace(/[^0-9]/g, "")) || 0;
    
    if (!formData.nama) {
      toast.error("Nama pekerjaan harus diisi");
      return;
    }

    setIsSubmitting(true);
    const result = await saveRateBorongan({
      id: editId || undefined,
      nama: formData.nama,
      jenis: formData.jenis,
      rate: rateVal
    });
    setIsSubmitting(false);

    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success(editId ? "Rate berhasil diperbarui" : "Rate baru berhasil ditambahkan");
      setIsDialogOpen(false);
      resetForm();
      // To properly reflect changes, we reload the page or we could optimistically update state.
      window.location.reload();
    }
  };

  const renderTable = (items: any[], type: "Produksi" | "Packaging") => {
    const filtered = items.filter(i => i.nama.toLowerCase().includes(search.toLowerCase()));

    return (
      <div className="bg-white rounded-md border mt-4">
        <Table>
          <TableHeader className="bg-slate-50">
            <TableRow>
              <TableHead>Nama Pekerjaan {type}</TableHead>
              <TableHead>Rate {type === "Produksi" ? "(per Kg)" : "(per Pcs)"}</TableHead>
              <TableHead className="text-right">Aksi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.length === 0 ? (
              <TableRow>
                <TableCell colSpan={3} className="text-center py-8 text-muted-foreground">
                  Tidak ada data.
                </TableCell>
              </TableRow>
            ) : (
              filtered.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium">{item.nama}</TableCell>
                  <TableCell>Rp {item.rate.toLocaleString('id-ID')}</TableCell>
                  <TableCell className="text-right">
                    <Button 
                      size="icon" 
                      variant="ghost"
                      onClick={() => handleEdit(item)}
                      disabled={loadingId === item.id}
                      className="text-slate-600 hover:text-primary"
                    >
                      <Edit className="h-4 w-4" />
                    </Button>
                    <Button 
                      size="icon" 
                      variant="ghost"
                      onClick={() => handleDelete(item.id, item.jenis)}
                      disabled={loadingId === item.id}
                      className="text-red-500 hover:text-red-600 hover:bg-red-50"
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
    );
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Master Rate Borongan</h2>
          <p className="text-muted-foreground mt-1">Atur besaran tarif upah borongan per Produk (Kg) dan Packaging (Pcs).</p>
        </div>

        <Dialog open={isDialogOpen} onOpenChange={(open) => {
          setIsDialogOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-primary/90">
              <Plus className="mr-2 h-4 w-4" /> Tambah Pekerjaan Borongan
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>{editId ? "Edit Pekerjaan Borongan" : "Tambah Pekerjaan Borongan Baru"}</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleSubmit} className="space-y-4 py-4">
              <div className="space-y-2">
                <Label>Nama Pekerjaan</Label>
                <Input 
                  placeholder="Contoh: Cetak Bolu Coklat" 
                  value={formData.nama}
                  onChange={(e) => setFormData({...formData, nama: e.target.value})}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label>Jenis Pekerjaan</Label>
                <Select 
                  value={formData.jenis} 
                  onValueChange={(val) => setFormData({...formData, jenis: val})}
                  disabled={!!editId} // Mencegah pindah jenis jika sedang edit
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Pilih Jenis" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Produksi">Borongan Produksi</SelectItem>
                    <SelectItem value="Packaging">Borongan Packaging</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Rate (Rp)</Label>
                <Input 
                  placeholder="Contoh: 2500" 
                  type="text"
                  value={formData.rate}
                  onChange={(e) => setFormData({...formData, rate: e.target.value})}
                  required
                />
              </div>
              <div className="flex justify-end gap-2 pt-4">
                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>Batal</Button>
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
            placeholder="Cari pekerjaan..." 
            className="pl-8"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <Tabs defaultValue="produksi" className="w-full">
        <TabsList className="grid w-full grid-cols-2 max-w-[400px]">
          <TabsTrigger value="produksi">Borongan Produksi</TabsTrigger>
          <TabsTrigger value="packaging">Borongan Packaging</TabsTrigger>
        </TabsList>
        <TabsContent value="produksi">
          {renderTable(data.produksi, "Produksi")}
        </TabsContent>
        <TabsContent value="packaging">
          {renderTable(data.packaging, "Packaging")}
        </TabsContent>
      </Tabs>
    </div>
  );
}
