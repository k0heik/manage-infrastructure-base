import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Template",
  description: "Next.js + Python monorepo template",
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
