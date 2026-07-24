"use client";

import React, { createContext, useContext, useState } from "react";

// Types
export type ProduksiInfo = {
  tanggal: string;
  pic: string;
  keterangan: string;
};

export type BahanBakuItem = {
  id: string;
  nama: string;
  satuan: string;
  jumlah: number;
  harga_satuan: number;
  subtotal: number;
};

export type PackagingItem = {
  id: string;
  nama: string;
  jumlah: number;
  harga_satuan: number;
  subtotal: number;
};

export type HasilProduksiItem = {
  id: string;
  nama: string;
  jumlah: number;
  catatan: string;
};

type ProduksiState = {
  info: ProduksiInfo;
  bahanBaku: BahanBakuItem[];
  packaging: PackagingItem[];
  hasil: HasilProduksiItem[];
  
  // Data Master (Read-only)
  masterData: {
    bahanBaku: any[];
    packaging: any[];
    produk: any[];
  };
  
  setInfo: (info: ProduksiInfo) => void;
  setBahanBaku: (items: BahanBakuItem[]) => void;
  setPackaging: (items: PackagingItem[]) => void;
  setHasil: (items: HasilProduksiItem[]) => void;
  
  reset: () => void;
};

const initialState: ProduksiState = {
  info: { tanggal: new Date().toISOString().split("T")[0], pic: "", keterangan: "" },
  bahanBaku: [],
  packaging: [],
  hasil: [],
  masterData: { bahanBaku: [], packaging: [], produk: [] },
  setInfo: () => {},
  setBahanBaku: () => {},
  setPackaging: () => {},
  setHasil: () => {},
  reset: () => {},
};

const ProduksiContext = createContext<ProduksiState>(initialState);

export const ProduksiProvider = ({ children, masterData }: { children: React.ReactNode, masterData: ProduksiState["masterData"] }) => {
  const [info, setInfo] = useState<ProduksiInfo>(initialState.info);
  const [bahanBaku, setBahanBaku] = useState<BahanBakuItem[]>([]);
  const [packaging, setPackaging] = useState<PackagingItem[]>([]);
  const [hasil, setHasil] = useState<HasilProduksiItem[]>([]);

  const reset = () => {
    setInfo(initialState.info);
    setBahanBaku([]);
    setPackaging([]);
    setHasil([]);
  };

  return (
    <ProduksiContext.Provider
      value={{
        info,
        bahanBaku,
        packaging,
        hasil,
        masterData,
        setInfo,
        setBahanBaku,
        setPackaging,
        setHasil,
        reset,
      }}
    >
      {children}
    </ProduksiContext.Provider>
  );
};

export const useProduksi = () => useContext(ProduksiContext);
