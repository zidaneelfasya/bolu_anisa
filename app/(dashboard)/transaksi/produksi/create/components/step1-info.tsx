"use client";

import { useProduksi } from "../context/produksi-context";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";

import { Textarea } from "@/components/ui/textarea";

export function Step1Info() {
  const { info, setInfo } = useProduksi();

  const handleChange = (field: keyof typeof info, value: string) => {
    setInfo({ ...info, [field]: value });
  };

  return (
    <div className="space-y-6 max-w-xl mx-auto">
      <div className="text-center mb-8">
        <h3 className="text-xl font-semibold">Informasi Produksi</h3>
        <p className="text-sm text-muted-foreground mt-1">Masukkan data dasar untuk aktivitas produksi ini.</p>
      </div>

      <div className="grid gap-4">
        <div className="space-y-2">
          <Label htmlFor="tanggal">Tanggal Produksi</Label>
          <Input 
            id="tanggal" 
            type="date" 
            value={info.tanggal}
            onChange={(e) => handleChange("tanggal", e.target.value)}
          />
        </div>



        <div className="space-y-2">
          <Label htmlFor="pic">Penanggung Jawab (PIC)</Label>
          <Input 
            id="pic" 
            placeholder="Nama Koordinator Produksi"
            value={info.pic}
            onChange={(e) => handleChange("pic", e.target.value)}
          />
        </div>

        <div className="space-y-2">
          <Label htmlFor="keterangan">Keterangan / Catatan (Opsional)</Label>
          <Textarea 
            id="keterangan" 
            placeholder="Misal: Produksi khusus pesanan hajatan"
            value={info.keterangan}
            onChange={(e) => handleChange("keterangan", e.target.value)}
          />
        </div>
      </div>
    </div>
  );
}
