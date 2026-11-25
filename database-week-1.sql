SELECT * FROM school.students;
-- ============================================================================
-- Week 1 Database Systems Assignment: School Management System (MySQL)
-- File: answer.sql
-- ============================================================================

-- 1. Create the database (name clearly reflects the School Management topic)
DROP DATABASE IF EXISTS school_management_db;
CREATE DATABASE school_management_db;

-- 2. Select the database so subsequent commands run inside it
USE school_management_db;

-- 3. Create tables with primary keys, foreign keys, and constraints
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    office_location VARCHAR(100)
);

CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30),
    hire_date DATE NOT NULL,
    department_id INT NULL,
    CONSTRAINT fk_teachers_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_number VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(150) UNIQUE,
    enrollment_date DATE NOT NULL
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_title VARCHAR(150) NOT NULL,
    credits TINYINT NOT NULL DEFAULT 3,
    department_id INT NULL,
    teacher_id INT NULL,
    CONSTRAINT chk_courses_credits CHECK (credits > 0 AND credits <= 10),
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_courses_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES teachers(teacher_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(5) NULL,
    CONSTRAINT uq_student_course UNIQUE (student_id, course_id),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 4. Insert sample records into each table
INSERT INTO departments (department_name, office_location) VALUES
    ('Computer Science', 'Science Block - Room 101'),
    ('Mathematics', 'Academic Wing - Room 204'),
    ('Humanities', 'Arts Block - Room 112');

INSERT INTO teachers (full_name, email, phone, hire_date, department_id) VALUES
    ('Dr. Samuel Kamau', 's.kamau@school.edu', '+254711000111', '2021-02-01', 1),
    ('Grace Muthoni', 'g.muthoni@school.edu', '+254711000222', '2022-09-01', 2),
    ('Peter Otieno', 'p.otieno@school.edu', '+254711000333', '2020-01-15', 3);

INSERT INTO students (admission_number, full_name, date_of_birth, email, enrollment_date) VALUES
    ('ADM-2026-001', 'Amina Wanjiku', '2007-04-12', 'amina.wanjiku@student.school.edu', '2026-01-10'),
    ('ADM-2026-002', 'Brian Kiprop', '2006-11-23', 'brian.kiprop@student.school.edu', '2026-01-10'),
    ('ADM-2026-003', 'Halima Abdullahi', '2007-08-05', 'halima.abdullahi@student.school.edu', '2026-01-12');

INSERT INTO courses (course_code, course_title, credits, department_id, teacher_id) VALUES
    ('CS101', 'Introduction to Programming', 4, 1, 1),
    ('MATH102', 'Discrete Mathematics', 3, 2, 2),
    ('HUM101', 'African History & Society', 3, 3, 3);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
    (1, 1, '2026-01-15', 'A'),
    (1, 2, '2026-01-15', 'B+'),
    (2, 1, '2026-01-16', 'A-'),
    (3, 3, '2026-01-18', NULL);

-- 5. Sample update & verification queries
UPDATE enrollments
SET grade = 'A'
WHERE student_id = 3 AND course_id = 3;

SHOW DATABASES;
SHOW TABLES;
DESCRIBE students;
SELECT * FROM departments;
SELECT * FROM teachers;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;

-- View student course enrollments with teacher and department info
SELECT
    s.admission_number,
    s.full_name AS student_name,
    c.course_code,
    c.course_title,
    t.full_name AS teacher_name,
    d.department_name,
    e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN departments d ON c.department_id = d.department_id;