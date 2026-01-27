import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/providers";
import { PWAInstallBanner, UpdateBanner, OfflineIndicator } from "@/components/pwa/pwa-features";
import { AccessibilityProvider, SkipToContent, LiveRegion } from "@/components/accessibility/keyboard-shortcuts";
import Script from "next/script";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

export const viewport: Viewport = {
  themeColor: "#4f46e5",
  width: "device-width",
  initialScale: 1,
  maximumScale: 5,
  userScalable: true,
};

export const metadata: Metadata = {
  title: "JobScouter - Smart Job Application Tracker",
  description: "Track your job applications, manage interviews, and land your dream job faster with AI-powered insights.",
  keywords: ["job tracker", "application tracker", "career management", "interview prep", "job search"],
  authors: [{ name: "JobScouter" }],
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "JobScouter",
  },
  formatDetection: {
    telephone: false,
  },
  openGraph: {
    title: "JobScouter - Smart Job Application Tracker",
    description: "Track your job applications, manage interviews, and land your dream job faster.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <link rel="apple-touch-icon" href="/icons/icon-192x192.png" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="mobile-web-app-capable" content="yes" />
      </head>
      <body className={`${inter.variable} font-sans antialiased`}>
        <Providers>
          <AccessibilityProvider>
            <SkipToContent />
            <OfflineIndicator />
            <UpdateBanner />
            <PWAInstallBanner />
            <main id="main-content">
              {children}
            </main>
            <LiveRegion message="" />
          </AccessibilityProvider>
        </Providers>
        <Script
          id="register-sw"
          strategy="afterInteractive"
          dangerouslySetInnerHTML={{
            __html: `
              if ('serviceWorker' in navigator) {
                window.addEventListener('load', function() {
                  navigator.serviceWorker.register('/sw.js')
                    .then(function(registration) {
                      console.log('ServiceWorker registration successful');
                    })
                    .catch(function(err) {
                      console.log('ServiceWorker registration failed: ', err);
                    });
                });
              }
            `,
          }}
        />
      </body>
    </html>
  );
}
