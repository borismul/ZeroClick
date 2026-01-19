'use client'

import { signIn } from "next-auth/react"
import { useSearchParams } from "next/navigation"
import { Suspense, useState, useEffect } from "react"
import Link from "next/link"
import { translations, localeNames, detectLocale, isRTL, type Locale } from "./translations"

function LoginContent() {
  const searchParams = useSearchParams()
  const error = searchParams.get("error")
  const [locale, setLocale] = useState<Locale>('en')
  const [isOpen, setIsOpen] = useState(false)

  useEffect(() => {
    setLocale(detectLocale())
  }, [])

  const t = translations[locale]
  const rtl = isRTL(locale)

  return (
    <div className="landing-page" dir={rtl ? 'rtl' : 'ltr'}>
      {/* Header */}
      <header className="landing-header">
        <div className="landing-logo">
          <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
            <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
          </svg>
          <span>Mileage Tracker</span>
        </div>

        {/* Language Selector */}
        <div className="lang-selector">
          <button
            className="lang-btn"
            onClick={() => setIsOpen(!isOpen)}
            aria-expanded={isOpen}
          >
            <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
              <path d="M12.87 15.07l-2.54-2.51.03-.03c1.74-1.94 2.98-4.17 3.71-6.53H17V4h-7V2H8v2H1v1.99h11.17C11.5 7.92 10.44 9.75 9 11.35 8.07 10.32 7.3 9.19 6.69 8h-2c.73 1.63 1.73 3.17 2.98 4.56l-5.09 5.02L4 19l5-5 3.11 3.11.76-2.04zM18.5 10h-2L12 22h2l1.12-3h4.75L21 22h2l-4.5-12zm-2.62 7l1.62-4.33L19.12 17h-3.24z"/>
            </svg>
            {localeNames[locale]}
            <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" style={{ marginLeft: '4px' }}>
              <path d="M7 10l5 5 5-5z"/>
            </svg>
          </button>

          {isOpen && (
            <div className="lang-dropdown">
              {(Object.keys(localeNames) as Locale[]).map((code) => (
                <button
                  key={code}
                  className={`lang-option ${code === locale ? 'active' : ''}`}
                  onClick={() => {
                    setLocale(code)
                    setIsOpen(false)
                  }}
                >
                  {localeNames[code]}
                </button>
              ))}
            </div>
          )}
        </div>
      </header>

      <main className="landing-main">
        {/* Hero */}
        <section className="hero">
          <h1>{t.title}</h1>
          <p className="hero-subtitle">{t.subtitle}</p>

          {error && (
            <div className="login-error">
              {error === "AccessDenied" ? t.errorAccess : t.errorGeneric}
            </div>
          )}

          <button
            className="cta-btn"
            onClick={() => signIn("google", { callbackUrl: "/" })}
          >
            <svg viewBox="0 0 24 24" width="20" height="20">
              <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
              <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
              <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            {t.cta}
          </button>
        </section>

        {/* Features */}
        <section className="features">
          <div className="feature">
            <div className="feature-icon">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
              </svg>
            </div>
            <h3>{t.features.autoTrack.title}</h3>
            <p>{t.features.autoTrack.desc}</p>
          </div>

          <div className="feature">
            <div className="feature-icon">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
                <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
              </svg>
            </div>
            <h3>{t.features.classify.title}</h3>
            <p>{t.features.classify.desc}</p>
          </div>

          <div className="feature">
            <div className="feature-icon">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
                <path d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" strokeWidth="2" stroke="currentColor" fill="none"/>
              </svg>
            </div>
            <h3>{t.features.export.title}</h3>
            <p>{t.features.export.desc}</p>
          </div>

          <div className="feature">
            <div className="feature-icon">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
              </svg>
            </div>
            <h3>{t.features.watch.title}</h3>
            <p>{t.features.watch.desc}</p>
          </div>

          <div className="feature">
            <div className="feature-icon">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
                <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
              </svg>
            </div>
            <h3>{t.features.audi.title}</h3>
            <p>{t.features.audi.desc}</p>
          </div>

          <div className="feature">
            <div className="feature-icon">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="currentColor">
                <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
              </svg>
            </div>
            <h3>{t.features.privacy.title}</h3>
            <p>{t.features.privacy.desc}</p>
          </div>
        </section>

        {/* How it works */}
        <section className="how-it-works">
          <h2>{t.howItWorks}</h2>
          <div className="steps">
            <div className="step">
              <div className="step-number">1</div>
              <h4>{t.steps.connect.title}</h4>
              <p>{t.steps.connect.desc}</p>
            </div>
            <div className="step">
              <div className="step-number">2</div>
              <h4>{t.steps.drive.title}</h4>
              <p>{t.steps.drive.desc}</p>
            </div>
            <div className="step">
              <div className="step-number">3</div>
              <h4>{t.steps.classify.title}</h4>
              <p>{t.steps.classify.desc}</p>
            </div>
            <div className="step">
              <div className="step-number">4</div>
              <h4>{t.steps.export.title}</h4>
              <p>{t.steps.export.desc}</p>
            </div>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="landing-footer">
        <div className="footer-links">
          <Link href="/privacy">{t.footer.privacy}</Link>
          <Link href="/terms">{t.footer.terms}</Link>
        </div>
        <p className="footer-copy">{t.footer.copy}</p>
      </footer>
    </div>
  )
}

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="landing-page"><div className="loading">Loading...</div></div>}>
      <LoginContent />
    </Suspense>
  )
}
