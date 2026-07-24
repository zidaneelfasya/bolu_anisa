"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import {
  Home,
  Package,
  Layers,
  ShoppingCart,
  Users,
  DollarSign,
  FileText,
  Settings,
  MoreVertical,
  LogOut,
  User,
} from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";

export function Sidebar({ email = "user@example.com", role = "kasir" }: { email?: string, role?: string }) {
  const pathname = usePathname();
  const router = useRouter();

  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/auth/login");
  };

  const navGroups = role === 'admin' ? [
    {
      items: [
        { href: "/admin", label: "Dashboard", icon: Home },
      ]
    },
    {
      title: "Master Data",
      items: [
        { href: "/admin/master/bahan-baku", label: "Bahan Baku", icon: Layers },
        { href: "/admin/master/packaging", label: "Packaging", icon: Package },
        { href: "/admin/master/produk", label: "Produk Kue", icon: ShoppingCart },
        { href: "/admin/hr/karyawan", label: "Karyawan", icon: Users },
      ]
    },
    {
      title: "Transaksi",
      items: [
        { href: "/admin/transaksi/pembelian", label: "Pembelian", icon: DollarSign },
        { href: "/admin/transaksi/produksi", label: "Produksi", icon: Layers },
        { href: "/admin/transaksi/penjualan", label: "Penjualan", icon: ShoppingCart },
      ]
    },
    {
      title: "HR & Keuangan",
      items: [
        { href: "/admin/hr/rate-borongan", label: "Rate Borongan", icon: DollarSign },
        { href: "/admin/hr/gaji", label: "Penggajian Harian", icon: DollarSign },
        { href: "/admin/keuangan/cash-flow", label: "Cash Flow", icon: DollarSign },
        { href: "/admin/laporan", label: "Laporan", icon: FileText },
      ]
    },
    {
      title: "Pengaturan",
      items: [
        { href: "/admin/pengguna", label: "Pengguna Aplikasi", icon: Users },
      ]
    }
  ] : [
    {
      items: [
        { href: "/kasir", label: "Dashboard Kasir", icon: Home },
        { href: "/kasir/transaksi/penjualan", label: "Penjualan", icon: ShoppingCart },
      ]
    }
  ];

  const roleDisplay = role === 'admin' ? 'Administrator' : 'Kasir';
  const roleInitial = role === 'admin' ? 'AD' : 'KS';

  return (
    <div className="flex h-full w-64 flex-col bg-card border-r">
      <div className="flex h-14 items-center border-b px-4 shrink-0">
        <Link href={role === 'admin' ? "/admin" : "/kasir"} className="text-xl font-bold text-primary flex items-center gap-2 hover:opacity-90 transition-opacity">
          <Image 
            src="/image/logo_bolu_anisa.svg" 
            alt="Logo Bolu Anisa" 
            width={32} 
            height={32} 
            className="h-8 w-8 object-contain" 
          />
          Bolu Anisa
        </Link>
      </div>
      
      <div className="flex-1 overflow-auto py-4">
        <nav className="grid items-start px-2 text-sm font-medium gap-1">
          {navGroups.map((group, groupIndex) => (
            <div key={groupIndex} className={groupIndex > 0 ? "mt-4" : "mt-0"}>
              {group.title && (
                <div className="px-3 py-2 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                  {group.title}
                </div>
              )}
              <div className="grid gap-1">
                {group.items.map((item) => {
                  // Active state logic
                  const isActive = (item.href === "/admin" || item.href === "/kasir")
                    ? pathname === item.href 
                    : pathname.startsWith(item.href);
                  
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      className={`flex items-center gap-3 rounded-lg px-3 py-2 transition-all ${
                        isActive 
                          ? "bg-muted text-foreground" 
                          : "text-muted-foreground hover:bg-muted hover:text-foreground"
                      }`}
                    >
                      <item.icon className="h-4 w-4" />
                      {item.label}
                    </Link>
                  );
                })}
              </div>
            </div>
          ))}
        </nav>
      </div>

      <div className="p-4 border-t mt-auto shrink-0">
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <button className="flex items-center w-full gap-3 p-2 rounded-md hover:bg-muted transition-colors text-left outline-none">
              <Avatar className="h-9 w-9">
                <AvatarImage src="" alt={roleDisplay} />
                <AvatarFallback className="bg-primary/10 text-primary">{roleInitial}</AvatarFallback>
              </Avatar>
              <div className="flex-1 overflow-hidden">
                <p className="text-sm font-medium leading-none truncate">{roleDisplay}</p>
                <p className="text-xs text-muted-foreground truncate mt-1">{email}</p>
              </div>
              <MoreVertical className="h-4 w-4 text-muted-foreground" />
            </button>
          </DropdownMenuTrigger>
          <DropdownMenuContent className="w-56" align="end" alignOffset={-10}>
            <DropdownMenuLabel>Akun Saya</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuGroup>
              <DropdownMenuItem>
                <User className="mr-2 h-4 w-4" />
                <span>Profile</span>
              </DropdownMenuItem>
              <DropdownMenuItem>
                <Settings className="mr-2 h-4 w-4" />
                <span>Pengaturan</span>
              </DropdownMenuItem>
            </DropdownMenuGroup>
            <DropdownMenuSeparator />
            <DropdownMenuItem asChild className="text-red-600 focus:text-red-600 cursor-pointer">
              <button onClick={handleLogout} className="flex items-center w-full">
                <LogOut className="mr-2 h-4 w-4" />
                <span>Keluar</span>
              </button>
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </div>
  );
}
