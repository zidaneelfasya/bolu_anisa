"use client";

import { WizardContainer } from "../../create/components/wizard-container";
import { updateProduksi } from "../../actions";

export function EditClient({ id, nomorProduksi }: { id: string, nomorProduksi: string }) {
  
  const handleUpdate = async (payload: any) => {
    // Inject original nomor_produksi back into payload
    payload.nomor_produksi = nomorProduksi;
    return await updateProduksi(id, payload);
  };

  return <WizardContainer isEdit={true} onSubmit={handleUpdate} />;
}
