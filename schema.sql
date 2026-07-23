-- Hapus tabel jika sudah ada (opsional, untuk reset saat testing)
DROP TABLE IF EXISTS stock_movements, biaya_operasional, cash_flow, gaji_harian, rate_borongan, karyawan, penjualan_detail, penjualan, produksi_hasil, produksi_packaging, produksi_bahan, produksi, pembelian_packaging_detail, pembelian_bahan_detail, pembelian, produk, packaging, bahan_baku CASCADE;

-- ENUMS (Tipe Data Opsional agar lebih ketat, atau gunakan VARCHAR CHECK)
-- CREATE TYPE status_produksi AS ENUM ('Draft', 'Sedang Diproses', 'Selesai', 'Batal');
-- CREATE TYPE jenis_pergerakan AS ENUM ('Masuk', 'Keluar', 'Penyesuaian');
-- CREATE TYPE kategori_barang AS ENUM ('Bahan Baku', 'Packaging', 'Produk Jadi');

-- Tabel Master
CREATE TABLE bahan_baku (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    kategori VARCHAR(100),
    satuan VARCHAR(50) NOT NULL,
    stok NUMERIC(10,2) DEFAULT 0 CHECK (stok >= 0),
    minimum_stok NUMERIC(10,2) DEFAULT 0,
    harga_terakhir NUMERIC(15,2) DEFAULT 0,
    harga_rata_rata NUMERIC(15,2) DEFAULT 0,
    supplier VARCHAR(255),
    keterangan TEXT,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE packaging (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    jenis VARCHAR(100),
    harga_per_pcs NUMERIC(10,2) DEFAULT 0,
    stok INT DEFAULT 0 CHECK (stok >= 0),
    minimum_stok INT DEFAULT 0,
    keterangan TEXT,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE produk (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    kategori VARCHAR(100),
    harga_jual NUMERIC(15,2) DEFAULT 0,
    hpp NUMERIC(15,2) DEFAULT 0,
    berat VARCHAR(50),
    status_aktif BOOLEAN DEFAULT true,
    foto VARCHAR(255),
    keterangan TEXT,
    stok INT DEFAULT 0 CHECK (stok >= 0),
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Audit Trail: Stock Movements
CREATE TABLE stock_movements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    kategori_barang VARCHAR(50) CHECK (kategori_barang IN ('Bahan Baku', 'Packaging', 'Produk Jadi')),
    barang_id UUID NOT NULL,
    jenis_pergerakan VARCHAR(50) CHECK (jenis_pergerakan IN ('Masuk', 'Keluar', 'Penyesuaian')),
    jumlah NUMERIC(10,2) NOT NULL,
    stok_sebelum NUMERIC(10,2) NOT NULL,
    stok_sesudah NUMERIC(10,2) NOT NULL,
    referensi VARCHAR(255), -- Contoh: "PRD-20260721-0001" atau "Pembelian #INV-001"
    keterangan TEXT,
    user_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transaksi Pembelian Bahan & Packaging
CREATE TABLE pembelian (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal DATE NOT NULL,
    supplier VARCHAR(255),
    total NUMERIC(15,2) DEFAULT 0,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE pembelian_bahan_detail (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    pembelian_id UUID REFERENCES pembelian(id) ON DELETE CASCADE,
    bahan_id UUID REFERENCES bahan_baku(id) ON DELETE RESTRICT,
    jumlah NUMERIC(10,2) NOT NULL CHECK (jumlah > 0),
    harga NUMERIC(15,2) NOT NULL CHECK (harga >= 0),
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE pembelian_packaging_detail (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    pembelian_id UUID REFERENCES pembelian(id) ON DELETE CASCADE,
    packaging_id UUID REFERENCES packaging(id) ON DELETE RESTRICT,
    jumlah INT NOT NULL CHECK (jumlah > 0),
    harga NUMERIC(15,2) NOT NULL CHECK (harga >= 0),
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- HR & Penggajian (Diperlukan oleh Modul Produksi)
CREATE TABLE karyawan (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    nomor_hp VARCHAR(50),
    alamat TEXT,
    status VARCHAR(50) DEFAULT 'Aktif',
    keterangan TEXT,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE rate_borongan (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    jenis VARCHAR(50) CHECK (jenis IN ('Produksi', 'Packaging')),
    rate NUMERIC(15,2) NOT NULL CHECK (rate >= 0),
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE gaji_harian (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal DATE NOT NULL,
    karyawan_id UUID REFERENCES karyawan(id) ON DELETE RESTRICT,
    jenis_gaji VARCHAR(50) CHECK (jenis_gaji IN ('Harian', 'Borongan Produksi', 'Borongan Packaging')),
    nominal NUMERIC(15,2) NOT NULL CHECK (nominal >= 0),
    referensi_id UUID, -- ID Produksi jika dari modul produksi
    keterangan TEXT,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Transaksi Produksi Terpusat (Inti)
CREATE TABLE produksi (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nomor_produksi VARCHAR(50) UNIQUE NOT NULL,
    tanggal_produksi DATE NOT NULL,
    shift VARCHAR(50),
    pic_produksi VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Draft' CHECK (status IN ('Draft', 'Sedang Diproses', 'Selesai', 'Dibatalkan')),
    keterangan TEXT,
    
    total_biaya_bahan NUMERIC(15,2) DEFAULT 0,
    total_biaya_packaging NUMERIC(15,2) DEFAULT 0,
    total_gaji_produksi NUMERIC(15,2) DEFAULT 0,
    total_gaji_packaging NUMERIC(15,2) DEFAULT 0,
    grand_total_biaya NUMERIC(15,2) DEFAULT 0,
    estimasi_hpp NUMERIC(15,2) DEFAULT 0,
    
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Produksi Step 1: Bahan Baku
CREATE TABLE produksi_bahan (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    produksi_id UUID REFERENCES produksi(id) ON DELETE CASCADE,
    bahan_id UUID REFERENCES bahan_baku(id) ON DELETE RESTRICT,
    jumlah NUMERIC(10,2) NOT NULL CHECK (jumlah > 0),
    harga_satuan NUMERIC(15,2) NOT NULL,
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Produksi Step 2: Packaging
CREATE TABLE produksi_packaging (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    produksi_id UUID REFERENCES produksi(id) ON DELETE CASCADE,
    packaging_id UUID REFERENCES packaging(id) ON DELETE RESTRICT,
    jumlah INT NOT NULL CHECK (jumlah > 0),
    harga_satuan NUMERIC(15,2) NOT NULL,
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Produksi Step 3: Hasil
CREATE TABLE produksi_hasil (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    produksi_id UUID REFERENCES produksi(id) ON DELETE CASCADE,
    produk_id UUID REFERENCES produk(id) ON DELETE RESTRICT,
    jumlah INT NOT NULL CHECK (jumlah > 0),
    catatan TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Produksi Step 4 & 5 (Tenaga Kerja tersimpan di gaji_harian dengan referensi_id ke produksi.id)

-- Keuangan & Cash Flow
CREATE TABLE cash_flow (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal DATE NOT NULL,
    kategori VARCHAR(100) NOT NULL,
    jenis VARCHAR(50) CHECK (jenis IN ('Pemasukan', 'Pengeluaran')),
    deskripsi TEXT,
    nominal NUMERIC(15,2) NOT NULL CHECK (nominal >= 0),
    referensi_id UUID,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE biaya_operasional (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal DATE NOT NULL,
    kategori VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    nominal NUMERIC(15,2) NOT NULL CHECK (nominal >= 0),
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Transaksi Penjualan
CREATE TABLE penjualan (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tanggal DATE NOT NULL,
    keterangan TEXT,
    total NUMERIC(15,2) DEFAULT 0,
    created_by UUID,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE penjualan_detail (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    penjualan_id UUID REFERENCES penjualan(id) ON DELETE CASCADE,
    produk_id UUID REFERENCES produk(id) ON DELETE RESTRICT,
    jumlah INT NOT NULL CHECK (jumlah > 0),
    harga NUMERIC(15,2) NOT NULL CHECK (harga >= 0),
    subtotal NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- ========================================================================================= --
-- DATABASE FUNCTIONS (RPC) & TRIGGERS
-- ========================================================================================= --

-- Fungsi untuk menyelesaikan produksi secara aman dalam 1 transaksi
CREATE OR REPLACE FUNCTION selesaikan_produksi(p_produksi_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_status VARCHAR;
    v_nomor VARCHAR;
    v_tanggal DATE;
    v_bahan RECORD;
    v_pack RECORD;
    v_hasil RECORD;
    v_gaji RECORD;
    v_stok_sekarang NUMERIC;
    v_biaya_bahan NUMERIC = 0;
    v_biaya_packaging NUMERIC = 0;
    v_gaji_produksi NUMERIC = 0;
    v_gaji_packaging NUMERIC = 0;
BEGIN
    -- Ambil info produksi
    SELECT status, nomor_produksi, tanggal_produksi 
    INTO v_status, v_nomor, v_tanggal 
    FROM produksi WHERE id = p_produksi_id;

    IF v_status = 'Selesai' THEN
        RAISE EXCEPTION 'Produksi ini sudah diselesaikan!';
    END IF;

    -- 1. PROSES BAHAN BAKU
    FOR v_bahan IN SELECT * FROM produksi_bahan WHERE produksi_id = p_produksi_id LOOP
        SELECT stok INTO v_stok_sekarang FROM bahan_baku WHERE id = v_bahan.bahan_id;
        IF v_stok_sekarang < v_bahan.jumlah THEN
            RAISE EXCEPTION 'Stok bahan baku tidak mencukupi untuk bahan ID %', v_bahan.bahan_id;
        END IF;

        UPDATE bahan_baku SET stok = stok - v_bahan.jumlah WHERE id = v_bahan.bahan_id;
        
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Bahan Baku', v_bahan.bahan_id, 'Keluar', v_bahan.jumlah, v_stok_sekarang, v_stok_sekarang - v_bahan.jumlah, 'Produksi ' || v_nomor, p_user_id);
        
        v_biaya_bahan := v_biaya_bahan + v_bahan.subtotal;
    END LOOP;

    -- 2. PROSES PACKAGING
    FOR v_pack IN SELECT * FROM produksi_packaging WHERE produksi_id = p_produksi_id LOOP
        SELECT stok INTO v_stok_sekarang FROM packaging WHERE id = v_pack.packaging_id;
        IF v_stok_sekarang < v_pack.jumlah THEN
            RAISE EXCEPTION 'Stok packaging tidak mencukupi untuk packaging ID %', v_pack.packaging_id;
        END IF;

        UPDATE packaging SET stok = stok - v_pack.jumlah WHERE id = v_pack.packaging_id;
        
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Packaging', v_pack.packaging_id, 'Keluar', v_pack.jumlah, v_stok_sekarang, v_stok_sekarang - v_pack.jumlah, 'Produksi ' || v_nomor, p_user_id);
        
        v_biaya_packaging := v_biaya_packaging + v_pack.subtotal;
    END LOOP;

    -- 3. PROSES HASIL PRODUK JADI
    FOR v_hasil IN SELECT * FROM produksi_hasil WHERE produksi_id = p_produksi_id LOOP
        SELECT stok INTO v_stok_sekarang FROM produk WHERE id = v_hasil.produk_id;
        
        UPDATE produk SET stok = stok + v_hasil.jumlah WHERE id = v_hasil.produk_id;
        
        INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, user_id)
        VALUES ('Produk Jadi', v_hasil.produk_id, 'Masuk', v_hasil.jumlah, v_stok_sekarang, v_stok_sekarang + v_hasil.jumlah, 'Produksi ' || v_nomor, p_user_id);
    END LOOP;

    -- 4. PENGGAJIAN (Hitung dari gaji_harian yang referensinya ke produksi ini)
    SELECT COALESCE(SUM(nominal), 0) INTO v_gaji_produksi FROM gaji_harian WHERE referensi_id = p_produksi_id AND jenis_gaji = 'Borongan Produksi';
    SELECT COALESCE(SUM(nominal), 0) INTO v_gaji_packaging FROM gaji_harian WHERE referensi_id = p_produksi_id AND jenis_gaji = 'Borongan Packaging';

    -- 5. UPDATE CASH FLOW (Catat Biaya Produksi Gaji saja sebagai pengeluaran tunai)
    -- Catatan: Bahan dan Packaging sudah dibayar saat pembelian, jadi di sini murni HPP (Harga Pokok Produksi).
    IF (v_gaji_produksi + v_gaji_packaging) > 0 THEN
        INSERT INTO cash_flow (tanggal, kategori, jenis, deskripsi, nominal, referensi_id, created_by)
        VALUES (v_tanggal, 'Biaya Gaji Produksi', 'Pengeluaran', 'Gaji Borongan ' || v_nomor, (v_gaji_produksi + v_gaji_packaging), p_produksi_id, p_user_id);
    END IF;

    -- 6. UPDATE STATUS PRODUKSI
    UPDATE produksi 
    SET status = 'Selesai', 
        updated_at = NOW(),
        updated_by = p_user_id,
        total_biaya_bahan = v_biaya_bahan,
        total_biaya_packaging = v_biaya_packaging,
        total_gaji_produksi = v_gaji_produksi,
        total_gaji_packaging = v_gaji_packaging,
        grand_total_biaya = (v_biaya_bahan + v_biaya_packaging + v_gaji_produksi + v_gaji_packaging)
    WHERE id = p_produksi_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- ========================================================================================= --
-- FUNGSI RPC: SELESAIKAN PEMBELIAN
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
-- FUNGSI RPC: SELESAIKAN PENJUALAN
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

-- ========================================================================================= --
-- KONFIGURASI ROW LEVEL SECURITY (RLS)
-- Mengaktifkan RLS namun memberikan akses penuh sementara (Allow All)
-- Agar aplikasi tetap berfungsi tanpa mematikan fitur keamanan bawaan Supabase.
-- Nanti saat fitur Login selesai, policy ini bisa diganti menjadi (auth.uid() = user_id).
-- ========================================================================================= --

-- 1. Mengaktifkan RLS di semua tabel
ALTER TABLE bahan_baku ENABLE ROW LEVEL SECURITY;
ALTER TABLE packaging ENABLE ROW LEVEL SECURITY;
ALTER TABLE produk ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE pembelian ENABLE ROW LEVEL SECURITY;
ALTER TABLE pembelian_bahan_detail ENABLE ROW LEVEL SECURITY;
ALTER TABLE pembelian_packaging_detail ENABLE ROW LEVEL SECURITY;
ALTER TABLE karyawan ENABLE ROW LEVEL SECURITY;
ALTER TABLE rate_borongan ENABLE ROW LEVEL SECURITY;
ALTER TABLE gaji_harian ENABLE ROW LEVEL SECURITY;
ALTER TABLE produksi ENABLE ROW LEVEL SECURITY;
ALTER TABLE produksi_bahan ENABLE ROW LEVEL SECURITY;
ALTER TABLE produksi_packaging ENABLE ROW LEVEL SECURITY;
ALTER TABLE produksi_hasil ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_flow ENABLE ROW LEVEL SECURITY;
ALTER TABLE biaya_operasional ENABLE ROW LEVEL SECURITY;
ALTER TABLE penjualan ENABLE ROW LEVEL SECURITY;
ALTER TABLE penjualan_detail ENABLE ROW LEVEL SECURITY;

-- 2. Membuat Policy (Izin Akses Penuh) untuk setiap tabel
CREATE POLICY "Allow All Access" ON bahan_baku FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON packaging FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON produk FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON stock_movements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON pembelian FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON pembelian_bahan_detail FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON pembelian_packaging_detail FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON karyawan FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON rate_borongan FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON gaji_harian FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON produksi FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON produksi_bahan FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON produksi_packaging FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON produksi_hasil FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON cash_flow FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON biaya_operasional FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON penjualan FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow All Access" ON penjualan_detail FOR ALL USING (true) WITH CHECK (true);
