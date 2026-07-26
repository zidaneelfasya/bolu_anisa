-- 1. Buat Tabel pembelian_produk_detail
CREATE TABLE IF NOT EXISTS pembelian_produk_detail (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    pembelian_id UUID REFERENCES pembelian(id) ON DELETE CASCADE,
    produk_id UUID REFERENCES produk(id) ON DELETE RESTRICT,
    jumlah INT NOT NULL CHECK (jumlah > 0),
    harga NUMERIC(15,2) NOT NULL CHECK (harga >= 0),
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. RLS Konfigurasi
ALTER TABLE pembelian_produk_detail ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow All Access" ON pembelian_produk_detail FOR ALL USING (true) WITH CHECK (true);

-- 3. Update Fungsi selesaikan_pembelian
CREATE OR REPLACE FUNCTION selesaikan_pembelian(p_pembelian_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_tanggal DATE;
    v_total NUMERIC = 0;
    v_bahan RECORD;
    v_pack RECORD;
    v_prod RECORD;
    v_stok_sekarang NUMERIC;
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

    -- C. PROSES PRODUK JADI
    FOR v_prod IN SELECT * FROM pembelian_produk_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = v_prod.produk_id;
        
        -- Update Stok dan HPP (timpa)
        UPDATE produk 
        SET stok = stok + v_prod.jumlah,
            hpp = v_prod.harga
        WHERE id = v_prod.produk_id;

        -- Catat Stock Movement
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Produk Jadi', v_prod.produk_id, 'Masuk', v_prod.jumlah, v_stok_sekarang, v_stok_sekarang + v_prod.jumlah, 'Pembelian ' || p_pembelian_id, p_user_id);
        
        v_total := v_total + v_prod.subtotal;
    END LOOP;

    -- D. UPDATE TOTAL PEMBELIAN
    UPDATE pembelian SET total = v_total, updated_by = p_user_id, updated_at = NOW() WHERE id = p_pembelian_id;

    -- E. CATAT KE CASH FLOW (Pengeluaran)
    IF v_total > 0 THEN
        INSERT INTO cash_flow (tanggal, kategori, jenis, deskripsi, nominal, referensi_id, created_by)
        VALUES (v_tanggal, 'Pembelian Barang', 'Pengeluaran', 'Pembelian Bahan, Packaging & Produk', v_total, p_pembelian_id, p_user_id);
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 4. Update Fungsi hapus_pembelian
CREATE OR REPLACE FUNCTION hapus_pembelian(p_pembelian_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_bahan RECORD;
    v_pack RECORD;
    v_prod RECORD;
    v_stok_sekarang NUMERIC;
BEGIN
    -- Pastikan pembelian ada
    IF NOT EXISTS (SELECT 1 FROM pembelian WHERE id = p_pembelian_id) THEN
        RAISE EXCEPTION 'Data pembelian tidak ditemukan.';
    END IF;

    -- A. PROSES REVERT BAHAN BAKU
    FOR v_bahan IN SELECT * FROM pembelian_bahan_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = v_bahan.bahan_id;
        
        IF v_stok_sekarang < v_bahan.jumlah THEN
            RAISE EXCEPTION 'Stok bahan baku (ID: %) saat ini lebih kecil dari jumlah yang akan dibatalkan.', v_bahan.bahan_id;
        END IF;

        UPDATE bahan_baku SET stok = stok - v_bahan.jumlah WHERE id = v_bahan.bahan_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Bahan Baku', v_bahan.bahan_id, 'Keluar', v_bahan.jumlah, v_stok_sekarang, v_stok_sekarang - v_bahan.jumlah, 'Hapus Pembelian ' || p_pembelian_id, 'Pembatalan transaksi pembelian', p_user_id);
    END LOOP;

    -- B. PROSES REVERT PACKAGING
    FOR v_pack IN SELECT * FROM pembelian_packaging_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = v_pack.packaging_id;
        
        IF v_stok_sekarang < v_pack.jumlah THEN
            RAISE EXCEPTION 'Stok packaging (ID: %) saat ini lebih kecil dari jumlah yang akan dibatalkan.', v_pack.packaging_id;
        END IF;

        UPDATE packaging SET stok = stok - v_pack.jumlah WHERE id = v_pack.packaging_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Packaging', v_pack.packaging_id, 'Keluar', v_pack.jumlah, v_stok_sekarang, v_stok_sekarang - v_pack.jumlah, 'Hapus Pembelian ' || p_pembelian_id, 'Pembatalan transaksi pembelian', p_user_id);
    END LOOP;

    -- C. PROSES REVERT PRODUK JADI
    FOR v_prod IN SELECT * FROM pembelian_produk_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = v_prod.produk_id;
        
        IF v_stok_sekarang < v_prod.jumlah THEN
            RAISE EXCEPTION 'Stok produk jadi (ID: %) saat ini lebih kecil dari jumlah yang akan dibatalkan.', v_prod.produk_id;
        END IF;

        UPDATE produk SET stok = stok - v_prod.jumlah WHERE id = v_prod.produk_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Produk Jadi', v_prod.produk_id, 'Keluar', v_prod.jumlah, v_stok_sekarang, v_stok_sekarang - v_prod.jumlah, 'Hapus Pembelian ' || p_pembelian_id, 'Pembatalan transaksi pembelian', p_user_id);
    END LOOP;

    -- D. HAPUS PENCATATAN CASH FLOW
    DELETE FROM cash_flow WHERE referensi_id = p_pembelian_id AND jenis = 'Pengeluaran';

    -- E. HAPUS DATA PEMBELIAN UTAMA
    DELETE FROM pembelian WHERE id = p_pembelian_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
