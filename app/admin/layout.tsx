import { Toaster } from "@/components/ui/sonner";
import { createClient } from "@/utils/supabase/server";
import { AppLayout } from "@/components/app-layout";

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
    <>
      <AppLayout title="Dashboard Admin" email={email} role={role}>
        {children}
      </AppLayout>
      <Toaster />
    </>
  );
}
