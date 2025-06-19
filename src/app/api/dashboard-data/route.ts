import { NextResponse } from "next/server";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function GET() {
  // Get all students
  const students = await prisma.students.findMany();
  // Get all courses
  const courses = await prisma.courses.findMany();
  // Get all lecturers
  const lecturers = await prisma.lecturers.findMany();

  return NextResponse.json({ students, courses, lecturers });
} 