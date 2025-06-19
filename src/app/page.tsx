'use client';
import { useSession } from "next-auth/react";
import { useRouter } from "next/navigation";
import Link from "next/link";

export default function Home() {
  const { data: session, status } = useSession();
  const router = useRouter();

  if (status === "loading") {
    return <div className="flex justify-center items-center h-screen">Loading...</div>;
  }

  if (status === "authenticated") {
    router.push('/dashboard');
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#D4A3C4] to-[#A8D1E7] flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-xl max-w-md w-full mx-4">
        <h1 className="text-3xl font-bold text-center text-[#EB8DB5] mb-6">
          Student Portal
        </h1>
        <p className="text-gray-600 text-center mb-8">
          Welcome to the student management system. Please sign in to access your dashboard.
        </p>
        
        <div className="space-y-4">
          <Link
            href="/auth/login"
            className="block w-full bg-[#EB8DB5] text-white py-3 px-4 rounded-lg text-center font-semibold hover:bg-[#D4A3C4] transition-colors"
          >
            Sign In
          </Link>
          
          <Link
            href="/auth/register"
            className="block w-full bg-[#A8D1E7] text-white py-3 px-4 rounded-lg text-center font-semibold hover:bg-[#8BC4E8] transition-colors"
          >
            Create Account
          </Link>
        </div>
      </div>
    </div>
  );
}
