// src/app/(dashboard)/layout.tsx
'use client';
import React from "react";
import Link from "next/link";
import { useSession, signOut } from "next-auth/react";
import { useRouter } from "next/navigation";

const navItems = [
  { name: "Dashboard", href: "/dashboard" },
  { name: "Students", href: "/dashboard/students" },
  { name: "Courses", href: "/dashboard/courses" },
  { name: "Payments", href: "/dashboard/payments" },
  { name: "Settings", href: "/dashboard/settings" },
];

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const { data: session, status } = useSession();
  const router = useRouter();

  // Redirect to login if not authenticated
  if (status === "loading") {
    return <div className="flex justify-center items-center h-screen">Loading...</div>;
  }

  if (status === "unauthenticated") {
    router.push('/auth/login');
    return null;
  }

  const handleLogout = () => {
    signOut({ callbackUrl: '/auth/login' });
  };

  return (
    <div className="flex min-h-screen">
      {/* Sidebar */}
      <aside className="w-64 bg-[#D4A3C4] p-4 shadow-md">
        <h2 className="text-xl font-bold text-white mb-6">Student Portal</h2>
        <nav className="flex flex-col space-y-4">
          {navItems.map((item) => (
            <Link
              key={item.name}
              href={item.href}
              className="text-white hover:bg-[#EB8DB5] hover:text-white rounded-lg px-3 py-2 transition-colors"
            >
              {item.name}
            </Link>
          ))}
          <button
            onClick={handleLogout}
            className="text-white hover:bg-[#EB8DB5] hover:text-white rounded-lg px-3 py-2 transition-colors text-left"
          >
            Logout
          </button>
        </nav>
      </aside>

      {/* Main Content */}
      <main className="flex-1 bg-[#FFFBFC] p-6">
        {/* Header */}
        <header className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl font-bold text-[#EB8DB5]">
              Welcome {session?.user?.name || 'User'}
            </h1>
          </div>
          <div className="flex items-center space-x-4">
            <input
              type="text"
              placeholder="Search..."
              className="px-3 py-2 rounded-lg border border-[#D4A3C4] text-[#333] placeholder-[#888] focus:outline-none focus:ring-2 focus:ring-[#A8D1E7]"
            />
            <div className="w-10 h-10 rounded-full bg-[#D4A3C4] text-white flex items-center justify-center font-bold">
              {session?.user?.name?.charAt(0) || 'U'}
            </div>
          </div>
        </header>

        {children}
      </main>
    </div>
  );
}
