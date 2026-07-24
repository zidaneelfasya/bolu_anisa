import { Suspense } from "react";
import { TableSkeleton } from "@/components/ui/table-skeleton";
import { CashFlowClient } from "./cashflow-client";
import { getCashFlowData } from "./actions";

async function CashFlowDataFetcher() {
  const data = await getCashFlowData();
  return <CashFlowClient data={data} />;
}

export default function CashFlowPage() {
  return (
    <Suspense fallback={<TableSkeleton />}>
      <CashFlowDataFetcher />
    </Suspense>
  );
}