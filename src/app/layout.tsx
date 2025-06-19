// src/app/layout.tsx
import "./globals.css";
import { ReactNode } from "react";
import { Inter } from "next/font/google";
import ClientProvider from "./client-provider";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Student Portal",
  description: "A dashboard for student management",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <ClientProvider>{children}</ClientProvider>
      </body>
    </html>
  );
}
