-- CREATE DATABASE

CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- CREATE TABLES (WITH PRIMARY KEY / FOREIGN KEY)

CREATE TABLE Categories (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);
 
CREATE TABLE Suppliers (
    supplier_id   INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    city          VARCHAR(50)
);
 
CREATE TABLE Products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(100) NOT NULL,
    category_id   INT,
    supplier_id   INT,
    price         DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);
 
CREATE TABLE Customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email         VARCHAR(100),
    city          VARCHAR(50)
);
 
CREATE TABLE Employees (
    employee_id   INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    position      VARCHAR(50)
);
 
CREATE TABLE Shippers (
    shipper_id    INT PRIMARY KEY AUTO_INCREMENT,
    shipper_name  VARCHAR(100) NOT NULL
);
 
CREATE TABLE Orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT,
    employee_id   INT,
    shipper_id    INT,
    order_date    DATE NOT NULL,
    status        VARCHAR(20) DEFAULT 'Completed',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (shipper_id)  REFERENCES Shippers(shipper_id)
);
 
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id      INT,
    product_id    INT,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- INSERT REALISTIC DATA

-- Categories 
INSERT INTO Categories (category_name) VALUES
('Electronics'), ('Clothing'), ('Books'), ('Home & Kitchen'), ('Toys'), ('Sports');
 
-- Suppliers 
INSERT INTO Suppliers (supplier_name, contact_email, city) VALUES
('TechSource Pvt Ltd',      'tech@gmail.com',    'Chennai'),
('FashionHub Traders',      'fashion@gmail.com',    'Mumbai'),
('BookWorld Distributors',  'bookworld@gmail.com',      'Delhi'),
('HomeEssentials Co',       'essential@gmail.com',       'Bangalore'),
('PlayTime Imports',        'play@gmail.com',      'Kochi');
 
-- Products 
INSERT INTO Products (product_name, category_id, supplier_id, price) VALUES
('Wireless Mouse',          1, 1,  799.00),
('Bluetooth Headphones',    1, 1, 2499.00),
('Smartwatch',              1, 1, 4999.00),
('Men''s Cotton T-Shirt',   2, 2,  499.00),
('Women''s Denim Jeans',    2, 2, 1599.00),
('Winter Jacket',           2, 2, 2999.00),
('The Alchemist (Book)',    3, 3,  399.00),
('Atomic Habits (Book)',    3, 3,  599.00),
('Non-Stick Frying Pan',    4, 4,  899.00),
('Electric Kettle',         4, 4, 1299.00),
('LED Table Lamp',          4, 4,  699.00),
('Building Blocks Set',     5, 2,  999.00),
('Remote Control Car',      5, 2, 1499.00);
 
-- Customers 
INSERT INTO Customers (customer_name, email, city) VALUES
('Ravi Kumar',              'ravi@gmail.com',      'Chennai'),
('Ananya Sharma',           'ananya@gmail.com',   'Bangalore'),
('Mohammed Iqbal',          'mohammed@gmail.com',      'Hyderabad'),
('Priya Nair',              'priya@gmail.com',       'Kochi'),
('Arjun Reddy',             'arjun@gmail.com',      'Chennai'),
('Sneha Gupta',             'sneha@gmail.com',      'Delhi'),
('Karthik Subramanian',     'karthik@gmail.com',    'Chennai'),
('Divya Menon',             'divya@gmail.com',      'Mumbai');
 
-- Employees
INSERT INTO Employees (employee_name, position) VALUES
('Suresh Babu',   'Sales Executive'),
('Lakshmi Iyer',  'Sales Executive'),
('Vikram Singh',  'Sales Manager');
 
-- Shippers
INSERT INTO Shippers (shipper_name) VALUES
('Speedy Logistics'), ('BlueDart Express'), ('QuickShip Cargo');
 
-- Orders
INSERT INTO Orders (customer_id, employee_id, shipper_id, order_date, status) VALUES
(1, 1, 1, '2026-05-03', 'Completed'),  -- order 1
(2, 2, 2, '2026-05-10', 'Completed'),  -- order 2
(1, 1, 1, '2026-05-15', 'Completed'),  -- order 3
(3, 3, 3, '2026-05-20', 'Completed'),  -- order 4
(4, 2, 2, '2026-06-02', 'Completed'),  -- order 5
(5, 1, 1, '2026-06-08', 'Completed'),  -- order 6
(2, 2, 3, '2026-06-14', 'Completed'),  -- order 7
(6, 3, 1, '2026-06-20', 'Completed'),  -- order 8
(1, 1, 2, '2026-07-01', 'Completed'),  -- order 9  
(4, 2, 1, '2026-07-05', 'Completed'),  -- order 10 
(8, 3, 3, '2026-07-10', 'Completed'),  -- order 11
(5, 1, 2, '2026-07-15', 'Completed'); -- order 12
 
-- Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES
-- Order 1
(1, 1, 2, 799.00), (1, 7, 1, 399.00),
-- Order 2 
(2, 4, 3, 499.00), (2, 9, 1, 899.00),
-- Order 3 
(3, 3, 1, 4999.00),
-- Order 4 
(4, 5, 2, 1599.00), (4, 8, 2, 599.00),
-- Order 5
(5, 2, 1, 2499.00),
-- Order 6 
(6, 6, 1, 2999.00), (6, 10, 1, 1299.00),
-- Order 7 
(7, 12, 3, 999.00),
-- Order 8 
(8, 1, 5, 799.00), (8, 4, 2, 499.00),
-- Order 9 
(9, 1, 1, 799.00), (9, 2, 1, 2499.00), (9, 7, 2, 399.00), (9, 9, 1, 899.00),
-- Order 10 
(10, 3, 1, 4999.00), (10, 6, 1, 2999.00),
-- Order 11 
(11, 8, 1, 599.00),
-- Order 12 
(12, 13, 2, 1499.00);

-- JOIN QUESTIONS & QUERIES

-- 1. Display all customers with their orders.
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
 
-- 2. Display order details with customer names.
SELECT o.order_id, o.order_date, c.customer_name, o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
 
-- 3. Show every product with its category.
SELECT p.product_id, p.product_name, cat.category_name
FROM Products p
JOIN Categories cat ON p.category_id = cat.category_id;
 
-- 4. Display products with supplier names.
SELECT p.product_name, s.supplier_name
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id;
 
-- 5. Show orders handled by each employee.
SELECT e.employee_name, o.order_id, o.order_date
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
ORDER BY e.employee_name;
 
-- 6. Display orders with shipper names.
SELECT o.order_id, o.order_date, sh.shipper_name
FROM Orders o
JOIN Shippers sh ON o.shipper_id = sh.shipper_id;
 
-- 7. Show customers who placed at least one order.
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;
 
-- 8. Display products purchased in each order.
SELECT o.order_id, p.product_name, oi.quantity
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
ORDER BY o.order_id;
 
-- 9. Display product name and quantity ordered.
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_ordered
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_name;
 
-- 10. Display employee names and customer names.
SELECT DISTINCT e.employee_name, c.customer_name
FROM Orders o
JOIN Employees e ON o.employee_id = e.employee_id
JOIN Customers c ON o.customer_id = c.customer_id
ORDER BY e.employee_name;
 
-- 11. Display customer, order, product, quantity and price.
SELECT c.customer_name, o.order_id, p.product_name, oi.quantity, oi.unit_price
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
ORDER BY o.order_id;
 
-- 12. Display supplier name with products sold.
SELECT s.supplier_name, p.product_name, SUM(oi.quantity) AS units_sold
FROM Suppliers s
JOIN Products p ON s.supplier_id = p.supplier_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY s.supplier_name, p.product_name
ORDER BY s.supplier_name;
 
-- 13. Display category-wise product count.
SELECT cat.category_name, COUNT(p.product_id) AS product_count
FROM Categories cat
LEFT JOIN Products p ON cat.category_id = p.category_id
GROUP BY cat.category_name;
 
-- 14. Find total orders for each customer.
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;
 
-- 15. Find total sales by employee.
SELECT e.employee_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY e.employee_name
ORDER BY total_sales DESC;
 
-- 16. Find total revenue by category.
SELECT cat.category_name, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM Categories cat
JOIN Products p ON cat.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY cat.category_name
ORDER BY total_revenue DESC;
 
-- 17. Display the most expensive product in every category.
SELECT cat.category_name, p.product_name, p.price
FROM Products p
JOIN Categories cat ON p.category_id = cat.category_id
WHERE p.price = (
    SELECT MAX(p2.price) FROM Products p2 WHERE p2.category_id = p.category_id
);
 
-- 18. Find products never ordered.
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
 
-- 19. Find customers who never placed orders.
SELECT c.customer_id, c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
 
-- 20. Display suppliers without products.
SELECT s.supplier_id, s.supplier_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
WHERE p.product_id IS NULL;
 
-- 21. Find top five customers by spending.
SELECT c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;
 
-- 22. Display monthly sales by employee.
SELECT e.employee_name,
       DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       SUM(oi.quantity * oi.unit_price) AS monthly_sales
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY e.employee_name, sales_month
ORDER BY e.employee_name, sales_month;
 
-- 23. Find the best-selling product (by quantity sold).
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;
 
-- 24. Display supplier-wise revenue.
SELECT s.supplier_name, SUM(oi.quantity * oi.unit_price) AS supplier_revenue
FROM Suppliers s
JOIN Products p ON s.supplier_id = p.supplier_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY s.supplier_name
ORDER BY supplier_revenue DESC;
 
-- 25. Find average order value per customer.
SELECT c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY avg_order_value DESC;
 
-- 26. Display orders with more than three products.
SELECT o.order_id, COUNT(oi.product_id) AS product_count
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING COUNT(oi.product_id) > 3;
 
-- 27. Find customers ordering from multiple categories.
SELECT c.customer_name, COUNT(DISTINCT p.category_id) AS category_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT p.category_id) > 1;
 
-- 28. Display categories with no sales.
SELECT cat.category_name
FROM Categories cat
LEFT JOIN Products p ON cat.category_id = p.category_id
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY cat.category_name
HAVING SUM(oi.quantity) IS NULL;
 
-- 29. Display the highest-value order.
SELECT o.order_id, c.customer_name, o.order_date,
       SUM(oi.quantity * oi.unit_price) AS order_value
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name, o.order_date
ORDER BY order_value DESC
LIMIT 1;
 
-- 30. Generate a complete invoice report using all tables.
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.city AS customer_city,
    e.employee_name AS handled_by,
    sh.shipper_name,
    p.product_name,
    cat.category_name,
    s.supplier_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM Orders o
JOIN Customers c   ON o.customer_id  = c.customer_id
JOIN Employees e   ON o.employee_id  = e.employee_id
JOIN Shippers sh   ON o.shipper_id   = sh.shipper_id
JOIN Order_Items oi ON o.order_id    = oi.order_id
JOIN Products p    ON oi.product_id  = p.product_id
JOIN Categories cat ON p.category_id = cat.category_id
JOIN Suppliers s   ON p.supplier_id  = s.supplier_id
ORDER BY o.order_id;
 
 
 