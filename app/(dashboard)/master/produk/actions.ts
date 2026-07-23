"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getProduk() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("produk")
    .select("*")
    .is("deleted_at", null)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching produk:", error);
    return [];
  }
  return data;
}

export async function addProduk(formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const kategori = formData.get("kategori") as string;
  const harga_jual = parseFloat(formData.get("harga_jual") as string) || 0;
  const hpp = parseFloat(formData.get("hpp") as string) || 0;
  const berat = formData.get("berat") as string;
  const stok = parseInt(formData.get("stok") as string) || 0;
  const keterangan = formData.get("keterangan") as string;

  const { error } = await supabase.from("produk").insert({
    nama,
    kategori,
    harga_jual,
    hpp,
    berat,
    stok,
    keterangan
  });

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/master/produk");
  return { success: true };
}

export async function deleteProduk(id: string) {
  const supabase = await createClient();
  
  const { error } = await supabase
    .from("produk")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/master/produk");
  return { success: true };
}
