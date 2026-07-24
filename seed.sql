
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
INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', 'PRD-20260717-1', '2026-07-17', 'Selesai', 4489600, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '92b9eadf-6513-4266-8b55-89d8cba47c79', 140, 15000, 2100000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '4c610743-10af-4973-8baf-c40cebc46896', 112, 6800, 761600);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '21efeda7-0b32-4b99-a454-d92f38fb118f', 43, 26000, 1118000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '40d3687a-b79a-4693-a5a9-d86793a6d436', 41);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '6c06beee-bff9-483b-b651-f888b8881a97', 40);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '11a6d461-5b7a-4a0e-a629-82406a22d824', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', 'e131c794-e7d7-48f3-855b-ba2e25348226', 40);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 101);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '155a9b23-cb5f-4253-b09d-475ba47c2568', 97);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 57);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 26);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 40);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('1eddf838-60ec-437e-aa6b-b3e92adc344e', 'be25bd23-4f9b-4309-9497-60598a0477eb', 40);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-17', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-17', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-17', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 888000, 'Cetak Kue 592 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-17', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 118400, 'Pack & Stiker 592 pcs');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('d6191d6c-34b3-40a2-8dba-1195dcf69692', '2026-07-17', 'Toko Kue ABC', 1082000, '2026-07-17 14:27:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6191d6c-34b3-40a2-8dba-1195dcf69692', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 22, 16000, 8000, 352000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6191d6c-34b3-40a2-8dba-1195dcf69692', '40d3687a-b79a-4693-a5a9-d86793a6d436', 18, 15000, 7000, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6191d6c-34b3-40a2-8dba-1195dcf69692', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 18, 17000, 8500, 306000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6191d6c-34b3-40a2-8dba-1195dcf69692', '155a9b23-cb5f-4253-b09d-475ba47c2568', 11, 14000, 7000, 154000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('9b2b1d03-2466-4332-a3b1-a5242c55b03e', '2026-07-17', 'Toko Kue ABC', 1062000, '2026-07-17 14:21:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9b2b1d03-2466-4332-a3b1-a5242c55b03e', 'e131c794-e7d7-48f3-855b-ba2e25348226', 17, 14000, 7000, 238000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9b2b1d03-2466-4332-a3b1-a5242c55b03e', '11a6d461-5b7a-4a0e-a629-82406a22d824', 29, 16000, 8000, 464000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9b2b1d03-2466-4332-a3b1-a5242c55b03e', '6c06beee-bff9-483b-b651-f888b8881a97', 30, 12000, 6000, 360000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', '2026-07-17', 'Toko Kue ABC', 1651000, '2026-07-17 13:53:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 11, 16000, 8000, 176000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', 'e131c794-e7d7-48f3-855b-ba2e25348226', 10, 14000, 7000, 140000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 14, 17000, 8500, 238000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', '11a6d461-5b7a-4a0e-a629-82406a22d824', 25, 16000, 8000, 400000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', 'be25bd23-4f9b-4309-9497-60598a0477eb', 25, 15000, 7000, 375000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('980630e3-7084-4f14-8be9-c74df3ca6ea1', '155a9b23-cb5f-4253-b09d-475ba47c2568', 23, 14000, 7000, 322000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', '2026-07-17', 'Reseller', 2078000, '2026-07-17 16:35:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 17, 15000, 7500, 255000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', '11a6d461-5b7a-4a0e-a629-82406a22d824', 24, 16000, 8000, 384000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 18, 16000, 8000, 288000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 19, 15000, 7000, 285000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 7000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', '6c06beee-bff9-483b-b651-f888b8881a97', 17, 12000, 6000, 204000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('bd66c164-527d-4885-bbbe-9dc7f86b4949', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 16, 30000, 15000, 480000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', 'PRD-20260718-2', '2026-07-18', 'Selesai', 4400600, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '92b9eadf-6513-4266-8b55-89d8cba47c79', 137, 15000, 2055000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '4c610743-10af-4973-8baf-c40cebc46896', 117, 6800, 795600);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '21efeda7-0b32-4b99-a454-d92f38fb118f', 40, 26000, 1040000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '40d3687a-b79a-4693-a5a9-d86793a6d436', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '6c06beee-bff9-483b-b651-f888b8881a97', 45);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '11a6d461-5b7a-4a0e-a629-82406a22d824', 49);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', 'e131c794-e7d7-48f3-855b-ba2e25348226', 60);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 97);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '155a9b23-cb5f-4253-b09d-475ba47c2568', 98);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 42);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 33);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 45);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 42);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('fb4e36a9-b805-46ed-9d1b-876e8349e671', 'be25bd23-4f9b-4309-9497-60598a0477eb', 43);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-18', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-18', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-18', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 915000, 'Cetak Kue 610 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-18', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 122000, 'Pack & Stiker 610 pcs');
INSERT INTO biaya_operasional (tanggal, kategori, nominal, deskripsi) VALUES ('2026-07-18', 'Listrik & Air', 150000, 'Token Listrik');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('fdcdd432-ea34-404a-a9b8-0f08f43965ca', '2026-07-18', 'Toko Kue ABC', 728000, '2026-07-18 08:30:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fdcdd432-ea34-404a-a9b8-0f08f43965ca', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 12, 15000, 7000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fdcdd432-ea34-404a-a9b8-0f08f43965ca', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 23, 16000, 8000, 368000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fdcdd432-ea34-404a-a9b8-0f08f43965ca', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 7000, 180000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('d2c3e574-3e31-4330-8c22-64e57ed65244', '2026-07-18', 'Toko Laris', 1071000, '2026-07-18 10:28:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d2c3e574-3e31-4330-8c22-64e57ed65244', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 29, 15000, 7500, 435000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d2c3e574-3e31-4330-8c22-64e57ed65244', '155a9b23-cb5f-4253-b09d-475ba47c2568', 12, 14000, 7000, 168000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d2c3e574-3e31-4330-8c22-64e57ed65244', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 18, 16000, 8000, 288000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d2c3e574-3e31-4330-8c22-64e57ed65244', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 12, 15000, 7000, 180000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', '2026-07-18', 'Toko Kue ABC', 2003000, '2026-07-18 12:40:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 12, 30000, 15000, 360000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', 'be25bd23-4f9b-4309-9497-60598a0477eb', 25, 15000, 7000, 375000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 12, 15000, 7500, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', 'e131c794-e7d7-48f3-855b-ba2e25348226', 12, 14000, 7000, 168000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', '155a9b23-cb5f-4253-b09d-475ba47c2568', 22, 14000, 7000, 308000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 21, 17000, 8500, 357000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c42049e-c459-4340-9e3d-4f7b331b4732', '40d3687a-b79a-4693-a5a9-d86793a6d436', 17, 15000, 7000, 255000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('236f41eb-3c5f-4c9c-a506-08a5c9034c02', '2026-07-18', 'Toko Kue ABC', 1272000, '2026-07-18 16:53:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('236f41eb-3c5f-4c9c-a506-08a5c9034c02', '40d3687a-b79a-4693-a5a9-d86793a6d436', 18, 15000, 7000, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('236f41eb-3c5f-4c9c-a506-08a5c9034c02', 'be25bd23-4f9b-4309-9497-60598a0477eb', 19, 15000, 7000, 285000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('236f41eb-3c5f-4c9c-a506-08a5c9034c02', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 7000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('236f41eb-3c5f-4c9c-a506-08a5c9034c02', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 11, 17000, 8500, 187000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('236f41eb-3c5f-4c9c-a506-08a5c9034c02', '6c06beee-bff9-483b-b651-f888b8881a97', 29, 12000, 6000, 348000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('ddc6db4a-c838-4beb-b6e9-fe85fdbd4757', '2026-07-18', 'Toko Kue ABC', 855000, '2026-07-18 10:39:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddc6db4a-c838-4beb-b6e9-fe85fdbd4757', 'e131c794-e7d7-48f3-855b-ba2e25348226', 14, 14000, 7000, 196000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddc6db4a-c838-4beb-b6e9-fe85fdbd4757', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 7000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddc6db4a-c838-4beb-b6e9-fe85fdbd4757', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 11, 15000, 7500, 165000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddc6db4a-c838-4beb-b6e9-fe85fdbd4757', '6c06beee-bff9-483b-b651-f888b8881a97', 26, 12000, 6000, 312000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('6c6938d1-796d-4b67-91ee-f319d7701093', '2026-07-18', 'Reseller', 1363000, '2026-07-18 17:07:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('6c6938d1-796d-4b67-91ee-f319d7701093', '40d3687a-b79a-4693-a5a9-d86793a6d436', 20, 15000, 7000, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('6c6938d1-796d-4b67-91ee-f319d7701093', '155a9b23-cb5f-4253-b09d-475ba47c2568', 30, 14000, 7000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('6c6938d1-796d-4b67-91ee-f319d7701093', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 27, 15000, 7500, 405000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('6c6938d1-796d-4b67-91ee-f319d7701093', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 14, 17000, 8500, 238000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', 'PRD-20260719-3', '2026-07-19', 'Selesai', 4935200, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '92b9eadf-6513-4266-8b55-89d8cba47c79', 148, 15000, 2220000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '4c610743-10af-4973-8baf-c40cebc46896', 114, 6800, 775200);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '21efeda7-0b32-4b99-a454-d92f38fb118f', 55, 26000, 1430000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '40d3687a-b79a-4693-a5a9-d86793a6d436', 59);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '6c06beee-bff9-483b-b651-f888b8881a97', 43);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '11a6d461-5b7a-4a0e-a629-82406a22d824', 45);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', 'e131c794-e7d7-48f3-855b-ba2e25348226', 41);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 110);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '155a9b23-cb5f-4253-b09d-475ba47c2568', 98);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 34);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 44);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('afcd0f81-33d0-49b4-934c-ff1095ba4fcd', 'be25bd23-4f9b-4309-9497-60598a0477eb', 50);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-19', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-19', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-19', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 945000, 'Cetak Kue 630 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-19', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 126000, 'Pack & Stiker 630 pcs');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('37868ce6-256d-41c1-8a70-c5da8b155187', '2026-07-19', 'Bu Sari', 1097000, '2026-07-19 16:17:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('37868ce6-256d-41c1-8a70-c5da8b155187', '6c06beee-bff9-483b-b651-f888b8881a97', 26, 12000, 6000, 312000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('37868ce6-256d-41c1-8a70-c5da8b155187', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 25, 17000, 8500, 425000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('37868ce6-256d-41c1-8a70-c5da8b155187', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 24, 15000, 7500, 360000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('fc86b30a-cf17-446c-a324-0f0c27f8f5ef', '2026-07-19', 'Bu Sari', 893000, '2026-07-19 10:26:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fc86b30a-cf17-446c-a324-0f0c27f8f5ef', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 18, 15000, 7500, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fc86b30a-cf17-446c-a324-0f0c27f8f5ef', 'be25bd23-4f9b-4309-9497-60598a0477eb', 13, 15000, 7000, 195000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fc86b30a-cf17-446c-a324-0f0c27f8f5ef', '155a9b23-cb5f-4253-b09d-475ba47c2568', 10, 14000, 7000, 140000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('fc86b30a-cf17-446c-a324-0f0c27f8f5ef', '11a6d461-5b7a-4a0e-a629-82406a22d824', 18, 16000, 8000, 288000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('d6a762f6-4671-41eb-be55-ce56b859c631', '2026-07-19', 'Reseller', 975000, '2026-07-19 08:00:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6a762f6-4671-41eb-be55-ce56b859c631', '40d3687a-b79a-4693-a5a9-d86793a6d436', 21, 15000, 7000, 315000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6a762f6-4671-41eb-be55-ce56b859c631', '6c06beee-bff9-483b-b651-f888b8881a97', 19, 12000, 6000, 228000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d6a762f6-4671-41eb-be55-ce56b859c631', '11a6d461-5b7a-4a0e-a629-82406a22d824', 27, 16000, 8000, 432000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', '2026-07-19', 'Bpk Budi', 1616000, '2026-07-19 11:02:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 27, 16000, 8000, 432000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', '40d3687a-b79a-4693-a5a9-d86793a6d436', 14, 15000, 7000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', '155a9b23-cb5f-4253-b09d-475ba47c2568', 13, 14000, 7000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', '6c06beee-bff9-483b-b651-f888b8881a97', 21, 12000, 6000, 252000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', 'be25bd23-4f9b-4309-9497-60598a0477eb', 14, 15000, 7000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ddec3ea1-c5a0-436c-a5b0-8a6d2ec4403b', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 11, 30000, 15000, 330000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('d96c403c-e291-403d-95ad-f875161246f8', '2026-07-19', 'Reseller', 766000, '2026-07-19 10:54:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d96c403c-e291-403d-95ad-f875161246f8', '6c06beee-bff9-483b-b651-f888b8881a97', 16, 12000, 6000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d96c403c-e291-403d-95ad-f875161246f8', 'e131c794-e7d7-48f3-855b-ba2e25348226', 30, 14000, 7000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('d96c403c-e291-403d-95ad-f875161246f8', '155a9b23-cb5f-4253-b09d-475ba47c2568', 11, 14000, 7000, 154000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('238f0362-3003-443d-8d09-1c57375408e1', '2026-07-19', 'Bu Sari', 2107000, '2026-07-19 10:02:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('238f0362-3003-443d-8d09-1c57375408e1', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 28, 30000, 15000, 840000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('238f0362-3003-443d-8d09-1c57375408e1', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 26, 15000, 7500, 390000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('238f0362-3003-443d-8d09-1c57375408e1', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 29, 15000, 7000, 435000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('238f0362-3003-443d-8d09-1c57375408e1', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 11, 17000, 8500, 187000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('238f0362-3003-443d-8d09-1c57375408e1', '40d3687a-b79a-4693-a5a9-d86793a6d436', 17, 15000, 7000, 255000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', 'PRD-20260720-4', '2026-07-20', 'Selesai', 4441400, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '92b9eadf-6513-4266-8b55-89d8cba47c79', 133, 15000, 1995000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '4c610743-10af-4973-8baf-c40cebc46896', 128, 6800, 870400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '21efeda7-0b32-4b99-a454-d92f38fb118f', 41, 26000, 1066000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '40d3687a-b79a-4693-a5a9-d86793a6d436', 49);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '6c06beee-bff9-483b-b651-f888b8881a97', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '11a6d461-5b7a-4a0e-a629-82406a22d824', 40);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', 'e131c794-e7d7-48f3-855b-ba2e25348226', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 94);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '155a9b23-cb5f-4253-b09d-475ba47c2568', 101);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 46);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 32);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 44);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 50);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('06272071-a56d-424b-bea7-db4667ccc29c', 'be25bd23-4f9b-4309-9497-60598a0477eb', 55);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-20', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-20', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-20', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 937500, 'Cetak Kue 625 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-20', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 125000, 'Pack & Stiker 625 pcs');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', '2026-07-20', 'Toko Kue ABC', 2374000, '2026-07-20 15:10:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 30, 30000, 15000, 900000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', '155a9b23-cb5f-4253-b09d-475ba47c2568', 18, 14000, 7000, 252000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 30, 16000, 8000, 480000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 11, 17000, 8500, 187000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 24, 15000, 7500, 360000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('cf30fbd1-f4f2-4b25-b4f6-8f6684065a13', 'be25bd23-4f9b-4309-9497-60598a0477eb', 13, 15000, 7000, 195000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('351e2851-9089-42e8-b16f-6ec712267aef', '2026-07-20', 'Bpk Budi', 1098000, '2026-07-20 08:34:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('351e2851-9089-42e8-b16f-6ec712267aef', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 10, 15000, 7000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('351e2851-9089-42e8-b16f-6ec712267aef', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 11, 30000, 15000, 330000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('351e2851-9089-42e8-b16f-6ec712267aef', '40d3687a-b79a-4693-a5a9-d86793a6d436', 18, 15000, 7000, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('351e2851-9089-42e8-b16f-6ec712267aef', '6c06beee-bff9-483b-b651-f888b8881a97', 29, 12000, 6000, 348000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', '2026-07-20', 'Toko Laris', 2805000, '2026-07-20 12:02:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', '6c06beee-bff9-483b-b651-f888b8881a97', 30, 12000, 6000, 360000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', 'be25bd23-4f9b-4309-9497-60598a0477eb', 30, 15000, 7000, 450000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', 'e131c794-e7d7-48f3-855b-ba2e25348226', 30, 14000, 7000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 25, 15000, 7500, 375000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 30, 30000, 15000, 900000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('2604eb32-057c-434c-a408-93475bf2b0a2', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 20, 15000, 7000, 300000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('9c1c787c-7a9b-4917-83c5-378a8e9a8076', '2026-07-20', 'Bu Sari', 614000, '2026-07-20 14:59:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c1c787c-7a9b-4917-83c5-378a8e9a8076', '6c06beee-bff9-483b-b651-f888b8881a97', 11, 12000, 6000, 132000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c1c787c-7a9b-4917-83c5-378a8e9a8076', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 20, 15000, 7500, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('9c1c787c-7a9b-4917-83c5-378a8e9a8076', 'e131c794-e7d7-48f3-855b-ba2e25348226', 13, 14000, 7000, 182000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', '2026-07-20', 'Toko Kue ABC', 1910000, '2026-07-20 12:21:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', 'be25bd23-4f9b-4309-9497-60598a0477eb', 21, 15000, 7000, 315000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', 'e131c794-e7d7-48f3-855b-ba2e25348226', 27, 14000, 7000, 378000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 15, 16000, 8000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 18, 15000, 7000, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', '11a6d461-5b7a-4a0e-a629-82406a22d824', 17, 16000, 8000, 272000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', '6c06beee-bff9-483b-b651-f888b8881a97', 10, 12000, 6000, 120000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ed5e3df-c1d2-4623-b677-b9194cee14d8', '40d3687a-b79a-4693-a5a9-d86793a6d436', 21, 15000, 7000, 315000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('288d4798-669a-4148-be7c-c2be0b14f53f', '2026-07-20', 'Toko Kue ABC', 975000, '2026-07-20 16:44:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('288d4798-669a-4148-be7c-c2be0b14f53f', '40d3687a-b79a-4693-a5a9-d86793a6d436', 29, 15000, 7000, 435000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('288d4798-669a-4148-be7c-c2be0b14f53f', '6c06beee-bff9-483b-b651-f888b8881a97', 20, 12000, 6000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('288d4798-669a-4148-be7c-c2be0b14f53f', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 20, 15000, 7500, 300000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', '2026-07-20', 'Toko Kue ABC', 1911000, '2026-07-20 14:15:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 19, 16000, 8000, 304000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 10, 30000, 15000, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 25, 17000, 8500, 425000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', 'e131c794-e7d7-48f3-855b-ba2e25348226', 17, 14000, 7000, 238000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', '11a6d461-5b7a-4a0e-a629-82406a22d824', 20, 16000, 8000, 320000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('04a6cf82-0e1a-4930-ab48-cb0a572959f1', '6c06beee-bff9-483b-b651-f888b8881a97', 27, 12000, 6000, 324000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', 'PRD-20260721-5', '2026-07-21', 'Selesai', 4682200, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '92b9eadf-6513-4266-8b55-89d8cba47c79', 137, 15000, 2055000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '4c610743-10af-4973-8baf-c40cebc46896', 124, 6800, 843200);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '21efeda7-0b32-4b99-a454-d92f38fb118f', 49, 26000, 1274000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '40d3687a-b79a-4693-a5a9-d86793a6d436', 40);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '6c06beee-bff9-483b-b651-f888b8881a97', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '11a6d461-5b7a-4a0e-a629-82406a22d824', 59);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', 'e131c794-e7d7-48f3-855b-ba2e25348226', 58);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 99);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '155a9b23-cb5f-4253-b09d-475ba47c2568', 100);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 54);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 32);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 45);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 44);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('e4c3c506-4241-4b50-901d-a99129e32f88', 'be25bd23-4f9b-4309-9497-60598a0477eb', 49);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-21', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-21', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-21', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 942000, 'Cetak Kue 628 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-21', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 125600, 'Pack & Stiker 628 pcs');
INSERT INTO biaya_operasional (tanggal, kategori, nominal, deskripsi) VALUES ('2026-07-21', 'Listrik & Air', 150000, 'Token Listrik');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('ff620785-ffbe-47e7-a81a-ece5dcec70c7', '2026-07-21', 'Toko Kue ABC', 963000, '2026-07-21 13:15:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ff620785-ffbe-47e7-a81a-ece5dcec70c7', 'e131c794-e7d7-48f3-855b-ba2e25348226', 19, 14000, 7000, 266000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ff620785-ffbe-47e7-a81a-ece5dcec70c7', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 22, 16000, 8000, 352000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('ff620785-ffbe-47e7-a81a-ece5dcec70c7', '40d3687a-b79a-4693-a5a9-d86793a6d436', 23, 15000, 7000, 345000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', '2026-07-21', 'Toko Laris', 1802000, '2026-07-21 14:04:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 21, 17000, 8500, 357000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', '155a9b23-cb5f-4253-b09d-475ba47c2568', 17, 14000, 7000, 238000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 20, 16000, 8000, 320000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 28, 15000, 7000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', 'e131c794-e7d7-48f3-855b-ba2e25348226', 13, 14000, 7000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a67f9aaa-2813-4c97-b671-d051024ff282', 'be25bd23-4f9b-4309-9497-60598a0477eb', 19, 15000, 7000, 285000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('59da5013-462c-4267-bde3-b82a49c73db6', '2026-07-21', 'Bu Sari', 1134000, '2026-07-21 12:44:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('59da5013-462c-4267-bde3-b82a49c73db6', '155a9b23-cb5f-4253-b09d-475ba47c2568', 27, 14000, 7000, 378000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('59da5013-462c-4267-bde3-b82a49c73db6', '11a6d461-5b7a-4a0e-a629-82406a22d824', 12, 16000, 8000, 192000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('59da5013-462c-4267-bde3-b82a49c73db6', '6c06beee-bff9-483b-b651-f888b8881a97', 27, 12000, 6000, 324000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('59da5013-462c-4267-bde3-b82a49c73db6', '40d3687a-b79a-4693-a5a9-d86793a6d436', 16, 15000, 7000, 240000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', '2026-07-21', 'Bu Sari', 1397000, '2026-07-21 17:25:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 14, 15000, 7500, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', 'be25bd23-4f9b-4309-9497-60598a0477eb', 10, 15000, 7000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', '6c06beee-bff9-483b-b651-f888b8881a97', 20, 12000, 6000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', '40d3687a-b79a-4693-a5a9-d86793a6d436', 26, 15000, 7000, 390000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 15, 15000, 7000, 225000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c07508f4-3cfc-4e3a-9a9c-12e126fbf6b7', 'e131c794-e7d7-48f3-855b-ba2e25348226', 13, 14000, 7000, 182000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', 'PRD-20260722-6', '2026-07-22', 'Selesai', 4922600, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '92b9eadf-6513-4266-8b55-89d8cba47c79', 143, 15000, 2145000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '4c610743-10af-4973-8baf-c40cebc46896', 127, 6800, 863600);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '21efeda7-0b32-4b99-a454-d92f38fb118f', 54, 26000, 1404000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '40d3687a-b79a-4693-a5a9-d86793a6d436', 57);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '6c06beee-bff9-483b-b651-f888b8881a97', 46);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '11a6d461-5b7a-4a0e-a629-82406a22d824', 51);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', 'e131c794-e7d7-48f3-855b-ba2e25348226', 50);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 109);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '155a9b23-cb5f-4253-b09d-475ba47c2568', 99);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 43);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 27);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 59);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 47);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('bf8eec54-14ac-4e84-a037-fbbfc70caabb', 'be25bd23-4f9b-4309-9497-60598a0477eb', 44);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-22', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-22', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-22', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 948000, 'Cetak Kue 632 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-22', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 126400, 'Pack & Stiker 632 pcs');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('4880c920-37e8-4364-bd63-5af30f67f70b', '2026-07-22', 'Reseller', 1524000, '2026-07-22 12:44:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4880c920-37e8-4364-bd63-5af30f67f70b', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 20, 30000, 15000, 600000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4880c920-37e8-4364-bd63-5af30f67f70b', '155a9b23-cb5f-4253-b09d-475ba47c2568', 18, 14000, 7000, 252000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4880c920-37e8-4364-bd63-5af30f67f70b', '11a6d461-5b7a-4a0e-a629-82406a22d824', 27, 16000, 8000, 432000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4880c920-37e8-4364-bd63-5af30f67f70b', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 16, 15000, 7000, 240000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('f20b2418-e342-4cc8-b3cc-9df9efde0ac3', '2026-07-22', 'Toko Laris', 1284000, '2026-07-22 09:56:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('f20b2418-e342-4cc8-b3cc-9df9efde0ac3', '11a6d461-5b7a-4a0e-a629-82406a22d824', 17, 16000, 8000, 272000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('f20b2418-e342-4cc8-b3cc-9df9efde0ac3', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 10, 16000, 8000, 160000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('f20b2418-e342-4cc8-b3cc-9df9efde0ac3', '40d3687a-b79a-4693-a5a9-d86793a6d436', 20, 15000, 7000, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('f20b2418-e342-4cc8-b3cc-9df9efde0ac3', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 20, 15000, 7000, 300000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('f20b2418-e342-4cc8-b3cc-9df9efde0ac3', '6c06beee-bff9-483b-b651-f888b8881a97', 21, 12000, 6000, 252000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('8ca15212-9da1-479b-a797-ef450b67c8d2', '2026-07-22', 'Reseller', 836000, '2026-07-22 10:54:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ca15212-9da1-479b-a797-ef450b67c8d2', '11a6d461-5b7a-4a0e-a629-82406a22d824', 10, 16000, 8000, 160000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ca15212-9da1-479b-a797-ef450b67c8d2', 'be25bd23-4f9b-4309-9497-60598a0477eb', 28, 15000, 7000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8ca15212-9da1-479b-a797-ef450b67c8d2', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 16, 16000, 8000, 256000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', '2026-07-22', 'Reseller', 1890000, '2026-07-22 15:05:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', '11a6d461-5b7a-4a0e-a629-82406a22d824', 19, 16000, 8000, 304000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 13, 17000, 8500, 221000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', 'be25bd23-4f9b-4309-9497-60598a0477eb', 27, 15000, 7000, 405000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 19, 15000, 7000, 285000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 19, 15000, 7500, 285000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b53fe074-537d-4fac-98c6-31322eb791af', '40d3687a-b79a-4693-a5a9-d86793a6d436', 26, 15000, 7000, 390000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('57dbaee1-c6d7-4c1d-ae18-78063438f468', '2026-07-22', 'Toko Laris', 924000, '2026-07-22 11:33:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('57dbaee1-c6d7-4c1d-ae18-78063438f468', '40d3687a-b79a-4693-a5a9-d86793a6d436', 21, 15000, 7000, 315000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('57dbaee1-c6d7-4c1d-ae18-78063438f468', '6c06beee-bff9-483b-b651-f888b8881a97', 17, 12000, 6000, 204000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('57dbaee1-c6d7-4c1d-ae18-78063438f468', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 27, 15000, 7000, 405000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('c9cf2beb-4008-4f0f-952b-b25526d961ff', '2026-07-22', 'Bu Sari', 1025000, '2026-07-22 08:51:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c9cf2beb-4008-4f0f-952b-b25526d961ff', '40d3687a-b79a-4693-a5a9-d86793a6d436', 14, 15000, 7000, 210000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c9cf2beb-4008-4f0f-952b-b25526d961ff', '155a9b23-cb5f-4253-b09d-475ba47c2568', 22, 14000, 7000, 308000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c9cf2beb-4008-4f0f-952b-b25526d961ff', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 11, 17000, 8500, 187000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('c9cf2beb-4008-4f0f-952b-b25526d961ff', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 20, 16000, 8000, 320000);

INSERT INTO produksi (id, nomor_produksi, tanggal_produksi, status, total_biaya_bahan, total_biaya_packaging) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', 'PRD-20260723-7', '2026-07-23', 'Selesai', 4568800, 295400);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '92b9eadf-6513-4266-8b55-89d8cba47c79', 132, 15000, 1980000);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '4c610743-10af-4973-8baf-c40cebc46896', 126, 6800, 856800);
INSERT INTO produksi_bahan (produksi_id, bahan_id, jumlah, harga_satuan, subtotal) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '21efeda7-0b32-4b99-a454-d92f38fb118f', 47, 26000, 1222000);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '40d3687a-b79a-4693-a5a9-d86793a6d436', 60);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '6c06beee-bff9-483b-b651-f888b8881a97', 49);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '11a6d461-5b7a-4a0e-a629-82406a22d824', 55);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', 'e131c794-e7d7-48f3-855b-ba2e25348226', 53);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 108);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '155a9b23-cb5f-4253-b09d-475ba47c2568', 110);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 48);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 27);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 45);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 56);
INSERT INTO produksi_hasil (produksi_id, produk_id, jumlah) VALUES ('32e433b5-4fda-4c56-8d3d-da1364b5dbcc', 'be25bd23-4f9b-4309-9497-60598a0477eb', 51);
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-23', '29db5630-53d6-4938-b362-937820d4b96e', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-23', '3dc0db29-5b3b-45cf-9338-b3f2672862d6', 'Harian', 75000, 'Gaji Harian');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-23', 'c203a896-db4b-49d5-a2bf-21fc5c010057', 'Borongan Produksi', 993000, 'Cetak Kue 662 pcs');
INSERT INTO gaji_harian (tanggal, karyawan_id, jenis_gaji, nominal, keterangan) VALUES ('2026-07-23', '0cf16460-3903-48db-b286-9fcb902db689', 'Borongan Packaging', 132400, 'Pack & Stiker 662 pcs');
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', '2026-07-23', 'Reseller', 2763000, '2026-07-23 16:22:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', '40d3687a-b79a-4693-a5a9-d86793a6d436', 12, 15000, 7000, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 26, 15000, 7000, 390000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', '6c06beee-bff9-483b-b651-f888b8881a97', 18, 12000, 6000, 216000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 21, 30000, 15000, 630000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', 'be25bd23-4f9b-4309-9497-60598a0477eb', 29, 15000, 7000, 435000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 29, 16000, 8000, 464000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('e0b1c30e-3309-4ddf-83d0-fabd71e360f9', '11a6d461-5b7a-4a0e-a629-82406a22d824', 28, 16000, 8000, 448000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('984dee80-7329-40e0-b02a-f3c9a3e47c1a', '2026-07-23', 'Toko Kue ABC', 1003000, '2026-07-23 08:48:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('984dee80-7329-40e0-b02a-f3c9a3e47c1a', 'be25bd23-4f9b-4309-9497-60598a0477eb', 10, 15000, 7000, 150000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('984dee80-7329-40e0-b02a-f3c9a3e47c1a', '6c06beee-bff9-483b-b651-f888b8881a97', 13, 12000, 6000, 156000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('984dee80-7329-40e0-b02a-f3c9a3e47c1a', '40d3687a-b79a-4693-a5a9-d86793a6d436', 25, 15000, 7000, 375000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('984dee80-7329-40e0-b02a-f3c9a3e47c1a', 'e131c794-e7d7-48f3-855b-ba2e25348226', 23, 14000, 7000, 322000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', '2026-07-23', 'Bu Sari', 2971000, '2026-07-23 10:22:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 24, 15000, 7500, 360000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', '155a9b23-cb5f-4253-b09d-475ba47c2568', 20, 14000, 7000, 280000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 30, 30000, 15000, 900000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', 'e131c794-e7d7-48f3-855b-ba2e25348226', 11, 14000, 7000, 154000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 26, 16000, 8000, 416000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', '11a6d461-5b7a-4a0e-a629-82406a22d824', 23, 16000, 8000, 368000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('a19e4c64-743c-450f-8c37-a0dc97596c4c', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 29, 17000, 8500, 493000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('b0529f6f-4c8f-48da-9f92-f0c2eea2595d', '2026-07-23', 'Bu Sari', 1541000, '2026-07-23 12:31:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b0529f6f-4c8f-48da-9f92-f0c2eea2595d', 'c630378c-faa3-4b45-a83e-b87cd7b0277c', 30, 16000, 8000, 480000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b0529f6f-4c8f-48da-9f92-f0c2eea2595d', '155a9b23-cb5f-4253-b09d-475ba47c2568', 25, 14000, 7000, 350000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b0529f6f-4c8f-48da-9f92-f0c2eea2595d', 'e131c794-e7d7-48f3-855b-ba2e25348226', 24, 14000, 7000, 336000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('b0529f6f-4c8f-48da-9f92-f0c2eea2595d', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 25, 15000, 7500, 375000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', '2026-07-23', 'Bpk Budi', 2138000, '2026-07-23 17:44:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', 'e131c794-e7d7-48f3-855b-ba2e25348226', 13, 14000, 7000, 182000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 14, 30000, 15000, 420000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 26, 17000, 8500, 442000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', '155a9b23-cb5f-4253-b09d-475ba47c2568', 16, 14000, 7000, 224000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', 'be25bd23-4f9b-4309-9497-60598a0477eb', 18, 15000, 7000, 270000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 12, 15000, 7500, 180000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('21ea9694-8df0-4463-8db0-423097f9039b', '40d3687a-b79a-4693-a5a9-d86793a6d436', 28, 15000, 7000, 420000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', '2026-07-23', 'Reseller', 2538000, '2026-07-23 10:28:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', '155a9b23-cb5f-4253-b09d-475ba47c2568', 29, 14000, 7000, 406000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 11, 30000, 15000, 330000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', '40d3687a-b79a-4693-a5a9-d86793a6d436', 29, 15000, 7000, 435000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', 'be25bd23-4f9b-4309-9497-60598a0477eb', 27, 15000, 7000, 405000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 19, 17000, 8500, 323000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', '6c06beee-bff9-483b-b651-f888b8881a97', 27, 12000, 6000, 324000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('8be8b58b-f1fa-46eb-b66c-70c1abffdf16', '38cfc22f-2a14-4c2b-a248-b52b17ab8008', 21, 15000, 7500, 315000);
INSERT INTO penjualan (id, tanggal, keterangan, total, created_at) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', '2026-07-23', 'Toko Kue ABC', 2146000, '2026-07-23 14:29:00');
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', '3de269c2-ad21-45b4-89e0-0f57618eaf81', 21, 30000, 15000, 630000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', 'e131c794-e7d7-48f3-855b-ba2e25348226', 29, 14000, 7000, 406000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', '40d3687a-b79a-4693-a5a9-d86793a6d436', 26, 15000, 7000, 390000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', 'b6fde04a-590a-4570-8b57-0a109ed9fa21', 15, 17000, 8500, 255000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', 'be25bd23-4f9b-4309-9497-60598a0477eb', 16, 15000, 7000, 240000);
INSERT INTO penjualan_detail (penjualan_id, produk_id, jumlah, harga, hpp_satuan, subtotal) VALUES ('4569fe5a-aabd-4624-acdc-0f55c703b57f', 'e11f9941-669c-47e7-aaaa-8e373bfce877', 15, 15000, 7000, 225000);

