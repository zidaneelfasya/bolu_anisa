-- 1. MATIKAN RLS (ROW LEVEL SECURITY) SEMENTARA
-- Supabase seringkali memblokir akses baca jika RLS tidak sengaja aktif
ALTER TABLE bahan_baku DISABLE ROW LEVEL SECURITY;
ALTER TABLE packaging DISABLE ROW LEVEL SECURITY;
ALTER TABLE produk DISABLE ROW LEVEL SECURITY;
ALTER TABLE karyawan DISABLE ROW LEVEL SECURITY;
ALTER TABLE produksi DISABLE ROW LEVEL SECURITY;
ALTER TABLE gaji_harian DISABLE ROW LEVEL SECURITY;

-- 2. HAPUS DATA LAMA JIKA ADA (Agar bersih)
TRUNCATE TABLE bahan_baku, packaging, produk, karyawan CASCADE;

-- 3. MASUKKAN DATA (SEEDER)
INSERT INTO karyawan (nama, nomor_hp, alamat, jenis_gaji, status) VALUES
('Bapak Yanto', '081234567890', 'Banyuwangi', 'Borongan Produksi', 'Aktif'),
('Ibu Siti', '081298765432', 'Giri', 'Borongan Packaging', 'Aktif');

INSERT INTO bahan_baku (nama, kategori, satuan, stok, harga_terakhir, harga_rata_rata) VALUES
('Gula Pasir', 'Bahan Pokok', 'Kg', 141, 15000, 15000),
('Tepung Terigu', 'Bahan Pokok', 'Kg', 125, 6800, 6800);

INSERT INTO packaging (nama, jenis, harga_per_pcs, stok, minimum_stok) VALUES
('Stiker Semua Varian', 'Stiker', 80, 5000, 500),
('Box Bolu', 'Kardus', 1500, 300, 50);

INSERT INTO produk (nama, kategori, harga_jual, stok) VALUES
('Pia Ori', 'Kue Basah', 15000, 0),
('Bolu Pandan', 'Bolu', 35000, 0);
