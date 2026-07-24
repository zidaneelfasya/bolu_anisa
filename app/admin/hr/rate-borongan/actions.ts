"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getRateData() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("rate_borongan")
    .select("id, nama, jenis, rate")
    .is("deleted_at", null)
    .order("jenis")
    .order("nama");

  if (error) {
    console.error("Error fetching rate data:", error);
    return { produksi: [], packaging: [] };
  }

  const rates = data || [];

  return {
    produksi: rates.filter(r => r.jenis === 'Produksi'),
    packaging: rates.filter(r => r.jenis === 'Packaging')
  };
}

export async function saveRateBorongan(payload: { nama: string, jenis: string, rate: number, id?: string }) {
  const supabase = await createClient();

  if (payload.id) {
    // Update existing
    const { error } = await supabase
      .from("rate_borongan")
      .update({ nama: payload.nama, jenis: payload.jenis, rate: payload.rate, updated_at: new Date().toISOString() })
      .eq("id", payload.id);
    
    if (error) return { error: error.message };
  } else {
    // Insert new
    const { error } = await supabase
      .from("rate_borongan")
      .insert({
        nama: payload.nama,
        jenis: payload.jenis,
        rate: payload.rate
      });
    
    if (error) return { error: error.message };
  }

  revalidatePath("/admin/hr/rate-borongan");
  return { success: true };
}

export async function deleteRateBorongan(id: string) {
  const supabase = await createClient();
  const { error } = await supabase
    .from("rate_borongan")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", id);
    
  if (error) return { error: error.message };
  revalidatePath("/admin/hr/rate-borongan");
  return { success: true };
}
