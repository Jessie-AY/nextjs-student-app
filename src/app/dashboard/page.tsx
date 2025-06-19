"use client";
import { useSession, signOut } from "next-auth/react";
import Link from "next/link";
import { useEffect, useState } from "react";

const navItems = [
  { name: "Dashboard", href: "/dashboard" },
  { name: "Students", href: "/dashboard/students" },
  { name: "Courses", href: "/dashboard/courses" },
  { name: "Payments", href: "/dashboard/payments" },
  { name: "Settings", href: "/dashboard/settings" },
];

export default function DashboardPage() {
  const { status } = useSession();
  const [students, setStudents] = useState<any[]>([]);
  const [courses, setCourses] = useState<any[]>([]);
  const [lecturers, setLecturers] = useState<any[]>([]);

  useEffect(() => {
    async function fetchDashboardData() {
      const res = await fetch(`/api/dashboard-data`);
      if (res.ok) {
        const data = await res.json();
        setStudents(data.students);
        setCourses(data.courses);
        setLecturers(data.lecturers);
      }
    }
    fetchDashboardData();
  }, []);

  if (status === "loading") {
    return <div className="flex justify-center items-center h-screen">Loading...</div>;
  }

  if (status === "unauthenticated") {
    if (typeof window !== "undefined") window.location.href = "/auth/login";
    return null;
  }

  return (
    <div className="min-h-screen flex bg-gradient-to-br from-[#A8D1E7] via-[#FCFAF2] to-[#D4A3C4]">
      {/* Sidebar */}
      <aside className="w-64 bg-[#D4A3C4] p-6 flex flex-col shadow-lg min-h-screen">
        <h2 className="text-2xl font-extrabold text-white mb-10 text-center tracking-wide">Student Portal</h2>
        <nav className="flex flex-col gap-3 flex-1">
          {navItems.map((item) => (
            <Link
              key={item.name}
              href={item.href}
              className="text-[#fff] font-semibold rounded-lg px-4 py-2 hover:bg-[#A8D1E7] hover:text-[#EB8DB5] transition-colors"
            >
              {item.name}
            </Link>
          ))}
        </nav>
        <button
          onClick={() => signOut({ callbackUrl: "/auth/login" })}
          className="mt-8 bg-[#EB8DB5] text-white font-bold py-2 rounded-lg hover:bg-[#FFBFC5] transition-colors"
        >
          Logout
        </button>
      </aside>

      {/* Main Content */}
      <main className="flex-1 flex flex-col items-center justify-start p-8">
        <h1 className="text-4xl font-extrabold text-[#EB8DB5] mb-8 text-center drop-shadow-sm">
          Welcome
        </h1>
        <div className="w-full flex flex-col gap-10 items-center">
          {/* Students Table */}
          <div className="w-full max-w-4xl">
            <h2 className="text-2xl font-bold text-[#A8D1E7] mb-2">Students</h2>
            <div className="overflow-x-auto">
              <table className="w-full bg-white rounded-xl shadow border border-[#EB8DB5]">
                <thead>
                  <tr className="bg-[#A8D1E7] text-white">
                    <th className="p-2">ID</th>
                    <th className="p-2">Name</th>
                    <th className="p-2">Email</th>
                    <th className="p-2">Contact</th>
                  </tr>
                </thead>
                <tbody>
                  {students.map((student) => (
                    <tr key={student.student_id} className="text-center hover:bg-[#FCFAF2] transition">
                      <td className="p-2 shadow-sm bg-white">{student.student_id}</td>
                      <td className="p-2 shadow-sm bg-white">{student.student_name}</td>
                      <td className="p-2 shadow-sm bg-white">{student.student_email}</td>
                      <td className="p-2 shadow-sm bg-white">{student.student_contact}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Courses Table */}
          <div className="w-full max-w-4xl">
            <h2 className="text-2xl font-bold text-[#EB8DB5] mb-2">Courses</h2>
            <div className="overflow-x-auto">
              <table className="w-full bg-white rounded-xl shadow border border-[#A8D1E7]">
                <thead>
                  <tr className="bg-[#A8D1E7] text-white">
                    <th className="p-2">ID</th>
                    <th className="p-2">Name</th>
                    <th className="p-2">Credit Hours</th>
                  </tr>
                </thead>
                <tbody>
                  {courses.map((course) => (
                    <tr key={course.course_id} className="text-center hover:bg-[#FCFAF2] transition">
                      <td className="p-2 shadow-sm bg-white">{course.course_id}</td>
                      <td className="p-2 shadow-sm bg-white">{course.course_name}</td>
                      <td className="p-2 shadow-sm bg-white">{course.credit_hours}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Lecturers Table */}
          <div className="w-full max-w-4xl">
            <h2 className="text-2xl font-bold text-[#D4A3C4] mb-2">Lecturers</h2>
            <div className="overflow-x-auto">
              <table className="w-full bg-white rounded-xl shadow border border-[#A8D1E7]">
                <thead>
                  <tr className="bg-[#A8D1E7] text-white">
                    <th className="p-2">ID</th>
                    <th className="p-2">Name</th>
                    <th className="p-2">Email</th>
                  </tr>
                </thead>
                <tbody>
                  {lecturers.map((lect) => (
                    <tr key={lect.lecturer_id} className="text-center hover:bg-[#FCFAF2] transition">
                      <td className="p-2 shadow-sm bg-white">{lect.lecturer_id}</td>
                      <td className="p-2 shadow-sm bg-white">{lect.lecturer_name}</td>
                      <td className="p-2 shadow-sm bg-white">{lect.lecturer_email}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}