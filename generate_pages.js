const fs = require('fs');
const path = require('path');

const routes = [
  'master/bahan-baku',
  'master/packaging',
  'master/produk',
  'transaksi/pembelian',
  'transaksi/penjualan',
  'hr/karyawan',
  'hr/rate-borongan',
  'hr/gaji',
  'keuangan/cash-flow',
  'keuangan/operasional',
  'laporan'
];

const basePath = path.join(__dirname, 'app', '(dashboard)');

routes.forEach(route => {
  const dir = path.join(basePath, route);
  fs.mkdirSync(dir, { recursive: true });
  
  const title = route.split('/').pop().replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
  
  const content = `import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function ${title.replace(/\s/g, '')}Page() {
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight text-primary">${title}</h2>
        <p className="text-muted-foreground mt-1">
          Manajemen ${title} Bolu Anisa.
        </p>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Daftar ${title}</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-sm">Modul sedang dalam tahap pengembangan berikutnya...</p>
        </CardContent>
      </Card>
    </div>
  );
}`;

  fs.writeFileSync(path.join(dir, 'page.tsx'), content);
});

// Create login page
const loginDir = path.join(__dirname, 'app', 'login');
fs.mkdirSync(loginDir, { recursive: true });
fs.writeFileSync(path.join(loginDir, 'page.tsx'), `export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50">
      <div className="p-8 bg-white border rounded-xl shadow-lg w-full max-w-sm">
        <h1 className="text-2xl font-bold text-center text-primary mb-6">Login Bolu Anisa</h1>
        <p className="text-center text-sm text-muted-foreground mb-4">Silakan login untuk mengakses sistem admin.</p>
        <div className="space-y-4">
          <input type="email" placeholder="Email" className="w-full flex h-10 px-3 py-2 border rounded-md border-input bg-background text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" />
          <input type="password" placeholder="Password" className="w-full flex h-10 px-3 py-2 border rounded-md border-input bg-background text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" />
          <button className="w-full inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">Masuk</button>
        </div>
      </div>
    </div>
  );
}`);
console.log('Done generating pages!');
