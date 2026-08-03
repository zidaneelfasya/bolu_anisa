"use client";

import { useState, useEffect } from "react";
import { Menu, PanelLeftClose, PanelLeftOpen } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetTrigger, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { ThemeToggle } from "@/components/theme-toggle";
import { Sidebar } from "@/components/sidebar";
import { cn } from "@/lib/utils";

export function AppLayout({
  children,
  title,
  email,
  role
}: {
  children: React.ReactNode;
  title: string;
  email?: string;
  role?: string;
}) {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <div className="flex h-screen bg-background overflow-hidden print:h-auto print:overflow-visible">
      {/* Desktop Sidebar */}
      <div 
        className={cn(
          "hidden md:flex h-full flex-col border-r bg-card transition-all duration-300 print:hidden shrink-0",
          isCollapsed ? "w-20" : "w-64"
        )}
      >
        <Sidebar email={email} role={role} isCollapsed={isCollapsed} />
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden print:overflow-visible">
        <header className="h-14 border-b flex items-center justify-between px-4 lg:px-6 bg-card shrink-0 print:hidden">
          <div className="flex items-center gap-2">
            {/* Mobile Sidebar Trigger */}
            <Sheet open={isMobileOpen} onOpenChange={setIsMobileOpen}>
              <SheetTrigger asChild>
                <Button variant="ghost" size="icon" className="md:hidden">
                  <Menu className="h-5 w-5" />
                  <span className="sr-only">Toggle Sidebar</span>
                </Button>
              </SheetTrigger>
              <SheetContent side="left" className="p-0 w-72">
                <div className="sr-only">
                  <SheetTitle>Menu Navigasi</SheetTitle>
                  <SheetDescription>Akses fitur aplikasi dan pengaturan.</SheetDescription>
                </div>
                <Sidebar 
                  email={email} 
                  role={role} 
                  isCollapsed={false} 
                  onLinkClick={() => setIsMobileOpen(false)} 
                />
              </SheetContent>
            </Sheet>

            {/* Desktop Collapse Toggle */}
            {mounted && (
              <Button 
                variant="ghost" 
                size="icon" 
                className="hidden md:flex" 
                onClick={() => setIsCollapsed(!isCollapsed)}
              >
                {isCollapsed ? <PanelLeftOpen className="h-5 w-5" /> : <PanelLeftClose className="h-5 w-5" />}
                <span className="sr-only">Toggle Sidebar</span>
              </Button>
            )}
            
            <h1 className="text-sm font-semibold ml-2 lg:ml-4 truncate">{title}</h1>
          </div>
          <div className="flex items-center gap-4">
            <ThemeToggle />
          </div>
        </header>
        <main className="flex-1 overflow-auto p-4 md:p-6 lg:p-8 bg-muted/50/50 dark:bg-slate-900/50 print:bg-white print:p-0 print:overflow-visible">
          {children}
        </main>
      </div>
    </div>
  );
}
