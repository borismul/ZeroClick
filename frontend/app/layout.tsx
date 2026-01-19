import './globals.css'
import { Providers } from './providers'

export const metadata = {
  title: 'Kilometerregistratie',
  description: 'Zero Click - Automatic trip tracking',
  icons: {
    icon: '/icon.png',
    apple: '/icon.png',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="nl">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
