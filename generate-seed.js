const fs = require('fs');
const crypto = require('crypto');

// Fixed UUIDs for master data
const karyawan = [
  { id: crypto.randomUUID(), nama: 'Bapak Yanto', status: 'Aktif' },
  { id: crypto.randomUUID(), nama: 'Ibu Siti', status: 'Aktif' },
  { id: crypto.randomUUID(), nama: 'Mbak Ani', status: 'Aktif' },
  { id: crypto.randomUUID(), nama: 'Mas Budi', status: 'Aktif' },
  { id: crypto.randomUUID(), nama: 'Mbak Rina', status: 'Aktif' },
  { id: crypto.randomUUID(), nama: 'Mas Joko', status: 'Aktif' }
];

const bahanBaku = [
  { id: crypto.randomUUID(), nama: 'GULA', hrg: 15000, sat: 'Kg' },
  { id: crypto.randomUUID(), nama: 'TERIGU', hrg: 6800, sat: 'Kg' },
  { id: crypto.randomUUID(), nama: 'TELUR', hrg: 26000, sat: 'Kg' },
  { id: crypto.randomUUID(), nama: 'MINYAK', hrg: 18000, sat: 'Kg' },
  { id: crypto.randomUUID(), nama: 'GAS', hrg: 18000, sat: 'Tabung' },
  { id: crypto.randomUUID(), nama: 'LAIN-LAIN', hrg: 150000, sat: 'Paket' }
];

const pack = [
  { id: crypto.randomUUID(), nama: 'STIKER SEMUA VARIAN', hrg: 80 },
  { id: crypto.randomUUID(), nama: 'PLASTIK SEMUA VARIAN', hrg: 350 },
  { id: crypto.randomUUID(), nama: 'MIKA SEMUA VARIAN', hrg: 200 },
  { id: crypto.randomUUID(), nama: 'TOPLES PIA', hrg: 500 }
];

const produk = [
  { id: crypto.randomUUID(), nama: 'PIA ORI', harga_jual: 15000, hpp: 7000 },
  { id: crypto.randomUUID(), nama: 'PIA COKLAT', harga_jual: 12000, hpp: 6000 },
  { id: crypto.randomUUID(), nama: 'KEMBANG SIRIH', harga_jual: 16000, hpp: 8000 },
  { id: crypto.randomUUID(), nama: 'KECIPIR', harga_jual: 14000, hpp: 7000 },
  { id: crypto.randomUUID(), nama: 'SALE B', harga_jual: 30000, hpp: 15000 },
  { id: crypto.randomUUID(), nama: 'SALE K', harga_jual: 14000, hpp: 7000 },
  { id: crypto.randomUUID(), nama: 'KUPING GAJAH', harga_jual: 16000, hpp: 8000 },
  { id: crypto.randomUUID(), nama: 'LADRANG', harga_jual: 15000, hpp: 7500 },
  { id: crypto.randomUUID(), nama: 'PASTEL CUMI', harga_jual: 17000, hpp: 8500 },
  { id: crypto.randomUUID(), nama: 'PIA TOPLES ORI', harga_jual: 15000, hpp: 7000 },
  { id: crypto.randomUUID(), nama: 'PIA TOPLES COKLAT', harga_jual: 15000, hpp: 7000 }
];

const rateBorongan = [
  { id: crypto.randomUUID(), nama: 'Cetak Kue', jenis: 'Produksi', rate: 1500 },
  { id: crypto.randomUUID(), nama: 'Packaging & Stiker', jenis: 'Packaging', rate: 200 }
];

let sql = `-- SEEDER DATA REALISTIS BOLU ANISA
-- Dibuat berdasarkan LABA HARIAN.xlsx 

TRUNCATE TABLE 
    stock_movements, biaya_operasional, cash_flow, gaji_harian, rate_borongan, 
    karyawan, penjualan_detail, penjualan, produksi_hasil, produksi_packaging, 
    produksi_bahan, produksi, pembelian_packaging_detail, pembelian_bahan_detail, 
    pembelian, produk, packaging, bahan_baku CASCADE;

`;

// INSERT MASTER DATA
sql += `-- MASTER KARYAWANnINSERT INTO karyawan (id, nama, status) VALUESn`;
sql += karyawan.map(k => `('${k.id}', '${k.nama}', '${k.status}')`).join(",n") + ";nn";

sql += `-- MASTER BAHAN BAKUnINSERT INTO bahan_baku (id, nama, satuan, stok, minimum_stok, harga_terakhir, harga_rata_rata) VALUESn`;
sql += bahanBaku.map(b => `('${b.id}', '${b.nama}', '${b.sat}', 1000, 10, ${b.hrg}, ${b.hrg})`).join(",n") + ";nn";

sql += `-- MASTER PACKAGINGnINSERT INTO packaging (id, nama, jenis, harga_per_pcs, stok, minimum_stok) VALUESn`;
sql += pack.map(p => `('${p.id}', '${p.nama}', 'Pcs', ${p.hrg}, 5000, 100)`).join(",n") + ";nn";

sql += `-- MASTER PRODUKnINSERT INTO produk (id, nama, harga_jual, hpp, stok) VALUESn`;
sql += produk.map(p => `('${p.id}', '${p.nama}', ${p.harga_jual}, ${p.hpp}, 200)`).join(",n") + ";nn";

sql += `-- MASTER RATE BORONGANnINSERT INTO rate_borongan (id, nama, jenis, rate) VALUESn`;
sql += rateBorongan.map(r => `('${r.id}', '${r.nama}', '${r.jenis}', ${r.rate})`).join(",n") + ";nn";

// GENERATE DAILY TRANSACTIONS
let d = new Date('2026-01-01');
const end = new Date('2026-07-22');

const randomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
const randomPick = (arr) => arr[Math.floor(Math.random() * arr.length)];

sql += `-- ==========================================n`;
sql += `-- TRANSAKSI (JANUARI - JULI 2026)n`;
sql += `-- ==========================================nn`;

let prodIdx = 1;

while (d <= end) {
  const dateStr = d.toISOString().split('T')[0];
  
  // Every day produce similar to LABA HARIAN.xlsx
  // Let's add slight randomization (+- 10%)
  const mult = randomInt(80, 120) / 100;
  
  // Daily Prod Cost calculation
  const b_gula = Math.round(141 * mult);
  const b_terigu = Math.round(125 * mult);
  const b_telur = Math.round(50 * mult);
  const b_minyak = Math.round(13 * mult); // 234k / 18k = 13
  const b_gas = Math.round(7 * mult);
  const b_lain = 1;

  let totalBahan = 0;
  let bahanInserts = '';
  const prodId = crypto.randomUUID();
  const prodNum = `PRD-${dateStr.replace(/-/g, '')}-${prodIdx++}`;

  const bParams = [
    { id: bahanBaku[0].id, q: b_gula, p: bahanBaku[0].hrg },
    { id: bahanBaku[1].id, q: b_terigu, p: bahanBaku[1].hrg },
    { id: bahanBaku[2].id, q: b_telur, p: bahanBaku[2].hrg },
    { id: bahanBaku[3].id, q: b_minyak, p: bahanBaku[3].hrg },
    { id: bahanBaku[4].id, q: b_gas, p: bahanBaku[4].hrg },
    { id: bahanBaku[5].id, q: b_lain, p: bahanBaku[5].hrg }
  ];

  for (let b of bParams) {
    const sub = b.q * b.p;
    totalBahan += sub;
    bahanInserts += `INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('${prodId}', '${b.id}', ${b.q}, ${b.p}, ${sub});n`;
  }

  // Daily Packaging Cost calculation
  const p_stiker = Math.round(530 * mult);
  const p_plastik = Math.round(580 * mult);
  const p_toples = Math.round(100 * mult);

  let totalPack = 0;
  let packInserts = '';
  
  const pParams = [
    { id: pack[0].id, q: p_stiker, p: pack[0].hrg },
    { id: pack[1].id, q: p_plastik, p: pack[1].hrg },
    { id: pack[3].id, q: p_toples, p: pack[3].hrg }
  ];

  for (let p of pParams) {
    const sub = p.q * p.p;
    totalPack += sub;
    packInserts += `INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('${prodId}', '${p.id}', ${p.q}, ${p.p}, ${sub});n`;
  }

  // Daily Output
  let prodInserts = '';
  let totalOutputQty = 0;
  
  const outParams = [
    { id: produk[0].id, q: Math.round(50 * mult) },
    { id: produk[1].id, q: Math.round(50 * mult) },
    { id: produk[2].id, q: Math.round(50 * mult) },
    { id: produk[3].id, q: Math.round(50 * mult) },
    { id: produk[4].id, q: Math.round(100 * mult) }, // SALE B
    { id: produk[5].id, q: Math.round(100 * mult) }, // SALE K
    { id: produk[6].id, q: Math.round(50 * mult) },
    { id: produk[7].id, q: Math.round(30 * mult) },
    { id: produk[8].id, q: Math.round(50 * mult) },
    { id: produk[9].id, q: Math.round(50 * mult) },
    { id: produk[10].id, q: Math.round(50 * mult) }
  ];

  for (let op of outParams) {
    if (op.q > 0) {
      totalOutputQty += op.q;
      prodInserts += `INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('${prodId}', '${op.id}', ${op.q});n`;
    }
  }

  sql += `INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('${prodId}', '${prodNum}', '${dateStr}', 'Selesai', ${totalBahan}, ${totalPack});n`;
  sql += bahanInserts;
  sql += packInserts;
  sql += prodInserts;
  sql += "n";

  // GAJI untuk hari itu
  sql += `INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('${dateStr}', '${karyawan[0].id}', 'Harian', 75000, 'Gaji Shift Pagi');n`;
  sql += `INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('${dateStr}', '${karyawan[1].id}', 'Harian', 75000, 'Gaji Shift Pagi');n`;
  
  // Borongan cetak kue & packaging
  const gajiCetak = totalOutputQty * 1500;
  const gajiPack = totalOutputQty * 200;
  sql += `INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('${dateStr}', '${karyawan[2].id}', 'Borongan Produksi', ${gajiCetak}, 'Cetak Kue ${totalOutputQty} pcs');n`;
  sql += `INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('${dateStr}', '${karyawan[3].id}', 'Borongan Packaging', ${gajiPack}, 'Pack & Stiker ${totalOutputQty} pcs');nn`;


  // PENJUALAN (Semua hasil produksi hari itu dianggap terjual lewat beberapa transaksi)
  const numSales = randomInt(5, 12);
  let saleBatches = Array(numSales).fill(0).map(() => []);
  
  for (let op of outParams) {
    let remaining = op.q;
    while (remaining > 0) {
      const take = randomInt(1, Math.min(remaining, 15));
      const sIdx = randomInt(0, numSales - 1);
      
      const existingItem = saleBatches[sIdx].find(i => i.id === op.id);
      if (existingItem) {
        existingItem.q += take;
      } else {
        saleBatches[sIdx].push({ id: op.id, q: take });
      }
      remaining -= take;
    }
  }

  // Insert Penjualan
  for (let s = 0; s < numSales; s++) {
    const batch = saleBatches[s];
    if (batch.length === 0) continue;

    const saleId = crypto.randomUUID();
    const createdAt = `${dateStr} ${String(randomInt(8, 20)).padStart(2, '0')}:${String(randomInt(0, 59)).padStart(2, '0')}:00`;
    
    let totalSale = 0;
    let detailQueries = '';

    const randomCust = randomPick(['Bpk Budi', 'Toko Kue ABC', 'Bu Sari', 'Reseller', 'Eceran']);
    const isEceran = randomCust === 'Eceran';

    for (let item of batch) {
      const pData = produk.find(p => p.id === item.id);
      const isCustomPrice = Math.random() > 0.7; // Kadang ada harga diskon
      const price = isCustomPrice && !isEceran ? pData.harga_jual - 1000 : pData.harga_jual;
      
      const sub = item.q * price;
      totalSale += sub;
      detailQueries += `INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('${saleId}', '${item.id}', ${item.q}, ${price}, ${sub});n`;
    }

    const ket = isEceran ? '' : `'${randomCust}'`;
    sql += `INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('${saleId}', '${dateStr}', ${ket || 'NULL'}, ${totalSale}, '${createdAt}');n`;
    sql += detailQueries + "n";
  }

  // OPERASIONAL (Bulanan tanggal 25)
  if (d.getDate() === 25) {
    sql += `INSERT INTO biaya_operasional (tanggal, kategori, deskripsi, nominal) VALUES ('${dateStr}', 'Listrik & Air', 'Pembayaran Bulanan', 850000);n`;
    sql += `INSERT INTO biaya_operasional (tanggal, kategori, deskripsi, nominal) VALUES ('${dateStr}', 'Internet', 'Wifi Indihome', 350000);nn`;
  }

  d.setDate(d.getDate() + 1);
}

fs.writeFileSync('seed.sql', sql);
console.log('Successfully generated realistic seed.sql with Laba Harian simulation!');
