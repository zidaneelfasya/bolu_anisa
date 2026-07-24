"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Package, ShoppingCart, ShieldAlert } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { createClient } from "@/utils/supabase/client";
import { toast } from "sonner";

export default function KasirDashboard() {
  const makeMeAdmin = async () => {
    const supabase = createClient();
    const { error } = await supabase.auth.updateUser({
      data: { role: 'admin' }
    });
    if (error) {
      toast.error(error.message);
    } else {
      toast.success("Role berhasil diubah menjadi admin. Halaman akan dimuat ulang...");
      setTimeout(() => window.location.href = "/admin", 2000);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-start">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Dashboard Kasir</h2>
          <p className="text-muted-foreground mt-1">Selamat datang di sistem POS Bolu Anisa.</p>
        </div>
        <Button variant="outline" onClick={makeMeAdmin} className="text-amber-600 border-amber-600 hover:bg-amber-50">
          <ShieldAlert className="h-4 w-4 mr-2" />
          Jadikan Saya Admin (Dev Only)
        </Button>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <Link href="/kasir/transaksi/penjualan">
          <Card className="hover:border-primary transition-colors cursor-pointer h-full">
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Transaksi Penjualan</CardTitle>
              <ShoppingCart className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">Mulai POS</div>
              <p className="text-xs text-muted-foreground mt-1">
                Catat pesanan dan penjualan harian
              </p>
            </CardContent>
          </Card>
        </Link>
      </div>
    </div>
  );
}
