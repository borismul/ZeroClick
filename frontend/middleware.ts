import { auth } from "@/auth"

export default auth((req) => {
  const isLoggedIn = !!req.auth
  const isLoginPage = req.nextUrl.pathname === "/login"
  const isAuthApi = req.nextUrl.pathname.startsWith("/api/auth")
  const isPublicPage = ["/privacy", "/terms"].includes(req.nextUrl.pathname)

  // Allow auth API routes and public pages
  if (isAuthApi || isPublicPage) {
    return
  }

  // Redirect to login if not authenticated
  if (!isLoggedIn && !isLoginPage) {
    return Response.redirect(new URL("/login", req.url))
  }

  // Redirect to home if already logged in and trying to access login
  if (isLoggedIn && isLoginPage) {
    return Response.redirect(new URL("/", req.url))
  }
})

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"],
}
