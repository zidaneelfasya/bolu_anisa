-- 1. UBAH NAMA TABEL AGAR LEBIH UMUM (KARENA BISA BELI PACKAGING JUGA)
ALTER TABLE IF EXISTS pembelian_bahan RENAME TO pembelian;
ALTER TABLE IF EXISTS pembelian_detail RENAME TO pembelian_bahan_detail;

-- 2. SESUAIKAN KOLOM PADA TABEL pembelian_bahan_detail
-- Ubah nama kolom foreign key agar konsisten dengan nama tabel barunya
ALTER TABLE pembelian_bahan_detail RENAME COLUMN pembelian_id TO pembelian_id; -- Tetap

-- 3. BUAT TABEL BARU UNTUK PEMBELIAN PACKAGING
CREATE TABLE IF NOT EXISTS pembelian_packaging_detail (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    pembelian_id UUID REFERENCES pembelian(id) ON DELETE CASCADE,
    packaging_id UUID REFERENCES packaging(id) ON DELETE RESTRICT,
    jumlah INT NOT NULL CHECK (jumlah > 0),
    harga NUMERIC(15,2) NOT NULL CHECK (harga >= 0),
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. MATIKAN RLS UNTUK TABEL-TABEL PEMBELIAN & PENJUALAN
ALTER TABLE pembelian DISABLE ROW LEVEL SECURITY;
ALTER TABLE pembelian_bahan_detail DISABLE ROW LEVEL SECURITY;
ALTER TABLE pembelian_packaging_detail DISABLE ROW LEVEL SECURITY;
ALTER TABLE penjualan DISABLE ROW LEVEL SECURITY;
ALTER TABLE penjualan_detail DISABLE ROW LEVEL SECURITY;


-- ========================================================================================= --
-- 5. FUNGSI RPC: SELESAIKAN PEMBELIAN
-- ========================================================================================= --
CREATE OR REPLACE FUNCTION selesaikan_pembelian(p_pembelian_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_tanggal DATE;
    v_total NUMERIC = 0;
    v_bahan RECORD;
    v_pack RECORD;
    v_stok_sekarang NUMERIC;
    v_harga_baru NUMERIC;
BEGIN
    -- Ambil info pembelian
    SELECT tanggal INTO v_tanggal FROM pembelian WHERE id = p_pembelian_id;

    -- A. PROSES BAHAN BAKU
    FOR v_bahan IN SELECT * FROM pembelian_bahan_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = v_bahan.bahan_id;
        
        -- Update Stok dan Harga Terakhir di Bahan Baku
        UPDATE bahan_baku 
        SET stok = stok + v_bahan.jumlah,
            harga_terakhir = v_bahan.harga,
            -- Harga rata-rata disederhanakan: (Harga Lama + Harga Baru) / 2 jika sudah ada stok
            harga_rata_rata = CASE 
                WHEN stok = 0 THEN v_bahan.harga 
                ELSE (harga_rata_rata + v_bahan.harga) / 2 
            END
        WHERE id = v_bahan.bahan_id;

        -- Catat Stock Movement
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Bahan Baku', v_bahan.bahan_id, 'Masuk', v_bahan.jumlah, v_stok_sekarang, v_stok_sekarang + v_bahan.jumlah, 'Pembelian ' || p_pembelian_id, p_user_id);
        
        v_total := v_total + v_bahan.subtotal;
    END LOOP;

    -- B. PROSES PACKAGING
    FOR v_pack IN SELECT * FROM pembelian_packaging_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = v_pack.packaging_id;
        
        -- Update Stok dan Harga Terakhir
        UPDATE packaging 
        SET stok = stok + v_pack.jumlah,
            harga_per_pcs = v_pack.harga
        WHERE id = v_pack.packaging_id;

        -- Catat Stock Movement
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Packaging', v_pack.packaging_id, 'Masuk', v_pack.jumlah, v_stok_sekarang, v_stok_sekarang + v_pack.jumlah, 'Pembelian ' || p_pembelian_id, p_user_id);
        
        v_total := v_total + v_pack.subtotal;
    END LOOP;

    -- C. UPDATE TOTAL PEMBELIAN
    UPDATE pembelian SET total = v_total, updated_by = p_user_id, updated_at = NOW() WHERE id = p_pembelian_id;

    -- D. CATAT KE CASH FLOW (Pengeluaran)
    IF v_total > 0 THEN
        INSERT INTO cash_flow (tanggal, kategori, jenis, deskripsi, nominal, referensi_id, created_by)
        VALUES (v_tanggal, 'Pembelian Barang', 'Pengeluaran', 'Pembelian Bahan & Packaging', v_total, p_pembelian_id, p_user_id);
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- ========================================================================================= --
-- 6. FUNGSI RPC: SELESAIKAN PENJUALAN
-- ========================================================================================= --
CREATE OR REPLACE FUNCTION selesaikan_penjualan(p_penjualan_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_tanggal DATE;
    v_total NUMERIC = 0;
    v_detail RECORD;
    v_stok_sekarang NUMERIC;
BEGIN
    -- Ambil info penjualan
    SELECT tanggal INTO v_tanggal FROM penjualan WHERE id = p_penjualan_id;

    -- PROSES PRODUK YANG TERJUAL
    FOR v_detail IN SELECT * FROM penjualan_detail WHERE penjualan_id = p_penjualan_id LOOP
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = v_detail.produk_id;
        
        IF v_stok_sekarang < v_detail.jumlah THEN
            RAISE EXCEPTION 'Stok produk jadi tidak mencukupi untuk ID %', v_detail.produk_id;
        END IF;

        -- Kurangi Stok Produk
        UPDATE produk SET stok = stok - v_detail.jumlah WHERE id = v_detail.produk_id;

        -- Catat Stock Movement
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Produk Jadi', v_detail.produk_id, 'Keluar', v_detail.jumlah, v_stok_sekarang, v_stok_sekarang - v_detail.jumlah, 'Penjualan ' || p_penjualan_id, p_user_id);
        
        v_total := v_total + v_detail.subtotal;
    END LOOP;

    -- UPDATE TOTAL PENJUALAN
    UPDATE penjualan SET total = v_total, updated_by = p_user_id, updated_at = NOW() WHERE id = p_penjualan_id;

    -- CATAT KE CASH FLOW (Pemasukan)
    IF v_total > 0 THEN
        INSERT INTO cash_flow (tanggal, kategori, jenis, deskripsi, nominal, referensi_id, created_by)
        VALUES (v_tanggal, 'Penjualan Produk', 'Pemasukan', 'Pendapatan Penjualan', v_total, p_penjualan_id, p_user_id);
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
