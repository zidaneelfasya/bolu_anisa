"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getPackaging() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("packaging")
    .select("*")
    .is("deleted_at", null)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching packaging:", error);
    return [];
  }
  return data;
}

export async function addPackaging(formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const jenis = formData.get("jenis") as string;
  const harga_per_pcs = parseFloat(formData.get("harga_per_pcs") as string) || 0;
  const stok = parseInt(formData.get("stok") as string) || 0;
  const minimum_stok = parseInt(formData.get("minimum_stok") as string) || 0;
  const keterangan = formData.get("keterangan") as string;

  const { error } = await supabase.from("packaging").insert({
    nama,
    jenis,
    harga_per_pcs,
    stok,
    minimum_stok,
    keterangan
  });

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/master/packaging");
  return { success: true };
}

export async function deletePackaging(id: string) {
  const supabase = await createClient();
  
  const { error } = await supabase
    .from("packaging")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/master/packaging");
  return { success: true };
}
