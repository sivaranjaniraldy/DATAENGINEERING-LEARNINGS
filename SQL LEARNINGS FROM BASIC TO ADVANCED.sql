-- Create & select database
CREATE DATABASE university_db;
USE university_db;

-- Create table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50),
    department VARCHAR(30),
    gpa DECIMAL(3,2),
    admission_date DATE,
    email VARCHAR(100)
);

-- Insert values (20 records)
INSERT INTO students (student_name, department, gpa, admission_date, email) VALUES
('Ravi', 'CSE', 8.90, '2023-06-15', 'ravi@mail.com'),
('Anitha', 'ECE', 7.80, '2022-07-20', 'anitha@mail.com'),
('Suresh', 'Mech', 6.50, '2024-01-10', NULL),
('Priya', 'CSE', 9.20, '2021-08-05', 'priya@mail.com'),
('Karthik', 'Civil', 7.10, '2023-09-12', 'karthik@mail.com'),
('Divya', 'IT', 8.40, '2022-03-18', 'divya@mail.com'),
('Manoj', 'ECE', 6.90, '2024-02-25', NULL),
('Sneha', 'CSE', 9.50, '2021-11-30', 'sneha@mail.com'),
('Arjun', 'Mech', 7.30, '2023-07-08', 'arjun@mail.com'),
('Lavanya', 'IT', 8.10, '2022-05-14', 'lavanya@mail.com'),
('Vignesh', 'Civil', 6.70, '2024-03-02', NULL),
('Deepa', 'CSE', 8.80, '2021-09-19', 'deepa@mail.com'),
('Harish', 'ECE', 7.50, '2023-01-27', 'harish@mail.com'),
('Nisha', 'IT', 9.00, '2022-08-09', 'nisha@mail.com'),
('Prakash', 'Mech', 6.20, '2024-04-17', NULL),
('Swathi', 'CSE', 8.60, '2021-12-11', 'swathi@mail.com'),
('Vimal', 'Civil', 7.40, '2023-10-05', 'vimal@mail.com'),
('Keerthi', 'ECE', 8.20, '2022-06-23', 'keerthi@mail.com'),
('Ramesh', 'IT', 7.90, '2023-02-14', 'ramesh@mail.com'),
('Bhavya', 'Mech', 6.80, '2024-05-01', NULL);

SELECT * FROM students;
SELECT COUNT(*) AS total_rows FROM students;   -- confirms 20 records

-- ALTER: add, rename column, modify type, rename table
ALTER TABLE students ADD phone VARCHAR(15);
ALTER TABLE students RENAME COLUMN student_name TO full_name;
ALTER TABLE students MODIFY gpa DECIMAL(4,2);
ALTER TABLE students RENAME TO learners;

DESCRIBE learners;

-- TRUNCATE on a throwaway table
CREATE TABLE scratch_pad (id INT);
INSERT INTO scratch_pad VALUES (1),(2),(3);
TRUNCATE TABLE scratch_pad;
SELECT * FROM scratch_pad;    -- empty, structure intact

-- WHERE
SELECT * FROM learners WHERE department = 'CSE';

-- UPDATE
UPDATE learners SET gpa = 9.10 WHERE full_name = 'Ravi';

-- Transaction control
SET autocommit = 0;
START TRANSACTION;
DELETE FROM learners WHERE full_name = 'Suresh';
ROLLBACK;                       -- undo the delete
SELECT * FROM learners WHERE full_name = 'Suresh';   -- Suresh is back

START TRANSACTION;
UPDATE learners SET gpa = 8.00 WHERE full_name = 'Anitha';
COMMIT;                         -- permanently saved

-- Date & time functions
SELECT CURRENT_DATE() AS today, CURRENT_TIME() AS now_time, NOW() AS timestamp_now;
ALTER TABLE learners ADD created_at DATETIME DEFAULT NOW();

-- UNIQUE constraint
ALTER TABLE learners ADD CONSTRAINT uq_email UNIQUE (email);

-- AND / OR / NOT
SELECT * FROM learners WHERE department = 'CSE' AND gpa > 8.5;
SELECT * FROM learners WHERE department = 'CSE' OR department = 'ECE';
SELECT * FROM learners WHERE NOT department = 'Mech';

-- IN / NOT IN
SELECT * FROM learners WHERE department IN ('CSE', 'ECE', 'IT');
SELECT * FROM learners WHERE department NOT IN ('Mech', 'Civil');

-- IS NULL / IS NOT NULL
SELECT * FROM learners WHERE email IS NULL;
SELECT * FROM learners WHERE email IS NOT NULL;

-- LIKE & wildcards
SELECT * FROM learners WHERE full_name LIKE 'R%';
SELECT * FROM learners WHERE full_name LIKE '_nitha';
SELECT * FROM learners WHERE full_name LIKE '%esh';

-- BETWEEN
SELECT * FROM learners WHERE gpa BETWEEN 7.0 AND 9.0;                                                                              

-- Aggregate functions
SELECT COUNT(*) AS total_students FROM learners;
SELECT SUM(gpa) AS total_gpa FROM learners;
SELECT AVG(gpa) AS avg_gpa FROM learners;
SELECT MIN(gpa) AS min_gpa FROM learners;
SELECT MAX(gpa) AS max_gpa FROM learners;
SELECT DISTINCT department FROM learners;

-- ORDER BY
SELECT * FROM learners ORDER BY gpa DESC;

-- GROUP BY with alias
SELECT department, AVG(gpa) AS avg_gpa, COUNT(*) AS dept_count
FROM learners
GROUP BY department;

-- HAVING
SELECT department, AVG(gpa) AS avg_gpa
FROM learners
GROUP BY department
HAVING AVG(gpa) > 7.5;

-- LIMIT / OFFSET
SELECT * FROM learners ORDER BY student_id LIMIT 5 OFFSET 5;

-- Subquery
SELECT full_name FROM learners
WHERE gpa > (SELECT AVG(gpa) FROM learners);

-- EXISTS / NOT EXISTS
SELECT full_name FROM learners l
WHERE EXISTS (SELECT 1 FROM learners WHERE department = 'CSE' AND l.student_id = student_id);

SELECT full_name FROM learners l
WHERE NOT EXISTS (SELECT 1 FROM learners WHERE department = 'Aerospace' AND l.student_id = student_id);

-- ANY / ALL
SELECT full_name FROM learners
WHERE gpa > ANY (SELECT gpa FROM learners WHERE department = 'ECE');

SELECT full_name FROM learners
WHERE gpa > ALL (SELECT gpa FROM learners WHERE department = 'Mech');

-- String functions
SELECT UPPER(full_name), LOWER(full_name), LENGTH(full_name),
       CONCAT(full_name, ' - ', department) AS combo
FROM learners;

-- Numeric functions
SELECT ROUND(gpa, 1), CEIL(gpa), FLOOR(gpa) FROM learners;

-- Date functions
SELECT DATEDIFF(NOW(), admission_date) AS days_since_admission FROM learners;
SELECT DATE_FORMAT(admission_date, '%d-%b-%Y') AS formatted_date FROM learners;

-- Conversion functions
SELECT CAST(gpa AS CHAR) AS gpa_text FROM learners;
SELECT CONVERT(admission_date, CHAR) AS date_text FROM learners;

-- Window functions
SELECT full_name, department, gpa,
       RANK() OVER (PARTITION BY department ORDER BY gpa DESC) AS dept_rank,
       ROW_NUMBER() OVER (ORDER BY gpa DESC) AS overall_rank,
       AVG(gpa) OVER (PARTITION BY department) AS dept_avg_gpa
FROM learners;

-- Setup second table for joins (5 records)
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(30),
    department VARCHAR(30)
);

INSERT INTO courses VALUES
(1, 'Data Structures', 'CSE'),
(2, 'Signals & Systems', 'ECE'),
(3, 'Thermodynamics', 'Mech'),
(4, 'Structural Analysis', 'Civil'),
(5, 'Cloud Computing', 'IT');

-- INNER JOIN
SELECT l.full_name, c.course_name
FROM learners l
INNER JOIN courses c ON l.department = c.department;

-- LEFT JOIN
SELECT l.full_name, c.course_name
FROM learners l
LEFT JOIN courses c ON l.department = c.department;

-- RIGHT JOIN
SELECT l.full_name, c.course_name
FROM learners l
RIGHT JOIN courses c ON l.department = c.department;

-- Set operators
SELECT full_name FROM learners WHERE department = 'CSE'
UNION
SELECT full_name FROM learners WHERE department = 'ECE';

SELECT full_name FROM learners WHERE department = 'CSE'
UNION ALL
SELECT full_name FROM learners WHERE department = 'ECE';

-- Data constraints (NOT NULL, FOREIGN KEY)
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES learners(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Index
CREATE INDEX idx_department ON learners(department);

-- View
CREATE VIEW top_scorers AS
SELECT full_name, department, gpa
FROM learners
WHERE gpa > 8.0;

SELECT * FROM top_scorers;

-- Dynamic SQL
SET @sql_query = 'SELECT * FROM learners WHERE department = "CSE"';
PREPARE stmt FROM @sql_query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



