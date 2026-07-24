"use server";

import { createClient } from "@/utils/supabase/server";

export async function getDashboardMetrics() {
  const supabase = await createClient();
  const today = new Date();
  
  // Format dates strictly using local time
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth() + 1).padStart(2, '0');
  const dd = String(today.getDate()).padStart(2, '0');
  const todayStr = `${yyyy}-${mm}-${dd}`;
  
  const firstDayOfMonth = `${yyyy}-${mm}-01`;
  const firstDayOfYear = `${yyyy}-01-01`;

  // Fetch all necessary data from the start of the year
  const [
    penjualanRes,
    produksiRes,
    gajiRes,
    operasionalRes,
    produkRes
  ] = await Promise.all([
    supabase.from("penjualan").select("id, tanggal, total, penjualan_detail(jumlah, hpp_satuan)").gte("tanggal", firstDayOfYear).is("deleted_at", null),
    supabase.from("produksi").select("id, tanggal_produksi, total_biaya_bahan, total_biaya_packaging, status, produksi_hasil(jumlah, produk_id)").gte("tanggal_produksi", firstDayOfYear).eq("status", "Selesai").is("deleted_at", null),
    supabase.from("gaji_harian").select("id, tanggal, nominal").gte("tanggal", firstDayOfYear).is("deleted_at", null),
    supabase.from("biaya_operasional").select("id, tanggal, nominal").gte("tanggal", firstDayOfYear).is("deleted_at", null),
    supabase.from("produk").select("id, nama, harga_jual, hpp").is("deleted_at", null)
  ]);

  const penjualanData = penjualanRes.data || [];
  const produksiData = produksiRes.data || [];
  const gajiData = gajiRes.data || [];
  const operasionalData = operasionalRes.data || [];
  const produkData = produkRes.data || [];

  const productMap = produkData.reduce((acc: any, p: any) => {
    acc[p.id] = { 
      nama: p.nama,
      harga: Number(p.harga_jual || 0), 
      hpp: Number(p.hpp || 0) 
    };
    return acc;
  }, {});

  const isToday = (dateStr: string) => dateStr === todayStr;
  const isThisMonth = (dateStr: string) => dateStr >= firstDayOfMonth;

  const calculateEstimatedRevAndCogs = (productions: any[]) => {
    return productions.reduce((acc, prod) => {
      const hasil = prod.produksi_hasil || [];
      const rev = hasil.reduce((subTotal: number, item: any) => subTotal + (Number(item.jumlah) * (productMap[item.produk_id]?.harga || 0)), 0);
      const cogs = hasil.reduce((subTotal: number, item: any) => subTotal + (Number(item.jumlah) * (productMap[item.produk_id]?.hpp || 0)), 0);
      return { rev: acc.rev + rev, cogs: acc.cogs + cogs };
    }, { rev: 0, cogs: 0 });
  };

  const calculateActualCogs = (sales: any[]) => {
    return sales.reduce((sum, sale) => {
      const details = sale.penjualan_detail || [];
      const saleCogs = details.reduce((sub: number, d: any) => sub + (Number(d.jumlah) * Number(d.hpp_satuan || 0)), 0);
      return sum + saleCogs;
    }, 0);
  };

  const calculateProdCost = (productions: any[]) => {
    return productions.reduce((total, prod) => total + Number(prod.total_biaya_bahan) + Number(prod.total_biaya_packaging), 0);
  };

  const calculateSalary = (salaries: any[]) => salaries.reduce((sum, s) => sum + Number(s.nominal), 0);
  const calculateRevenue = (sales: any[]) => sales.reduce((sum, s) => sum + Number(s.total), 0);
  const calculateOpCost = (ops: any[]) => ops.reduce((sum, o) => sum + Number(o.nominal), 0);

  // --- HARIAN ---
  const todayPenjualan = penjualanData.filter(p => isToday(p.tanggal));
  const todayProduksi = produksiData.filter(p => isToday(p.tanggal_produksi));
  const todayGaji = gajiData.filter(p => isToday(p.tanggal));

  const dailyActualRevenue = calculateRevenue(todayPenjualan);
  const dailyActualCogs = calculateActualCogs(todayPenjualan);
  const dailyEstInfo = calculateEstimatedRevAndCogs(todayProduksi);
  const dailyEstimatedRevenue = dailyEstInfo.rev;
  const dailyEstimatedCogs = dailyEstInfo.cogs;
  
  const dailyProdCost = calculateProdCost(todayProduksi); // for reference if needed
  const dailySalary = calculateSalary(todayGaji);
  
  const dailyActualGrossProfit = dailyActualRevenue - dailyActualCogs - dailySalary;
  const dailyEstimatedGrossProfit = dailyEstimatedRevenue - dailyEstimatedCogs - dailySalary;

  // --- BULANAN ---
  const monthPenjualan = penjualanData.filter(p => isThisMonth(p.tanggal));
  const monthProduksi = produksiData.filter(p => isThisMonth(p.tanggal_produksi));
  const monthGaji = gajiData.filter(p => isThisMonth(p.tanggal));
  const monthOperasional = operasionalData.filter(p => isThisMonth(p.tanggal));

  const monthlyActualRevenue = calculateRevenue(monthPenjualan);
  const monthlyActualCogs = calculateActualCogs(monthPenjualan);
  const monthlyProdCost = calculateProdCost(monthProduksi);
  const monthlySalary = calculateSalary(monthGaji);
  const monthlyOpCost = calculateOpCost(monthOperasional);
  
  // Real cashflow profit for monthly (Revenue - Material Cost - Salary - OpCost)
  const monthlyCashProfit = monthlyActualRevenue - monthlyProdCost - monthlySalary - monthlyOpCost;
  // Or if we want to show Actual Gross Profit based on COGS:
  const monthlyGrossProfit = monthlyActualRevenue - monthlyActualCogs - monthlySalary;
  const monthlyNetProfit = monthlyGrossProfit - monthlyOpCost;

  // Monthly Estimations
  const monthlyEstInfo = calculateEstimatedRevAndCogs(monthProduksi);
  const monthlyEstimatedRevenue = monthlyEstInfo.rev;
  const monthlyEstimatedCogs = monthlyEstInfo.cogs;
  const monthlyEstimatedGrossProfit = monthlyEstimatedRevenue - monthlyEstimatedCogs - monthlySalary;
  const monthlyEstimatedNetProfit = monthlyEstimatedGrossProfit - monthlyOpCost;
  
  // Rekap Produksi Bulanan
  const rekapProduksi = monthProduksi.reduce((acc: any, prod) => {
    (prod.produksi_hasil || []).forEach((item: any) => {
      const pName = productMap[item.produk_id]?.nama || 'Unknown';
      if (!acc[pName]) acc[pName] = 0;
      acc[pName] += Number(item.jumlah);
    });
    return acc;
  }, {});

  // --- TAHUNAN ---
  const yearlyActualRevenue = calculateRevenue(penjualanData);
  const yearlyActualCogs = calculateActualCogs(penjualanData);
  const yearlyProdCost = calculateProdCost(produksiData);
  const yearlySalary = calculateSalary(gajiData);
  const yearlyOpCost = calculateOpCost(operasionalData);

  const yearlyGrossProfit = yearlyActualRevenue - yearlyActualCogs - yearlySalary;
  const yearlyNetProfit = yearlyGrossProfit - yearlyOpCost;

  // --- CHART TRENDS ---

  // 1. Trend Harian (7 Hari Terakhir)
  const trendHarian = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date();
    d.setDate(today.getDate() - i);
    const dStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
    const displayStr = d.toLocaleDateString('id-ID', { day: 'numeric', month: 'short' });

    const rev = calculateRevenue(penjualanData.filter(p => p.tanggal === dStr));
    const cogs = calculateActualCogs(penjualanData.filter(p => p.tanggal === dStr));
    const prod = produksiData.filter(p => p.tanggal_produksi === dStr);
    const est = calculateEstimatedRevAndCogs(prod);
    const sal = calculateSalary(gajiData.filter(p => p.tanggal === dStr));
    
    trendHarian.push({
      date: displayStr,
      actualRevenue: rev,
      estimatedRevenue: est.rev,
      actualGross: rev - cogs - sal,
      estimatedGross: est.rev - est.cogs - sal
    });
  }

  // 2. Trend Bulanan (Per Tanggal dalam Bulan Ini)
  const trendBulanan = [];
  const daysInMonth = new Date(yyyy, today.getMonth() + 1, 0).getDate(); // Get last day of month
  // We can just iterate from day 1 up to today.getDate() to not show flat line for future days
  for (let i = 1; i <= today.getDate(); i++) {
    const dStr = `${yyyy}-${mm}-${String(i).padStart(2, '0')}`;
    const rev = calculateRevenue(penjualanData.filter(p => p.tanggal === dStr));
    const cogs = calculateActualCogs(penjualanData.filter(p => p.tanggal === dStr));
    const sal = calculateSalary(gajiData.filter(p => p.tanggal === dStr));
    const op = calculateOpCost(operasionalData.filter(p => p.tanggal === dStr));
    
    const gross = rev - cogs - sal;
    const net = gross - op;

    trendBulanan.push({
      date: `${i} ${new Date(yyyy, today.getMonth(), i).toLocaleDateString('id-ID', { month: 'short' })}`,
      revenue: rev,
      netProfit: net
    });
  }

  // 3. Trend Tahunan (Per Bulan dalam Tahun Ini)
  const trendTahunan = [];
  // Loop from Jan up to current month
  for (let m = 0; m <= today.getMonth(); m++) {
    const monthStr = String(m + 1).padStart(2, '0');
    // Filter matching month in the string YYYY-MM
    const prefix = `${yyyy}-${monthStr}`;
    
    const mRev = calculateRevenue(penjualanData.filter(p => p.tanggal.startsWith(prefix)));
    const mCogs = calculateActualCogs(penjualanData.filter(p => p.tanggal.startsWith(prefix)));
    const mSal = calculateSalary(gajiData.filter(p => p.tanggal.startsWith(prefix)));
    const mOp = calculateOpCost(operasionalData.filter(p => p.tanggal.startsWith(prefix)));
    
    const mGross = mRev - mCogs - mSal;
    const mNet = mGross - mOp;

    const monthName = new Date(yyyy, m, 1).toLocaleDateString('id-ID', { month: 'long' });
    trendTahunan.push({
      month: monthName,
      revenue: mRev,
      netProfit: mNet
    });
  }

  // --- RECENT TRANSACTIONS ---
  const { data: recentTrxData } = await supabase
    .from("penjualan")
    .select("id, tanggal, total, created_at, penjualan_detail(jumlah)")
    .is("deleted_at", null)
    .order("created_at", { ascending: false })
    .limit(5);

  const recentTransactions = (recentTrxData || []).map(trx => {
    const itemsCount = trx.penjualan_detail?.reduce((sum: number, detail: any) => sum + Number(detail.jumlah), 0) || 0;
    return {
      id: trx.id,
      date: new Date(trx.created_at).toLocaleString('id-ID', { dateStyle: 'medium', timeStyle: 'short' }),
      amount: Number(trx.total),
      items: itemsCount
    };
  });

  return {
    harian: {
      actualRevenue: dailyActualRevenue,
      estimatedRevenue: dailyEstimatedRevenue,
      prodCost: dailyProdCost,
      salary: dailySalary,
      actualGrossProfit: dailyActualGrossProfit,
      estimatedGrossProfit: dailyEstimatedGrossProfit
    },
    bulanan: {
      revenue: monthlyActualRevenue,
      cogs: monthlyActualCogs,
      prodCost: monthlyProdCost, // Real cash spent on ingredients
      salary: monthlySalary,
      grossProfit: monthlyGrossProfit,
      opCost: monthlyOpCost,
      netProfit: monthlyNetProfit,
      cashProfit: monthlyCashProfit,
      estimatedRevenue: monthlyEstimatedRevenue,
      estimatedCogs: monthlyEstimatedCogs,
      estimatedGrossProfit: monthlyEstimatedGrossProfit,
      estimatedNetProfit: monthlyEstimatedNetProfit,
      rekapProduksi
    },
    tahunan: {
      revenue: yearlyActualRevenue,
      grossProfit: yearlyGrossProfit,
      opCost: yearlyOpCost,
      netProfit: yearlyNetProfit
    },
    trendHarian,
    trendBulanan,
    trendTahunan,
    recentTransactions
  };
}
