import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { PenjualanClient } from "./penjualan-client";
import { getRiwayatPenjualan } from "./actions";

async function DataFetcher() {
  const data = await getRiwayatPenjualan();
  return <PenjualanClient data={data} />;
}

export default function PenjualanPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <DataFetcher />
    </Suspense>
  );
}