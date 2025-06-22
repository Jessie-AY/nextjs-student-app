--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: calculate_outstanding_fees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_outstanding_fees() RETURNS json
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.calculate_outstanding_fees() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: course_enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_enrollment (
    enrollment_id integer NOT NULL,
    student_id integer,
    course_id integer,
    enrollment_date date
);


ALTER TABLE public.course_enrollment OWNER TO postgres;

--
-- Name: course_enrollment_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_enrollment_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_enrollment_enrollment_id_seq OWNER TO postgres;

--
-- Name: course_enrollment_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_enrollment_enrollment_id_seq OWNED BY public.course_enrollment.enrollment_id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id integer NOT NULL,
    course_name character varying(100) NOT NULL,
    credit_hours integer NOT NULL
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_course_id_seq OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_course_id_seq OWNED BY public.courses.course_id;


--
-- Name: lecturer_course_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturer_course_assignment (
    id integer NOT NULL,
    lecturer_id integer,
    course_id integer
);


ALTER TABLE public.lecturer_course_assignment OWNER TO postgres;

--
-- Name: lecturer_course_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lecturer_course_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturer_course_assignment_id_seq OWNER TO postgres;

--
-- Name: lecturer_course_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lecturer_course_assignment_id_seq OWNED BY public.lecturer_course_assignment.id;


--
-- Name: lecturer_ta_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturer_ta_assignment (
    id integer NOT NULL,
    lecturer_id integer,
    ta_id integer
);


ALTER TABLE public.lecturer_ta_assignment OWNER TO postgres;

--
-- Name: lecturer_ta_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lecturer_ta_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturer_ta_assignment_id_seq OWNER TO postgres;

--
-- Name: lecturer_ta_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lecturer_ta_assignment_id_seq OWNED BY public.lecturer_ta_assignment.id;


--
-- Name: lecturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturers (
    lecturer_id integer NOT NULL,
    lecturer_name character varying(100) NOT NULL,
    lecturer_email character varying(50) NOT NULL
);


ALTER TABLE public.lecturers OWNER TO postgres;

--
-- Name: lecturers_lecturer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lecturers_lecturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturers_lecturer_id_seq OWNER TO postgres;

--
-- Name: lecturers_lecturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lecturers_lecturer_id_seq OWNED BY public.lecturers.lecturer_id;


--
-- Name: student_fees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_fees (
    payment_id integer NOT NULL,
    payment_date date,
    amount_paid numeric(10,2) NOT NULL,
    student_id integer
);


ALTER TABLE public.student_fees OWNER TO postgres;

--
-- Name: student_fees_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_fees_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_fees_payment_id_seq OWNER TO postgres;

--
-- Name: student_fees_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_fees_payment_id_seq OWNED BY public.student_fees.payment_id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    student_name character varying(100) NOT NULL,
    student_email character varying(50) NOT NULL,
    student_contact character varying(50) NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- Name: ta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ta (
    ta_id integer NOT NULL,
    ta_name character varying(100) NOT NULL,
    ta_email character varying(50) NOT NULL
);


ALTER TABLE public.ta OWNER TO postgres;

--
-- Name: ta_ta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ta_ta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ta_ta_id_seq OWNER TO postgres;

--
-- Name: ta_ta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ta_ta_id_seq OWNED BY public.ta.ta_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100) NOT NULL,
    password text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: course_enrollment enrollment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment ALTER COLUMN enrollment_id SET DEFAULT nextval('public.course_enrollment_enrollment_id_seq'::regclass);


--
-- Name: courses course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN course_id SET DEFAULT nextval('public.courses_course_id_seq'::regclass);


--
-- Name: lecturer_course_assignment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_course_assignment ALTER COLUMN id SET DEFAULT nextval('public.lecturer_course_assignment_id_seq'::regclass);


--
-- Name: lecturer_ta_assignment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_ta_assignment ALTER COLUMN id SET DEFAULT nextval('public.lecturer_ta_assignment_id_seq'::regclass);


--
-- Name: lecturers lecturer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturers ALTER COLUMN lecturer_id SET DEFAULT nextval('public.lecturers_lecturer_id_seq'::regclass);


--
-- Name: student_fees payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fees ALTER COLUMN payment_id SET DEFAULT nextval('public.student_fees_payment_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- Name: ta ta_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ta ALTER COLUMN ta_id SET DEFAULT nextval('public.ta_ta_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
7cd00613-c266-40ed-891f-46190686cb31	b56fd4406b2700f68f006f39f2c6572b8a483a0824a6fd0eee8544cbb446f992	2025-06-19 06:54:48.847213+00	20250619065448_init	\N	\N	2025-06-19 06:54:48.803868+00	1
\.


--
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_enrollment (enrollment_id, student_id, course_id, enrollment_date) FROM stdin;
1	1	1	2025-06-21
2	2	2	2025-06-21
3	1	1	2025-06-21
4	2	2	2025-06-21
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (course_id, course_name, credit_hours) FROM stdin;
1	Software Engineering	3
2	Data Structures	3
3	Software Engineering	3
4	Data Structures	3
\.


--
-- Data for Name: lecturer_course_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturer_course_assignment (id, lecturer_id, course_id) FROM stdin;
1	1	1
2	2	2
3	1	1
4	2	2
\.


--
-- Data for Name: lecturer_ta_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturer_ta_assignment (id, lecturer_id, ta_id) FROM stdin;
1	1	1
2	1	1
\.


--
-- Data for Name: lecturers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturers (lecturer_id, lecturer_name, lecturer_email) FROM stdin;
1	Mr. John Assiamah	johnasiamah@ug.edu.gh
2	Dr. John Kutor	johnkutor@ug.edu.gh
3	Mr. John Assiamah	johnasiamah@ug.edu.gh
4	Dr. John Kutor	johnkutor@ug.edu.gh
\.


--
-- Data for Name: student_fees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_fees (payment_id, payment_date, amount_paid, student_id) FROM stdin;
1	2025-06-21	1500.00	1
2	2025-06-21	1000.00	2
3	2025-06-21	1500.00	1
4	2025-06-21	1000.00	2
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, student_name, student_email, student_contact) FROM stdin;
1	Ohnyu Lee	steel@st.ug.edu.gh	0201234546
2	jessica Amemor	jessicaamemor@gmail.com	0541237654
3	Ohnyu Lee	steel@st.ug.edu.gh	0201234546
4	jessica Amemor	jessicaamemor@gmail.com	0541237654
\.


--
-- Data for Name: ta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ta (ta_id, ta_name, ta_email) FROM stdin;
1	Kudus Bannah	kudusb@ug.edu.gh
2	Kudus Bannah	kudusb@ug.edu.gh
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password) FROM stdin;
1	Billy	billyeilish@gmail.com	$2b$10$RWYtMbquqdcv.UiQz39EfeHyRKHa2xgYDXiLP76ZTXb6WGpJzQQzm
2	Jessica Amemor 	jessicaamemor@gmail.com	$2b$10$6RJR8ngk8T//4sx.aYA/9u3cyDs6TBBzqdRHuAUlD3hqDp0gnd3ia
\.


--
-- Name: course_enrollment_enrollment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_enrollment_enrollment_id_seq', 4, true);


--
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_course_id_seq', 4, true);


--
-- Name: lecturer_course_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lecturer_course_assignment_id_seq', 4, true);


--
-- Name: lecturer_ta_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lecturer_ta_assignment_id_seq', 2, true);


--
-- Name: lecturers_lecturer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lecturers_lecturer_id_seq', 4, true);


--
-- Name: student_fees_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_fees_payment_id_seq', 4, true);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 4, true);


--
-- Name: ta_ta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ta_ta_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: course_enrollment course_enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment
    ADD CONSTRAINT course_enrollment_pkey PRIMARY KEY (enrollment_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: lecturer_course_assignment lecturer_course_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_assignment_pkey PRIMARY KEY (id);


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_pkey PRIMARY KEY (id);


--
-- Name: lecturers lecturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturers
    ADD CONSTRAINT lecturers_pkey PRIMARY KEY (lecturer_id);


--
-- Name: student_fees student_fees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fees
    ADD CONSTRAINT student_fees_pkey PRIMARY KEY (payment_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: ta ta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ta
    ADD CONSTRAINT ta_pkey PRIMARY KEY (ta_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: course_enrollment course_enrollment_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment
    ADD CONSTRAINT course_enrollment_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id);


--
-- Name: course_enrollment course_enrollment_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_enrollment
    ADD CONSTRAINT course_enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: lecturer_course_assignment lecturer_course_assignment_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_assignment_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id);


--
-- Name: lecturer_course_assignment lecturer_course_assignment_lecturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_assignment_lecturer_id_fkey FOREIGN KEY (lecturer_id) REFERENCES public.lecturers(lecturer_id);


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_lecturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_lecturer_id_fkey FOREIGN KEY (lecturer_id) REFERENCES public.lecturers(lecturer_id);


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_ta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_ta_id_fkey FOREIGN KEY (ta_id) REFERENCES public.ta(ta_id);


--
-- Name: student_fees student_fees_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fees
    ADD CONSTRAINT student_fees_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

