import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "School Management System",
  description: "Student academic tracking and parent communication platform",
  icons: {
    icon: '/favicon.svg',
    apple: '/apple-touch-icon.png',
  },
  manifest: '/manifest.json',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
