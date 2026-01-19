import { Metadata } from 'next'
import Link from 'next/link'

export const metadata: Metadata = {
  title: 'Privacy Policy - Mileage Tracker',
  description: 'Privacy Policy for Mileage Tracker app',
}

export default function PrivacyPolicy() {
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
        <h1>Privacy Policy</h1>
        <p className="legal-date">Last updated: January 17, 2026</p>

        <section>
          <h2>Introduction</h2>
          <p>
            Mileage Tracker (&quot;we&quot;, &quot;our&quot;, or &quot;us&quot;) is committed to protecting your privacy.
            This Privacy Policy explains how we collect, use, and safeguard your information when you use our
            mobile application and related services.
          </p>
        </section>

        <section>
          <h2>Information We Collect</h2>

          <h3>1. Location Data</h3>
          <ul>
            <li>GPS coordinates during trips</li>
            <li>Background location tracking while driving</li>
            <li>Start and end locations of trips</li>
          </ul>
          <p>
            <strong>Purpose:</strong> Location data is essential for recording your trips, calculating distances,
            and automatically detecting when you start and end a journey. We use &quot;Always&quot; location permission
            to detect driving activity automatically via CarPlay or Bluetooth connection.
          </p>

          <h3>2. Account Information</h3>
          <ul>
            <li>Google account email address</li>
            <li>Authentication tokens</li>
          </ul>
          <p>
            <strong>Purpose:</strong> We use Google Sign-In to identify you and secure your data.
            Your email is used as your account identifier.
          </p>

          <h3>3. Trip Data</h3>
          <ul>
            <li>Trip start and end times</li>
            <li>Distance traveled</li>
            <li>Trip classification (business/private)</li>
            <li>GPS trail during trips</li>
          </ul>
          <p>
            <strong>Purpose:</strong> This is the core data you&apos;re tracking for mileage reporting and tax purposes.
          </p>

          <h3>4. Vehicle Data (Optional)</h3>
          <ul>
            <li>Car brand and model information</li>
            <li>Odometer readings (if connected to car API)</li>
            <li>Battery level (for electric vehicles)</li>
          </ul>
          <p>
            <strong>Purpose:</strong> If you connect your car&apos;s API, we can provide more accurate odometer-based
            distance tracking and vehicle status information.
          </p>
        </section>

        <section>
          <h2>How We Use Your Information</h2>
          <ul>
            <li>To record and display your trip history</li>
            <li>To calculate distances and generate statistics</li>
            <li>To classify trips as business or private</li>
            <li>To export data to Google Sheets for tax reporting</li>
            <li>To sync data between your iPhone and Apple Watch</li>
            <li>To automatically detect driving activity</li>
          </ul>
        </section>

        <section>
          <h2>Data Storage and Security</h2>
          <p>
            Your data is stored securely in Google Cloud Firestore, located in the EU (europe-west4 region).
            We use industry-standard encryption for data in transit and at rest.
          </p>
          <ul>
            <li>All API communications use HTTPS encryption</li>
            <li>Authentication tokens are stored securely in the iOS Keychain</li>
            <li>We do not sell or share your data with third parties</li>
          </ul>
        </section>

        <section>
          <h2>Data Retention</h2>
          <p>
            We retain your trip data for as long as your account is active. You can export your data at any time
            using the Google Sheets export feature. When you delete your account, all associated data is
            permanently deleted from our servers.
          </p>
        </section>

        <section>
          <h2>Your Rights</h2>
          <p>You have the right to:</p>
          <ul>
            <li><strong>Access:</strong> View all your trip data in the app</li>
            <li><strong>Export:</strong> Export your data to Google Sheets</li>
            <li><strong>Correction:</strong> Edit trip details and classifications</li>
            <li><strong>Deletion:</strong> Delete individual trips or your entire account</li>
          </ul>
          <p>
            To delete your account and all associated data, go to Settings → Delete Account in the app.
          </p>
        </section>

        <section>
          <h2>Third-Party Services</h2>
          <p>We use the following third-party services:</p>
          <ul>
            <li><strong>Google Sign-In:</strong> For authentication</li>
            <li><strong>Google Cloud:</strong> For data storage and hosting</li>
            <li><strong>Google Maps:</strong> For route distance calculation</li>
            <li><strong>OpenStreetMap:</strong> For map display in the Apple Watch app</li>
          </ul>
          <p>
            If you connect your car, we may communicate with your car manufacturer&apos;s API
            (Audi, Volkswagen, Tesla, Renault, etc.) to retrieve vehicle data.
          </p>
        </section>

        <section>
          <h2>Children&apos;s Privacy</h2>
          <p>
            Our app is not intended for children under 16. We do not knowingly collect personal
            information from children.
          </p>
        </section>

        <section>
          <h2>Changes to This Policy</h2>
          <p>
            We may update this Privacy Policy from time to time. We will notify you of any changes by
            posting the new Privacy Policy on this page and updating the &quot;Last updated&quot; date.
          </p>
        </section>

        <section>
          <h2>Contact Us</h2>
          <p>
            If you have any questions about this Privacy Policy, please contact us at:
          </p>
          <p className="legal-contact">
            <strong>Email:</strong> privacy@mileagetracker.app
          </p>
        </section>
      </main>

      <footer className="legal-footer">
        <div className="footer-links">
          <Link href="/login">Home</Link>
          <Link href="/terms">Terms of Service</Link>
        </div>
        <p>© 2026 Mileage Tracker. All rights reserved.</p>
      </footer>
    </div>
  )
}
