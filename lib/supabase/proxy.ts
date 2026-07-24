import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { hasEnvVars } from "../utils";

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  });

  // If the env vars are not set, skip proxy check. You can remove this
  // once you setup the project.
  if (!hasEnvVars) {
    return supabaseResponse;
  }

  // With Fluid compute, don't put this client in a global environment
  // variable. Always create a new one on each request.
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value),
          );
          supabaseResponse = NextResponse.next({
            request,
          });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options),
          );
        },
      },
    },
  );

  // Do not run code between createServerClient and
  // supabase.auth.getClaims(). A simple mistake could make it very hard to debug
  // issues with users being randomly logged out.

  // IMPORTANT: If you remove getClaims() and you use server-side rendering
  // with the Supabase client, your users may be randomly logged out.
  const { data: { user } } = await supabase.auth.getUser();
  
  const url = request.nextUrl.clone();

  if (user) {
    const role = user?.user_metadata?.role || "kasir";
    const isAdminRoute = url.pathname.startsWith("/admin");
    const isKasirRoute = url.pathname.startsWith("/kasir");
    const isRoot = url.pathname === "/" || url.pathname === "/dashboard";
    const isAuthRoute = url.pathname.startsWith("/auth") || url.pathname.startsWith("/login");

    if (isAuthRoute) {
      url.pathname = role === "admin" ? "/admin" : "/kasir";
      return NextResponse.redirect(url);
    }

    if (isRoot) {
      url.pathname = role === "admin" ? "/admin" : "/kasir";
      return NextResponse.redirect(url);
    }

    if (role === "kasir" && isAdminRoute) {
      url.pathname = "/kasir";
      return NextResponse.redirect(url);
    }
    
    if (role === "admin" && isKasirRoute) {
      url.pathname = "/admin";
      return NextResponse.redirect(url);
    }
  } else {
    // Not logged in
    const isProtectedRoute = 
      url.pathname.startsWith("/admin") || 
      url.pathname.startsWith("/kasir") || 
      url.pathname === "/" || 
      url.pathname === "/dashboard";
      
    if (isProtectedRoute) {
      url.pathname = "/auth/login";
      return NextResponse.redirect(url);
    }
  }

  // IMPORTANT: You *must* return the supabaseResponse object as it is.
  // If you're creating a new response object with NextResponse.next() make sure to:
  // 1. Pass the request in it, like so:
  //    const myNewResponse = NextResponse.next({ request })
  // 2. Copy over the cookies, like so:
  //    myNewResponse.cookies.setAll(supabaseResponse.cookies.getAll())
  // 3. Change the myNewResponse object to fit your needs, but avoid changing
  //    the cookies!
  // 4. Finally:
  //    return myNewResponse
  // If this is not done, you may be causing the browser and server to go out
  // of sync and terminate the user's session prematurely!

  return supabaseResponse;
}
