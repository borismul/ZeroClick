import { Metadata } from 'next'
import Link from 'next/link'

export const metadata: Metadata = {
  title: 'Terms of Service - Mileage Tracker',
  description: 'Terms of Service for Mileage Tracker app',
}

export default function TermsOfService() {
  return (
    <div className="legal-page">
      <header className="legal-header">
        <Link href="/login" className="legal-logo">
          <svg viewBox="0 0 24 24" width="28" height="28" fill="currentColor">
            <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
          </svg>
          Mileage Tracker
        </Link>
      </header>

      <main className="legal-content">
        <h1>Terms of Service</h1>
        <p className="legal-date">Last updated: January 17, 2026</p>

        <section>
          <h2>1. Acceptance of Terms</h2>
          <p>
            By downloading, installing, or using Mileage Tracker (&quot;the App&quot;), you agree to be bound by these
            Terms of Service. If you do not agree to these terms, do not use the App.
          </p>
        </section>

        <section>
          <h2>2. Description of Service</h2>
          <p>
            Mileage Tracker is a mobile application that helps users track their driving trips for
            business and personal use. The App provides:
          </p>
          <ul>
            <li>Automatic trip detection via CarPlay and Bluetooth</li>
            <li>GPS-based trip recording</li>
            <li>Trip classification (business/private)</li>
            <li>Distance tracking and statistics</li>
            <li>Data export to Google Sheets</li>
            <li>Apple Watch companion app</li>
          </ul>
        </section>

        <section>
          <h2>3. User Accounts</h2>
          <p>
            To use the App, you must sign in with a Google account. You are responsible for:
          </p>
          <ul>
            <li>Maintaining the security of your Google account</li>
            <li>All activities that occur under your account</li>
            <li>Ensuring your account information is accurate</li>
          </ul>
        </section>

        <section>
          <h2>4. Acceptable Use</h2>
          <p>You agree not to:</p>
          <ul>
            <li>Use the App for any unlawful purpose</li>
            <li>Attempt to gain unauthorized access to our systems</li>
            <li>Interfere with or disrupt the App or servers</li>
            <li>Reverse engineer or decompile the App</li>
            <li>Use the App while driving in a way that distracts from safe operation of a vehicle</li>
          </ul>
        </section>

        <section>
          <h2>5. Data Accuracy</h2>
          <p>While we strive to provide accurate trip tracking:</p>
          <ul>
            <li>GPS accuracy may vary based on device and environmental conditions</li>
            <li>Distance calculations are estimates unless odometer data is available</li>
            <li>You are responsible for verifying data accuracy for tax or business purposes</li>
            <li>We are not liable for any inaccuracies in recorded data</li>
          </ul>
        </section>

        <section>
          <h2>6. Vehicle API Connections</h2>
          <p>
            If you connect your vehicle&apos;s API (Audi, Volkswagen, Tesla, Renault, etc.):
          </p>
          <ul>
            <li>You authorize us to access your vehicle data through the manufacturer&apos;s API</li>
            <li>We are not responsible for changes to third-party APIs</li>
            <li>Vehicle data availability depends on your car manufacturer</li>
          </ul>
        </section>

        <section>
          <h2>7. Intellectual Property</h2>
          <p>
            The App and its original content, features, and functionality are owned by us and are
            protected by international copyright, trademark, and other intellectual property laws.
          </p>
        </section>

        <section>
          <h2>8. Disclaimer of Warranties</h2>
          <p className="legal-disclaimer">
            THE APP IS PROVIDED &quot;AS IS&quot; AND &quot;AS AVAILABLE&quot; WITHOUT WARRANTIES OF ANY KIND,
            EITHER EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT THE APP WILL BE UNINTERRUPTED,
            ERROR-FREE, OR FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS.
          </p>
        </section>

        <section>
          <h2>9. Limitation of Liability</h2>
          <p className="legal-disclaimer">
            TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR ANY INDIRECT,
            INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING LOSS OF PROFITS,
            DATA, OR OTHER INTANGIBLE LOSSES.
          </p>
        </section>

        <section>
          <h2>10. Termination</h2>
          <p>
            We may terminate or suspend your access to the App immediately, without prior notice,
            for any reason, including breach of these Terms. You may delete your account at any
            time through the App settings.
          </p>
        </section>

        <section>
          <h2>11. Changes to Terms</h2>
          <p>
            We reserve the right to modify these terms at any time. We will notify users of any
            material changes by updating the &quot;Last updated&quot; date. Continued use of the App after
            changes constitutes acceptance of the new terms.
          </p>
        </section>

        <section>
          <h2>12. Governing Law</h2>
          <p>
            These Terms shall be governed by and construed in accordance with the laws of the
            Netherlands, without regard to its conflict of law provisions.
          </p>
        </section>

        <section>
          <h2>13. Contact</h2>
          <p>
            For any questions about these Terms of Service, please contact us at:
          </p>
          <p className="legal-contact">
            <strong>Email:</strong> support@mileagetracker.app
          </p>
        </section>
      </main>

      <footer className="legal-footer">
        <div className="footer-links">
          <Link href="/login">Home</Link>
          <Link href="/privacy">Privacy Policy</Link>
        </div>
        <p>© 2026 Mileage Tracker. All rights reserved.</p>
      </footer>
    </div>
  )
}
