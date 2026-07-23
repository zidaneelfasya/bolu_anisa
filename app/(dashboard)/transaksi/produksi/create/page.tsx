import { Suspense } from "react";
import { FormSkeleton } from "@/components/ui/form-skeleton";
import { getProduksiMasterData } from "./actions";
import { ProduksiProvider } from "./context/produksi-context";
import { WizardContainer } from "./components/wizard-container";

async function ProduksiFormFetcher() {
  const masterData = await getProduksiMasterData();
  return (
    <ProduksiProvider masterData={masterData}>
      <WizardContainer />
    </ProduksiProvider>
  );
}

export default function CreateProduksiPage() {
  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight text-primary">Produksi Baru</h2>
        <p className="text-muted-foreground mt-1">
          Buat rekap produksi harian. Isi setiap langkah dengan cermat.
        </p>
      </div>

      <Suspense fallback={<FormSkeleton />}>
        <ProduksiFormFetcher />
      </Suspense>
    </div>
  );
}
