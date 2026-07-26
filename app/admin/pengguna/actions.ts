"use server";

import { createClient } from "@/utils/supabase/server";
import { revalidatePath } from "next/cache";

export async function getProfiles() {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching profiles:", error);
    return [];
  }
  return data || [];
}

export async function updateProfileRole(id: string, newRole: string) {
  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update({ role: newRole })
    .eq("id", id);

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/pengguna");
  return { success: true };
}

export async function confirmUserEmail(id: string) {
  const supabase = await createClient();
  const { error } = await supabase.rpc("confirm_user_email", { user_id: id });

  if (error) {
    return { error: error.message };
  }

  revalidatePath("/admin/pengguna");
  return { success: true };
}
