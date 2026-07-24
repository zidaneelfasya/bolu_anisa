-- Menambahkan kolom hpp_satuan ke tabel penjualan_detail
ALTER TABLE penjualan_detail ADD COLUMN hpp_satuan NUMERIC(15,2) DEFAULT 0;

-- (Opsional) Mengisi data hpp_satuan untuk transaksi yang sudah ada menggunakan harga hpp produk saat ini
UPDATE penjualan_detail
SET hpp_satuan = produk.hpp
FROM produk
WHERE penjualan_detail.produk_id = produk.id;
