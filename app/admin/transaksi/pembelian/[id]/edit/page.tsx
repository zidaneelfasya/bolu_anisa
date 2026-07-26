import { Suspense } from "react";
import { FormSkeleton } from "@/components/ui/form-skeleton";
import { getPembelianById } from "../../actions";
import { createClient } from "@/utils/supabase/server";
import { notFound } from "next/navigation";
import { EditClient } from "./edit-client";

async function PembelianEditFetcher({ id }: { id: string }) {
  const supabase = await createClient();

  const [resBahan, resPackaging, resProduk, pembelian] = await Promise.all([
    supabase.from("bahan_baku").select("id, nama, satuan, harga_terakhir").is("deleted_at", null).order("nama"),
    supabase.from("packaging").select("id, nama, jenis, harga_per_pcs").is("deleted_at", null).order("nama"),
    supabase.from("produk").select("id, nama, harga_jual, hpp").is("deleted_at", null).order("nama"),
    getPembelianById(id)
  ]);

  if (!pembelian) return notFound();

  const initialData = {
    tanggal: pembelian.tanggal,
    supplier: pembelian.supplier || "",
    bahanBaku: pembelian.pembelian_bahan_detail?.map((b: any) => ({
      id: b.bahan_id,
      jumlah: b.jumlah,
      harga: b.harga
    })) || [],
    packaging: pembelian.pembelian_packaging_detail?.map((p: any) => ({
      id: p.packaging_id,
      jumlah: p.jumlah,
      harga: p.harga
    })) || [],
    produk: pembelian.pembelian_produk_detail?.map((p: any) => ({
      id: p.produk_id,
      jumlah: p.jumlah,
      harga: p.harga
    })) || []
  };

  return (
    <EditClient 
      id={id}
      initialData={initialData}
      masterBahan={resBahan.data || []} 
      masterPackaging={resPackaging.data || []} 
      masterProduk={resProduk.data || []}
    />
  );
}

export default async function EditPembelianPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return (
    <Suspense fallback={<FormSkeleton />}>
      <PembelianEditFetcher id={id} />
    </Suspense>
  );
}
