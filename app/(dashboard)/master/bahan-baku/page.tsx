import { BahanBakuClient } from "./bahan-client";
import { getBahanBaku } from "./actions";

export default async function BahanBakuPage() {
  const bahanBakuData = await getBahanBaku();
  
  return <BahanBakuClient initialData={bahanBakuData} />;
}