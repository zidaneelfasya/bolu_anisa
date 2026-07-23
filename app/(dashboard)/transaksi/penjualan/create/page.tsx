import { Suspense } from "react";
import { FormSkeleton } from "@/components/ui/form-skeleton";
import { CreatePenjualanClient } from "./create-client";
import { createClient } from "@/utils/supabase/server";

async function MasterDataFetcher() {
  const supabase = await createClient();

  // Hanya ambil produk yang stoknya > 0 dan status aktif
  const { data } = await supabase
    .from("produk")
    .select("id, nama, harga_jual, stok")
    .is("deleted_at", null)
    .eq("status_aktif", true)
    .gt("stok", 0)
    .order("nama");

  return <CreatePenjualanClient masterProduk={data || []} />;
}

export default function CreatePenjualanPage() {
  return (
    <Suspense fallback={<FormSkeleton />}>
      <MasterDataFetcher />
    </Suspense>
  );
}
