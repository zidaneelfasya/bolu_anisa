import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { PembelianClient } from "./pembelian-client";
import { getRiwayatPembelian } from "./actions";

async function DataFetcher() {
  const data = await getRiwayatPembelian();
  return <PembelianClient data={data} />;
}

export default function PembelianPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <DataFetcher />
    </Suspense>
  );
}