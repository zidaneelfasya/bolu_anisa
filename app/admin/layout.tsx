import { Sidebar } from "@/components/sidebar";
import { Toaster } from "@/components/ui/sonner";
import { ThemeToggle } from "@/components/theme-toggle";
import { createClient } from "@/utils/supabase/server";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  
  const email = user?.email;
  const role = user?.user_metadata?.role || 'kasir';

  return (
    <div className="flex h-screen bg-background overflow-hidden">
      <Sidebar email={email} role={role} />
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <header className="h-14 border-b flex items-center justify-between px-4 lg:px-6 bg-card shrink-0">
          <div className="flex items-center gap-4">
            <h1 className="text-sm font-semibold hidden lg:block">Dashboard Admin</h1>
          </div>
          <div className="flex items-center gap-4">
            <ThemeToggle />
          </div>
        </header>
        <main className="flex-1 overflow-auto p-4 md:p-6 lg:p-8 bg-slate-50/50 dark:bg-slate-900/50">
          {children}
        </main>
      </div>
      <Toaster />
    </div>
  );
}
