import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/providers";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "JobScouter - Smart Job Application Tracker",
  description: "Track your job applications, manage interviews, and land your dream job faster with AI-powered insights.",
  keywords: ["job tracker", "application tracker", "career management", "interview prep", "job search"],
  authors: [{ name: "JobScouter" }],
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
      <body className={`${inter.variable} font-sans antialiased`}>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  );
}
