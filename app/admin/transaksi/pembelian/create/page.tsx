import { Suspense } from "react";
import { FormSkeleton } from "@/components/ui/form-skeleton";
import { CreatePembelianClient } from "./create-client";
import { createClient } from "@/utils/supabase/server";

async function MasterDataFetcher() {
  const supabase = await createClient();

  const [resBahan, resPackaging] = await Promise.all([
    supabase.from("bahan_baku").select("id, nama, satuan, harga_terakhir").is("deleted_at", null).order("nama"),
    supabase.from("packaging").select("id, nama, jenis, harga_per_pcs").is("deleted_at", null).order("nama")
  ]);

  return <CreatePembelianClient 
    masterBahan={resBahan.data || []} 
    masterPackaging={resPackaging.data || []} 
  />;
}

export default function CreatePembelianPage() {
  return (
    <Suspense fallback={<FormSkeleton />}>
      <MasterDataFetcher />
    </Suspense>
  );
}
