"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getKaryawan() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("karyawan")
    .select("*")
    .is("deleted_at", null)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching karyawan:", error);
    return [];
  }
  return data;
}

export async function addKaryawan(formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const nomor_hp = formData.get("nomor_hp") as string;
  const alamat = formData.get("alamat") as string;
  const status = formData.get("status") as string || "Aktif";
  const keterangan = formData.get("keterangan") as string;

  const { error } = await supabase.from("karyawan").insert({
    nama,
    nomor_hp,
    alamat,
    status,
    keterangan
  });

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/hr/karyawan");
  return { success: true };
}

export async function deleteKaryawan(id: string) {
  const supabase = await createClient();
  
  const { error } = await supabase
    .from("karyawan")
    .update({ deleted_at: new Date().toISOString(), status: 'Nonaktif' })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/hr/karyawan");
  return { success: true };
}
