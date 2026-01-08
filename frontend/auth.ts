import NextAuth from "next-auth"
import Google from "next-auth/providers/google"

declare module "next-auth" {
  interface Session {
    idToken?: string
    error?: string
  }
}

// Whitelist of allowed email addresses
const ALLOWED_EMAILS = [
  "borismulder91@gmail.com",
  "boris@nextnovate.com",
  "tim.zwart@nextnovate.com",
  "timzwt@gmail.com",
]

async function refreshAccessToken(token: any) {
  try {
    const response = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        client_id: process.env.GOOGLE_CLIENT_ID!,
        client_secret: process.env.GOOGLE_CLIENT_SECRET!,
        grant_type: "refresh_token",
        refresh_token: token.refreshToken,
      }),
    })

    const refreshedTokens = await response.json()

    if (!response.ok) {
      throw refreshedTokens
    }

    return {
      ...token,
      idToken: refreshedTokens.id_token,
      accessToken: refreshedTokens.access_token,
      accessTokenExpires: Date.now() + refreshedTokens.expires_in * 1000,
      refreshToken: refreshedTokens.refresh_token ?? token.refreshToken,
    }
  } catch (error) {
    console.error("Error refreshing access token", error)
    return { ...token, error: "RefreshAccessTokenError" }
  }
}

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    Google({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
      authorization: {
        params: {
          access_type: "offline",
          prompt: "consent",
        },
      },
    }),
  ],
  callbacks: {
    async signIn({ user }) {
      // Only allow whitelisted emails
      return ALLOWED_EMAILS.includes(user.email ?? "")
    },
    async jwt({ token, account }) {
      // Initial sign in - store all tokens
      if (account) {
        return {
          ...token,
          idToken: account.id_token,
          accessToken: account.access_token,
          accessTokenExpires: account.expires_at ? account.expires_at * 1000 : Date.now() + 3600 * 1000,
          refreshToken: account.refresh_token,
        }
      }

      // Return token if not expired (with 5 min buffer)
      if (Date.now() < (token.accessTokenExpires as number) - 5 * 60 * 1000) {
        return token
      }

      // Token expired, refresh it
      return refreshAccessToken(token)
    },
    async session({ session, token }) {
      // Pass id_token to client-side session
      session.idToken = token.idToken as string
      session.error = token.error as string | undefined
      return session
    },
  },
  pages: {
    signIn: "/login",
    error: "/login",
  },
})
