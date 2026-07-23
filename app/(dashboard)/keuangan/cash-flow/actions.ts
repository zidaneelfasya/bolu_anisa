"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getCashFlowData() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("cash_flow")
    .select("*")
    .is("deleted_at", null)
    .order("tanggal", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching cash flow:", error);
    return [];
  }

  return data || [];
}

export async function addManualCashFlow(payload: {
  tanggal: string,
  kategori: string,
  jenis: string,
  deskripsi: string,
  nominal: number
}) {
  const supabase = await createClient();

  const { error } = await supabase
    .from("cash_flow")
    .insert({
      tanggal: payload.tanggal,
      kategori: payload.kategori,
      jenis: payload.jenis,
      deskripsi: payload.deskripsi,
      nominal: payload.nominal
    });

  if (error) {
    console.error("Error inserting cash flow:", error);
    return { error: error.message };
  }

  revalidatePath("/keuangan/cash-flow");
  return { success: true };
}
