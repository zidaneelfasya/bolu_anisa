import { Suspense } from "react";
import { FormSkeleton } from "@/components/ui/form-skeleton";
import { getProduksiMasterData } from "../../create/actions";
import { getProduksiById } from "../../actions";
import { ProduksiProvider } from "../../create/context/produksi-context";
import { notFound } from "next/navigation";
import { EditClient } from "./edit-client";

async function ProduksiEditFetcher({ id }: { id: string }) {
  const [masterData, produksi] = await Promise.all([
    getProduksiMasterData(),
    getProduksiById(id)
  ]);

  if (!produksi) return notFound();

  // Map Produksi to Context State format
  const initialData = {
    info: {
      tanggal: new Date(produksi.tanggal_produksi).toISOString().split("T")[0],
      pic: produksi.pic_produksi || "",
      keterangan: produksi.keterangan || "",
      nomor_produksi: produksi.nomor_produksi // we will need to inject this when submitting
    },
    bahanBaku: produksi.produksi_bahan?.map((b: any) => ({
      id: b.bahan_id,
      nama: b.bahan_baku?.nama || "",
      satuan: b.bahan_baku?.satuan || "",
      jumlah: b.jumlah,
      harga_satuan: b.harga_satuan,
      subtotal: b.subtotal
    })) || [],
    packaging: produksi.produksi_packaging?.map((p: any) => ({
      id: p.packaging_id,
      nama: p.packaging?.nama || "",
      jumlah: p.jumlah,
      harga_satuan: p.harga_satuan,
      subtotal: p.subtotal
    })) || [],
    hasil: produksi.produksi_hasil?.map((h: any) => ({
      id: h.produk_id,
      nama: h.produk?.nama || "",
      jumlah: h.jumlah,
      catatan: h.catatan || ""
    })) || []
  };

  return (
    <ProduksiProvider masterData={masterData} initialData={initialData}>
      <EditClient id={id} nomorProduksi={produksi.nomor_produksi} />
    </ProduksiProvider>
  );
}

export default async function EditProduksiPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight text-primary">Edit Produksi</h2>
        <p className="text-muted-foreground mt-1">
          Ubah data produksi. Menyimpan perubahan akan menghitung ulang stok dan HPP.
        </p>
      </div>

      <Suspense fallback={<FormSkeleton />}>
        <ProduksiEditFetcher id={id} />
      </Suspense>
    </div>
  );
}
