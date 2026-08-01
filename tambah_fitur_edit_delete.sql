-- FUNGSI RPC: HAPUS PRODUKSI
CREATE OR REPLACE FUNCTION hapus_produksi(p_produksi_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_status VARCHAR;
    v_nomor VARCHAR;
    v_bahan RECORD;
    v_pack RECORD;
    v_hasil RECORD;
    v_stok_sekarang NUMERIC;
BEGIN
    -- Pastikan produksi ada
    SELECT status, nomor_produksi INTO v_status, v_nomor FROM produksi WHERE id = p_produksi_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Data produksi tidak ditemukan.';
    END IF;

    -- A. PROSES REVERT BAHAN BAKU (Kembalikan stok)
    FOR v_bahan IN SELECT * FROM produksi_bahan WHERE produksi_id = p_produksi_id LOOP
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = v_bahan.bahan_id;
        
        UPDATE bahan_baku SET stok = stok + v_bahan.jumlah WHERE id = v_bahan.bahan_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Bahan Baku', v_bahan.bahan_id, 'Masuk', v_bahan.jumlah, v_stok_sekarang, v_stok_sekarang + v_bahan.jumlah, 'Hapus Produksi ' || v_nomor, 'Pembatalan transaksi produksi', p_user_id);
    END LOOP;

    -- B. PROSES REVERT PACKAGING (Kembalikan stok)
    FOR v_pack IN SELECT * FROM produksi_packaging WHERE produksi_id = p_produksi_id LOOP
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = v_pack.packaging_id;
        
        UPDATE packaging SET stok = stok + v_pack.jumlah WHERE id = v_pack.packaging_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Packaging', v_pack.packaging_id, 'Masuk', v_pack.jumlah, v_stok_sekarang, v_stok_sekarang + v_pack.jumlah, 'Hapus Produksi ' || v_nomor, 'Pembatalan transaksi produksi', p_user_id);
    END LOOP;

    -- C. PROSES REVERT PRODUK JADI (Tarik stok)
    FOR v_hasil IN SELECT * FROM produksi_hasil WHERE produksi_id = p_produksi_id LOOP
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = v_hasil.produk_id;
        

        UPDATE produk SET stok = stok - v_hasil.jumlah WHERE id = v_hasil.produk_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Produk Jadi', v_hasil.produk_id, 'Keluar', v_hasil.jumlah, v_stok_sekarang, v_stok_sekarang - v_hasil.jumlah, 'Hapus Produksi ' || v_nomor, 'Pembatalan transaksi produksi', p_user_id);
    END LOOP;

    -- D. HAPUS PENCATATAN CASH FLOW
    DELETE FROM cash_flow WHERE referensi_id = p_produksi_id AND jenis = 'Pengeluaran';

    -- E. HAPUS PENCATATAN GAJI HARIAN
    DELETE FROM gaji_harian WHERE referensi_id = p_produksi_id;

    -- F. HAPUS DATA PRODUKSI UTAMA 
    -- (produksi_bahan, produksi_packaging, produksi_hasil otomatis terhapus karena ON DELETE CASCADE di schema)
    DELETE FROM produksi WHERE id = p_produksi_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
