import NextAuth from "next-auth"
import Google from "next-auth/providers/google"

// Whitelist of allowed email addresses
const ALLOWED_EMAILS = [
  "borismulder91@gmail.com",
  "boris@nextnovate.com",
  "tim.zwart@nextnovate.com",
  "timzwt@gmail.com",
]

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
      // Persist the id_token from Google to the JWT
      if (account) {
        token.idToken = account.id_token
      }
      return token
    },
    async session({ session, token }) {
      // Pass id_token to client-side session
      session.idToken = token.idToken as string
      return session
    },
  },
  pages: {
    signIn: "/login",
    error: "/login",
  },
})
