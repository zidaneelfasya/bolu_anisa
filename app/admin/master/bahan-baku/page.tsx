import { Suspense } from "react";
import { BahanBakuClient } from "./bahan-client";
import { getBahanBaku } from "./actions";

async function BahanBakuData() {
  const bahanBakuData = await getBahanBaku();
  return <BahanBakuClient initialData={bahanBakuData} />;
}

export default function BahanBakuPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <BahanBakuData />
    </Suspense>
  );
}