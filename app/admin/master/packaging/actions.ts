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

  const { data: insertedData, error } = await supabase.from("packaging").insert({
    nama,
    jenis,
    harga_per_pcs,
    stok,
    minimum_stok,
    keterangan
  }).select("id").single();

  if (error) {
    return { error: error.message };
  }

  if (stok > 0 && insertedData) {
    await supabase.from("stock_movements").insert({
      kategori_barang: "Packaging",
      barang_id: insertedData.id,
      jenis_pergerakan: "Masuk",
      jumlah: stok,
      stok_sebelum: 0,
      stok_sesudah: stok,
      referensi: "Tambah Packaging Baru",
      keterangan: "Stok awal packaging baru",
      user_id: null
    });
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

export async function editPackaging(id: string, formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const jenis = formData.get("jenis") as string;
  const harga_per_pcs = parseFloat(formData.get("harga_per_pcs") as string) || 0;
  const stok = parseInt(formData.get("stok") as string) || 0;
  const minimum_stok = parseInt(formData.get("minimum_stok") as string) || 0;
  const keterangan = formData.get("keterangan") as string;

  // Ambil stok lama
  const { data: oldData } = await supabase.from("packaging").select("stok").eq("id", id).single();
  const oldStok = oldData?.stok || 0;

  const { error } = await supabase.from("packaging").update({
    nama,
    jenis,
    harga_per_pcs,
    stok,
    minimum_stok,
    keterangan,
    updated_at: new Date().toISOString()
  }).eq("id", id);

  if (error) {
    return { error: error.message };
  }

  // Log pergerakan jika stok berubah
  if (oldStok !== stok) {
    const selisih = Math.abs(stok - oldStok);
    await supabase.from("stock_movements").insert({
      kategori_barang: "Packaging",
      barang_id: id,
      jenis_pergerakan: "Penyesuaian",
      jumlah: selisih,
      stok_sebelum: oldStok,
      stok_sesudah: stok,
      referensi: "Edit Manual",
      keterangan: `Penyesuaian stok manual dari ${oldStok} menjadi ${stok}`,
      user_id: null
    });
  }

  revalidatePath("/admin/master/packaging");
  return { success: true };
}
