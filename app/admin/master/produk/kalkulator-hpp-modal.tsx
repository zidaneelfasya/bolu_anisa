"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Plus, Trash2, Calculator, History, Clock } from "lucide-react";
import { saveKalkulasiHpp, getBahanBakuForHpp, getPackagingForHpp, getKalkulasiHppHistory } from "./actions";
import { toast } from "sonner";
import { Textarea } from "@/components/ui/textarea";

interface KalkulatorHppModalProps {
  isOpen: boolean;
  setIsOpen: (open: boolean) => void;
  produk: any;
}

interface IngredientItem {
  id: string; // random id for key
  bahan_id: string;
  qty: string | number;
}

interface PackagingItem {
  id: string; // random id for key
  packaging_id: string;
  qty: string | number;
}

export function KalkulatorHppModal({ isOpen, setIsOpen, produk }: KalkulatorHppModalProps) {
  const [bahanBaku, setBahanBaku] = useState<any[]>([]);
  const [packaging, setPackaging] = useState<any[]>([]);
  const [ingredients, setIngredients] = useState<IngredientItem[]>([]);
  const [packagings, setPackagings] = useState<PackagingItem[]>([]);
  const [history, setHistory] = useState<any[]>([]);
  const [upahTenagaKerja, setUpahTenagaKerja] = useState<string | number>("");
  const [targetHasil, setTargetHasil] = useState<string | number>("");
  const [catatan, setCatatan] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Initialize with one empty row if opening and empty, and fetch data
  useEffect(() => {
    if (isOpen) {
      if (ingredients.length === 0) {
        setIngredients([{ id: Math.random().toString(), bahan_id: "", qty: 0 }]);
      }
      
      const fetchData = async () => {
        const [bahan, pack, hist] = await Promise.all([
          getBahanBakuForHpp(),
          getPackagingForHpp(),
          getKalkulasiHppHistory(produk?.id)
        ]);
        setBahanBaku(bahan);
        setPackaging(pack);
        setHistory(hist);
      };
      
      fetchData();
    }
  }, [isOpen]);

  const addIngredient = () => {
    setIngredients([...ingredients, { id: Math.random().toString(), bahan_id: "", qty: 0 }]);
  };

  const removeIngredient = (id: string) => {
    setIngredients(ingredients.filter(item => item.id !== id));
  };

  const updateIngredient = (id: string, field: keyof IngredientItem, value: any) => {
    setIngredients(ingredients.map(item => item.id === id ? { ...item, [field]: value } : item));
  };

  const addPackaging = () => {
    setPackagings([...packagings, { id: Math.random().toString(), packaging_id: "", qty: 0 }]);
  };

  const removePackaging = (id: string) => {
    setPackagings(packagings.filter(item => item.id !== id));
  };

  const updatePackaging = (id: string, field: keyof PackagingItem, value: any) => {
    setPackagings(packagings.map(item => item.id === id ? { ...item, [field]: value } : item));
  };

  // Calculations
  const calculateTotalBahan = () => {
    return ingredients.reduce((total, item) => {
      const bahan = bahanBaku.find(b => b.id === item.bahan_id);
      const qty = parseFloat(item.qty as string) || 0;
      if (bahan && qty > 0) {
        return total + (bahan.harga_rata_rata * qty);
      }
      return total;
    }, 0);
  };

  const calculateTotalPackaging = () => {
    return packagings.reduce((total, item) => {
      const p = packaging.find(p => p.id === item.packaging_id);
      const qty = parseFloat(item.qty as string) || 0;
      if (p && qty > 0) {
        return total + (p.harga_per_pcs * qty);
      }
      return total;
    }, 0);
  };

  const totalBiayaBahan = calculateTotalBahan();
  const totalBiayaPackaging = calculateTotalPackaging();
  const upahVal = parseFloat(upahTenagaKerja as string) || 0;
  const targetVal = parseFloat(targetHasil as string) || 0;
  
  const totalBiaya = totalBiayaBahan + totalBiayaPackaging + upahVal;
  
  const hppSatuan = targetVal > 0 ? totalBiaya / targetVal : 0;

  const handleSave = async () => {
    const targetVal = parseFloat(targetHasil as string) || 0;
    if (targetVal <= 0) {
      toast.error("Target Hasil (Pcs) harus lebih dari 0");
      return;
    }

    // Validation
    const validIngredients = ingredients.filter(i => i.bahan_id && (parseFloat(i.qty as string) || 0) > 0);
    const validPackagings = packagings.filter(p => p.packaging_id && (parseFloat(p.qty as string) || 0) > 0);

    if (validIngredients.length === 0) {
      toast.error("Pilih minimal 1 bahan baku beserta jumlahnya");
      return;
    }

    setIsSubmitting(true);
    
    // Format komposisi JSON
    const komposisi = {
      bahan: validIngredients.map(i => {
        const b = bahanBaku.find(bb => bb.id === i.bahan_id);
        const qty = parseFloat(i.qty as string) || 0;
        return {
          id: i.bahan_id,
          nama: b?.nama,
          qty: qty,
          satuan: b?.satuan,
          harga_satuan: b?.harga_rata_rata,
          subtotal: qty * (b?.harga_rata_rata || 0)
        };
      }),
      packaging: validPackagings.map(p => {
        const pk = packaging.find(pp => pp.id === p.packaging_id);
        const qty = parseFloat(p.qty as string) || 0;
        return {
          id: p.packaging_id,
          nama: pk?.nama,
          qty: qty,
          harga_satuan: pk?.harga_per_pcs,
          subtotal: qty * (pk?.harga_per_pcs || 0)
        };
      })
    };

    const payload = {
      produk_id: produk?.id,
      komposisi,
      total_biaya_bahan: totalBiayaBahan,
      total_biaya_packaging: totalBiayaPackaging,
      upah_tenaga_kerja: parseFloat(upahTenagaKerja as string) || 0,
      total_biaya: totalBiaya,
      target_hasil: targetVal,
      hpp_satuan: hppSatuan,
      catatan
    };

    const result = await saveKalkulasiHpp(payload);
    
    setIsSubmitting(false);

    if (result.error) {
      toast.error(result.error);
    } else {
      toast.success("Histori perhitungan HPP berhasil disimpan");
      setIsOpen(false);
      // Reset form
      setIngredients([{ id: Math.random().toString(), bahan_id: "", qty: "" }]);
      setPackagings([]);
      setUpahTenagaKerja("");
      setTargetHasil("");
      setCatatan("");
      
      // Refresh history
      getKalkulasiHppHistory(produk?.id).then(hist => setHistory(hist));
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogContent className="max-w-[95vw] sm:max-w-[900px] max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Calculator className="h-5 w-5 text-blue-600" />
            Kalkulator HPP - {produk?.nama}
          </DialogTitle>
          <DialogDescription>
            Simulasikan biaya produksi untuk mendapatkan nilai HPP yang akurat. Hasil perhitungan akan disimpan sebagai histori.
          </DialogDescription>
        </DialogHeader>

        <Tabs defaultValue="calculator" className="w-full">
          <div className="flex items-center justify-between py-2 mb-4 border-b">
            <TabsList>
              <TabsTrigger value="calculator" className="flex items-center gap-2">
                <Calculator className="h-4 w-4" /> Kalkulator
              </TabsTrigger>
              <TabsTrigger value="history" className="flex items-center gap-2">
                <History className="h-4 w-4" /> Histori Kalkulasi
              </TabsTrigger>
            </TabsList>
          </div>

          <TabsContent value="calculator" className="m-0 focus-visible:outline-none focus-visible:ring-0">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 py-4">
          
          {/* LEFT SIDE: Inputs */}
          <div className="space-y-6">
            
            {/* Bahan Baku Section */}
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <h3 className="font-semibold text-sm text-slate-700">1. Bahan Baku</h3>
                <Button variant="outline" size="sm" onClick={addIngredient} className="h-7 text-xs">
                  <Plus className="h-3 w-3 mr-1" /> Tambah
                </Button>
              </div>
              
              <div className="space-y-2">
                {ingredients.map((item, index) => (
                  <div key={item.id} className="grid grid-cols-[minmax(0,1fr)_auto_auto] gap-2 items-center bg-slate-50 p-2 rounded-md border">
                    <Select value={item.bahan_id} onValueChange={(val) => updateIngredient(item.id, "bahan_id", val)}>
                      <SelectTrigger className="w-full bg-white [&>span]:truncate [&>span]:text-left">
                        <SelectValue placeholder="Pilih Bahan" />
                      </SelectTrigger>
                      <SelectContent>
                        {bahanBaku.map(b => (
                          <SelectItem key={b.id} value={b.id}>
                            {b.nama} (Rp {b.harga_rata_rata}/{b.satuan})
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    
                    <div className="flex items-center gap-2">
                      <Input 
                        type="number" 
                        step="any"
                        value={item.qty} 
                        onChange={(e) => updateIngredient(item.id, "qty", e.target.value)}
                        placeholder="Qty" 
                        className="bg-white w-20 sm:w-24 [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none [-moz-appearance:textfield]"
                      />
                      <span className="text-sm font-medium text-slate-500 w-12 truncate" title={bahanBaku.find(b => b.id === item.bahan_id)?.satuan || ""}>
                        {bahanBaku.find(b => b.id === item.bahan_id)?.satuan || ""}
                      </span>
                    </div>
                    <Button variant="ghost" size="icon" onClick={() => removeIngredient(item.id)} className="h-10 w-10 text-red-500 shrink-0">
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                ))}
                {ingredients.length === 0 && (
                  <div className="text-sm text-muted-foreground text-center py-2 italic border border-dashed rounded-md">Belum ada bahan baku</div>
                )}
              </div>
            </div>

            {/* Packaging Section */}
            <div className="space-y-3 pt-2 border-t">
              <div className="flex justify-between items-center">
                <h3 className="font-semibold text-sm text-slate-700">2. Packaging (Opsional)</h3>
                <Button variant="outline" size="sm" onClick={addPackaging} className="h-7 text-xs">
                  <Plus className="h-3 w-3 mr-1" /> Tambah
                </Button>
              </div>
              
              <div className="space-y-2">
                {packagings.map((item, index) => (
                  <div key={item.id} className="grid grid-cols-[minmax(0,1fr)_auto_auto] gap-2 items-center bg-slate-50 p-2 rounded-md border">
                    <Select value={item.packaging_id} onValueChange={(val) => updatePackaging(item.id, "packaging_id", val)}>
                      <SelectTrigger className="w-full bg-white [&>span]:truncate [&>span]:text-left">
                        <SelectValue placeholder="Pilih Packaging" />
                      </SelectTrigger>
                      <SelectContent>
                        {packaging.map(p => (
                          <SelectItem key={p.id} value={p.id}>
                            {p.nama} (Rp {p.harga_per_pcs}/pcs)
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    
                    <div className="flex items-center gap-2">
                      <Input 
                        type="number" 
                        step="any"
                        value={item.qty} 
                        onChange={(e) => updatePackaging(item.id, "qty", e.target.value)}
                        placeholder="Jumlah" 
                        className="bg-white w-20 sm:w-24 [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none [-moz-appearance:textfield]"
                      />
                      <span className="text-sm font-medium text-slate-500 w-12 truncate" title="Pcs">
                        Pcs
                      </span>
                    </div>
                    <Button variant="ghost" size="icon" onClick={() => removePackaging(item.id)} className="h-10 w-10 text-red-500 shrink-0">
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                ))}
              </div>
            </div>

            {/* Tenaga Kerja & Target */}
            <div className="space-y-3 pt-2 border-t">
              <h3 className="font-semibold text-sm text-slate-700">3. Biaya Lain & Target Hasil</h3>
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1">
                  <Label htmlFor="upah" className="text-xs">Upah Tenaga Kerja (Rp)</Label>
                  <Input 
                    id="upah"
                    type="number" 
                    step="any"
                    value={upahTenagaKerja} 
                    onChange={(e) => setUpahTenagaKerja(e.target.value)}
                    placeholder="Contoh: 100000" 
                    className="[&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none [-moz-appearance:textfield]"
                  />
                </div>
                <div className="space-y-1">
                  <Label htmlFor="target" className="text-xs">Hasil Produksi (Pcs)</Label>
                  <Input 
                    id="target"
                    type="number" 
                    step="any"
                    value={targetHasil} 
                    onChange={(e) => setTargetHasil(e.target.value)}
                    placeholder="Contoh: 100" 
                    className="border-blue-300 bg-blue-50 focus-visible:ring-blue-500 [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none [-moz-appearance:textfield]"
                  />
                </div>
              </div>
              
              <div className="space-y-1">
                <Label htmlFor="catatan" className="text-xs">Catatan (Opsional)</Label>
                <Textarea 
                  id="catatan" 
                  placeholder="Misal: Perhitungan berdasarkan resep baru" 
                  value={catatan}
                  onChange={(e) => setCatatan(e.target.value)}
                  className="h-16 resize-none"
                />
              </div>
            </div>
          </div>

          {/* RIGHT SIDE: Summary / Preview */}
          <div className="bg-slate-50 p-6 rounded-lg border h-fit sticky top-0">
            <h3 className="font-bold text-lg mb-4 text-slate-800">Ringkasan Biaya</h3>
            
            <div className="space-y-3 text-sm">
              <div className="flex justify-between items-center text-slate-600">
                <span>Total Biaya Bahan:</span>
                <span className="font-medium">Rp {totalBiayaBahan.toLocaleString('id-ID')}</span>
              </div>
              <div className="flex justify-between items-center text-slate-600">
                <span>Total Biaya Packaging:</span>
                <span className="font-medium">Rp {totalBiayaPackaging.toLocaleString('id-ID')}</span>
              </div>
              <div className="flex justify-between items-center text-slate-600">
                <span>Upah Tenaga Kerja:</span>
                <span className="font-medium">Rp {upahTenagaKerja.toLocaleString('id-ID')}</span>
              </div>
              
              <div className="border-t pt-3 mt-3 flex justify-between items-center font-bold text-slate-800 text-base">
                <span>Total Keseluruhan Modal:</span>
                <span>Rp {totalBiaya.toLocaleString('id-ID')}</span>
              </div>
              
              <div className="bg-blue-100 p-4 rounded-md mt-6 flex flex-col items-center justify-center space-y-1 border border-blue-200">
                <span className="text-blue-700 text-xs uppercase tracking-wider font-semibold">Estimasi HPP per Satuan</span>
                <span className="text-3xl font-black text-blue-900">
                  Rp {Math.round(hppSatuan).toLocaleString('id-ID')}
                </span>
                {(parseFloat(targetHasil as string) || 0) > 0 ? (
                  <span className="text-blue-600 text-xs">Berdasarkan hasil {targetHasil} pcs</span>
                ) : (
                  <span className="text-red-500 text-xs font-medium mt-1">Masukkan hasil produksi!</span>
                )}
              </div>
              
              <div className="text-xs text-slate-500 mt-6 text-center italic bg-yellow-50 p-3 rounded border border-yellow-200">
                <b>Perhatian:</b> Hasil akhir dari HPP ini akan otomatis disimpan dan diperbarui ke Master Data Produk sebagai patokan modal dasar untuk transaksi ke depannya. Perhitungan ini juga akan tercatat ke dalam Histori Kalkulasi.
              </div>
            </div>

            <div className="mt-8 flex justify-end gap-3">
              <Button variant="outline" onClick={() => setIsOpen(false)}>Batal</Button>
              <Button 
                onClick={handleSave} 
                disabled={isSubmitting || (parseFloat(targetHasil as string) || 0) <= 0}
                className="bg-blue-600 hover:bg-blue-700"
              >
                {isSubmitting ? "Menyimpan..." : "Simpan Histori"}
              </Button>
            </div>
          </div>
        </div>
        </TabsContent>

        <TabsContent value="history" className="m-0 focus-visible:outline-none focus-visible:ring-0">
          <div className="py-4">
            {history.length > 0 ? (
              <div className="space-y-4">
                {history.map((hist) => (
                  <div key={hist.id} className="p-4 border rounded-lg bg-slate-50 space-y-3">
                    <div className="flex justify-between items-start border-b pb-2">
                      <div className="flex items-center gap-2 text-slate-700">
                        <Clock className="h-4 w-4" />
                        <span className="font-semibold text-sm">
                          {new Date(hist.created_at).toLocaleString("id-ID", { 
                            dateStyle: "medium", timeStyle: "short" 
                          })}
                        </span>
                      </div>
                      <div className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-xs font-bold">
                        Rp {Math.round(hist.hpp_satuan).toLocaleString("id-ID")} / pcs
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                      <div>
                        <p className="text-slate-500 text-xs">Total Modal</p>
                        <p className="font-medium">Rp {Number(hist.total_biaya).toLocaleString("id-ID")}</p>
                      </div>
                      <div>
                        <p className="text-slate-500 text-xs">Target Hasil</p>
                        <p className="font-medium">{hist.target_hasil} Pcs</p>
                      </div>
                      <div className="col-span-2">
                        <p className="text-slate-500 text-xs">Catatan</p>
                        <p className="font-medium italic text-slate-700">{hist.catatan || "-"}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-12 text-slate-500 bg-slate-50 rounded-lg border border-dashed">
                Belum ada histori kalkulasi untuk produk ini.
              </div>
            )}
          </div>
        </TabsContent>
      </Tabs>
      </DialogContent>
    </Dialog>
  );
}
