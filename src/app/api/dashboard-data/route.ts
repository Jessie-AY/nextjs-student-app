import { NextResponse } from "next/server";
import { PrismaClient } from "@prisma/client";

// Use a singleton for PrismaClient to avoid connection leaks
let prisma: PrismaClient;
if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient();
} else {
  // @ts-ignore
  if (!global.prisma) {
    // @ts-ignore
    global.prisma = new PrismaClient();
  }
  // @ts-ignore
  prisma = global.prisma;
}

export async function GET() {
  try {
    // Get all students
    const students = await prisma.students.findMany();
    // Get all courses
    const courses = await prisma.courses.findMany();
    // Get all lecturers
    const lecturers = await prisma.lecturers.findMany();
    return NextResponse.json({ students, courses, lecturers });
  } catch (error) {
    console.error('Dashboard data fetch error:', error);
    return NextResponse.json({ error: 'Failed to fetch dashboard data' }, { status: 500 });
  }
} 