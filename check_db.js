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
  const res = await client.query(`
    SELECT pg_get_functiondef(p.oid)
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE p.proname = 'selesaikan_penjualan';
  `);
  console.log("selesaikan_penjualan:");
  if (res.rows.length > 0) {
    console.log(res.rows[0].pg_get_functiondef);
  }
  
  const res2 = await client.query(`
    SELECT pg_get_functiondef(p.oid)
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE p.proname = 'selesaikan_produksi';
  `);
  console.log("\nselesaikan_produksi:");
  if (res2.rows.length > 0) {
    console.log(res2.rows[0].pg_get_functiondef);
  }
  
  await client.end();
}

main().catch(console.error);
