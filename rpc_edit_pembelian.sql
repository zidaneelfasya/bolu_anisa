-- ========================================================================================= --
-- FUNGSI RPC: EDIT PEMBELIAN (PENYESUAIAN STOK YANG AMAN)
-- ========================================================================================= --
CREATE OR REPLACE FUNCTION edit_pembelian(
    p_pembelian_id UUID,
    p_tanggal DATE,
    p_supplier VARCHAR,
    p_bahan JSONB,
    p_pack JSONB,
    p_produk JSONB,
    p_user_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
    v_total NUMERIC = 0;
    v_bahan_item RECORD;
    v_pack_item RECORD;
    v_prod_item RECORD;
    v_stok_sekarang NUMERIC;
    
    -- Variables for JSON parsing
    v_item JSONB;
BEGIN
    -- Pastikan pembelian ada
    IF NOT EXISTS (SELECT 1 FROM pembelian WHERE id = p_pembelian_id) THEN
        RAISE EXCEPTION 'Data pembelian tidak ditemukan.';
    END IF;

    -- =========================================================================
    -- FASE 1: TAMBAHKAN STOK BARU (Mensimulasikan pembelian baru)
    -- Ini dilakukan lebih dulu untuk mencegah error constraint stok < 0 sementara
    -- =========================================================================

    -- A1. PROSES BAHAN BAKU BARU
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_bahan) LOOP
        -- Pastikan jumlah dan harga valid (tidak null, >= 0)
        IF (v_item->>'jumlah')::NUMERIC <= 0 THEN CONTINUE; END IF;
        
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = (v_item->>'id')::UUID;
        
        -- Update Stok dan Harga Terakhir di Bahan Baku
        UPDATE bahan_baku 
        SET stok = stok + (v_item->>'jumlah')::NUMERIC,
            harga_terakhir = (v_item->>'harga')::NUMERIC,
            harga_rata_rata = CASE 
                WHEN stok = 0 THEN (v_item->>'harga')::NUMERIC 
                ELSE (harga_rata_rata + (v_item->>'harga')::NUMERIC) / 2 
            END
        WHERE id = (v_item->>'id')::UUID;

        -- Catat Stock Movement (Masuk - Baru)
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Bahan Baku', (v_item->>'id')::UUID, 'Masuk', (v_item->>'jumlah')::NUMERIC, v_stok_sekarang, v_stok_sekarang + (v_item->>'jumlah')::NUMERIC, 'Pembelian ' || p_pembelian_id, 'Penyesuaian Edit Pembelian (Baru)', p_user_id);
        
        v_total := v_total + ((v_item->>'jumlah')::NUMERIC * (v_item->>'harga')::NUMERIC);
    END LOOP;

    -- B1. PROSES PACKAGING BARU
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_pack) LOOP
        IF (v_item->>'jumlah')::NUMERIC <= 0 THEN CONTINUE; END IF;
        
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = (v_item->>'id')::UUID;
        
        -- Update Stok dan Harga Terakhir
        UPDATE packaging 
        SET stok = stok + (v_item->>'jumlah')::NUMERIC,
            harga_per_pcs = (v_item->>'harga')::NUMERIC
        WHERE id = (v_item->>'id')::UUID;

        -- Catat Stock Movement (Masuk - Baru)
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Packaging', (v_item->>'id')::UUID, 'Masuk', (v_item->>'jumlah')::NUMERIC, v_stok_sekarang, v_stok_sekarang + (v_item->>'jumlah')::NUMERIC, 'Pembelian ' || p_pembelian_id, 'Penyesuaian Edit Pembelian (Baru)', p_user_id);
        
        v_total := v_total + ((v_item->>'jumlah')::NUMERIC * (v_item->>'harga')::NUMERIC);
    END LOOP;

    -- C1. PROSES PRODUK JADI BARU
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_produk) LOOP
        IF (v_item->>'jumlah')::NUMERIC <= 0 THEN CONTINUE; END IF;
        
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = (v_item->>'id')::UUID;
        
        -- Update Stok dan HPP
        UPDATE produk 
        SET stok = stok + (v_item->>'jumlah')::NUMERIC,
            hpp = (v_item->>'harga')::NUMERIC
        WHERE id = (v_item->>'id')::UUID;

        -- Catat Stock Movement (Masuk - Baru)
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Produk Jadi', (v_item->>'id')::UUID, 'Masuk', (v_item->>'jumlah')::NUMERIC, v_stok_sekarang, v_stok_sekarang + (v_item->>'jumlah')::NUMERIC, 'Pembelian ' || p_pembelian_id, 'Penyesuaian Edit Pembelian (Baru)', p_user_id);
        
        v_total := v_total + ((v_item->>'jumlah')::NUMERIC * (v_item->>'harga')::NUMERIC);
    END LOOP;


    -- =========================================================================
    -- FASE 2: KURANGI STOK LAMA (Mensimulasikan penghapusan pembelian lama)
    -- Jika stok akhir < 0, fungsi akan otomatis gagal berkat constraint CHECK (stok >= 0)
    -- =========================================================================

    -- A2. PROSES REVERT BAHAN BAKU LAMA
    FOR v_bahan_item IN SELECT * FROM pembelian_bahan_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = v_bahan_item.bahan_id;
        
        UPDATE bahan_baku SET stok = stok - v_bahan_item.jumlah WHERE id = v_bahan_item.bahan_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Bahan Baku', v_bahan_item.bahan_id, 'Keluar', v_bahan_item.jumlah, v_stok_sekarang, v_stok_sekarang - v_bahan_item.jumlah, 'Pembelian ' || p_pembelian_id, 'Penyesuaian Edit Pembelian (Lama)', p_user_id);
    END LOOP;

    -- B2. PROSES REVERT PACKAGING LAMA
    FOR v_pack_item IN SELECT * FROM pembelian_packaging_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = v_pack_item.packaging_id;
        
        UPDATE packaging SET stok = stok - v_pack_item.jumlah WHERE id = v_pack_item.packaging_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Packaging', v_pack_item.packaging_id, 'Keluar', v_pack_item.jumlah, v_stok_sekarang, v_stok_sekarang - v_pack_item.jumlah, 'Pembelian ' || p_pembelian_id, 'Penyesuaian Edit Pembelian (Lama)', p_user_id);
    END LOOP;

    -- C2. PROSES REVERT PRODUK JADI LAMA
    FOR v_prod_item IN SELECT * FROM pembelian_produk_detail WHERE pembelian_id = p_pembelian_id LOOP
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = v_prod_item.produk_id;
        
        UPDATE produk SET stok = stok - v_prod_item.jumlah WHERE id = v_prod_item.produk_id;

        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id)
        VALUES ('Produk Jadi', v_prod_item.produk_id, 'Keluar', v_prod_item.jumlah, v_stok_sekarang, v_stok_sekarang - v_prod_item.jumlah, 'Pembelian ' || p_pembelian_id, 'Penyesuaian Edit Pembelian (Lama)', p_user_id);
    END LOOP;


    -- =========================================================================
    -- FASE 3: PERBARUI TABEL DETAIL DAN UTAMA
    -- =========================================================================

    -- Hapus detail lama
    DELETE FROM pembelian_bahan_detail WHERE pembelian_id = p_pembelian_id;
    DELETE FROM pembelian_packaging_detail WHERE pembelian_id = p_pembelian_id;
    DELETE FROM pembelian_produk_detail WHERE pembelian_id = p_pembelian_id;

    -- Masukkan detail baru
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_bahan) LOOP
        IF (v_item->>'jumlah')::NUMERIC > 0 THEN
            INSERT INTO pembelian_bahan_detail (pembelian_id, bahan_id, jumlah, harga, subtotal)
            VALUES (p_pembelian_id, (v_item->>'id')::UUID, (v_item->>'jumlah')::NUMERIC, (v_item->>'harga')::NUMERIC, (v_item->>'jumlah')::NUMERIC * (v_item->>'harga')::NUMERIC);
        END IF;
    END LOOP;

    FOR v_item IN SELECT * FROM jsonb_array_elements(p_pack) LOOP
        IF (v_item->>'jumlah')::NUMERIC > 0 THEN
            INSERT INTO pembelian_packaging_detail (pembelian_id, packaging_id, jumlah, harga, subtotal)
            VALUES (p_pembelian_id, (v_item->>'id')::UUID, (v_item->>'jumlah')::NUMERIC, (v_item->>'harga')::NUMERIC, (v_item->>'jumlah')::NUMERIC * (v_item->>'harga')::NUMERIC);
        END IF;
    END LOOP;

    FOR v_item IN SELECT * FROM jsonb_array_elements(p_produk) LOOP
        IF (v_item->>'jumlah')::NUMERIC > 0 THEN
            INSERT INTO pembelian_produk_detail (pembelian_id, produk_id, jumlah, harga, subtotal)
            VALUES (p_pembelian_id, (v_item->>'id')::UUID, (v_item->>'jumlah')::NUMERIC, (v_item->>'harga')::NUMERIC, (v_item->>'jumlah')::NUMERIC * (v_item->>'harga')::NUMERIC);
        END IF;
    END LOOP;

    -- Perbarui Pembelian Utama
    UPDATE pembelian 
    SET tanggal = p_tanggal, 
        supplier = p_supplier, 
        total = v_total, 
        updated_by = p_user_id, 
        updated_at = NOW() 
    WHERE id = p_pembelian_id;

    -- Perbarui Cash Flow
    -- Hapus yang lama, insert yang baru.
    DELETE FROM cash_flow WHERE referensi_id = p_pembelian_id AND jenis = 'Pengeluaran';
    
    IF v_total > 0 THEN
        INSERT INTO cash_flow (tanggal, kategori, jenis, deskripsi, nominal, referensi_id, created_by)
        VALUES (p_tanggal, 'Pembelian Barang', 'Pengeluaran', 'Pembelian Bahan & Packaging (Edit)', v_total, p_pembelian_id, p_user_id);
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
