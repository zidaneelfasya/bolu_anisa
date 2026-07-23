import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { RateBoronganClient } from "./rate-client";
import { getRateData } from "./actions";

async function RateDataFetcher() {
  const data = await getRateData();
  return <RateBoronganClient initialData={data} />;
}

export default function RateBoronganPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <RateDataFetcher />
    </Suspense>
  );
}