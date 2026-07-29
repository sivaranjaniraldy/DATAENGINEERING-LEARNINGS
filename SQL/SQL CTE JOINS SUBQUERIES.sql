
-- CREATE DATABASE

CREATE DATABASE hospital_db;
USE hospital_db;

-- CREATE TABLES 

CREATE TABLE Departments (
    department_id   VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    doctor_id       VARCHAR(10) PRIMARY KEY,
    doctor_name     VARCHAR(100) NOT NULL,
    department_id   VARCHAR(10),
    specialization  VARCHAR(50),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Patients (
    patient_id      VARCHAR(10) PRIMARY KEY,
    patient_name    VARCHAR(100) NOT NULL,
    gender          VARCHAR(10),
    city            VARCHAR(50),
    age             INT
);

CREATE TABLE Appointments (
    appointment_id   VARCHAR(10) PRIMARY KEY,
    patient_id       VARCHAR(10),
    doctor_id        VARCHAR(10),
    appointment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Treatments (
    treatment_id     VARCHAR(10) PRIMARY KEY,
    appointment_id   VARCHAR(10),
    treatment_name   VARCHAR(100),
    cost             DECIMAL(10,2),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

CREATE TABLE Medicines (
    medicine_id      VARCHAR(10) PRIMARY KEY,
    medicine_name    VARCHAR(100),
    price            DECIMAL(10,2)
);

CREATE TABLE Prescriptions (
    prescription_id  VARCHAR(10) PRIMARY KEY,
    appointment_id   VARCHAR(10),
    medicine_id      VARCHAR(10),
    quantity         INT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

CREATE TABLE Billing (
    bill_id          VARCHAR(10) PRIMARY KEY,
    appointment_id   VARCHAR(10),
    total_amount     DECIMAL(10,2),
    payment_status   VARCHAR(20),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- SAMPLE INSERT DATA 

-- Departments
INSERT INTO Departments (department_id, department_name) VALUES
('DEP01','Cardiology'),('DEP02','Neurology'),('DEP03','Orthopedics'),
('DEP04','General Medicine'),('DEP05','Pediatrics');

-- Doctors
INSERT INTO Doctors (doctor_id,doctor_name,department_id,specialization) VALUES
('DOC001','Dr. Arun','DEP01','Cardiologist'),
('DOC002','Dr. Priya','DEP02','Neurologist'),
('DOC003','Dr. David','DEP03','Orthopedic'),
('DOC004','Dr. Meena','DEP04','General Physician'),
('DOC005','Dr. Ahmed','DEP05','Pediatrician');

-- Patients
INSERT INTO Patients (patient_id,patient_name,gender,city,age) VALUES
('PAT001','John','Male','Chennai',35),('PAT002','Sarah','Female','Hyderabad',28),
('PAT003','David','Male','Mumbai',45),('PAT004','Fatima','Female','Chennai',30),
('PAT005','Rahul','Male','Bangalore',40),('PAT006','Anita','Female','Delhi',32),
('PAT007','Kumar','Male','Coimbatore',29),('PAT008','Priya','Female','Salem',26),
('PAT009','Ravi','Male','Madurai',38),('PAT010','Ayesha','Female','Kochi',34);

-- Appointments
INSERT INTO Appointments (appointment_id,patient_id,doctor_id,appointment_date) VALUES
('APP001','PAT001','DOC001','2025-01-10'),('APP002','PAT002','DOC002','2025-01-11'),
('APP003','PAT003','DOC003','2025-01-12'),('APP004','PAT004','DOC004','2025-01-13'),
('APP005','PAT005','DOC001','2025-01-15'),('APP006','PAT006','DOC005','2025-01-18'),
('APP007','PAT007','DOC004','2025-01-20'),('APP008','PAT008','DOC003','2025-01-22');

-- Treatments
INSERT INTO Treatments (treatment_id,appointment_id,treatment_name,cost) VALUES
('TR001','APP001','ECG',2500),('TR002','APP002','Brain Scan',8000),
('TR003','APP003','Bone Surgery',55000),('TR004','APP004','General Checkup',1200),
('TR005','APP005','Heart Scan',6000),('TR006','APP006','Vaccination',1500),
('TR007','APP007','Blood Test',900),('TR008','APP008','X-Ray',1800);

-- Medicines
INSERT INTO Medicines (medicine_id,medicine_name,price) VALUES
('MED001','Paracetamol',50),('MED002','Amoxicillin',120),
('MED003','Vitamin C',80),('MED004','Ibuprofen',100),('MED005','Insulin',500);

-- Prescriptions
INSERT INTO Prescriptions (prescription_id,appointment_id,medicine_id,quantity) VALUES
('PRE001','APP001','MED001',10),('PRE002','APP002','MED002',7),
('PRE003','APP003','MED004',15),('PRE004','APP004','MED003',12),
('PRE005','APP005','MED005',5),('PRE006','APP006','MED001',8),
('PRE007','APP007','MED003',6),('PRE008','APP008','MED004',9);

-- Billing
INSERT INTO Billing (bill_id,appointment_id,total_amount,payment_status) VALUES
('B001','APP001',3000,'Paid'),('B002','APP002',9000,'Paid'),
('B003','APP003',60000,'Pending'),('B004','APP004',1500,'Paid'),
('B005','APP005',7000,'Pending'),('B006','APP006',1800,'Paid'),
('B007','APP007',1200,'Paid'),('B008','APP008',2200,'Pending');

-- ASSIGNMENT QUESTIONS (CTEs, JOINs & SUBQUERIES)

-- 1. Display all patient details using a CTE.
WITH patient_cte AS (
    SELECT * FROM Patients
)
SELECT * FROM patient_cte;

-- 2. Display patients above the average age using a CTE.
WITH avg_age_cte AS (
    SELECT AVG(age) AS avg_age FROM Patients
)
SELECT p.*
FROM Patients p
JOIN avg_age_cte ON p.age > avg_age_cte.avg_age;

-- 3. Find doctors who handled more than one appointment using a CTE.
WITH doctor_appt_count AS (
    SELECT doctor_id, COUNT(*) AS appt_count
    FROM Appointments
    GROUP BY doctor_id
)
SELECT d.doctor_name, dac.appt_count
FROM Doctors d
JOIN doctor_appt_count dac ON d.doctor_id = dac.doctor_id
WHERE dac.appt_count > 1;

-- 4. Display the department-wise appointment count using a CTE.
WITH dept_appt_cte AS (
    SELECT dep.department_id, dep.department_name, COUNT(a.appointment_id) AS appt_count
    FROM Departments dep
    LEFT JOIN Doctors doc ON dep.department_id = doc.department_id
    LEFT JOIN Appointments a ON doc.doctor_id = a.doctor_id
    GROUP BY dep.department_id, dep.department_name
)
SELECT * FROM dept_appt_cte;

-- 5. Find the top three treatment costs using a CTE.
WITH ranked_treatments AS (
    SELECT treatment_name, cost,
           RANK() OVER (ORDER BY cost DESC) AS rnk
    FROM Treatments
)
SELECT treatment_name, cost
FROM ranked_treatments
WHERE rnk <= 3;

-- 6. Display patients who paid more than the average bill.
WITH avg_bill_cte AS (
    SELECT AVG(total_amount) AS avg_amt FROM Billing
)
SELECT DISTINCT p.patient_name, b.total_amount
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
JOIN avg_bill_cte ON b.total_amount > avg_bill_cte.avg_amt;

-- 7. Display total revenue generated by each department.
SELECT dep.department_name, SUM(b.total_amount) AS total_revenue
FROM Departments dep
JOIN Doctors doc ON dep.department_id = doc.department_id
JOIN Appointments a ON doc.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY dep.department_name;

-- 8. Find patients who visited multiple departments.
SELECT p.patient_name, COUNT(DISTINCT doc.department_id) AS dept_count
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors doc ON a.doctor_id = doc.doctor_id
GROUP BY p.patient_name
HAVING COUNT(DISTINCT doc.department_id) > 1;

-- 9. Display doctor-wise treatment counts.
SELECT doc.doctor_name, COUNT(t.treatment_id) AS treatment_count
FROM Doctors doc
LEFT JOIN Appointments a ON doc.doctor_id = a.doctor_id
LEFT JOIN Treatments t ON a.appointment_id = t.appointment_id
GROUP BY doc.doctor_name;

-- 10. Find patients with pending bills.
SELECT p.patient_name, b.total_amount, b.payment_status
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Pending';

-- 11. Display patient name, doctor name, and department.
SELECT p.patient_name, doc.doctor_name, dep.department_name
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors doc ON a.doctor_id = doc.doctor_id
JOIN Departments dep ON doc.department_id = dep.department_id;

-- 12. Display patient name with treatment details.
SELECT p.patient_name, t.treatment_name, t.cost
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Treatments t ON a.appointment_id = t.appointment_id;

-- 13. Display patient name with medicine details.
SELECT p.patient_name, m.medicine_name, pr.quantity
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
JOIN Medicines m ON pr.medicine_id = m.medicine_id;

-- 14. Display department-wise total billing.
SELECT dep.department_name, SUM(b.total_amount) AS total_billing
FROM Departments dep
JOIN Doctors doc ON dep.department_id = doc.department_id
JOIN Appointments a ON doc.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY dep.department_name;

-- 15. Find the highest billed patient.
SELECT p.patient_name, b.total_amount
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.total_amount = (SELECT MAX(total_amount) FROM Billing);

-- 16. Display doctor-wise revenue.
SELECT doc.doctor_name, SUM(b.total_amount) AS revenue
FROM Doctors doc
JOIN Appointments a ON doc.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY doc.doctor_name;

-- 17. Display all appointments with billing status.
SELECT a.appointment_id, a.appointment_date, p.patient_name, doc.doctor_name,
       b.total_amount, b.payment_status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors doc ON a.doctor_id = doc.doctor_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id;

-- 18. Display patients without prescriptions.
SELECT p.patient_name
FROM Patients p
WHERE p.patient_id NOT IN (
    SELECT a.patient_id
    FROM Appointments a
    JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
);

-- 19. Display doctors without appointments.
SELECT doc.doctor_name
FROM Doctors doc
LEFT JOIN Appointments a ON doc.doctor_id = a.doctor_id
WHERE a.appointment_id IS NULL;

-- 20. Display department-wise patient count.
SELECT dep.department_name, COUNT(DISTINCT a.patient_id) AS patient_count
FROM Departments dep
JOIN Doctors doc ON dep.department_id = doc.department_id
JOIN Appointments a ON doc.doctor_id = a.doctor_id
GROUP BY dep.department_name;

-- 21. Find patients whose bill is greater than the average bill.
SELECT p.patient_name, b.total_amount
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.total_amount > (SELECT AVG(total_amount) FROM Billing);

-- 22. Display doctors earning the highest department revenue.
WITH doctor_revenue AS (
    SELECT doc.doctor_id, doc.doctor_name, doc.department_id, SUM(b.total_amount) AS revenue
    FROM Doctors doc
    JOIN Appointments a ON doc.doctor_id = a.doctor_id
    JOIN Billing b ON a.appointment_id = b.appointment_id
    GROUP BY doc.doctor_id, doc.doctor_name, doc.department_id
)
SELECT dr.doctor_name, dr.department_id, dr.revenue
FROM doctor_revenue dr
WHERE dr.revenue = (
    SELECT MAX(dr2.revenue) FROM doctor_revenue dr2 WHERE dr2.department_id = dr.department_id
);

-- 23. Find patients prescribed the most expensive medicine.
SELECT DISTINCT p.patient_name, m.medicine_name, m.price
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
JOIN Medicines m ON pr.medicine_id = m.medicine_id
WHERE m.price = (SELECT MAX(price) FROM Medicines);

-- 24. Display departments having above-average revenue.
WITH dept_revenue AS (
    SELECT dep.department_id, dep.department_name, SUM(b.total_amount) AS revenue
    FROM Departments dep
    JOIN Doctors doc ON dep.department_id = doc.department_id
    JOIN Appointments a ON doc.doctor_id = a.doctor_id
    JOIN Billing b ON a.appointment_id = b.appointment_id
    GROUP BY dep.department_id, dep.department_name
)
SELECT department_name, revenue
FROM dept_revenue
WHERE revenue > (SELECT AVG(revenue) FROM dept_revenue);

-- 25. Find doctors who handled the maximum appointments.
WITH doctor_appt_count AS (
    SELECT doctor_id, COUNT(*) AS appt_count
    FROM Appointments
    GROUP BY doctor_id
)
SELECT doc.doctor_name, dac.appt_count
FROM Doctors doc
JOIN doctor_appt_count dac ON doc.doctor_id = dac.doctor_id
WHERE dac.appt_count = (SELECT MAX(appt_count) FROM doctor_appt_count);

-- 26. Display patients with treatment costs greater than the average treatment cost.
SELECT p.patient_name, t.treatment_name, t.cost
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Treatments t ON a.appointment_id = t.appointment_id
WHERE t.cost > (SELECT AVG(cost) FROM Treatments);

-- 27. Find medicines prescribed more than the average quantity.
SELECT m.medicine_name, SUM(pr.quantity) AS total_quantity
FROM Medicines m
JOIN Prescriptions pr ON m.medicine_id = pr.medicine_id
GROUP BY m.medicine_name
HAVING SUM(pr.quantity) > (SELECT AVG(quantity) FROM Prescriptions);

-- 28. Display patient-wise total hospital expenditure.
SELECT p.patient_name, SUM(b.total_amount) AS total_expenditure
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_name;

-- 29. Find departments with no pending payments.
SELECT dep.department_name
FROM Departments dep
WHERE dep.department_id NOT IN (
    SELECT doc.department_id
    FROM Doctors doc
    JOIN Appointments a ON doc.doctor_id = a.doctor_id
    JOIN Billing b ON a.appointment_id = b.appointment_id
    WHERE b.payment_status = 'Pending'
);

-- 30. Generate a complete hospital report using CTEs, JOINs, and Subqueries.
WITH patient_billing_cte AS (
    SELECT
        p.patient_id,
        p.patient_name,
        a.appointment_id,
        a.appointment_date,
        doc.doctor_name,
        dep.department_name,
        t.treatment_name,
        t.cost AS treatment_cost,
        b.total_amount,
        b.payment_status
    FROM Patients p
    JOIN Appointments a ON p.patient_id = a.patient_id
    JOIN Doctors doc ON a.doctor_id = doc.doctor_id
    JOIN Departments dep ON doc.department_id = dep.department_id
    LEFT JOIN Treatments t ON a.appointment_id = t.appointment_id
    LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
)
SELECT *
FROM patient_billing_cte
WHERE total_amount > (SELECT AVG(total_amount) FROM Billing)
   OR total_amount IS NULL
ORDER BY patient_id;
