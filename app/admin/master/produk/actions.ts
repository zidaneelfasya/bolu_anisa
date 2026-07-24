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

  revalidatePath("/admin/master/produk");
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

  revalidatePath("/admin/master/produk");
  return { success: true };
}

export async function updateProduk(id: string, formData: FormData) {
  const supabase = await createClient();
  
  const nama = formData.get("nama") as string;
  const kategori = formData.get("kategori") as string;
  const harga_jual = parseFloat(formData.get("harga_jual") as string) || 0;
  const hpp = parseFloat(formData.get("hpp") as string) || 0;
  const berat = formData.get("berat") as string;
  const stok = parseInt(formData.get("stok") as string) || 0;
  const keterangan = formData.get("keterangan") as string;

  const { error } = await supabase.from("produk")
    .update({
      nama,
      kategori,
      harga_jual,
      hpp,
      berat,
      stok,
      keterangan
    })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/master/produk");
  return { success: true };
}

export async function getBahanBakuForHpp() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("bahan_baku")
    .select("id, nama, satuan, harga_rata_rata")
    .order("nama", { ascending: true });

  if (error) {
    console.error("Error fetching bahan_baku:", error);
    return [];
  }
  return data;
}

export async function getPackagingForHpp() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("packaging")
    .select("id, nama, jenis, harga_per_pcs")
    .order("nama", { ascending: true });

  if (error) {
    console.error("Error fetching packaging:", error);
    return [];
  }
  return data;
}

export async function saveKalkulasiHpp(data: any) {
  const supabase = await createClient();
  
  const { error } = await supabase.from("kalkulasi_hpp").insert({
    produk_id: data.produk_id,
    tanggal: new Date().toISOString(),
    komposisi: data.komposisi,
    total_biaya_bahan: data.total_biaya_bahan,
    total_biaya_packaging: data.total_biaya_packaging,
    upah_tenaga_kerja: data.upah_tenaga_kerja,
    total_biaya: data.total_biaya,
    target_hasil: data.target_hasil,
    hpp_satuan: data.hpp_satuan,
    catatan: data.catatan
  });

  if (error) {
    console.error("Error saving kalkulasi_hpp:", error);
    return { error: error.message };
  }
  
  // Update HPP di master produk
  const { error: updateError } = await supabase
    .from("produk")
    .update({ hpp: data.hpp_satuan })
    .eq("id", data.produk_id);

  if (updateError) {
    console.error("Error updating produk HPP:", updateError);
    return { error: updateError.message };
  }

  revalidatePath("/admin/master/produk");
  
  return { success: true };
}

export async function getKalkulasiHppHistory(produkId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("kalkulasi_hpp")
    .select("*")
    .eq("produk_id", produkId)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching kalkulasi_hpp history:", error);
    return [];
  }
  return data;
}
