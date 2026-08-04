"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";
import * as xlsx from "xlsx";

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

  const stok = parseFloat(formData.get("stok") as string) || 0;

  const { data: insertedData, error } = await supabase.from("bahan_baku").insert({
    nama,
    kategori,
    satuan,
    minimum_stok,
    supplier,
    keterangan,
    stok,
    harga_terakhir: 0,
    harga_rata_rata: 0,
  }).select("id").single();

  if (error) {
    return { error: error.message };
  }

  if (stok > 0 && insertedData) {
    await supabase.from("stock_movements").insert({
      kategori_barang: "Bahan Baku",
      barang_id: insertedData.id,
      jenis_pergerakan: "Masuk",
      jumlah: stok,
      stok_sebelum: 0,
      stok_sesudah: stok,
      referensi: "Tambah Bahan Baku Baru",
      keterangan: "Stok awal bahan baku baru",
      user_id: null
    });
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

  const stok = parseFloat(formData.get("stok") as string) || 0;

  // Ambil stok lama
  const { data: oldData } = await supabase.from("bahan_baku").select("stok").eq("id", id).single();
  const oldStok = oldData?.stok || 0;

  const { error } = await supabase
    .from("bahan_baku")
    .update({
      nama,
      kategori,
      satuan,
      minimum_stok,
      supplier,
      keterangan,
      stok,
    })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  // Log pergerakan jika stok berubah
  if (oldStok !== stok) {
    const selisih = Math.abs(stok - oldStok);
    await supabase.from("stock_movements").insert({
      kategori_barang: "Bahan Baku",
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

  revalidatePath("/admin/master/bahan-baku");
  return { success: true };
}

export async function importBahanBaku(formData: FormData) {
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
    
    // Header is at row index 0, data starts at index 1
    if (rawData.length <= 1) {
      return { error: 'File kosong atau format tidak sesuai' };
    }

    const dataToInsert = [];
    
    for (let i = 1; i < rawData.length; i++) {
      const row = rawData[i];
      if (!row || row.length === 0 || !row[0]) continue; // Skip empty rows

      const nama = row[0]?.toString().trim();
      const harga = parseFloat(row[1]) || 0;
      const satuan = row[2]?.toString().trim() || "";

      if (!nama) continue;

      dataToInsert.push({
        nama,
        kategori: 'Belum Dikategorikan',
        satuan,
        minimum_stok: 0,
        supplier: null,
        keterangan: null,
        stok: 0,
        harga_terakhir: harga,
        harga_rata_rata: harga
      });
    }

    if (dataToInsert.length === 0) {
      return { error: 'Tidak ada data bahan baku valid yang ditemukan' };
    }

    const supabase = await createClient();
    
    const { error } = await supabase.from('bahan_baku').insert(dataToInsert);

    if (error) {
      console.error('Error inserting imported bahan baku:', error);
      return { error: error.message };
    }

    revalidatePath('/admin/master/bahan-baku');
    
    return { 
      success: true, 
      message: `Berhasil mengimpor ${dataToInsert.length} bahan baku.` 
    };

  } catch (error: any) {
    console.error('Error importing bahan baku:', error);
    return { error: error.message || 'Gagal mengimpor bahan baku' };
  }
}
