CREATE TABLE IF NOT EXISTS students (
student_id SERIAL PRIMARY KEY,
student_name VARCHAR(100) NOT NULL,
student_email VARCHAR(50) NOT NULL,
student_contact VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS courses(
course_id SERIAL PRIMARY KEY, 
course_name VARCHAR(100) NOT NULL,
credit_hours INT NOT NULL
);

CREATE TABLE IF NOT EXISTS course_enrollment(
enrollment_id SERIAL PRIMARY KEY,
student_id INT,
course_id INT,
enrollment_date DATE,
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
); 

CREATE TABLE IF NOT EXISTS student_fees(
payment_id SERIAL PRIMARY KEY,
payment_date DATE,
amount_paid NUMERIC(10,2) NOT NULL,
student_id INT,
FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE IF NOT EXISTS TA(
TA_id  SERIAL PRIMARY KEY,
TA_name VARCHAR(100) NOT NULL,
TA_email VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS lecturers(
lecturer_id SERIAL PRIMARY KEY,
lecturer_name VARCHAR(100) NOT NULL,
lecturer_email VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS lecturer_course_assignment (
    id SERIAL PRIMARY KEY,
    lecturer_id INT,
    course_id INT,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE IF NOT EXISTS lecturer_ta_assignment (
    id SERIAL PRIMARY KEY,
    lecturer_id INT,
    ta_id INT,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id),
    FOREIGN KEY (ta_id) REFERENCES TA(TA_id)
);

INSERT INTO students(student_name, student_email, student_contact)
VALUES 
('Ohnyu Lee','steel@st.ug.edu.gh','0201234546'),
('jessica Amemor','jessicaamemor@gmail.com','0541237654');

INSERT INTO courses (course_name, credit_hours) 
VALUES
('Software Engineering', 3),
('Data Structures', 3);


INSERT INTO lecturers (lecturer_name, lecturer_email)
VALUES
('Mr. John Assiamah', 'johnasiamah@ug.edu.gh'),
('Dr. John Kutor', 'johnkutor@ug.edu.gh');


INSERT INTO TA (TA_name, TA_email) 
VALUES 
('Kudus Bannah', 'kudusb@ug.edu.gh');

INSERT INTO course_enrollment (student_id, course_id, enrollment_date) 
VALUES
(1, 1, CURRENT_DATE),
(2, 2, CURRENT_DATE);


INSERT INTO student_fees (student_id, amount_paid, payment_date) 
VALUES
(1, 1500.00, CURRENT_DATE),
(2, 1000.00, CURRENT_DATE);

INSERT INTO lecturer_course_assignment (lecturer_id, course_id)
VALUES
(1, 1), 
(2, 2);

INSERT INTO lecturer_ta_assignment (lecturer_id, ta_id)
VALUES
(1, 1);  

CREATE OR REPLACE FUNCTION calculate_outstanding_fees()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(row_to_json(sub))
    INTO result
    FROM (
        SELECT 
            s.student_id AS student_id,
            s.student_name AS full_name,
            COUNT(e.course_id) * 1000 AS total_fees,
            COALESCE(SUM(f.amount_paid), 0) AS amount_paid,
            (COUNT(e.course_id) * 1000 - COALESCE(SUM(f.amount_paid), 0)) AS outstanding_balance
        FROM students s
        LEFT JOIN course_enrollment e ON s.student_id = e.student_id
        LEFT JOIN student_fees f ON s.student_id = f.student_id
        GROUP BY s.student_id, s.student_name
    ) sub;

    RETURN result;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM course_enrollment;
SELECT * FROM student_fees;
SELECT * FROM TA;
SELECT * FROM lecturers;
SELECT calculate_outstanding_fees();