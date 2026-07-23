-- SEEDER DATA REALISTIS BOLU ANISA
-- Dibuat berdasarkan LABA HARIAN.xlsx 

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
-- TRANSAKSI (JANUARI - JULI 2026)
-- ==========================================
INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'PRD-20260101-1', '2026-06-16', 'Selesai', 4511400, 277590);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '92b9eadf-6513-4266-8b55-89d8cba47c79', 133, 15000, 1995000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '4c610743-10af-4973-8baf-c40cebc46896', 118, 6800, 802400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '21efeda7-0b32-4b99-a454-d92f38fb118f', 47, 26000, 1222000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 12, 18000, 216000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 7, 18000, 126000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 498, 80, 39840);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 545, 350, 190750);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'b142b0ce-120f-431b-942e-f182b6e60841', 94, 500, 47000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '40d3687a-b79a-4693-a5a9-d86793a6d436', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '6c06beee-bff9-483b-b651-f888b8881a97', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '11a6d461-5b7a-4a0e-a629-82406a22d824', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'e131c794-e7d7-48f3-855b-ba2e25348226', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 94);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '155a9b23-cb5f-4253-b09d-475ba47c2568', 94);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 28);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('d9237e8b-5c51-40a7-8e57-e6a9ce01dcfe', 'be25bd23-4f9b-4309-9497-60598a0477eb', 47);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-16', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-16', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-16', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 888000, 'Cetak Kue 592 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-16', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 118400, 'Pack & Stiker 592 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('8ce943d2-6982-48f9-a653-c1c7b868d661', '2026-06-16', 'Toko Kue ABC', 519000, '2026-06-16 18:24:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8ce943d2-6982-48f9-a653-c1c7b868d661', '40d3687a-b79a-4693-a5a9-d86793a6d436', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8ce943d2-6982-48f9-a653-c1c7b868d661', '155a9b23-cb5f-4253-b09d-475ba47c2568', 14, 14000, 196000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8ce943d2-6982-48f9-a653-c1c7b868d661', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 8, 16000, 128000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8ce943d2-6982-48f9-a653-c1c7b868d661', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 1, 15000, 15000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8ce943d2-6982-48f9-a653-c1c7b868d661', 'be25bd23-4f9b-4309-9497-60598a0477eb', 2, 15000, 30000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', '2026-06-16', NULL, 1372000, '2026-06-16 15:36:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', '11a6d461-5b7a-4a0e-a629-82406a22d824', 5, 16000, 80000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 26, 30000, 780000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', '155a9b23-cb5f-4253-b09d-475ba47c2568', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 6, 16000, 96000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 9, 15000, 135000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 2, 17000, 34000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('794d91fb-7efd-473a-9145-cfbf155bd131', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 9, 15000, 135000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('e9bfbe91-ae8c-4ca8-8096-8d3d825cb130', '2026-06-16', 'Bu Sari', 717000, '2026-06-16 09:42:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9bfbe91-ae8c-4ca8-8096-8d3d825cb130', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 11, 30000, 330000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9bfbe91-ae8c-4ca8-8096-8d3d825cb130', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 12, 16000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9bfbe91-ae8c-4ca8-8096-8d3d825cb130', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9bfbe91-ae8c-4ca8-8096-8d3d825cb130', 'be25bd23-4f9b-4309-9497-60598a0477eb', 11, 15000, 165000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('f784b737-c2c6-44e2-8b81-23b2c60224ec', '2026-06-16', 'Bpk Budi', 440000, '2026-06-16 15:47:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f784b737-c2c6-44e2-8b81-23b2c60224ec', '6c06beee-bff9-483b-b651-f888b8881a97', 5, 12000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f784b737-c2c6-44e2-8b81-23b2c60224ec', '11a6d461-5b7a-4a0e-a629-82406a22d824', 8, 16000, 128000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f784b737-c2c6-44e2-8b81-23b2c60224ec', '155a9b23-cb5f-4253-b09d-475ba47c2568', 10, 14000, 140000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f784b737-c2c6-44e2-8b81-23b2c60224ec', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 7, 16000, 112000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('8e3e56cf-339f-4102-a4b5-4e8e3d8d6e72', '2026-06-16', 'Bu Sari', 377000, '2026-06-16 15:46:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8e3e56cf-339f-4102-a4b5-4e8e3d8d6e72', 'e131c794-e7d7-48f3-855b-ba2e25348226', 7, 14000, 98000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8e3e56cf-339f-4102-a4b5-4e8e3d8d6e72', '155a9b23-cb5f-4253-b09d-475ba47c2568', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8e3e56cf-339f-4102-a4b5-4e8e3d8d6e72', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 2, 16000, 32000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8e3e56cf-339f-4102-a4b5-4e8e3d8d6e72', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 3, 17000, 51000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('8e3e56cf-339f-4102-a4b5-4e8e3d8d6e72', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 6, 14000, 84000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', '2026-06-16', 'Bpk Budi', 1288000, '2026-06-16 14:29:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', '6c06beee-bff9-483b-b651-f888b8881a97', 2, 12000, 24000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', 'e131c794-e7d7-48f3-855b-ba2e25348226', 20, 13000, 260000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 24, 29000, 696000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', '155a9b23-cb5f-4253-b09d-475ba47c2568', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('98b0f2e0-b590-4c98-8866-ae958a2d6892', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 1, 16000, 16000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', '2026-06-16', 'Bu Sari', 1153000, '2026-06-16 14:09:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', '40d3687a-b79a-4693-a5a9-d86793a6d436', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', '11a6d461-5b7a-4a0e-a629-82406a22d824', 15, 15000, 225000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 17, 30000, 510000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 6, 15000, 90000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 3, 17000, 51000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 11, 15000, 165000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1a7c092c-1af6-455d-9c3d-a51805272dbd', 'be25bd23-4f9b-4309-9497-60598a0477eb', 6, 14000, 84000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('da147e3b-0eaa-48f6-9fc6-c4a2be5368e9', '2026-06-16', 'Toko Kue ABC', 643000, '2026-06-16 17:44:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('da147e3b-0eaa-48f6-9fc6-c4a2be5368e9', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('da147e3b-0eaa-48f6-9fc6-c4a2be5368e9', '6c06beee-bff9-483b-b651-f888b8881a97', 19, 12000, 228000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('da147e3b-0eaa-48f6-9fc6-c4a2be5368e9', '11a6d461-5b7a-4a0e-a629-82406a22d824', 6, 15000, 90000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('da147e3b-0eaa-48f6-9fc6-c4a2be5368e9', 'e131c794-e7d7-48f3-855b-ba2e25348226', 5, 14000, 70000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('da147e3b-0eaa-48f6-9fc6-c4a2be5368e9', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 5, 15000, 75000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('236e4c51-0daf-41fc-a48b-4b8e6354ecaa', '2026-06-16', 'Reseller', 1038000, '2026-06-16 16:22:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('236e4c51-0daf-41fc-a48b-4b8e6354ecaa', 'e131c794-e7d7-48f3-855b-ba2e25348226', 11, 13000, 143000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('236e4c51-0daf-41fc-a48b-4b8e6354ecaa', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('236e4c51-0daf-41fc-a48b-4b8e6354ecaa', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 19, 17000, 323000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('236e4c51-0daf-41fc-a48b-4b8e6354ecaa', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 14, 15000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('236e4c51-0daf-41fc-a48b-4b8e6354ecaa', 'be25bd23-4f9b-4309-9497-60598a0477eb', 12, 15000, 180000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('84ae2b4c-d772-4d0e-84ba-0c2e9a7b21bf', '2026-06-16', 'Reseller', 834000, '2026-06-16 19:21:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('84ae2b4c-d772-4d0e-84ba-0c2e9a7b21bf', '11a6d461-5b7a-4a0e-a629-82406a22d824', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('84ae2b4c-d772-4d0e-84ba-0c2e9a7b21bf', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 9, 30000, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('84ae2b4c-d772-4d0e-84ba-0c2e9a7b21bf', '155a9b23-cb5f-4253-b09d-475ba47c2568', 20, 14000, 280000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('84ae2b4c-d772-4d0e-84ba-0c2e9a7b21bf', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 15, 16000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('84ae2b4c-d772-4d0e-84ba-0c2e9a7b21bf', 'be25bd23-4f9b-4309-9497-60598a0477eb', 1, 14000, 14000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '2026-06-16', 'Bpk Budi', 1328000, '2026-06-16 08:29:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '40d3687a-b79a-4693-a5a9-d86793a6d436', 11, 15000, 165000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '6c06beee-bff9-483b-b651-f888b8881a97', 11, 12000, 132000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '11a6d461-5b7a-4a0e-a629-82406a22d824', 11, 16000, 176000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', 'e131c794-e7d7-48f3-855b-ba2e25348226', 4, 14000, 56000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 6, 29000, 174000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 4, 16000, 64000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 11, 14000, 154000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f0d73d3c-2533-4c99-81e5-ba8440c0b066', 'be25bd23-4f9b-4309-9497-60598a0477eb', 15, 15000, 225000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('31ba46f2-1d79-4f07-9f1d-daf205690f4b', '2026-06-16', 'Bpk Budi', 358000, '2026-06-16 11:02:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('31ba46f2-1d79-4f07-9f1d-daf205690f4b', '6c06beee-bff9-483b-b651-f888b8881a97', 10, 11000, 110000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('31ba46f2-1d79-4f07-9f1d-daf205690f4b', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 1, 29000, 29000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('31ba46f2-1d79-4f07-9f1d-daf205690f4b', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 12, 17000, 204000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('31ba46f2-1d79-4f07-9f1d-daf205690f4b', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 1, 15000, 15000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'PRD-20260102-2', '2026-06-17', 'Selesai', 5210800, 321940);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '92b9eadf-6513-4266-8b55-89d8cba47c79', 154, 15000, 2310000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '4c610743-10af-4973-8baf-c40cebc46896', 136, 6800, 924800);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '21efeda7-0b32-4b99-a454-d92f38fb118f', 55, 26000, 1430000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 14, 18000, 252000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 8, 18000, 144000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 578, 80, 46240);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 632, 350, 221200);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'b142b0ce-120f-431b-942e-f182b6e60841', 109, 500, 54500);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '40d3687a-b79a-4693-a5a9-d86793a6d436', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '6c06beee-bff9-483b-b651-f888b8881a97', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '11a6d461-5b7a-4a0e-a629-82406a22d824', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'e131c794-e7d7-48f3-855b-ba2e25348226', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 109);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '155a9b23-cb5f-4253-b09d-475ba47c2568', 109);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 33);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('f17a3dd1-fefd-484f-94e0-14ff2d807914', 'be25bd23-4f9b-4309-9497-60598a0477eb', 55);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-17', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-17', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-17', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 1036500, 'Cetak Kue 691 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-17', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 138200, 'Pack & Stiker 691 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('eff7d1eb-abd3-4168-b7f9-35cc02caddf7', '2026-06-17', 'Toko Kue ABC', 680000, '2026-06-17 16:05:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('eff7d1eb-abd3-4168-b7f9-35cc02caddf7', '6c06beee-bff9-483b-b651-f888b8881a97', 12, 12000, 144000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('eff7d1eb-abd3-4168-b7f9-35cc02caddf7', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 1, 30000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('eff7d1eb-abd3-4168-b7f9-35cc02caddf7', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('eff7d1eb-abd3-4168-b7f9-35cc02caddf7', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 13, 17000, 221000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('eff7d1eb-abd3-4168-b7f9-35cc02caddf7', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 9, 15000, 135000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', '2026-06-17', 'Reseller', 634000, '2026-06-17 09:48:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', '40d3687a-b79a-4693-a5a9-d86793a6d436', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', '6c06beee-bff9-483b-b651-f888b8881a97', 5, 12000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', '155a9b23-cb5f-4253-b09d-475ba47c2568', 1, 13000, 13000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 6, 14000, 84000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 12, 16000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('57c1c2dc-51ad-49dd-92c8-1d161e3c8513', 'be25bd23-4f9b-4309-9497-60598a0477eb', 11, 15000, 165000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('c82ce331-ad68-4b53-ba2f-cb5c59400097', '2026-06-17', 'Toko Kue ABC', 1756000, '2026-06-17 14:02:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c82ce331-ad68-4b53-ba2f-cb5c59400097', '6c06beee-bff9-483b-b651-f888b8881a97', 8, 12000, 96000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c82ce331-ad68-4b53-ba2f-cb5c59400097', 'e131c794-e7d7-48f3-855b-ba2e25348226', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c82ce331-ad68-4b53-ba2f-cb5c59400097', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 51, 30000, 1530000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c82ce331-ad68-4b53-ba2f-cb5c59400097', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 6, 17000, 102000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', '2026-06-17', 'Toko Kue ABC', 1586000, '2026-06-17 13:15:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', '40d3687a-b79a-4693-a5a9-d86793a6d436', 13, 15000, 195000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', '6c06beee-bff9-483b-b651-f888b8881a97', 8, 12000, 96000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', '11a6d461-5b7a-4a0e-a629-82406a22d824', 7, 16000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', 'e131c794-e7d7-48f3-855b-ba2e25348226', 13, 13000, 169000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 15, 30000, 450000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', '155a9b23-cb5f-4253-b09d-475ba47c2568', 14, 13000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 11, 17000, 187000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 11, 15000, 165000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88c12656-2184-4580-a0f0-fbbfc86a636c', 'be25bd23-4f9b-4309-9497-60598a0477eb', 2, 15000, 30000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('1b3b422e-cec4-4cba-a4b7-4567f3932abb', '2026-06-17', 'Reseller', 433000, '2026-06-17 20:18:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1b3b422e-cec4-4cba-a4b7-4567f3932abb', '40d3687a-b79a-4693-a5a9-d86793a6d436', 8, 15000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1b3b422e-cec4-4cba-a4b7-4567f3932abb', '6c06beee-bff9-483b-b651-f888b8881a97', 1, 12000, 12000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1b3b422e-cec4-4cba-a4b7-4567f3932abb', '11a6d461-5b7a-4a0e-a629-82406a22d824', 1, 16000, 16000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1b3b422e-cec4-4cba-a4b7-4567f3932abb', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 3, 30000, 90000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1b3b422e-cec4-4cba-a4b7-4567f3932abb', '155a9b23-cb5f-4253-b09d-475ba47c2568', 15, 13000, 195000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', '2026-06-17', 'Bpk Budi', 723000, '2026-06-17 18:51:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', '40d3687a-b79a-4693-a5a9-d86793a6d436', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', '11a6d461-5b7a-4a0e-a629-82406a22d824', 8, 15000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 1, 30000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 2, 16000, 32000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 1, 14000, 14000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('88f5d72f-1873-4b4f-b218-407c65b10920', 'be25bd23-4f9b-4309-9497-60598a0477eb', 19, 15000, 285000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', '2026-06-17', 'Reseller', 1672000, '2026-06-17 12:40:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', '6c06beee-bff9-483b-b651-f888b8881a97', 12, 12000, 144000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', '11a6d461-5b7a-4a0e-a629-82406a22d824', 17, 16000, 272000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', 'e131c794-e7d7-48f3-855b-ba2e25348226', 22, 14000, 308000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', '155a9b23-cb5f-4253-b09d-475ba47c2568', 23, 13000, 299000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 24, 16000, 384000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('b4bac91c-6f92-40be-bf5a-20c8fc2577a6', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 9, 17000, 153000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', '2026-06-17', 'Reseller', 1721000, '2026-06-17 12:14:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', '6c06beee-bff9-483b-b651-f888b8881a97', 2, 12000, 24000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 12, 30000, 360000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', '155a9b23-cb5f-4253-b09d-475ba47c2568', 20, 14000, 280000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 29, 15000, 435000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 8, 15000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('22cba682-df8a-47f5-a5c5-bd20c29ed308', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 23, 14000, 322000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', '2026-06-17', NULL, 1222000, '2026-06-17 12:42:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', '40d3687a-b79a-4693-a5a9-d86793a6d436', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', '11a6d461-5b7a-4a0e-a629-82406a22d824', 22, 16000, 352000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', 'e131c794-e7d7-48f3-855b-ba2e25348226', 12, 14000, 168000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 12, 30000, 360000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', '155a9b23-cb5f-4253-b09d-475ba47c2568', 3, 14000, 42000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 3, 15000, 45000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('13a34231-a76d-4648-aa5b-94a51400cf61', 'be25bd23-4f9b-4309-9497-60598a0477eb', 15, 15000, 225000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', '2026-06-17', 'Reseller', 1299000, '2026-06-17 17:23:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', '6c06beee-bff9-483b-b651-f888b8881a97', 7, 12000, 84000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', 'e131c794-e7d7-48f3-855b-ba2e25348226', 6, 14000, 84000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 14, 30000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', '155a9b23-cb5f-4253-b09d-475ba47c2568', 20, 14000, 280000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 4, 16000, 64000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 5, 15000, 75000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('5c99a926-f623-4d49-9c82-f8442ff9c83a', 'be25bd23-4f9b-4309-9497-60598a0477eb', 8, 14000, 112000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'PRD-20260103-3', '2026-06-18', 'Selesai', 5363800, 333670);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '92b9eadf-6513-4266-8b55-89d8cba47c79', 159, 15000, 2385000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '4c610743-10af-4973-8baf-c40cebc46896', 141, 6800, 958800);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '21efeda7-0b32-4b99-a454-d92f38fb118f', 56, 26000, 1456000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 15, 18000, 270000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 8, 18000, 144000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 599, 80, 47920);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 655, 350, 229250);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'b142b0ce-120f-431b-942e-f182b6e60841', 113, 500, 56500);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '40d3687a-b79a-4693-a5a9-d86793a6d436', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '6c06beee-bff9-483b-b651-f888b8881a97', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '11a6d461-5b7a-4a0e-a629-82406a22d824', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'e131c794-e7d7-48f3-855b-ba2e25348226', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 113);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '155a9b23-cb5f-4253-b09d-475ba47c2568', 113);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 34);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('b511c2a8-1677-488b-8dec-e23e92a29fce', 'be25bd23-4f9b-4309-9497-60598a0477eb', 56);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-18', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-18', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-18', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 1062000, 'Cetak Kue 708 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-18', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 141600, 'Pack & Stiker 708 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', '2026-06-18', 'Reseller', 2028000, '2026-06-18 18:47:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', '40d3687a-b79a-4693-a5a9-d86793a6d436', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', '6c06beee-bff9-483b-b651-f888b8881a97', 19, 11000, 209000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', '11a6d461-5b7a-4a0e-a629-82406a22d824', 22, 16000, 352000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', 'e131c794-e7d7-48f3-855b-ba2e25348226', 10, 13000, 130000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 16, 30000, 480000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 20, 16000, 320000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 12, 16000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 1, 15000, 15000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('92b3e6e1-e3e6-4ff2-8c34-2ea66008090d', 'be25bd23-4f9b-4309-9497-60598a0477eb', 15, 14000, 210000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', '2026-06-18', 'Toko Kue ABC', 2467000, '2026-06-18 17:55:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', '6c06beee-bff9-483b-b651-f888b8881a97', 25, 11000, 275000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', '11a6d461-5b7a-4a0e-a629-82406a22d824', 6, 16000, 96000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', 'e131c794-e7d7-48f3-855b-ba2e25348226', 23, 13000, 299000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 19, 30000, 570000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', '155a9b23-cb5f-4253-b09d-475ba47c2568', 30, 14000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 10, 16000, 160000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 15, 17000, 255000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('9bbe77dc-7049-472a-a941-f47d750cf67c', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 28, 14000, 392000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', '2026-06-18', 'Bpk Budi', 1524000, '2026-06-18 11:24:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', '40d3687a-b79a-4693-a5a9-d86793a6d436', 31, 14000, 434000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', 'e131c794-e7d7-48f3-855b-ba2e25348226', 4, 14000, 56000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 1, 29000, 29000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', '155a9b23-cb5f-4253-b09d-475ba47c2568', 27, 13000, 351000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 10, 16000, 160000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 17, 15000, 255000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 7, 17000, 119000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('6e063544-f9e0-4106-af29-31d117d2c052', 'be25bd23-4f9b-4309-9497-60598a0477eb', 8, 15000, 120000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', '2026-06-18', 'Bu Sari', 2893000, '2026-06-18 09:34:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', '40d3687a-b79a-4693-a5a9-d86793a6d436', 9, 14000, 126000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', '6c06beee-bff9-483b-b651-f888b8881a97', 1, 12000, 12000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', '11a6d461-5b7a-4a0e-a629-82406a22d824', 13, 16000, 208000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', 'e131c794-e7d7-48f3-855b-ba2e25348226', 14, 13000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 46, 29000, 1334000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', '155a9b23-cb5f-4253-b09d-475ba47c2568', 23, 14000, 322000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 15, 16000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 4, 16000, 64000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 6, 15000, 90000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('c42011fe-5ce0-4c08-b617-a14e719b93cc', 'be25bd23-4f9b-4309-9497-60598a0477eb', 21, 15000, 315000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '2026-06-18', 'Bpk Budi', 3000000, '2026-06-18 15:29:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '6c06beee-bff9-483b-b651-f888b8881a97', 11, 12000, 132000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '11a6d461-5b7a-4a0e-a629-82406a22d824', 15, 16000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', 'e131c794-e7d7-48f3-855b-ba2e25348226', 5, 13000, 65000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 31, 30000, 930000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '155a9b23-cb5f-4253-b09d-475ba47c2568', 33, 14000, 462000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 1, 16000, 16000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 13, 15000, 195000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 18, 17000, 306000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 21, 14000, 294000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('ad1e40bb-79f1-4fc7-aea5-e10f9f897f8e', 'be25bd23-4f9b-4309-9497-60598a0477eb', 12, 15000, 180000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'PRD-20260104-4', '2026-06-19', 'Selesai', 4581000, 283670);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '92b9eadf-6513-4266-8b55-89d8cba47c79', 135, 15000, 2025000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '4c610743-10af-4973-8baf-c40cebc46896', 120, 6800, 816000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '21efeda7-0b32-4b99-a454-d92f38fb118f', 48, 26000, 1248000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 12, 18000, 216000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 7, 18000, 126000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 509, 80, 40720);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 557, 350, 194950);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'b142b0ce-120f-431b-942e-f182b6e60841', 96, 500, 48000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '40d3687a-b79a-4693-a5a9-d86793a6d436', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '6c06beee-bff9-483b-b651-f888b8881a97', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '11a6d461-5b7a-4a0e-a629-82406a22d824', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'e131c794-e7d7-48f3-855b-ba2e25348226', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 96);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '155a9b23-cb5f-4253-b09d-475ba47c2568', 96);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 29);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('9187c5d6-037a-42ac-b11b-4a9c08876c0e', 'be25bd23-4f9b-4309-9497-60598a0477eb', 48);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-19', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-19', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-19', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 907500, 'Cetak Kue 605 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-19', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 121000, 'Pack & Stiker 605 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', '2026-06-19', 'Reseller', 1186000, '2026-06-19 09:29:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', '40d3687a-b79a-4693-a5a9-d86793a6d436', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', '11a6d461-5b7a-4a0e-a629-82406a22d824', 15, 15000, 225000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', 'e131c794-e7d7-48f3-855b-ba2e25348226', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 4, 30000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', '155a9b23-cb5f-4253-b09d-475ba47c2568', 22, 14000, 308000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 8, 15000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 14, 14000, 196000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('de74c746-9652-4ac8-985e-4db5fe80dde2', 'be25bd23-4f9b-4309-9497-60598a0477eb', 1, 15000, 15000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', '2026-06-19', 'Toko Kue ABC', 2419000, '2026-06-19 19:36:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', '6c06beee-bff9-483b-b651-f888b8881a97', 7, 12000, 84000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', 'e131c794-e7d7-48f3-855b-ba2e25348226', 15, 14000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 35, 30000, 1050000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', '155a9b23-cb5f-4253-b09d-475ba47c2568', 33, 14000, 462000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 14, 15000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a424f711-bac1-4f06-bc72-cc55c0925a6f', 'be25bd23-4f9b-4309-9497-60598a0477eb', 25, 15000, 375000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', '2026-06-19', 'Bu Sari', 1021000, '2026-06-19 20:27:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', '40d3687a-b79a-4693-a5a9-d86793a6d436', 7, 15000, 105000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', '11a6d461-5b7a-4a0e-a629-82406a22d824', 12, 16000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 6, 30000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', '155a9b23-cb5f-4253-b09d-475ba47c2568', 18, 13000, 234000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 3, 15000, 45000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 10, 16000, 160000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 3, 15000, 45000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('4f72ec21-669f-407d-9229-6fba1b40dd25', 'be25bd23-4f9b-4309-9497-60598a0477eb', 4, 15000, 60000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', '2026-06-19', 'Bu Sari', 1724000, '2026-06-19 10:07:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', '40d3687a-b79a-4693-a5a9-d86793a6d436', 16, 15000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', '6c06beee-bff9-483b-b651-f888b8881a97', 28, 12000, 336000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', '11a6d461-5b7a-4a0e-a629-82406a22d824', 9, 16000, 144000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 7, 30000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 22, 15000, 330000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 9, 17000, 153000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 15, 15000, 225000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0ecf9981-d98d-4738-a425-da472d4a7be4', 'be25bd23-4f9b-4309-9497-60598a0477eb', 4, 14000, 56000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', '2026-06-19', 'Reseller', 1861000, '2026-06-19 15:01:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', '6c06beee-bff9-483b-b651-f888b8881a97', 7, 12000, 84000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', '11a6d461-5b7a-4a0e-a629-82406a22d824', 12, 16000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 31, 29000, 899000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', '155a9b23-cb5f-4253-b09d-475ba47c2568', 9, 14000, 126000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 8, 15000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 5, 16000, 80000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('0c8e2232-92b7-4f76-85e4-bb7477b3c15a', 'be25bd23-4f9b-4309-9497-60598a0477eb', 14, 15000, 210000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', '2026-06-19', 'Bu Sari', 2052000, '2026-06-19 13:55:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', '40d3687a-b79a-4693-a5a9-d86793a6d436', 21, 15000, 315000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', '6c06beee-bff9-483b-b651-f888b8881a97', 6, 12000, 72000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', 'e131c794-e7d7-48f3-855b-ba2e25348226', 25, 14000, 350000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 13, 29000, 377000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', '155a9b23-cb5f-4253-b09d-475ba47c2568', 14, 14000, 196000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 4, 16000, 64000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 24, 17000, 408000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f9cb931f-93b8-459a-8c8b-1dda65ecd7f3', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 18, 15000, 270000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'PRD-20260105-5', '2026-06-20', 'Selesai', 5108200, 316210);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '92b9eadf-6513-4266-8b55-89d8cba47c79', 151, 15000, 2265000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '4c610743-10af-4973-8baf-c40cebc46896', 134, 6800, 911200);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '21efeda7-0b32-4b99-a454-d92f38fb118f', 54, 26000, 1404000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 14, 18000, 252000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 7, 18000, 126000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 567, 80, 45360);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 621, 350, 217350);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'b142b0ce-120f-431b-942e-f182b6e60841', 107, 500, 53500);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '40d3687a-b79a-4693-a5a9-d86793a6d436', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '6c06beee-bff9-483b-b651-f888b8881a97', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '11a6d461-5b7a-4a0e-a629-82406a22d824', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'e131c794-e7d7-48f3-855b-ba2e25348226', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 107);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '155a9b23-cb5f-4253-b09d-475ba47c2568', 107);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 32);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('4f276a49-e551-4d96-97ca-d03d8bf207dd', 'be25bd23-4f9b-4309-9497-60598a0477eb', 54);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-20', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-20', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-20', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 1017000, 'Cetak Kue 678 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-20', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 135600, 'Pack & Stiker 678 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', '2026-06-20', 'Bpk Budi', 1476000, '2026-06-20 19:29:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', '40d3687a-b79a-4693-a5a9-d86793a6d436', 7, 15000, 105000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', '11a6d461-5b7a-4a0e-a629-82406a22d824', 25, 16000, 400000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', 'e131c794-e7d7-48f3-855b-ba2e25348226', 1, 14000, 14000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 7, 29000, 203000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 7, 16000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 21, 14000, 294000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('40677047-46cb-487a-8848-8a297e327c4f', 'be25bd23-4f9b-4309-9497-60598a0477eb', 12, 14000, 168000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', '2026-06-20', 'Bu Sari', 1362000, '2026-06-20 08:42:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', '40d3687a-b79a-4693-a5a9-d86793a6d436', 25, 15000, 375000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', '6c06beee-bff9-483b-b651-f888b8881a97', 11, 12000, 132000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', 'e131c794-e7d7-48f3-855b-ba2e25348226', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 4, 30000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', '155a9b23-cb5f-4253-b09d-475ba47c2568', 12, 14000, 168000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 3, 15000, 45000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 7, 17000, 119000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('efb9e953-b05d-49fd-be24-77d21a60d75e', 'be25bd23-4f9b-4309-9497-60598a0477eb', 11, 15000, 165000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', '2026-06-20', NULL, 1827000, '2026-06-20 20:52:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', '6c06beee-bff9-483b-b651-f888b8881a97', 18, 12000, 216000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', '11a6d461-5b7a-4a0e-a629-82406a22d824', 3, 16000, 48000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', 'e131c794-e7d7-48f3-855b-ba2e25348226', 15, 14000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 29, 30000, 870000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', '155a9b23-cb5f-4253-b09d-475ba47c2568', 22, 14000, 308000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 10, 16000, 160000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69e993f3-af6c-46d0-adc3-d7af8e8fe732', 'be25bd23-4f9b-4309-9497-60598a0477eb', 1, 15000, 15000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '2026-06-20', NULL, 2055000, '2026-06-20 18:26:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '40d3687a-b79a-4693-a5a9-d86793a6d436', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '6c06beee-bff9-483b-b651-f888b8881a97', 9, 12000, 108000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '11a6d461-5b7a-4a0e-a629-82406a22d824', 15, 16000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', 'e131c794-e7d7-48f3-855b-ba2e25348226', 3, 14000, 42000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 19, 30000, 570000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '155a9b23-cb5f-4253-b09d-475ba47c2568', 42, 14000, 588000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 12, 16000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('bf0f9def-7c45-4333-860c-7c874c9cc388', 'be25bd23-4f9b-4309-9497-60598a0477eb', 15, 15000, 225000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', '2026-06-20', 'Bu Sari', 2517000, '2026-06-20 18:51:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', '40d3687a-b79a-4693-a5a9-d86793a6d436', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', '6c06beee-bff9-483b-b651-f888b8881a97', 15, 12000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', 'e131c794-e7d7-48f3-855b-ba2e25348226', 25, 14000, 350000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 21, 30000, 630000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', '155a9b23-cb5f-4253-b09d-475ba47c2568', 16, 14000, 224000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 22, 16000, 352000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 19, 17000, 323000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 7, 14000, 98000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('161a8d8f-83cb-4c7b-876c-b0c9291314ea', 'be25bd23-4f9b-4309-9497-60598a0477eb', 14, 15000, 210000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '2026-06-20', 'Bu Sari', 2341000, '2026-06-20 18:19:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '40d3687a-b79a-4693-a5a9-d86793a6d436', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '6c06beee-bff9-483b-b651-f888b8881a97', 1, 12000, 12000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '11a6d461-5b7a-4a0e-a629-82406a22d824', 11, 16000, 176000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', 'e131c794-e7d7-48f3-855b-ba2e25348226', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 27, 29000, 783000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '155a9b23-cb5f-4253-b09d-475ba47c2568', 15, 14000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 12, 14000, 168000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 28, 17000, 476000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 16, 15000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('48e4b162-ea57-47c9-ba9f-d1806c66f890', 'be25bd23-4f9b-4309-9497-60598a0477eb', 1, 14000, 14000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'PRD-20260106-6', '2026-06-21', 'Selesai', 5518000, 342750);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '92b9eadf-6513-4266-8b55-89d8cba47c79', 164, 15000, 2460000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '4c610743-10af-4973-8baf-c40cebc46896', 145, 6800, 986000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '21efeda7-0b32-4b99-a454-d92f38fb118f', 58, 26000, 1508000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 15, 18000, 270000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 8, 18000, 144000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 615, 80, 49200);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 673, 350, 235550);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'b142b0ce-120f-431b-942e-f182b6e60841', 116, 500, 58000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '40d3687a-b79a-4693-a5a9-d86793a6d436', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '6c06beee-bff9-483b-b651-f888b8881a97', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '11a6d461-5b7a-4a0e-a629-82406a22d824', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'e131c794-e7d7-48f3-855b-ba2e25348226', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 116);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '155a9b23-cb5f-4253-b09d-475ba47c2568', 116);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 35);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('ad9aca5e-cf30-44f0-90ab-96dbe4d49284', 'be25bd23-4f9b-4309-9497-60598a0477eb', 58);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-21', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-21', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-21', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 1096500, 'Cetak Kue 731 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-21', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 146200, 'Pack & Stiker 731 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', '2026-06-21', NULL, 2299000, '2026-06-21 11:11:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', '40d3687a-b79a-4693-a5a9-d86793a6d436', 19, 15000, 285000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', '6c06beee-bff9-483b-b651-f888b8881a97', 13, 12000, 156000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', '11a6d461-5b7a-4a0e-a629-82406a22d824', 7, 16000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', 'e131c794-e7d7-48f3-855b-ba2e25348226', 26, 14000, 364000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', '155a9b23-cb5f-4253-b09d-475ba47c2568', 33, 14000, 462000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 33, 16000, 528000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 1, 17000, 17000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 9, 15000, 135000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('2f294bb5-a784-4117-a4a7-183ff688d669', 'be25bd23-4f9b-4309-9497-60598a0477eb', 16, 15000, 240000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', '2026-06-21', 'Bu Sari', 1172000, '2026-06-21 10:30:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', '40d3687a-b79a-4693-a5a9-d86793a6d436', 16, 14000, 224000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', '6c06beee-bff9-483b-b651-f888b8881a97', 1, 12000, 12000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', '11a6d461-5b7a-4a0e-a629-82406a22d824', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', 'e131c794-e7d7-48f3-855b-ba2e25348226', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', '155a9b23-cb5f-4253-b09d-475ba47c2568', 16, 14000, 224000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 9, 16000, 144000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 17, 16000, 272000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 1, 15000, 15000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('d82fb9ef-f8e1-4c55-b1bd-77a07414a668', 'be25bd23-4f9b-4309-9497-60598a0477eb', 5, 15000, 75000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '2026-06-21', 'Toko Kue ABC', 3373000, '2026-06-21 08:54:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '6c06beee-bff9-483b-b651-f888b8881a97', 19, 11000, 209000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '11a6d461-5b7a-4a0e-a629-82406a22d824', 4, 16000, 64000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', 'e131c794-e7d7-48f3-855b-ba2e25348226', 4, 14000, 56000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 48, 30000, 1440000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '155a9b23-cb5f-4253-b09d-475ba47c2568', 10, 14000, 140000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 20, 15000, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 27, 17000, 459000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 14, 15000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('69f97c88-f326-4ee4-b253-6182f3961bce', 'be25bd23-4f9b-4309-9497-60598a0477eb', 21, 15000, 315000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '2026-06-21', NULL, 4059000, '2026-06-21 19:31:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '40d3687a-b79a-4693-a5a9-d86793a6d436', 11, 15000, 165000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '6c06beee-bff9-483b-b651-f888b8881a97', 25, 12000, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '11a6d461-5b7a-4a0e-a629-82406a22d824', 13, 16000, 208000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', 'e131c794-e7d7-48f3-855b-ba2e25348226', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 68, 30000, 2040000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '155a9b23-cb5f-4253-b09d-475ba47c2568', 37, 14000, 518000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 7, 15000, 105000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 13, 17000, 221000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1763fead-be27-48a1-b4b0-b2fe008b66f6', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 26, 15000, 390000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', '2026-06-21', 'Bu Sari', 1598000, '2026-06-21 13:56:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', '11a6d461-5b7a-4a0e-a629-82406a22d824', 24, 16000, 384000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', 'e131c794-e7d7-48f3-855b-ba2e25348226', 18, 14000, 252000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', '155a9b23-cb5f-4253-b09d-475ba47c2568', 20, 14000, 280000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 16, 16000, 256000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 6, 15000, 90000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 8, 14000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7a8051f3-240f-4ba4-b283-70ed84286f92', 'be25bd23-4f9b-4309-9497-60598a0477eb', 16, 14000, 224000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'PRD-20260107-7', '2026-06-22', 'Selesai', 5045400, 313210);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '92b9eadf-6513-4266-8b55-89d8cba47c79', 149, 15000, 2235000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '4c610743-10af-4973-8baf-c40cebc46896', 133, 6800, 904400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '21efeda7-0b32-4b99-a454-d92f38fb118f', 53, 26000, 1378000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'a764e783-8021-4cd1-bb0c-5ee1c27c819d', 14, 18000, 252000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '79457130-c0d2-4f62-8a5a-2658e2a47dd7', 7, 18000, 126000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '43a2d49e-7144-489b-ac9d-5f35d6aa4fe6', 1, 150000, 150000);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'edc8432f-fe5a-4574-8921-71d734a4ee75', 562, 80, 44960);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'b11caa72-d87c-4999-bc0b-eeba1805bb68', 615, 350, 215250);
INSERT INTO produksi_packaging (produksi_id, packaging_id, jumlah, harga_satuan, subtotal) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'b142b0ce-120f-431b-942e-f182b6e60841', 106, 500, 53000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '40d3687a-b79a-4693-a5a9-d86793a6d436', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '6c06beee-bff9-483b-b651-f888b8881a97', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '11a6d461-5b7a-4a0e-a629-82406a22d824', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'e131c794-e7d7-48f3-855b-ba2e25348226', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 106);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '155a9b23-cb5f-4253-b09d-475ba47c2568', 106);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 32);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('6cf728ff-7114-4e6f-a169-1a56f42d359b', 'be25bd23-4f9b-4309-9497-60598a0477eb', 53);

INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-22', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-22', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-22', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 1002000, 'Cetak Kue 668 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-06-22', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 133600, 'Pack & Stiker 668 pcs');

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', '2026-06-22', 'Bu Sari', 2172000, '2026-06-22 11:34:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', '40d3687a-b79a-4693-a5a9-d86793a6d436', 5, 14000, 70000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', '11a6d461-5b7a-4a0e-a629-82406a22d824', 14, 15000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', 'e131c794-e7d7-48f3-855b-ba2e25348226', 24, 13000, 312000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 23, 30000, 690000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', '155a9b23-cb5f-4253-b09d-475ba47c2568', 20, 13000, 260000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 14, 15000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 15, 14000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('7d2e0479-e395-4164-a53c-3119e7188a5b', 'be25bd23-4f9b-4309-9497-60598a0477eb', 14, 15000, 210000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', '2026-06-22', 'Bpk Budi', 2064000, '2026-06-22 13:44:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', '6c06beee-bff9-483b-b651-f888b8881a97', 14, 11000, 154000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', '11a6d461-5b7a-4a0e-a629-82406a22d824', 1, 16000, 16000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', 'e131c794-e7d7-48f3-855b-ba2e25348226', 18, 14000, 252000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 18, 30000, 540000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', '155a9b23-cb5f-4253-b09d-475ba47c2568', 25, 14000, 350000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 4, 15000, 60000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 10, 15000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 15, 17000, 255000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 7, 15000, 105000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('f696ce97-a130-49fc-8d35-eecd886945f2', 'be25bd23-4f9b-4309-9497-60598a0477eb', 13, 14000, 182000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', '2026-06-22', 'Toko Kue ABC', 1373000, '2026-06-22 12:24:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', '40d3687a-b79a-4693-a5a9-d86793a6d436', 23, 15000, 345000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', '11a6d461-5b7a-4a0e-a629-82406a22d824', 6, 16000, 96000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 17, 30000, 510000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', '155a9b23-cb5f-4253-b09d-475ba47c2568', 23, 14000, 322000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 1, 16000, 16000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('1f10f9d4-6b4b-4bd2-b3ac-bc67d401b0ba', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 6, 14000, 84000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '2026-06-22', 'Toko Kue ABC', 1964000, '2026-06-22 11:36:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '40d3687a-b79a-4693-a5a9-d86793a6d436', 6, 14000, 84000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '6c06beee-bff9-483b-b651-f888b8881a97', 2, 11000, 22000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '11a6d461-5b7a-4a0e-a629-82406a22d824', 25, 16000, 400000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', 'e131c794-e7d7-48f3-855b-ba2e25348226', 1, 14000, 14000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 5, 30000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '155a9b23-cb5f-4253-b09d-475ba47c2568', 15, 13000, 195000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 15, 16000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 15, 15000, 225000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 17, 17000, 289000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 2, 15000, 30000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('a58f8f6b-9ad1-4419-bdfa-55b6b657a158', 'be25bd23-4f9b-4309-9497-60598a0477eb', 21, 15000, 315000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', '2026-06-22', 'Bu Sari', 1156000, '2026-06-22 11:35:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', '40d3687a-b79a-4693-a5a9-d86793a6d436', 5, 15000, 75000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', '6c06beee-bff9-483b-b651-f888b8881a97', 16, 12000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', '11a6d461-5b7a-4a0e-a629-82406a22d824', 7, 16000, 112000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 13, 29000, 377000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', '155a9b23-cb5f-4253-b09d-475ba47c2568', 2, 14000, 28000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 1, 15000, 15000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 6, 17000, 102000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 12, 15000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('e9a04afc-1ef0-47be-b7e7-a2c0bd495cdb', 'be25bd23-4f9b-4309-9497-60598a0477eb', 5, 15000, 75000);

INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', '2026-06-22', 'Bu Sari', 2574000, '2026-06-22 14:21:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', '40d3687a-b79a-4693-a5a9-d86793a6d436', 14, 14000, 196000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', '6c06beee-bff9-483b-b651-f888b8881a97', 21, 12000, 252000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', 'e131c794-e7d7-48f3-855b-ba2e25348226', 10, 14000, 140000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 30, 30000, 900000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', '155a9b23-cb5f-4253-b09d-475ba47c2568', 21, 13000, 273000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 18, 16000, 288000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 1, 15000, 15000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 15, 17000, 255000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, subtotal) VALUES ('650c5fed-b6f3-498e-9f51-f04124570669', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 17, 15000, 255000);
