"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";
import * as xlsx from "xlsx";

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

export async function importProduk(formData: FormData) {
  try {
    const file = formData.get('file') as File;
    if (!file) {
      return { error: 'File tidak ditemukan' };
    }

    const buffer = await file.arrayBuffer();
    const workbook = xlsx.read(buffer, { type: 'buffer' });
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    
    const rawData = xlsx.utils.sheet_to_json(worksheet, { header: 1 }) as any[][];
    
    // Header is at row index 3, data starts at index 4
    if (rawData.length <= 4) {
      return { error: 'File kosong atau format tidak sesuai' };
    }

    const productsToInsert = [];
    
    for (let i = 4; i < rawData.length; i++) {
      const row = rawData[i];
      if (!row || row.length === 0 || !row[0]) continue; // Skip empty rows

      const name = row[0]?.toString().trim();
      const categoryNameRaw = row[1]?.toString().trim() || 'Lainnya';
      const keteranganRaw = row[3]?.toString().trim() || null;
      const baseHargaJual = parseFloat(row[6]) || 0;
      const hargaJualRaw = baseHargaJual - (baseHargaJual * 0.3); // Kurangi 30%
      const hargaModalRaw = parseFloat(row[8]) || 0;
      const stokRaw = parseInt(row[9]) || 0;

      if (!name) continue;

      productsToInsert.push({
        nama: name,
        kategori: categoryNameRaw,
        keterangan: keteranganRaw,
        harga_jual: hargaJualRaw,
        hpp: hargaModalRaw,
        stok: stokRaw,
        berat: "" // Provide empty string or null depending on table constraint
      });
    }

    if (productsToInsert.length === 0) {
      return { error: 'Tidak ada data produk valid yang ditemukan' };
    }

    const supabase = await createClient();
    
    // Insert products in batches if large, but for typical excel files this is fine
    const { error } = await supabase.from('produk').insert(productsToInsert);

    if (error) {
      console.error('Error inserting imported products:', error);
      return { error: error.message };
    }

    revalidatePath('/admin/master/produk');
    
    return { 
      success: true, 
      message: `Berhasil mengimpor ${productsToInsert.length} produk.` 
    };

  } catch (error: any) {
    console.error('Error importing products:', error);
    return { error: error.message || 'Gagal mengimpor produk' };
  }
}
