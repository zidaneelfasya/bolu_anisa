"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Input } from "@/components/ui/input";
import { Search, Plus, Eye, ReceiptText } from "lucide-react";
import Link from "next/link";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { format } from "date-fns";
import { id } from "date-fns/locale";

export function PenjualanClient({ data }: { data: any[] }) {
  const [search, setSearch] = useState("");
  const [selectedDetail, setSelectedDetail] = useState<any>(null);

  const filteredData = data.filter(item => 
    item.tanggal?.includes(search)
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Riwayat Penjualan</h2>
          <p className="text-muted-foreground mt-1">Daftar struk transaksi kasir dan penjualan kue.</p>
        </div>
        
        <Link href="/transaksi/penjualan/create">
          <Button className="bg-primary hover:bg-primary/90">
            <Plus className="mr-2 h-4 w-4" /> Kasir Baru
          </Button>
        </Link>
      </div>

      <div className="flex items-center gap-2 max-w-sm">
        <div className="relative w-full">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input 
            type="date" 
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
              <TableHead>ID Transaksi</TableHead>
              <TableHead>Tanggal</TableHead>
              <TableHead>Keterangan</TableHead>
              <TableHead className="text-right">Total Transaksi</TableHead>
              <TableHead className="text-right">Aksi</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length === 0 ? (
              <TableRow>
                <TableCell colSpan={4} className="text-center py-8 text-muted-foreground">
                  Belum ada data penjualan.
                </TableCell>
              </TableRow>
            ) : (
              filteredData.map((item) => (
                <TableRow key={item.id}>
                  <TableCell className="font-medium text-slate-500 text-xs">
                    {item.id.substring(0, 8).toUpperCase()}...
                  </TableCell>
                  <TableCell>
                    {format(new Date(item.tanggal), "dd MMM yyyy", { locale: id })}
                  </TableCell>
                  <TableCell className="text-muted-foreground truncate max-w-[200px]">
                    {item.keterangan || "-"}
                  </TableCell>
                  <TableCell className="text-right font-bold text-green-600">
                    Rp {(item.total || 0).toLocaleString('id-ID')}
                  </TableCell>
                  <TableCell className="text-right">
                    <Button 
                      variant="outline" 
                      size="sm"
                      onClick={() => setSelectedDetail(item)}
                    >
                      <Eye className="h-4 w-4 mr-1" /> Detail
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {/* MODAL DETAIL */}
      <Dialog open={!!selectedDetail} onOpenChange={(open) => !open && setSelectedDetail(null)}>
        <DialogContent className="sm:max-w-[500px]">
          {selectedDetail && (
            <>
              <DialogHeader>
                <DialogTitle className="flex items-center text-xl text-primary border-b pb-4">
                  <ReceiptText className="mr-3 h-5 w-5" />
                  Struk Penjualan
                </DialogTitle>
              </DialogHeader>

              <div className="text-sm mb-1 text-center text-muted-foreground">
                Tanggal: {format(new Date(selectedDetail.tanggal), "dd MMMM yyyy", { locale: id })}
              </div>
              {selectedDetail.keterangan && (
                <div className="text-sm mb-2 text-center text-slate-700 italic">
                  "{selectedDetail.keterangan}"
                </div>
              )}

              <div className="mt-4">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead className="py-2">Produk</TableHead>
                      <TableHead className="py-2 text-right">Qty</TableHead>
                      <TableHead className="py-2 text-right">Harga</TableHead>
                      <TableHead className="py-2 text-right">Subtotal</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {selectedDetail.penjualan_detail?.map((p: any) => (
                      <TableRow key={p.id}>
                        <TableCell className="py-2">{p.produk?.nama}</TableCell>
                        <TableCell className="py-2 text-right">{p.jumlah}x</TableCell>
                        <TableCell className="py-2 text-right">Rp {(p.harga||0).toLocaleString('id-ID')}</TableCell>
                        <TableCell className="py-2 text-right font-medium">Rp {(p.subtotal||0).toLocaleString('id-ID')}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              <div className="flex justify-between items-center mt-6 pt-4 border-t border-dashed border-slate-300">
                <div className="text-sm font-semibold text-muted-foreground">TOTAL BELANJA</div>
                <div className="text-2xl font-bold text-green-600">Rp {(selectedDetail.total || 0).toLocaleString('id-ID')}</div>
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
