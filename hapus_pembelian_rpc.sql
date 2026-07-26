-- ========================================================================================= --
-- FUNGSI RPC: HAPUS PEMBELIAN
-- ========================================================================================= --
CREATE OR REPLACE FUNCTION hapus_pembelian(p_pembelian_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_bahan RECORD;
    v_pack RECORD;
    v_stok_sekarang NUMERIC;
BEGIN
    -- Pastikan pembelian ada
    IF NOT EXISTS (SELECT 1 FROM pembelian WHERE id = p_pembelian_id) THEN
        RAISE EXCEPTION 'Data pembelian tidak ditemukan.';
    END IF;

    -- A. PROSES REVERT BAHAN BAKU
    FOR v_bahan IN SELECT * FROM pembelian_bahan_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = v_bahan.bahan_id;
        
        -- Validasi agar stok tidak menjadi negatif
        IF v_stok_sekarang < v_bahan.jumlah THEN
            RAISE EXCEPTION 'Stok bahan baku (ID: %) saat ini lebih kecil dari jumlah yang akan dibatalkan. Penghapusan tidak dapat dilakukan karena bahan mungkin sudah digunakan.', v_bahan.bahan_id;
        END IF;

        -- Kembalikan (kurangi) Stok di Bahan Baku
        UPDATE bahan_baku 
        SET stok = stok - v_bahan.jumlah
        WHERE id = v_bahan.bahan_id;

        -- Catat Stock Movement sebagai pengeluaran / pembatalan
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Bahan Baku', v_bahan.bahan_id, 'Keluar', v_bahan.jumlah, v_stok_sekarang, v_stok_sekarang - v_bahan.jumlah, 'Hapus Pembelian ' || p_pembelian_id, 'Pembatalan transaksi pembelian', p_user_id);
    END LOOP;

    -- B. PROSES REVERT PACKAGING
    FOR v_pack IN SELECT * FROM pembelian_packaging_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = v_pack.packaging_id;
        
        -- Validasi agar stok tidak menjadi negatif
        IF v_stok_sekarang < v_pack.jumlah THEN
            RAISE EXCEPTION 'Stok packaging (ID: %) saat ini lebih kecil dari jumlah yang akan dibatalkan. Penghapusan tidak dapat dilakukan karena packaging mungkin sudah digunakan.', v_pack.packaging_id;
        END IF;

        -- Kembalikan (kurangi) Stok
        UPDATE packaging 
        SET stok = stok - v_pack.jumlah
        WHERE id = v_pack.packaging_id;

        -- Catat Stock Movement
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Packaging', v_pack.packaging_id, 'Keluar', v_pack.jumlah, v_stok_sekarang, v_stok_sekarang - v_pack.jumlah, 'Hapus Pembelian ' || p_pembelian_id, 'Pembatalan transaksi pembelian', p_user_id);
    END LOOP;

    -- C. HAPUS PENCATATAN CASH FLOW
    DELETE FROM cash_flow WHERE referensi_id = p_pembelian_id AND jenis = 'Pengeluaran';

    -- D. HAPUS DATA PEMBELIAN UTAMA
    -- (Tabel pembelian_bahan_detail dan pembelian_packaging_detail akan terhapus otomatis berkat ON DELETE CASCADE)
    DELETE FROM pembelian WHERE id = p_pembelian_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
