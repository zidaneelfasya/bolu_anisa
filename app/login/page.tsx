export default function LoginPage() {
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
}