"use client";

import { CreatePembelianClient } from "../../create/create-client";
import { updatePembelian } from "../../actions";

type Props = {
  id: string;
  initialData: any;
  masterBahan: any[];
  masterPackaging: any[];
  masterProduk: any[];
};

export function EditClient({ id, initialData, masterBahan, masterPackaging, masterProduk }: Props) {
  
  const handleUpdate = async (payload: any) => {
    return await updatePembelian(id, payload);
  };

  return (
    <CreatePembelianClient 
      masterBahan={masterBahan}
      masterPackaging={masterPackaging}
      masterProduk={masterProduk}
      initialData={initialData}
      onSubmit={handleUpdate}
      isEdit={true}
    />
  );
}
