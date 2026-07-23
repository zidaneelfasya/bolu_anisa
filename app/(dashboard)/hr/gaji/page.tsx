import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { GajiClient } from "./gaji-client";
import { getGajiData } from "./actions";

async function GajiDataFetcher() {
  const data = await getGajiData();
  return <GajiClient initialData={data} />;
}

export default function GajiPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <GajiDataFetcher />
    </Suspense>
  );
}