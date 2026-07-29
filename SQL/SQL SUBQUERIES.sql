--  CREATE DATABASE

CREATE DATABASE banking_db;
USE banking_db;

-- CREATE TABLES 

CREATE TABLE Branches (
    branch_id     VARCHAR(10) PRIMARY KEY,
    branch_name   VARCHAR(100) NOT NULL,
    city          VARCHAR(50)
);
 
CREATE TABLE Customers (
    customer_id   VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(50)
);
 
CREATE TABLE Accounts (
    account_no    VARCHAR(10) PRIMARY KEY,
    customer_id   VARCHAR(10),
    branch_id     VARCHAR(10),
    account_type  VARCHAR(20),
    balance       DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);
 
CREATE TABLE Transactions (
    transaction_id   VARCHAR(10) PRIMARY KEY,
    account_no       VARCHAR(10),
    transaction_type VARCHAR(20),
    amount           DECIMAL(12,2),
    transaction_date DATE,
    FOREIGN KEY (account_no) REFERENCES Accounts(account_no)
);
 
CREATE TABLE Loans (
    loan_id       VARCHAR(10) PRIMARY KEY,
    customer_id   VARCHAR(10),
    loan_type     VARCHAR(30),
    loan_amount   DECIMAL(12,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
 
CREATE TABLE Loan_Payments (
    payment_id      VARCHAR(10) PRIMARY KEY,
    loan_id         VARCHAR(10),
    payment_amount  DECIMAL(12,2),
    payment_date    DATE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- SAMPLE INSERT DATA 

-- Branches
INSERT INTO Branches (branch_id,branch_name,city) VALUES
('BR001','Chennai Main','Chennai'),
('BR002','Anna Nagar','Chennai'),
('BR003','Bangalore Central','Bangalore'),
('BR004','Hyderabad City','Hyderabad'),
('BR005','Mumbai West','Mumbai');
 
-- Customers
INSERT INTO Customers (customer_id,customer_name,city) VALUES
('CUS001','Ahmed','Chennai'),('CUS002','John','Bangalore'),('CUS003','Sarah','Hyderabad'),
('CUS004','David','Mumbai'),('CUS005','Priya','Chennai'),('CUS006','Rahul','Coimbatore'),
('CUS007','Fatima','Delhi'),('CUS008','Meena','Salem'),('CUS009','Kumar','Madurai'),
('CUS010','Anita','Pune'),('CUS011','Ravi','Trichy'),('CUS012','Ayesha','Kochi');
 
-- Accounts
INSERT INTO Accounts(account_no,customer_id,branch_id,account_type,balance) VALUES
('ACC1001','CUS001','BR001','Savings',85000),('ACC1002','CUS002','BR003','Savings',45000),
('ACC1003','CUS003','BR004','Current',120000),('ACC1004','CUS004','BR005','Savings',65000),
('ACC1005','CUS005','BR002','Savings',98000),('ACC1006','CUS006','BR001','Current',150000),
('ACC1007','CUS007','BR004','Savings',40000),('ACC1008','CUS008','BR001','Savings',76000),
('ACC1009','CUS009','BR002','Current',110000),('ACC1010','CUS010','BR003','Savings',53000),
('ACC1011','CUS011','BR005','Savings',30000),('ACC1012','CUS012','BR004','Current',170000);
 
-- Transactions
INSERT INTO Transactions(transaction_id,account_no,transaction_type,amount,transaction_date) VALUES
('TX001','ACC1001','Deposit',10000,'2025-01-02'),('TX002','ACC1001','Withdrawal',5000,'2025-01-05'),
('TX003','ACC1002','Deposit',20000,'2025-01-07'),('TX004','ACC1003','Withdrawal',15000,'2025-01-10'),
('TX005','ACC1004','Deposit',8000,'2025-01-12'),('TX006','ACC1005','Withdrawal',3000,'2025-01-15'),
('TX007','ACC1006','Deposit',25000,'2025-01-18'),('TX008','ACC1007','Deposit',12000,'2025-01-20'),
('TX009','ACC1008','Withdrawal',7000,'2025-01-22'),('TX010','ACC1009','Deposit',50000,'2025-01-25');
 
-- Loans
INSERT INTO Loans(loan_id,customer_id,loan_type,loan_amount) VALUES
('LN001','CUS001','Home Loan',2500000),('LN002','CUS003','Car Loan',800000),
('LN003','CUS005','Education Loan',600000),('LN004','CUS007','Personal Loan',300000),
('LN005','CUS010','Business Loan',1500000),('LN006','CUS012','Home Loan',3200000);
 
-- Loan_Payments
INSERT INTO Loan_Payments(payment_id,loan_id,payment_amount,payment_date) VALUES
('PAY001','LN001',50000,'2025-01-15'),('PAY002','LN001',50000,'2025-02-15'),
('PAY003','LN002',25000,'2025-01-20'),('PAY004','LN003',20000,'2025-01-25'),
('PAY005','LN004',15000,'2025-01-28'),('PAY006','LN005',60000,'2025-02-02'),
('PAY007','LN006',70000,'2025-02-05'),('PAY008','LN006',70000,'2025-03-05');

--  ASSIGNMENT QUESTIONS & SUBQUERIES

-- 1. Find the customer with the highest account balance.
SELECT c.customer_name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance = (SELECT MAX(balance) FROM Accounts);
 
-- 2. Find the account with the minimum balance.
SELECT *
FROM Accounts
WHERE balance = (SELECT MIN(balance) FROM Accounts);
 
-- 3. Find customers whose balance is greater than the average balance.
SELECT c.customer_name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > (SELECT AVG(balance) FROM Accounts);
 
-- 4. Find customers whose balance is less than the maximum balance.
SELECT c.customer_name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance < (SELECT MAX(balance) FROM Accounts);
 
-- 5. Display the account(s) having the second highest balance.
SELECT *
FROM Accounts
WHERE balance = (
    SELECT MAX(balance) FROM Accounts
    WHERE balance < (SELECT MAX(balance) FROM Accounts)
);
 
-- 6. Find customers who have taken a loan.
SELECT customer_name
FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Loans);
 
-- 7. Find customers who have not taken any loan.
SELECT customer_name
FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Loans);
 
-- 8. Find accounts belonging to Chennai branches.
SELECT *
FROM Accounts
WHERE branch_id IN (SELECT branch_id FROM Branches WHERE city = 'Chennai');
 
-- 9. Find customers whose accounts are in Chennai branches.
SELECT DISTINCT c.customer_name
FROM Customers c
WHERE c.customer_id IN (
    SELECT a.customer_id FROM Accounts a
    WHERE a.branch_id IN (SELECT branch_id FROM Branches WHERE city = 'Chennai')
);
 
-- 10. Display customers who have transactions greater than ₹20,000.
SELECT DISTINCT c.customer_name
FROM Customers c
WHERE c.customer_id IN (
    SELECT a.customer_id FROM Accounts a
    WHERE a.account_no IN (SELECT account_no FROM Transactions WHERE amount > 20000)
);
 
-- 11. Find customers whose balance is higher than the average balance of their branch.
SELECT c.customer_name, a.balance, a.branch_id
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > (
    SELECT AVG(a2.balance) FROM Accounts a2 WHERE a2.branch_id = a.branch_id
);
 
-- 12. Find branches with more accounts than the average branch.
SELECT branch_id, COUNT(*) AS account_count
FROM Accounts
GROUP BY branch_id
HAVING COUNT(*) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM Accounts GROUP BY branch_id
    ) branch_counts
);
 
-- 13. Find customers whose total transaction amount exceeds their current balance.
SELECT c.customer_name
FROM Customers c
WHERE (
    SELECT COALESCE(SUM(t.amount), 0)
    FROM Accounts a JOIN Transactions t ON a.account_no = t.account_no
    WHERE a.customer_id = c.customer_id
) > (
    SELECT COALESCE(SUM(a2.balance), 0)
    FROM Accounts a2 WHERE a2.customer_id = c.customer_id
);
 
-- 14. Display accounts with more transactions than the average account.
SELECT account_no, COUNT(*) AS txn_count
FROM Transactions
GROUP BY account_no
HAVING COUNT(*) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM Transactions GROUP BY account_no
    ) txn_counts
);
 
-- 15. Find loan payments above the average payment for the same loan.
SELECT lp.*
FROM Loan_Payments lp
WHERE lp.payment_amount > (
    SELECT AVG(lp2.payment_amount) FROM Loan_Payments lp2 WHERE lp2.loan_id = lp.loan_id
);
 
-- 16. Find customers who have transactions (EXISTS).
SELECT c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Accounts a
    JOIN Transactions t ON a.account_no = t.account_no
    WHERE a.customer_id = c.customer_id
);
 
-- 17. Find customers with no transactions (NOT EXISTS).
SELECT c.customer_name
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Accounts a
    JOIN Transactions t ON a.account_no = t.account_no
    WHERE a.customer_id = c.customer_id
);
 
-- 18. Find branches with at least one account.
SELECT *
FROM Branches b
WHERE EXISTS (SELECT 1 FROM Accounts a WHERE a.branch_id = b.branch_id);
 
-- 19. Find branches with no accounts.
SELECT *
FROM Branches b
WHERE NOT EXISTS (SELECT 1 FROM Accounts a WHERE a.branch_id = b.branch_id);
 
-- 20. Find loans that have received at least one payment.
SELECT *
FROM Loans l
WHERE EXISTS (SELECT 1 FROM Loan_Payments lp WHERE lp.loan_id = l.loan_id);
 
-- 21. Find customers in Chennai branches using IN.
SELECT customer_name
FROM Customers
WHERE customer_id IN (
    SELECT a.customer_id FROM Accounts a
    WHERE a.branch_id IN (SELECT branch_id FROM Branches WHERE city = 'Chennai')
);
 
-- 22. Find customers not having loans using NOT IN.
SELECT customer_name
FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Loans);
 
-- 23. Find accounts with balances greater than ANY account in Mumbai.
SELECT *
FROM Accounts
WHERE balance > ANY (
    SELECT balance FROM Accounts
    WHERE branch_id IN (SELECT branch_id FROM Branches WHERE city = 'Mumbai')
);
 
-- 24. Find accounts with balances greater than ALL savings accounts.
SELECT *
FROM Accounts
WHERE balance > ALL (
    SELECT balance FROM Accounts WHERE account_type = 'Savings'
);
 
-- 25. Find branches whose average balance exceeds ALL branch averages (i.e. the branch with the single highest average balance).
SELECT a.branch_id, AVG(a.balance) AS avg_balance
FROM Accounts a
GROUP BY a.branch_id
HAVING AVG(a.balance) > ALL (
    SELECT AVG(a2.balance)
    FROM Accounts a2
    WHERE a2.branch_id <> a.branch_id
    GROUP BY a2.branch_id
);
 
-- 26. Find the customer with the highest total transaction amount.
SELECT c.customer_name, cust_totals.total_amount
FROM Customers c
JOIN (
    SELECT a.customer_id, SUM(t.amount) AS total_amount
    FROM Accounts a JOIN Transactions t ON a.account_no = t.account_no
    GROUP BY a.customer_id
) cust_totals ON c.customer_id = cust_totals.customer_id
WHERE cust_totals.total_amount = (
    SELECT MAX(total_amount) FROM (
        SELECT SUM(t2.amount) AS total_amount
        FROM Accounts a2 JOIN Transactions t2 ON a2.account_no = t2.account_no
        GROUP BY a2.customer_id
    ) all_totals
);
 
-- 27. Find customers who have both an account and a loan.
SELECT customer_name
FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Accounts)
  AND customer_id IN (SELECT customer_id FROM Loans);
 
-- 28. Display the branch with the highest total deposits.
SELECT branch_id, deposit_total
FROM (
    SELECT a.branch_id, SUM(t.amount) AS deposit_total
    FROM Accounts a
    JOIN Transactions t ON a.account_no = t.account_no
    WHERE t.transaction_type = 'Deposit'
    GROUP BY a.branch_id
) branch_deposits
WHERE deposit_total = (
    SELECT MAX(deposit_total) FROM (
        SELECT a2.branch_id, SUM(t2.amount) AS deposit_total
        FROM Accounts a2
        JOIN Transactions t2 ON a2.account_no = t2.account_no
        WHERE t2.transaction_type = 'Deposit'
        GROUP BY a2.branch_id
    ) all_branch_deposits
);
 
-- 29. Find customers whose loan amount is above the average loan amount.
SELECT c.customer_name, l.loan_amount
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
WHERE l.loan_amount > (SELECT AVG(loan_amount) FROM Loans);
 
-- 30. Generate a customer banking report using subqueries.
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    (SELECT COUNT(*) FROM Accounts a WHERE a.customer_id = c.customer_id) AS num_accounts,
    (SELECT COALESCE(SUM(a.balance),0) FROM Accounts a WHERE a.customer_id = c.customer_id) AS total_balance,
    (SELECT COALESCE(SUM(t.amount),0)
        FROM Accounts a JOIN Transactions t ON a.account_no = t.account_no
        WHERE a.customer_id = c.customer_id) AS total_transactions,
    (SELECT COALESCE(SUM(l.loan_amount),0) FROM Loans l WHERE l.customer_id = c.customer_id) AS total_loan_amount,
    (SELECT COALESCE(SUM(lp.payment_amount),0)
        FROM Loans l JOIN Loan_Payments lp ON l.loan_id = lp.loan_id
        WHERE l.customer_id = c.customer_id) AS total_loan_paid
FROM Customers c
ORDER BY c.customer_id;