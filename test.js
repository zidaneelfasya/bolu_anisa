const fs = require('fs');
const env = fs.readFileSync('.env.local', 'utf8');
const urlMatch = env.match(/NEXT_PUBLIC_SUPABASE_URL=(.*)/);
const keyMatch = env.match(/NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=(.*)/);

if (!urlMatch || !keyMatch) {
  console.log("No env");
  process.exit(1);
}

const url = urlMatch[1].trim();
const key = keyMatch[1].trim();

fetch(`${url}/rest/v1/bahan_baku?select=*`, {
  headers: {
    apikey: key,
    Authorization: `Bearer ${key}`
  }
})
.then(r => r.json())
.then(console.log)
.catch(console.error);
