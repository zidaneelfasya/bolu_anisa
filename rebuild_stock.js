const { Client } = require('pg');
const fs = require('fs');

const env = fs.readFileSync('.env.local', 'utf8');
let dbUrlMatch = env.match(/DATABASE_URL="?([^"\n]+)"?/)[1];
const parts = dbUrlMatch.split('@');
if (parts.length === 2) {
  let [userPass, hostPort] = parts;
  const userPassParts = userPass.split(':');
  if (userPassParts.length >= 3) {
    let pass = userPassParts.slice(2).join(':');
    pass = pass.replace(/#/g, '%23');
    userPass = userPassParts[0] + ':' + userPassParts[1] + ':' + pass;
  }
  dbUrlMatch = userPass + '@' + hostPort;
}

const client = new Client({ connectionString: dbUrlMatch });

async function main() {
  await client.connect();

  console.log("Memulai Rebuild Stock Movements...");

  try {
    await client.query("BEGIN");
    
    // 1. Drop constraints
    console.log("Dropping constraints...");
    await client.query(`ALTER TABLE produk DROP CONSTRAINT IF EXISTS produk_stok_check`);
    await client.query(`ALTER TABLE bahan_baku DROP CONSTRAINT IF EXISTS bahan_baku_stok_check`);
    await client.query(`ALTER TABLE packaging DROP CONSTRAINT IF EXISTS packaging_stok_check`);

    // 2. Clear old data
    console.log("Clearing stock_movements and resetting stocks to 0...");
    await client.query(`DELETE FROM stock_movements`);
    await client.query(`UPDATE produk SET stok = 0`);
    await client.query(`UPDATE bahan_baku SET stok = 0`);
    await client.query(`UPDATE packaging SET stok = 0`);

    // 3. Fetch all transactions
    console.log("Fetching transactions...");
    
    // Penjualan (Hanya yang total > 0, karena jika 0 berarti rpc gagal/draf)
    const penjualanRes = await client.query(`
      SELECT pd.produk_id as barang_id, pd.jumlah, pd.penjualan_id as ref_id, p.created_at, p.updated_by as user_id 
      FROM penjualan_detail pd 
      JOIN penjualan p ON p.id = pd.penjualan_id 
      WHERE p.total > 0
    `);

    // Pembelian
    const pembelianBahan = await client.query(`
      SELECT pb.bahan_id as barang_id, pb.jumlah, pb.pembelian_id as ref_id, p.created_at, p.updated_by as user_id 
      FROM pembelian_bahan_detail pb JOIN pembelian p ON p.id = pb.pembelian_id WHERE p.total > 0
    `);
    const pembelianPack = await client.query(`
      SELECT pp.packaging_id as barang_id, pp.jumlah, pp.pembelian_id as ref_id, p.created_at, p.updated_by as user_id 
      FROM pembelian_packaging_detail pp JOIN pembelian p ON p.id = pp.pembelian_id WHERE p.total > 0
    `);
    const pembelianProduk = await client.query(`
      SELECT pp.produk_id as barang_id, pp.jumlah, pp.pembelian_id as ref_id, p.created_at, p.updated_by as user_id 
      FROM pembelian_produk_detail pp JOIN pembelian p ON p.id = pp.pembelian_id WHERE p.total > 0
    `);

    // Produksi (Hanya Selesai)
    const produksiBahan = await client.query(`
      SELECT pb.bahan_id as barang_id, pb.jumlah, pb.produksi_id as ref_id, p.created_at 
      FROM produksi_bahan pb JOIN produksi p ON p.id = pb.produksi_id WHERE p.status = 'Selesai'
    `);
    const produksiPack = await client.query(`
      SELECT pp.packaging_id as barang_id, pp.jumlah, pp.produksi_id as ref_id, p.created_at 
      FROM produksi_packaging pp JOIN produksi p ON p.id = pp.produksi_id WHERE p.status = 'Selesai'
    `);
    const produksiHasil = await client.query(`
      SELECT ph.produk_id as barang_id, ph.jumlah, ph.produksi_id as ref_id, p.created_at 
      FROM produksi_hasil ph JOIN produksi p ON p.id = ph.produksi_id WHERE p.status = 'Selesai'
    `);

    // Combine into events
    const events = [];
    
    // Penjualan
    penjualanRes.rows.forEach(r => events.push({ ...r, type: 'penjualan', table: 'produk', cat: 'Produk Jadi', jenis: 'Keluar', qty: -r.jumlah, ref_text: 'Penjualan ' + r.ref_id }));
    
    // Pembelian
    pembelianBahan.rows.forEach(r => events.push({ ...r, type: 'beli_bahan', table: 'bahan_baku', cat: 'Bahan Baku', jenis: 'Masuk', qty: r.jumlah, ref_text: 'Pembelian ' + r.ref_id }));
    pembelianPack.rows.forEach(r => events.push({ ...r, type: 'beli_pack', table: 'packaging', cat: 'Packaging', jenis: 'Masuk', qty: r.jumlah, ref_text: 'Pembelian ' + r.ref_id }));
    pembelianProduk.rows.forEach(r => events.push({ ...r, type: 'beli_produk', table: 'produk', cat: 'Produk Jadi', jenis: 'Masuk', qty: r.jumlah, ref_text: 'Pembelian ' + r.ref_id }));

    // Produksi
    produksiBahan.rows.forEach(r => events.push({ ...r, type: 'prod_bahan', table: 'bahan_baku', cat: 'Bahan Baku', jenis: 'Keluar', qty: -r.jumlah, ref_text: 'Produksi ' + r.ref_id }));
    produksiPack.rows.forEach(r => events.push({ ...r, type: 'prod_pack', table: 'packaging', cat: 'Packaging', jenis: 'Keluar', qty: -r.jumlah, ref_text: 'Produksi ' + r.ref_id }));
    produksiHasil.rows.forEach(r => events.push({ ...r, type: 'prod_hasil', table: 'produk', cat: 'Produk Jadi', jenis: 'Masuk', qty: r.jumlah, ref_text: 'Produksi ' + r.ref_id }));

    // Sort by created_at asc
    events.sort((a, b) => new Date(a.created_at) - new Date(b.created_at));
    
    console.log(`Found ${events.length} transactions to replay.`);

    let currentStock = new Map();

    for (let i = 0; i < events.length; i++) {
      const ev = events[i];
      const stokSebelum = parseFloat(currentStock.get(ev.barang_id) || 0);
      const qty = parseFloat(ev.qty);
      const stokSesudah = stokSebelum + qty;
      currentStock.set(ev.barang_id, stokSesudah);

      // We do real DB updates to keep everything in sync (if script crashes we see exactly where)
      await client.query(`UPDATE ${ev.table} SET stok = $1 WHERE id = $2`, [stokSesudah, ev.barang_id]);
      await client.query(`
        INSERT INTO stock_movements (tanggal, kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan, user_id, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      `, [ev.created_at, ev.cat, ev.barang_id, ev.jenis, Math.abs(ev.qty), stokSebelum, stokSesudah, ev.ref_text, 'Rebuild system', ev.user_id || null, ev.created_at]);
    }

    // 4. Reset negative stocks
    console.log("Checking for negative stocks at the end of history...");
    for (const [barangId, stok] of currentStock.entries()) {
      if (stok < 0) {
        // Find which table it belongs to
        let table = '', cat = '';
        const prodCheck = await client.query(`SELECT id FROM produk WHERE id = $1`, [barangId]);
        if (prodCheck.rows.length > 0) { table = 'produk'; cat = 'Produk Jadi'; }
        else {
          const bahanCheck = await client.query(`SELECT id FROM bahan_baku WHERE id = $1`, [barangId]);
          if (bahanCheck.rows.length > 0) { table = 'bahan_baku'; cat = 'Bahan Baku'; }
          else { table = 'packaging'; cat = 'Packaging'; }
        }

        console.log(`Fixing negative stock for ${barangId} in ${table} (was ${stok})`);
        
        await client.query(`UPDATE ${table} SET stok = 0 WHERE id = $1`, [barangId]);
        await client.query(`
          INSERT INTO stock_movements (kategori_barang, barang_id, jenis_pergerakan, jumlah, stok_sebelum, stok_sesudah, referensi, keterangan)
          VALUES ($1, $2, 'Penyesuaian', $3, $4, 0, 'Penyesuaian Sistem', 'Reset nilai minus dari history lama')
        `, [cat, barangId, Math.abs(stok), stok]);
      }
    }

    // 5. Re-add constraints
    console.log("Re-adding constraints...");
    await client.query(`ALTER TABLE produk ADD CONSTRAINT produk_stok_check CHECK (stok >= 0)`);
    await client.query(`ALTER TABLE bahan_baku ADD CONSTRAINT bahan_baku_stok_check CHECK (stok >= 0)`);
    await client.query(`ALTER TABLE packaging ADD CONSTRAINT packaging_stok_check CHECK (stok >= 0)`);

    await client.query("COMMIT");
    console.log("Rebuild Selesai!");

  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error during rebuild:", err);
  } finally {
    await client.end();
  }
}

main();
