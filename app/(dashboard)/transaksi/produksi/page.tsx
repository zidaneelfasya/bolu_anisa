import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { getRiwayatProduksi } from "./actions";
import { ProduksiClient } from "./produksi-client";

async function ProduksiDataFetcher() {
  const data = await getRiwayatProduksi();
  return <ProduksiClient data={data} />;
}

export default function ProduksiPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <ProduksiDataFetcher />
    </Suspense>
  );
}
