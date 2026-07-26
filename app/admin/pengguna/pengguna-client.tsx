"use client";

import { useState } from "react";
import { updateProfileRole, confirmUserEmail } from "./actions";
import { toast } from "sonner";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Shield, ShieldCheck, User, CheckCircle, XCircle } from "lucide-react";
import { format } from "date-fns";
import { id as localeId } from "date-fns/locale";

export default function PenggunaClient({ initialData }: { initialData: any[] }) {
  const [profiles, setProfiles] = useState(initialData);

  const handleRoleChange = async (userId: string, newRole: string) => {
    toast.loading("Mengubah role...", { id: "update-role" });
    
    // Optimistic update
    setProfiles(prev => prev.map(p => p.id === userId ? { ...p, role: newRole } : p));
    
    const res = await updateProfileRole(userId, newRole);
    
    if (res.error) {
      toast.error(res.error, { id: "update-role" });
      // Revert on error
      setProfiles(initialData);
    } else {
      toast.success(`Berhasil mengubah role menjadi ${newRole}`, { id: "update-role" });
    }
  };

  const handleConfirmEmail = async (userId: string) => {
    toast.loading("Mengonfirmasi email...", { id: "confirm-email" });
    
    // Optimistic update
    setProfiles(prev => prev.map(p => p.id === userId ? { ...p, email_confirmed: true } : p));
    
    const res = await confirmUserEmail(userId);
    
    if (res.error) {
      toast.error(res.error, { id: "confirm-email" });
      // Revert on error
      setProfiles(initialData);
    } else {
      toast.success("Email berhasil dikonfirmasi", { id: "confirm-email" });
    }
  };

  return (
    <Card className="shadow-sm">
      <CardHeader>
        <CardTitle className="text-xl flex items-center gap-2">
          <Shield className="h-5 w-5 text-primary" />
          Manajemen Hak Akses
        </CardTitle>
        <CardDescription>
          Atur siapa yang menjadi admin dan kasir di sistem.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow className="bg-slate-50/50">
                <TableHead>Email Pengguna</TableHead>
                <TableHead>Terdaftar Sejak</TableHead>
                <TableHead>Status Email</TableHead>
                <TableHead>Status Role</TableHead>
                <TableHead className="text-right">Ubah Role</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {profiles.map((profile) => (
                <TableRow key={profile.id}>
                  <TableCell className="font-medium flex items-center gap-2">
                    <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center">
                      <User className="h-4 w-4 text-primary" />
                    </div>
                    {profile.email}
                  </TableCell>
                  <TableCell>
                    {profile.created_at ? format(new Date(profile.created_at), "dd MMM yyyy", { locale: localeId }) : "-"}
                  </TableCell>
                  <TableCell>
                    {profile.email_confirmed ? (
                      <Badge variant="outline" className="border-green-500 text-green-600 bg-green-50">
                        <CheckCircle className="w-3 h-3 mr-1" />
                        Terkonfirmasi
                      </Badge>
                    ) : (
                      <div className="flex items-center gap-2">
                        <Badge variant="outline" className="border-red-500 text-red-600 bg-red-50">
                          <XCircle className="w-3 h-3 mr-1" />
                          Belum Konfirmasi
                        </Badge>
                        <Button 
                          variant="ghost" 
                          size="xs" 
                          onClick={() => handleConfirmEmail(profile.id)}
                          className="h-6 px-2 text-xs"
                        >
                          Konfirmasi
                        </Button>
                      </div>
                    )}
                  </TableCell>
                  <TableCell>
                    {profile.role === 'admin' ? (
                      <Badge variant="default" className="bg-amber-600 hover:bg-amber-700">
                        <ShieldCheck className="w-3 h-3 mr-1" />
                        Admin
                      </Badge>
                    ) : (
                      <Badge variant="secondary">Kasir</Badge>
                    )}
                  </TableCell>
                  <TableCell className="text-right">
                    <Select
                      defaultValue={profile.role}
                      onValueChange={(val) => handleRoleChange(profile.id, val)}
                    >
                      <SelectTrigger className="w-[130px] ml-auto">
                        <SelectValue placeholder="Pilih role" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="kasir">Kasir</SelectItem>
                        <SelectItem value="admin">Admin</SelectItem>
                      </SelectContent>
                    </Select>
                  </TableCell>
                </TableRow>
              ))}
              {profiles.length === 0 && (
                <TableRow>
                  <TableCell colSpan={5} className="h-24 text-center text-muted-foreground">
                    Tidak ada pengguna ditemukan.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>
      </CardContent>
    </Card>
  );
}
