"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Input } from "@/components/ui/input";
import { Search, Plus, Eye, ShoppingCart } from "lucide-react";
import Link from "next/link";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { format } from "date-fns";
import { id } from "date-fns/locale";
import { Trash2, Pencil } from "lucide-react";
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog";
import { deletePembelian } from "./actions";
import { useTransition } from "react";
import { toast } from "sonner";

export function PembelianClient({ data }: { data: any[] }) {
  const [search, setSearch] = useState("");
  const [selectedDetail, setSelectedDetail] = useState<any>(null);
  const [isPending, startTransition] = useTransition();

  const handleDelete = (id: string) => {
    startTransition(async () => {
      const res = await deletePembelian(id);
      if (res?.error) {
        toast.error(res.error);
      } else {
        toast.success("Histori pembelian berhasil dihapus.");
      }
    });
  };

  const filteredData = data.filter(item => 
    (item.supplier || "").toLowerCase().includes(search.toLowerCase()) ||
    item.tanggal?.includes(search)
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Riwayat Pembelian</h2>
          <p className="text-muted-foreground mt-1">Daftar transaksi pembelian bahan baku dan packaging.</p>
        </div>
        
        <Link href="/admin/transaksi/pembelian/create">
          <Button className="bg-primary hover:bg-primary/90">
            <Plus className="mr-2 h-4 w-4" /> Pembelian Baru
          </Button>
        </Link>
      </div>

      <div className="flex items-center gap-2 max-w-sm">
        <div className="relative w-full">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input 
            type="text" 
            placeholder="Cari supplier..."
            className="pl-8"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="bg-white rounded-md border">
        <Table>
          <TableHeader className="bg-slate-50">
            <TableRow>
              <TableHead>Tanggal</TableHead>
              <TableHead>Supplier</TableHead>
              <TableHead className="text-right">Total Transaksi</TableHead>
              <TableHead className="text-right">Aksi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-8 text-muted-foreground">
                  Belum ada data pembelian.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell>
                    {format(new Date(item.tanggal), "dd MMM yyyy", { locale: id })}
                  </TableCell>
                  <TableCell className="font-medium text-slate-800">
                    {item.supplier || "Tanpa Nama / Cash"}
                  </TableCell>
                  <TableCell className="text-right font-bold text-red-600">
                    Rp {(item.total || 0).toLocaleString('id-ID')}
                  </TableCell>
                  <TableCell className="text-right flex items-center justify-end gap-2">
                    <Button 
                      variant="outline" 
                      size="sm"
                      onClick={() => setSelectedDetail(item)}
                    >
                      <Eye className="h-4 w-4 mr-1" /> Detail
                    </Button>
                    <Link href={`/admin/transaksi/pembelian/${item.id}/edit`}>
                      <Button variant="outline" size="sm" className="text-blue-600 hover:text-blue-700">
                        <Pencil className="h-4 w-4" />
                      </Button>
                    </Link>
                    <AlertDialog>
                      <AlertDialogTrigger asChild>
                        <Button variant="destructive" size="sm" disabled={isPending}>
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </AlertDialogTrigger>
                      <AlertDialogContent>
                        <AlertDialogHeader>
                          <AlertDialogTitle>Hapus Histori Pembelian?</AlertDialogTitle>
                          <AlertDialogDescription>
                            Tindakan ini akan mengembalikan stok (bahan baku & packaging) dan menghapus catatan pengeluaran dari arus kas. Tindakan ini tidak dapat dibatalkan.
                          </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                          <AlertDialogCancel disabled={isPending}>Batal</AlertDialogCancel>
                          <AlertDialogAction 
                            onClick={(e) => { e.preventDefault(); handleDelete(item.id); }}
                            className="bg-red-600 hover:bg-red-700"
                            disabled={isPending}
                          >
                            {isPending ? "Menghapus..." : "Ya, Hapus"}
                          </AlertDialogAction>
                        </AlertDialogFooter>
                      </AlertDialogContent>
                    </AlertDialog>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {/* MODAL DETAIL */}
      <Dialog open={!!selectedDetail} onOpenChange={(open) => !open && setSelectedDetail(null)}>
        <DialogContent className="sm:max-w-[700px] max-h-[85vh] overflow-y-auto">
          {selectedDetail && (
            <>
              <DialogHeader>
                <DialogTitle className="flex items-center text-xl text-primary border-b pb-4">
                  <ShoppingCart className="mr-3 h-5 w-5" />
                  Detail Pembelian
                </DialogTitle>
              </DialogHeader>

              <div className="grid grid-cols-2 gap-4 mb-4 mt-2 text-sm">
                <div>
                  <div className="text-sm font-medium text-muted-foreground mb-1">Tanggal</div>
                  <div className="font-semibold text-slate-800">
                    {format(new Date(selectedDetail.tanggal), "dd MMMM yyyy", { locale: id })}
                  </div>
                </div>
                <div>
                  <div className="text-sm font-medium text-muted-foreground mb-1">Supplier</div>
                  <div className="font-semibold text-slate-800">
                    {selectedDetail.supplier || "-"}
                  </div>
                </div>
              </div>

              {selectedDetail.pembelian_bahan_detail?.length > 0 && (
                <div className="mt-4">
                  <h4 className="font-semibold text-primary mb-2 text-sm">Bahan Baku</h4>
                  <div className="border rounded-md">
                    <Table>
                      <TableHeader className="bg-slate-50">
                        <TableRow>
                          <TableHead className="py-2">Item</TableHead>
                          <TableHead className="py-2 text-right">Qty</TableHead>
                          <TableHead className="py-2 text-right">Harga Satuan</TableHead>
                          <TableHead className="py-2 text-right">Subtotal</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {selectedDetail.pembelian_bahan_detail.map((b: any) => (
                          <TableRow key={b.id}>
                            <TableCell className="py-2">{b.bahan_baku?.nama}</TableCell>
                            <TableCell className="py-2 text-right">{b.jumlah} {b.bahan_baku?.satuan}</TableCell>
                            <TableCell className="py-2 text-right">Rp {(b.harga||0).toLocaleString('id-ID')}</TableCell>
                            <TableCell className="py-2 text-right font-medium">Rp {(b.subtotal||0).toLocaleString('id-ID')}</TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </div>
                </div>
              )}

              {selectedDetail.pembelian_packaging_detail?.length > 0 && (
                <div className="mt-4">
                  <h4 className="font-semibold text-orange-600 mb-2 text-sm">Packaging</h4>
                  <div className="border rounded-md">
                    <Table>
                      <TableHeader className="bg-slate-50">
                        <TableRow>
                          <TableHead className="py-2">Item</TableHead>
                          <TableHead className="py-2 text-right">Qty</TableHead>
                          <TableHead className="py-2 text-right">Harga Satuan</TableHead>
                          <TableHead className="py-2 text-right">Subtotal</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {selectedDetail.pembelian_packaging_detail.map((p: any) => (
                          <TableRow key={p.id}>
                            <TableCell className="py-2">{p.packaging?.nama}</TableCell>
                            <TableCell className="py-2 text-right">{p.jumlah} Pcs</TableCell>
                            <TableCell className="py-2 text-right">Rp {(p.harga||0).toLocaleString('id-ID')}</TableCell>
                            <TableCell className="py-2 text-right font-medium">Rp {(p.subtotal||0).toLocaleString('id-ID')}</TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </div>
                </div>
              )}

              {selectedDetail.pembelian_produk_detail?.length > 0 && (
                <div className="mt-4">
                  <h4 className="font-semibold text-purple-600 mb-2 text-sm">Produk Jadi</h4>
                  <div className="border rounded-md">
                    <Table>
                      <TableHeader className="bg-slate-50">
                        <TableRow>
                          <TableHead className="py-2">Item</TableHead>
                          <TableHead className="py-2 text-right">Qty</TableHead>
                          <TableHead className="py-2 text-right">Harga Beli</TableHead>
                          <TableHead className="py-2 text-right">Subtotal</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {selectedDetail.pembelian_produk_detail.map((p: any) => (
                          <TableRow key={p.id}>
                            <TableCell className="py-2">{p.produk?.nama}</TableCell>
                            <TableCell className="py-2 text-right">{p.jumlah} Pcs</TableCell>
                            <TableCell className="py-2 text-right">Rp {(p.harga||0).toLocaleString('id-ID')}</TableCell>
                            <TableCell className="py-2 text-right font-medium">Rp {(p.subtotal||0).toLocaleString('id-ID')}</TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </div>
                </div>
              )}

              <div className="flex justify-end mt-6 pt-4 border-t">
                <div className="text-right">
                  <div className="text-sm text-muted-foreground mb-1">Grand Total</div>
                  <div className="text-2xl font-bold text-red-600">Rp {(selectedDetail.total || 0).toLocaleString('id-ID')}</div>
                </div>
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
