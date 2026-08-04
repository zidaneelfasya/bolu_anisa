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

const client = new Client({
  connectionString: dbUrlMatch
});

async function main() {
  await client.connect();
  
  // 1. Reset negative stock to 0
  const res1 = await client.query(`UPDATE produk SET stok = 0 WHERE stok < 0 RETURNING id, nama`);
  console.log("Reset produk stock:", res1.rows.length);
  
  const res2 = await client.query(`UPDATE bahan_baku SET stok = 0 WHERE stok < 0 RETURNING id, nama`);
  console.log("Reset bahan_baku stock:", res2.rows.length);
  
  const res3 = await client.query(`UPDATE packaging SET stok = 0 WHERE stok < 0 RETURNING id, nama`);
  console.log("Reset packaging stock:", res3.rows.length);

  // 2. Add constraints
  try {
    await client.query(`ALTER TABLE produk ADD CONSTRAINT produk_stok_check CHECK (stok >= 0)`);
    console.log("Added CHECK (stok >= 0) to produk");
  } catch(e) { console.error("Error adding constraint to produk:", e.message) }

  try {
    await client.query(`ALTER TABLE bahan_baku ADD CONSTRAINT bahan_baku_stok_check CHECK (stok >= 0)`);
    console.log("Added CHECK (stok >= 0) to bahan_baku");
  } catch(e) { console.error("Error adding constraint to bahan_baku:", e.message) }

  try {
    await client.query(`ALTER TABLE packaging ADD CONSTRAINT packaging_stok_check CHECK (stok >= 0)`);
    console.log("Added CHECK (stok >= 0) to packaging");
  } catch(e) { console.error("Error adding constraint to packaging:", e.message) }
  
  await client.end();
}

main().catch(console.error);
