-- CreateTable
CREATE TABLE "course_enrollment" (
    "enrollment_id" SERIAL NOT NULL,
    "student_id" INTEGER,
    "course_id" INTEGER,
    "enrollment_date" DATE,

    CONSTRAINT "course_enrollment_pkey" PRIMARY KEY ("enrollment_id")
);

-- CreateTable
CREATE TABLE "courses" (
    "course_id" SERIAL NOT NULL,
    "course_name" VARCHAR(100) NOT NULL,
    "credit_hours" INTEGER NOT NULL,

    CONSTRAINT "courses_pkey" PRIMARY KEY ("course_id")
);

-- CreateTable
CREATE TABLE "lecturer_course_assignment" (
    "id" SERIAL NOT NULL,
    "lecturer_id" INTEGER,
    "course_id" INTEGER,

    CONSTRAINT "lecturer_course_assignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lecturer_ta_assignment" (
    "id" SERIAL NOT NULL,
    "lecturer_id" INTEGER,
    "ta_id" INTEGER,

    CONSTRAINT "lecturer_ta_assignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lecturers" (
    "lecturer_id" SERIAL NOT NULL,
    "lecturer_name" VARCHAR(100) NOT NULL,
    "lecturer_email" VARCHAR(50) NOT NULL,

    CONSTRAINT "lecturers_pkey" PRIMARY KEY ("lecturer_id")
);

-- CreateTable
CREATE TABLE "student_fees" (
    "payment_id" SERIAL NOT NULL,
    "payment_date" DATE,
    "amount_paid" DECIMAL(10,2) NOT NULL,
    "student_id" INTEGER,

    CONSTRAINT "student_fees_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "students" (
    "student_id" SERIAL NOT NULL,
    "student_name" VARCHAR(100) NOT NULL,
    "student_email" VARCHAR(50) NOT NULL,
    "student_contact" VARCHAR(50) NOT NULL,

    CONSTRAINT "students_pkey" PRIMARY KEY ("student_id")
);

-- CreateTable
CREATE TABLE "ta" (
    "ta_id" SERIAL NOT NULL,
    "ta_name" VARCHAR(100) NOT NULL,
    "ta_email" VARCHAR(50) NOT NULL,

    CONSTRAINT "ta_pkey" PRIMARY KEY ("ta_id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100),
    "email" VARCHAR(100) NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- AddForeignKey
ALTER TABLE "course_enrollment" ADD CONSTRAINT "course_enrollment_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("course_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "course_enrollment" ADD CONSTRAINT "course_enrollment_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("student_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "lecturer_course_assignment" ADD CONSTRAINT "lecturer_course_assignment_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("course_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "lecturer_course_assignment" ADD CONSTRAINT "lecturer_course_assignment_lecturer_id_fkey" FOREIGN KEY ("lecturer_id") REFERENCES "lecturers"("lecturer_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "lecturer_ta_assignment" ADD CONSTRAINT "lecturer_ta_assignment_lecturer_id_fkey" FOREIGN KEY ("lecturer_id") REFERENCES "lecturers"("lecturer_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "lecturer_ta_assignment" ADD CONSTRAINT "lecturer_ta_assignment_ta_id_fkey" FOREIGN KEY ("ta_id") REFERENCES "ta"("ta_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "student_fees" ADD CONSTRAINT "student_fees_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("student_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
