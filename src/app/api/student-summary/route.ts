import { NextResponse } from "next/server";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url!);
  const email = searchParams.get("email");
  if (!email) {
    return NextResponse.json({ error: "Missing email" }, { status: 400 });
  }

  // Find student by email
  const student = await prisma.students.findFirst({
    where: { student_email: email },
  });

  let enrollCount = 0;
  if (student) {
    enrollCount = await prisma.course_enrollment.count({
      where: { student_id: student.student_id },
    });
  }

  const courseCount = await prisma.courses.count();

  return NextResponse.json({ student, enrollCount, courseCount });
} 