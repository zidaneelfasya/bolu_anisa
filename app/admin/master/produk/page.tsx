import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { ProdukClient } from "./produk-client";
import { getProduk } from "./actions";

async function ProdukDataFetcher() {
  const produk = await getProduk();
  return <ProdukClient initialData={produk} />;
}

export default function ProdukPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <ProdukDataFetcher />
    </Suspense>
  );
}