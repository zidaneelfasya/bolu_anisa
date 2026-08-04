"use client";

import { useState, useEffect } from "react";
import { format } from "date-fns";
import { id } from "date-fns/locale";
import { 
  History, 
  ArrowDownToLine, 
  ArrowUpFromLine, 
  RefreshCcw,
  Search,
  Filter,
  Download
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { getStockMovements } from "./actions";

export function PergerakanStokClient() {
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [kategori, setKategori] = useState("Semua");
  const [jenis, setJenis] = useState("Semua");
  const [dateRange, setDateRange] = useState({ start: "", end: "" });

  useEffect(() => {
    fetchData();
  }, [kategori]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await getStockMovements(dateRange.start, dateRange.end, kategori);
      setData(res);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const getJenisIcon = (jenisPergerakan: string) => {
    switch (jenisPergerakan) {
      case 'Masuk': return <ArrowDownToLine className="h-4 w-4 text-emerald-500" />;
      case 'Keluar': return <ArrowUpFromLine className="h-4 w-4 text-rose-500" />;
      case 'Penyesuaian': return <RefreshCcw className="h-4 w-4 text-amber-500" />;
      default: return null;
    }
  };

  const filteredData = data.filter(item => {
    const matchSearch = item.nama_barang.toLowerCase().includes(search.toLowerCase()) || 
                        (item.referensi && item.referensi.toLowerCase().includes(search.toLowerCase()));
    const matchJenis = jenis === "Semua" || item.jenis_pergerakan === jenis;
    return matchSearch && matchJenis;
  });

  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Riwayat Pergerakan Stok</h1>
          <p className="text-muted-foreground mt-1">
            Pantau arus masuk, keluar, dan penyesuaian stok secara historis.
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" onClick={fetchData}>
            <RefreshCcw className="mr-2 h-4 w-4" /> Refresh
          </Button>
          <Button variant="outline">
            <Download className="mr-2 h-4 w-4" /> Export CSV
          </Button>
        </div>
      </div>

      <Card>
        <CardHeader className="pb-4">
          <div className="flex flex-col md:flex-row gap-4 items-end">
            <div className="grid gap-2 flex-1 w-full">
              <label className="text-sm font-medium">Cari Barang / Referensi</label>
              <div className="relative">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input 
                  placeholder="Cari nama barang..." 
                  className="pl-8" 
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                />
              </div>
            </div>
            <div className="grid gap-2 w-full md:w-48">
              <label className="text-sm font-medium">Kategori Barang</label>
              <Select value={kategori} onValueChange={setKategori}>
                <SelectTrigger>
                  <SelectValue placeholder="Kategori" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Semua">Semua Kategori</SelectItem>
                  <SelectItem value="Produk Jadi">Produk Jadi (Kue)</SelectItem>
                  <SelectItem value="Bahan Baku">Bahan Baku</SelectItem>
                  <SelectItem value="Packaging">Packaging</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="grid gap-2 w-full md:w-48">
              <label className="text-sm font-medium">Jenis Pergerakan</label>
              <Select value={jenis} onValueChange={setJenis}>
                <SelectTrigger>
                  <SelectValue placeholder="Semua Jenis" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Semua">Semua Jenis</SelectItem>
                  <SelectItem value="Masuk">Masuk</SelectItem>
                  <SelectItem value="Keluar">Keluar</SelectItem>
                  <SelectItem value="Penyesuaian">Penyesuaian</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Tanggal & Waktu</TableHead>
                  <TableHead>Nama Barang</TableHead>
                  <TableHead>Kategori</TableHead>
                  <TableHead>Jenis</TableHead>
                  <TableHead className="text-right">Awal</TableHead>
                  <TableHead className="text-right">Jml</TableHead>
                  <TableHead className="text-right">Akhir</TableHead>
                  <TableHead>Referensi</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow>
                    <TableCell colSpan={8} className="text-center py-10 text-muted-foreground">
                      Memuat data pergerakan stok...
                    </TableCell>
                  </TableRow>
                ) : filteredData.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={8} className="text-center py-10 text-muted-foreground">
                      Tidak ada data riwayat stok yang ditemukan.
                    </TableCell>
                  </TableRow>
                ) : (
                  filteredData.map((item) => (
                    <TableRow key={item.id}>
                      <TableCell className="whitespace-nowrap">
                        <div className="font-medium">{format(new Date(item.created_at), "dd MMM yyyy", { locale: id })}</div>
                        <div className="text-xs text-muted-foreground">{format(new Date(item.created_at), "HH:mm")}</div>
                      </TableCell>
                      <TableCell className="font-medium">{item.nama_barang}</TableCell>
                      <TableCell>
                        <span className="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold bg-muted text-muted-foreground">
                          {item.kategori_barang}
                        </span>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center gap-2">
                          {getJenisIcon(item.jenis_pergerakan)}
                          <span className={
                            item.jenis_pergerakan === 'Masuk' ? 'text-emerald-600 font-medium' :
                            item.jenis_pergerakan === 'Keluar' ? 'text-rose-600 font-medium' :
                            'text-amber-600 font-medium'
                          }>
                            {item.jenis_pergerakan}
                          </span>
                        </div>
                      </TableCell>
                      <TableCell className="text-right">{item.stok_sebelum}</TableCell>
                      <TableCell className="text-right font-medium">
                        {item.jenis_pergerakan === 'Keluar' ? '-' : '+'}{item.jumlah}
                      </TableCell>
                      <TableCell className="text-right font-bold">{item.stok_sesudah}</TableCell>
                      <TableCell>
                        <div className="max-w-[200px] truncate" title={item.referensi}>
                          {item.referensi}
                        </div>
                        {item.keterangan && (
                          <div className="text-xs text-muted-foreground max-w-[200px] truncate" title={item.keterangan}>
                            {item.keterangan}
                          </div>
                        )}
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
