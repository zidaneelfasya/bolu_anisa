import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { KaryawanClient } from "./karyawan-client";
import { getKaryawan } from "./actions";

async function KaryawanDataFetcher() {
  const karyawan = await getKaryawan();
  return <KaryawanClient initialData={karyawan} />;
}

export default function KaryawanPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <KaryawanDataFetcher />
    </Suspense>
  );
}