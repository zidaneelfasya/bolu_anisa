"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList } from "@/components/ui/command";
import { Plus, Search, Trash2, Check, ChevronsUpDown } from "lucide-react";
import { cn } from "@/lib/utils";
import { Textarea } from "@/components/ui/textarea";
import { bayarGaji } from "./actions";
import { toast } from "sonner";
import { format } from "date-fns";
import { id } from "date-fns/locale";

type Props = {
  initialData: {
    riwayatGaji: any[];
    karyawan: any[];
    rates: any[];
  }
};

export function GajiClient({ initialData }: Props) {
  const [data, setData] = useState(initialData.riwayatGaji);
  const [search, setSearch] = useState("");
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Form State
  const [tanggal, setTanggal] = useState(new Date().toISOString().split("T")[0]);
  const [selectedKarId, setSelectedKarId] = useState("");
  const [karyawanOpen, setKaryawanOpen] = useState(false);
  const [jenisGaji, setJenisGaji] = useState("");
  const [nominalHarian, setNominalHarian] = useState("");
  const [keterangan, setKeterangan] = useState("");
  
  // Borongan State: array of { itemId, qty, rate, subtotal }
  const [boronganItems, setBoronganItems] = useState<any[]>([]);

  const selectedKaryawan = initialData.karyawan.find(k => k.id === selectedKarId);

  const filteredData = data.filter(item => 
    item.karyawan?.nama.toLowerCase().includes(search.toLowerCase()) ||
    item.jenis_gaji.toLowerCase().includes(search.toLowerCase())
  );

  const resetForm = () => {
    setSelectedKarId("");
    setJenisGaji("");
    setNominalHarian("");
    setKeterangan("");
    setBoronganItems([]);
  };

  const handleAddBorongan = () => {
    setBoronganItems([...boronganItems, { itemId: "", qty: "", rate: 0, subtotal: 0 }]);
  };

  const handleRemoveBorongan = (index: number) => {
    const newItems = [...boronganItems];
    newItems.splice(index, 1);
    setBoronganItems(newItems);
  };

  const handleBoronganChange = (index: number, field: string, value: string) => {
    const newItems = [...boronganItems];
    const item = newItems[index];

    if (field === "itemId") {
      item.itemId = value;
      const rateObj = initialData.rates.find(r => r.id === value);
      item.rate = rateObj ? rateObj.rate : 0;
      item.subtotal = (parseFloat(item.qty) || 0) * item.rate;
    } else if (field === "qty") {
      item.qty = value;
      item.subtotal = (parseFloat(value) || 0) * item.rate;
    }

    setBoronganItems(newItems);
  };

  const getTotalBorongan = () => {
    return boronganItems.reduce((acc, curr) => acc + curr.subtotal, 0);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedKarId) {
      toast.error("Pilih karyawan terlebih dahulu");
      return;
    }

    let finalNominal = 0;
    let finalKeterangan = keterangan;

    if (jenisGaji === "Harian") {
      finalNominal = parseInt(nominalHarian.replace(/[^0-9]/g, "")) || 0;
      if (finalNominal <= 0) {
        toast.error("Nominal gaji tidak boleh kosong");
        return;
      }
    } else {
      if (boronganItems.length === 0 || !boronganItems[0].itemId) {
        toast.error("Tambahkan minimal 1 item borongan");
        return;
      }
      finalNominal = getTotalBorongan();
      
      // Auto generate keterangan if empty
      if (!finalKeterangan) {
        const itemNames = boronganItems.map(b => {
          const found = initialData.rates.find(l => l.id === b.itemId);
          const satuan = jenisGaji === "Borongan Produksi" ? "Kg" : "Pcs";
          return `${b.qty} ${satuan} ${found?.nama || 'Unknown'}`;
        }).join(", ");
        finalKeterangan = `Pembayaran borongan: ${itemNames}`;
      }
    }

    setIsSubmitting(true);
    const result = await bayarGaji({
      tanggal,
      karyawan_id: selectedKarId,
      jenis_gaji: jenisGaji,
      nominal: finalNominal,
      keterangan: finalKeterangan
    });
    setIsSubmitting(false);

    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success("Gaji berhasil dicatat & masuk pengeluaran kas!");
      setIsDialogOpen(false);
      resetForm();
      window.location.reload();
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Penggajian Harian</h2>
          <p className="text-muted-foreground mt-1">Catat pembayaran gaji karyawan (Harian & Borongan). Otomatis memotong Saldo Kas.</p>
        </div>
        
        <Dialog open={isDialogOpen} onOpenChange={(open) => {
          setIsDialogOpen(open);
          if (!open) resetForm();
        }}>
          <DialogTrigger asChild>
            <Button className="bg-primary hover:bg-primary/90">
              <Plus className="mr-2 h-4 w-4" /> Bayar Gaji Baru
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>Input Gaji Harian</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleSubmit} className="space-y-4 py-4">
              
              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Tanggal</Label>
                <Input 
                  type="date" 
                  className="col-span-3" 
                  value={tanggal}
                  onChange={(e) => setTanggal(e.target.value)}
                  required
                />
              </div>

              <div className="grid grid-cols-4 items-center gap-4">
                <Label className="text-right">Karyawan</Label>
                <div className="col-span-3">
                  <Popover open={karyawanOpen} onOpenChange={setKaryawanOpen}>
                    <PopoverTrigger asChild>
                      <Button
                        variant="outline"
                        role="combobox"
                        aria-expanded={karyawanOpen}
                        className="w-full justify-between font-normal"
                      >
                        {selectedKarId
                          ? initialData.karyawan.find((k) => k.id === selectedKarId)?.nama
                          : "Pilih Karyawan..."}
                        <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-full p-0 sm:w-[400px]" align="start">
                      <Command>
                        <CommandInput placeholder="Cari karyawan..." />
                        <CommandList>
                          <CommandEmpty>Karyawan tidak ditemukan.</CommandEmpty>
                          <CommandGroup>
                            {initialData.karyawan.map((k) => (
                              <CommandItem
                                key={k.id}
                                value={k.nama}
                                onSelect={() => {
                                  setSelectedKarId(k.id === selectedKarId ? "" : k.id);
                                  setBoronganItems([]);
                                  setKaryawanOpen(false);
                                }}
                              >
                                <Check
                                  className={cn(
                                    "mr-2 h-4 w-4",
                                    selectedKarId === k.id ? "opacity-100" : "opacity-0"
                                  )}
                                />
                                {k.nama}
                              </CommandItem>
                            ))}
                          </CommandGroup>
                        </CommandList>
                      </Command>
                    </PopoverContent>
                  </Popover>
                </div>
              </div>

              {selectedKarId && (
                <div className="grid grid-cols-4 items-center gap-4">
                  <Label className="text-right">Jenis Gaji</Label>
                  <div className="col-span-3">
                    <Select value={jenisGaji} onValueChange={(val) => {
                      setJenisGaji(val);
                      setBoronganItems([]);
                    }}>
                      <SelectTrigger>
                        <SelectValue placeholder="Pilih Jenis Gaji" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Harian">Harian</SelectItem>
                        <SelectItem value="Borongan Produksi">Borongan Produksi</SelectItem>
                        <SelectItem value="Borongan Packaging">Borongan Packaging</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
              )}

              {selectedKarId && jenisGaji && (
                <div className="p-4 bg-slate-50 border rounded-lg mt-4 space-y-4">
                  <div className="font-semibold text-slate-700 border-b pb-2 mb-2">
                    Detail {jenisGaji}
                  </div>

                  {jenisGaji === "Harian" ? (
                    <div className="grid grid-cols-4 items-center gap-4">
                      <Label className="text-right">Nominal Rp</Label>
                      <Input 
                        className="col-span-3"
                        placeholder="Contoh: 50000"
                        value={nominalHarian}
                        onChange={(e) => setNominalHarian(e.target.value)}
                        required
                      />
                    </div>
                  ) : (
                    <div className="space-y-3">
                      {boronganItems.map((item, idx) => (
                        <div key={idx} className="flex gap-2 items-end">
                          <div className="flex-1">
                            <Label className="text-xs mb-1 block">
                              {jenisGaji === "Borongan Produksi" ? "Produk" : "Packaging"}
                            </Label>
                            <Select value={item.itemId} onValueChange={(val) => handleBoronganChange(idx, "itemId", val)}>
                              <SelectTrigger>
                                <SelectValue placeholder="Pilih Item" />
                              </SelectTrigger>
                              <SelectContent>
                                {initialData.rates
                                  .filter(r => r.jenis === (jenisGaji === "Borongan Produksi" ? "Produksi" : "Packaging"))
                                  .map(opt => (
                                    <SelectItem key={opt.id} value={opt.id}>{opt.nama}</SelectItem>
                                ))}
                              </SelectContent>
                            </Select>
                          </div>
                          <div className="w-[100px]">
                            <Label className="text-xs mb-1 block">
                              {jenisGaji === "Borongan Produksi" ? "Qty (Kg)" : "Qty (Pcs)"}
                            </Label>
                            <Input 
                              type="number" 
                              min="0"
                              step="0.01"
                              value={item.qty} 
                              onChange={(e) => handleBoronganChange(idx, "qty", e.target.value)}
                              placeholder="0"
                            />
                          </div>
                          <div className="w-[120px]">
                            <Label className="text-xs mb-1 block">Subtotal Rp</Label>
                            <Input disabled value={item.subtotal.toLocaleString('id-ID')} className="bg-slate-100 font-semibold" />
                          </div>
                          <Button type="button" variant="ghost" size="icon" className="text-red-500 mb-[2px]" onClick={() => handleRemoveBorongan(idx)}>
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      ))}
                      
                      <Button type="button" variant="outline" size="sm" onClick={handleAddBorongan} className="mt-2 w-full border-dashed">
                        <Plus className="h-4 w-4 mr-2" /> Tambah Item Pekerjaan
                      </Button>

                      <div className="flex justify-between items-center bg-primary/10 p-3 rounded-md mt-4">
                        <span className="font-semibold text-primary">Total Gaji Borongan:</span>
                        <span className="font-bold text-primary text-lg">Rp {getTotalBorongan().toLocaleString('id-ID')}</span>
                      </div>
                    </div>
                  )}

                  <div className="grid grid-cols-4 items-start gap-4 mt-4 pt-4 border-t">
                    <Label className="text-right mt-2">Keterangan</Label>
                    <Textarea 
                      className="col-span-3"
                      placeholder={jenisGaji === "Harian" ? "Misal: Gaji shift pagi" : "Otomatis diisi jika dikosongkan"}
                      value={keterangan}
                      onChange={(e) => setKeterangan(e.target.value)}
                    />
                  </div>
                </div>
              )}

              <div className="flex justify-end gap-2 mt-4 pt-4 border-t">
                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                  Batal
                </Button>
                <Button type="submit" disabled={isSubmitting || !selectedKarId || !jenisGaji}>
                  {isSubmitting ? "Menyimpan..." : "Simpan Gaji"}
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
            placeholder="Cari nama karyawan..." 
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
              <TableHead>Karyawan</TableHead>
              <TableHead>Jenis Gaji</TableHead>
              <TableHead>Keterangan</TableHead>
              <TableHead className="text-right">Nominal</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                  Tidak ada riwayat penggajian.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell>
                    {format(new Date(item.tanggal), "dd MMM yyyy", { locale: id })}
                  </TableCell>
                  <TableCell className="font-medium text-slate-900">{item.karyawan?.nama}</TableCell>
                  <TableCell>
                    <span className="inline-flex items-center rounded-full bg-slate-100 px-2.5 py-0.5 text-xs font-medium text-slate-800">
                      {item.jenis_gaji}
                    </span>
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm max-w-[300px] truncate">
                    {item.keterangan || "-"}
                  </TableCell>
                  <TableCell className="text-right font-bold text-slate-700">
                    Rp {item.nominal.toLocaleString('id-ID')}
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
