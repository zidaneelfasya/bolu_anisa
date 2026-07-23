"use client";

import { useEffect, useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { DollarSign, Layers, Package, Users, TrendingUp, Clock, Loader2, ArrowUpRight, CheckCircle2, AlertCircle } from "lucide-react";
import { Area, AreaChart, CartesianGrid, XAxis, ResponsiveContainer, Bar, BarChart, Tooltip } from "recharts";
import { ChartContainer, ChartTooltip, ChartTooltipContent } from "@/components/ui/chart";
import { Button } from "@/components/ui/button";
import { getDashboardMetrics } from "./actions";
import Link from "next/link";

const harianChartConfig = {
  estimatedGross: {
    label: "Profit Estimasi",
    color: "hsl(var(--primary))",
  },
  actualGross: {
    label: "Gross Profit Asli",
    color: "hsl(var(--chart-2))",
  }
};

const defaultChartConfig = {
  netProfit: {
    label: "Laba Bersih",
    color: "hsl(var(--primary))",
  },
  revenue: {
    label: "Pendapatan",
    color: "hsl(var(--chart-3))",
  }
};

export default function DashboardPage() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadData() {
      try {
        const metrics = await getDashboardMetrics();
        setData(metrics);
      } catch (error) {
        console.error("Error loading dashboard metrics:", error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  if (loading) {
    return (
      <div className="flex-1 flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
        <span className="ml-2 text-muted-foreground">Memuat Laporan Keuangan...</span>
      </div>
    );
  }

  if (!data) return null;

  return (
    <div className="flex-1 space-y-6">
      <div className="flex items-center justify-between space-y-2">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-primary">Overview Keuangan</h2>
          <p className="text-muted-foreground mt-1">
            Ringkasan pendapatan, HPP, gaji, operasional dan keuntungan toko Bolu Anisa.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Link href="/transaksi/penjualan/create">
            <Button>Input Penjualan</Button>
          </Link>
        </div>
      </div>

      <Tabs defaultValue="harian" className="space-y-6">
        <div className="flex justify-between items-center">
          <TabsList className="bg-slate-100">
            <TabsTrigger value="harian" className="data-[state=active]:bg-white data-[state=active]:text-primary">Harian</TabsTrigger>
            <TabsTrigger value="bulanan" className="data-[state=active]:bg-white data-[state=active]:text-primary">Bulanan</TabsTrigger>
            <TabsTrigger value="tahunan" className="data-[state=active]:bg-white data-[state=active]:text-primary">Tahunan</TabsTrigger>
          </TabsList>
        </div>

        {/* ======================= TAB HARIAN ======================= */}
        <TabsContent value="harian" className="space-y-6 outline-none">
          <div className="grid gap-4 md:grid-cols-2">
            <Card className="hover:shadow-md transition-all border-l-4 border-l-amber-500">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium flex items-center gap-2">
                  <AlertCircle className="h-4 w-4 text-amber-500" />
                  Profit Estimasi
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-amber-600">
                  Rp {data.harian.estimatedGrossProfit.toLocaleString('id-ID')}
                </div>
                <div className="text-xs text-muted-foreground mt-2 space-y-1">
                  <div className="flex justify-between font-medium">
                    <span>Estimasi Pendapatan (Produk Terjual 100%):</span>
                    <span className="text-slate-700">Rp {data.harian.estimatedRevenue.toLocaleString('id-ID')}</span>
                  </div>
                  <div className="flex justify-between text-red-500">
                    <span>Biaya HPP Produksi (Selesai):</span>
                    <span>-Rp {data.harian.prodCost.toLocaleString('id-ID')}</span>
                  </div>
                  <div className="flex justify-between text-red-500">
                    <span>Biaya Gaji (Harian & Borongan):</span>
                    <span>-Rp {data.harian.salary.toLocaleString('id-ID')}</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="hover:shadow-md transition-all border-l-4 border-l-blue-500">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium flex items-center gap-2">
                  <CheckCircle2 className="h-4 w-4 text-blue-500" />
                  Gross Profit Asli
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-blue-600">
                  Rp {data.harian.actualGrossProfit.toLocaleString('id-ID')}
                </div>
                <div className="text-xs text-muted-foreground mt-2 space-y-1">
                  <div className="flex justify-between font-medium">
                    <span>Pendapatan Real (Kas Masuk):</span>
                    <span className="text-slate-700">Rp {data.harian.actualRevenue.toLocaleString('id-ID')}</span>
                  </div>
                  <div className="flex justify-between text-red-500">
                    <span>Biaya HPP Produksi (Selesai):</span>
                    <span>-Rp {data.harian.prodCost.toLocaleString('id-ID')}</span>
                  </div>
                  <div className="flex justify-between text-red-500">
                    <span>Biaya Gaji (Harian & Borongan):</span>
                    <span>-Rp {data.harian.salary.toLocaleString('id-ID')}</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
            <Card className="col-span-4 lg:col-span-4 hover:shadow-md transition-all">
              <CardHeader>
                <CardTitle>Tren 7 Hari Terakhir</CardTitle>
                <CardDescription>Perbandingan Profit Estimasi dan Profit Asli Harian.</CardDescription>
              </CardHeader>
              <CardContent>
                <ChartContainer config={harianChartConfig} className="h-[300px] w-full">
                  <AreaChart data={data.trendHarian} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                    <defs>
                      <linearGradient id="colorEst" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="var(--color-estimatedGross)" stopOpacity={0.3} />
                        <stop offset="95%" stopColor="var(--color-estimatedGross)" stopOpacity={0} />
                      </linearGradient>
                      <linearGradient id="colorAct" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="var(--color-actualGross)" stopOpacity={0.3} />
                        <stop offset="95%" stopColor="var(--color-actualGross)" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--border))" />
                    <XAxis dataKey="date" tickLine={false} axisLine={false} tickMargin={8} className="text-xs text-muted-foreground" />
                    <ChartTooltip content={<ChartTooltipContent indicator="line" />} />
                    <Area 
                      type="monotone" 
                      dataKey="estimatedGross" 
                      name="Profit Estimasi"
                      stroke="var(--color-estimatedGross)" 
                      fillOpacity={1} 
                      fill="url(#colorEst)" 
                      strokeWidth={2}
                    />
                    <Area 
                      type="monotone" 
                      dataKey="actualGross"
                      name="Gross Profit Asli"
                      stroke="var(--color-actualGross)" 
                      fillOpacity={1} 
                      fill="url(#colorAct)" 
                      strokeWidth={2}
                    />
                  </AreaChart>
                </ChartContainer>
              </CardContent>
            </Card>
            
            <Card className="col-span-3 lg:col-span-3 hover:shadow-md transition-all">
              <CardHeader>
                <CardTitle>Penjualan Terakhir</CardTitle>
                <CardDescription>5 Transaksi terbaru yang tercatat.</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-6">
                  {data.recentTransactions.length === 0 ? (
                    <div className="text-center py-8 text-muted-foreground">
                      Belum ada transaksi penjualan.
                    </div>
                  ) : (
                    data.recentTransactions.map((trx: any) => (
                      <div key={trx.id} className="flex items-center justify-between">
                        <div className="space-y-1">
                          <div className="flex items-center gap-2">
                            <Package className="h-4 w-4 text-primary" />
                            <p className="text-sm font-medium leading-none">{trx.items} Item Terjual</p>
                          </div>
                          <p className="text-xs text-muted-foreground flex items-center gap-1">
                            <Clock className="h-3 w-3" /> {trx.date}
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="text-sm font-bold text-emerald-600">
                            + Rp {trx.amount.toLocaleString('id-ID')}
                          </p>
                        </div>
                      </div>
                    ))
                  )}
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* ======================= TAB BULANAN ======================= */}
        <TabsContent value="bulanan" className="space-y-6 outline-none">
          <div className="grid gap-4 md:grid-cols-3">
            <Card className="hover:shadow-md transition-all">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Akumulasi Laba Kotor</CardTitle>
                <DollarSign className="h-4 w-4 text-slate-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">
                  Rp {data.bulanan.grossProfit.toLocaleString('id-ID')}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Total (Pendapatan - HPP - Gaji)
                </p>
              </CardContent>
            </Card>
            <Card className="hover:shadow-md transition-all">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Biaya Operasional</CardTitle>
                <Layers className="h-4 w-4 text-slate-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-red-500">
                  - Rp {data.bulanan.opCost.toLocaleString('id-ID')}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Tagihan listrik, sewa, dll bulan ini
                </p>
              </CardContent>
            </Card>
            <Card className="hover:shadow-md transition-all border-l-4 border-l-emerald-500">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Laba Bersih (Net Profit)</CardTitle>
                <TrendingUp className="h-4 w-4 text-emerald-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-emerald-600">
                  Rp {data.bulanan.netProfit.toLocaleString('id-ID')}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Laba murni bersih bulan berjalan
                </p>
              </CardContent>
            </Card>
          </div>

          <Card className="hover:shadow-md transition-all">
            <CardHeader>
              <CardTitle>Tren Kinerja Bulan Ini</CardTitle>
              <CardDescription>Perbandingan Pendapatan dan Laba Bersih per tanggal.</CardDescription>
            </CardHeader>
            <CardContent>
              <ChartContainer config={defaultChartConfig} className="h-[300px] w-full">
                <AreaChart data={data.trendBulanan} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                  <defs>
                    <linearGradient id="colorNet" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="var(--color-netProfit)" stopOpacity={0.3} />
                      <stop offset="95%" stopColor="var(--color-netProfit)" stopOpacity={0} />
                    </linearGradient>
                    <linearGradient id="colorRevM" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="var(--color-revenue)" stopOpacity={0.1} />
                      <stop offset="95%" stopColor="var(--color-revenue)" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--border))" />
                  <XAxis dataKey="date" tickLine={false} axisLine={false} tickMargin={8} className="text-xs text-muted-foreground" />
                  <ChartTooltip content={<ChartTooltipContent indicator="line" />} />
                  <Area 
                    type="monotone" 
                    dataKey="revenue" 
                    name="Pendapatan"
                    stroke="var(--color-revenue)" 
                    fillOpacity={1} 
                    fill="url(#colorRevM)" 
                    strokeWidth={2}
                  />
                  <Area 
                    type="monotone" 
                    dataKey="netProfit"
                    name="Laba Bersih"
                    stroke="var(--color-netProfit)" 
                    fillOpacity={1} 
                    fill="url(#colorNet)" 
                    strokeWidth={2}
                  />
                </AreaChart>
              </ChartContainer>
            </CardContent>
          </Card>
        </TabsContent>

        {/* ======================= TAB TAHUNAN ======================= */}
        <TabsContent value="tahunan" className="space-y-6 outline-none">
          <div className="grid gap-4 md:grid-cols-3">
            <Card className="hover:shadow-md transition-all">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Total Laba Kotor</CardTitle>
                <DollarSign className="h-4 w-4 text-slate-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">
                  Rp {data.tahunan.grossProfit.toLocaleString('id-ID')}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Total (Pendapatan - HPP - Gaji) Setahun
                </p>
              </CardContent>
            </Card>
            <Card className="hover:shadow-md transition-all">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Total Biaya Operasional</CardTitle>
                <Layers className="h-4 w-4 text-slate-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-red-500">
                  - Rp {data.tahunan.opCost.toLocaleString('id-ID')}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Akumulasi biaya listrik, sewa, dll setahun
                </p>
              </CardContent>
            </Card>
            <Card className="hover:shadow-md transition-all border-l-4 border-l-amber-500">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Laba Bersih Tahunan</CardTitle>
                <TrendingUp className="h-4 w-4 text-amber-500" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-amber-600">
                  Rp {data.tahunan.netProfit.toLocaleString('id-ID')}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Laba murni bersih akumulasi tahun ini
                </p>
              </CardContent>
            </Card>
          </div>

          <Card className="hover:shadow-md transition-all">
            <CardHeader>
              <CardTitle>Tren Kinerja Sepanjang Tahun</CardTitle>
              <CardDescription>Grafik batang perbandingan Pendapatan dan Laba Bersih tiap bulan.</CardDescription>
            </CardHeader>
            <CardContent>
              <ChartContainer config={defaultChartConfig} className="h-[300px] w-full">
                <BarChart data={data.trendTahunan} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--border))" />
                  <XAxis dataKey="month" tickLine={false} axisLine={false} tickMargin={8} className="text-xs text-muted-foreground" />
                  <ChartTooltip content={<ChartTooltipContent indicator="dashed" />} cursor={{ fill: 'hsl(var(--muted))' }} />
                  <Bar dataKey="revenue" name="Pendapatan" fill="var(--color-revenue)" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="netProfit" name="Laba Bersih" fill="var(--color-netProfit)" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ChartContainer>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
