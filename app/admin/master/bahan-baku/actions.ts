"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getBahanBaku() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("bahan_baku")
    .select("*")
    .is("deleted_at", null)
    .order("nama", { ascending: true });

  if (error) {
    console.error("Error fetching bahan_baku:", error);
    return [];
  }
  return data;
}

export async function addBahanBaku(formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const kategori = formData.get("kategori") as string;
  const satuan = formData.get("satuan") as string;
  const minimum_stok = parseFloat((formData.get("min_stok") as string) || "0");
  const supplier = formData.get("supplier") as string;
  const keterangan = formData.get("keterangan") as string;

  const { error } = await supabase.from("bahan_baku").insert({
    nama,
    kategori,
    satuan,
    minimum_stok,
    supplier,
    keterangan,
    stok: 0,
    harga_terakhir: 0,
    harga_rata_rata: 0,
  });

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/master/bahan-baku");
  return { success: true };
}

export async function deleteBahanBaku(id: string) {
  const supabase = await createClient();
  
  // Soft delete
  const { error } = await supabase
    .from("bahan_baku")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/master/bahan-baku");
  return { success: true };
}

export async function updateBahanBaku(id: string, formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const kategori = formData.get("kategori") as string;
  const satuan = formData.get("satuan") as string;
  const minimum_stok = parseFloat((formData.get("min_stok") as string) || "0");
  const supplier = formData.get("supplier") as string;
  const keterangan = formData.get("keterangan") as string;

  const { error } = await supabase
    .from("bahan_baku")
    .update({
      nama,
      kategori,
      satuan,
      minimum_stok,
      supplier,
      keterangan,
    })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/master/bahan-baku");
  return { success: true };
}
