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
    <div className="flex h-screen print:h-auto bg-background overflow-hidden print:overflow-visible">
      <Sidebar email={email} role={role} />
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden print:overflow-visible">
        <header className="h-14 border-b flex items-center justify-between px-4 lg:px-6 bg-card shrink-0 print:hidden">
          <div className="flex items-center gap-4">
            <h1 className="text-sm font-semibold hidden lg:block">Dashboard Admin</h1>
          </div>
          <div className="flex items-center gap-4">
            <ThemeToggle />
          </div>
        </header>
        <main className="flex-1 overflow-auto print:overflow-visible p-4 md:p-6 lg:p-8 bg-slate-50/50 dark:bg-slate-900/50 print:bg-white print:p-0">
          {children}
        </main>
      </div>
      <Toaster />
    </div>
  );
}
