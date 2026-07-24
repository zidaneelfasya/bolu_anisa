const fs = require('fs');

const masterData = `
-- SEEDER DATA REALISTIS BOLU ANISA
-- Dibuat berdasarkan LABA HARIAN.xlsx untuk tanggal 17 Juli - 23 Juli 2026

TRUNCATE TABLE 
    stock_movements, biaya_operasional, cash_flow, gaji_harian, rate_borongan, 
    karyawan, penjualan_detail, penjualan, produksi_hasil, produksi_packaging, 
    produksi_bahan, produksi, pembelian_packaging_detail, pembelian_bahan_detail, 
    pembelian, produk, packaging, bahan_baku CASCADE;

-- MASTER KARYAWAN
INSERT INTO karyawan (id, nama, status) VALUES
('29db5630-53d6-4938-b362-937820d4b96e', 'Bapak Yanto', 'Aktif'),
('3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Ibu Siti', 'Aktif'),
('c203a896-db4b-49d5-a2bf-21fc5c010057', 'Mbak Ani', 'Aktif'),
('0cf16460-3903-48db-b286-9fcb902db689', 'Mas Budi', 'Aktif'),
('afe1f808-9773-4c28-a16c-c5ff518b55c9', 'Mbak Rina', 'Aktif'),
('93657a14-cf21-4036-bb34-184969711a46', 'Mas Joko', 'Aktif');

-- MASTER BAHAN BAKU
INSERT INTO bahan_baku (id, nama, satuan, stok, minimum_stok, harga_terakhir, harga_rata_rata) VALUES
('92b9eadf-6513-4266-8b55-89d8cba47c79', 'GULA', 'Kg', 1000, 10, 15000, 15000),
('4c610743-10af-4973-8baf-c40cebc46896', 'TERIGU', 'Kg', 1000, 10, 6800, 6800),
('21efeda7-0b32-4b99-a454-d92f38fb118f', 'TELUR', 'Kg', 1000, 10, 26000, 26000),
('a764e783-8021-4cd1-bb0c-5ee1c27c819d', 'MINYAK', 'Kg', 1000, 10, 18000, 18000),
('79457130-c0d2-4f62-8a5a-2658e2a47dd7', 'GAS', 'Tabung', 1000, 10, 18000, 18000),
('43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 'LAIN-LAIN', 'Paket', 1000, 10, 150000, 150000);

-- MASTER PACKAGING
INSERT INTO packaging (id, nama, jenis, harga_per_pcs, stok, minimum_stok) VALUES
('edc8432f-fe5a-4574-8921-71d734a4ee75', 'STIKER SEMUA VARIAN', 'Pcs', 80, 5000, 100),
('b11caa72-d87c-4999-bc0b-eeba1805bb68', 'PLASTIK SEMUA VARIAN', 'Pcs', 350, 5000, 100),
('6dc4c670-995e-41d3-a4d8-733a85b1f150', 'MIKA SEMUA VARIAN', 'Pcs', 200, 5000, 100),
('b142b0ce-120f-431b-942e-f182b6e60841', 'TOPLES PIA', 'Pcs', 500, 5000, 100);

-- MASTER PRODUK
INSERT INTO produk (id, nama, harga_jual, hpp, stok) VALUES
('40d3687a-b79a-4693-a5a9-d86793a6d436', 'PIA ORI', 15000, 7000, 200),
('6c06beee-bff9-483b-b651-f888b8881a97', 'PIA COKLAT', 12000, 6000, 200),
('11a6d461-5b7a-4a0e-a629-82406a22d824', 'KEMBANG SIRIH', 16000, 8000, 200),
('e131c794-e7d7-48f3-855b-ba2e25348226', 'KECIPIR', 14000, 7000, 200),
('3de269c2-ad21-45b4-89e0-0f57618eaf81', 'SALE B', 30000, 15000, 200),
('155a9b23-cb5f-4253-b09d-475ba47c2568', 'SALE K', 14000, 7000, 200),
('c630378c-faa3-4b45-a83e-b87cd7b0277c', 'KUPING GAJAH', 16000, 8000, 200),
('38cfc22f-2a14-4c2b-a248-b52b17ab8008', 'LADRANG', 15000, 7500, 200),
('b6fde04a-590a-4570-8b57-0a109ed9fa21', 'PASTEL CUMI', 17000, 8500, 200),
('e11f9941-669c-47e7-aaaa-8e373bfce877', 'PIA TOPLES ORI', 15000, 7000, 200),
('be25bd23-4f9b-4309-9497-60598a0477eb', 'PIA TOPLES COKLAT', 15000, 7000, 200);

-- MASTER RATE BORONGAN
INSERT INTO rate_borongan (id, nama, jenis, rate) VALUES
('3da2cc9b-7a03-464f-90a1-2277191f027b', 'Cetak Kue', 'Produksi', 1500),
('12ab3e6a-bf70-4850-b676-9d57ae9a1896', 'Packaging & Stiker', 'Packaging', 200);

-- ==========================================
-- TRANSAKSI (17 - 23 Juli 2026)
-- ==========================================
`;

const products = [
    { id: '40d3687a-b79a-4693-a5a9-d86793a6d436', name: 'PIA ORI', price: 15000, hpp: 7000 },
    { id: '6c06beee-bff9-483b-b651-f888b8881a97', name: 'PIA COKLAT', price: 12000, hpp: 6000 },
    { id: '11a6d461-5b7a-4a0e-a629-82406a22d824', name: 'KEMBANG SIRIH', price: 16000, hpp: 8000 },
    { id: 'e131c794-e7d7-48f3-855b-ba2e25348226', name: 'KECIPIR', price: 14000, hpp: 7000 },
    { id: '3de269c2-ad21-45b4-89e0-0f57618eaf81', name: 'SALE B', price: 30000, hpp: 15000 },
    { id: '155a9b23-cb5f-4253-b09d-475ba47c2568', name: 'SALE K', price: 14000, hpp: 7000 },
    { id: 'c630378c-faa3-4b45-a83e-b87cd7b0277c', name: 'KUPING GAJAH', price: 16000, hpp: 8000 },
    { id: '38cfc22f-2a14-4c2b-a248-b52b17ab8008', name: 'LADRANG', price: 15000, hpp: 7500 },
    { id: 'b6fde04a-590a-4570-8b57-0a109ed9fa21', name: 'PASTEL CUMI', price: 17000, hpp: 8500 },
    { id: 'e11f9941-669c-47e7-aaaa-8e373bfce877', name: 'PIA TOPLES ORI', price: 15000, hpp: 7000 },
    { id: 'be25bd23-4f9b-4309-9497-60598a0477eb', name: 'PIA TOPLES COKLAT', price: 15000, hpp: 7000 }
];

const uuid = () => {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
};

const randomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

let output = masterData;
let prdCounter = 1;

for (let d = 17; d <= 23; d++) {
    const dateStr = "2026-07-" + d.toString().padStart(2, '0');
    
    // 1. PRODUKSI
    const prdId = uuid();
    const noPrd = "PRD-202607" + d.toString().padStart(2, '0') + "-" + (prdCounter++);
    
    // Simulate materials based on LABA HARIAN.xlsx approx variations
    const gulaQty = randomInt(130, 150);
    const teriguQty = randomInt(110, 130);
    const telurQty = randomInt(40, 60);
    const bahanCost = (gulaQty * 15000) + (teriguQty * 6800) + (telurQty * 26000) + 234000 + 150000 + 126000;
    
    const packagingCost = 42400 + 203000 + 50000; // static approx
    
    output += "INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('" + prdId + "', '" + noPrd + "', '" + dateStr + "', 'Selesai', " + bahanCost + ", " + packagingCost + ");\n";
    
    // Bahan
    output += "INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('" + prdId + "', '92b9eadf-6513-4266-8b55-89d8cba47c79', " + gulaQty + ", 15000, " + (gulaQty * 15000) + ");\n";
    output += "INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('" + prdId + "', '4c610743-10af-4973-8baf-c40cebc46896', " + teriguQty + ", 6800, " + (teriguQty * 6800) + ");\n";
    output += "INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('" + prdId + "', '21efeda7-0b32-4b99-a454-d92f38fb118f', " + telurQty + ", 26000, " + (telurQty * 26000) + ");\n";
    
    // Hasil Produksi
    let totalPcs = 0;
    for (const prod of products) {
        let baseQty = 50;
        if (prod.name.includes('SALE')) baseQty = 100;
        if (prod.name === 'LADRANG') baseQty = 30;
        const qty = randomInt(baseQty - 10, baseQty + 10);
        totalPcs += qty;
        output += "INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('" + prdId + "', '" + prod.id + "', " + qty + ");\n";
    }
    
    // 2. GAJI HARIAN
    output += "INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('" + dateStr + "', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');\n";
    output += "INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('" + dateStr + "', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');\n";
    output += "INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('" + dateStr + "', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', " + (totalPcs * 1500) + ", 'Cetak Kue " + totalPcs + " pcs');\n";
    output += "INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('" + dateStr + "', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', " + (totalPcs * 200) + ", 'Pack & Stiker " + totalPcs + " pcs');\n";

    // 3. OPERASIONAL
    if (d % 3 === 0) {
        output += "INSERT INTO biaya_operasional (tanggal, kategori, nominal, deskripsi) VALUES ('" + dateStr + "', 'Listrik & Air', 150000, 'Token Listrik');\n";
    }

    // 4. PENJUALAN (4 - 7 transactions per day to reflect high sales volume)
    const numSales = randomInt(4, 7);
    const customers = ['Bu Sari', 'Bpk Budi', 'Toko Kue ABC', 'Reseller', 'Toko Laris'];
    for (let s = 0; s < numSales; s++) {
        const saleId = uuid();
        const cust = customers[randomInt(0, customers.length - 1)];
        let saleTotal = 0;
        let details = '';
        
        const numItems = randomInt(3, 7);
        const shuffled = [...products].sort(() => 0.5 - Math.random());
        for (let i = 0; i < numItems; i++) {
            const p = shuffled[i];
            const qty = randomInt(10, 30);
            const subtotal = qty * p.price;
            saleTotal += subtotal;
            details += "INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('" + saleId + "', '" + p.id + "', " + qty + ", " + p.price + ", " + p.hpp + ", " + subtotal + ");\n";
        }
        
        const h = randomInt(8, 17).toString().padStart(2, '0');
        const m = randomInt(0, 59).toString().padStart(2, '0');
        output += "INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('" + saleId + "', '" + dateStr + "', '" + cust + "', " + saleTotal + ", '" + dateStr + " " + h + ":" + m + ":00');\n";
        output += details;
    }
    
    output += "\n";
}

fs.writeFileSync('seed.sql', output);
console.log('seed.sql has been generated successfully.');
