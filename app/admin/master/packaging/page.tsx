import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { PackagingClient } from "./packaging-client";
import { getPackaging } from "./actions";

async function PackagingDataFetcher() {
  const packaging = await getPackaging();
  return <PackagingClient initialData={packaging} />;
}

export default function PackagingPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <PackagingDataFetcher />
    </Suspense>
  );
}