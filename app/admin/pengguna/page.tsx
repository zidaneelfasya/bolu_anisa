import { getProfiles } from "./actions";
import PenggunaClient from "./pengguna-client";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Pengguna Aplikasi - Bolu Anisa",
  description: "Manajemen pengguna dan hak akses aplikasi",
};

export default async function PenggunaPage() {
  const profiles = await getProfiles();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Pengguna Aplikasi</h1>
        <p className="text-muted-foreground">
          Kelola akun yang terdaftar dan atur hak akses mereka.
        </p>
      </div>
      <PenggunaClient initialData={profiles} />
    </div>
  );
}
