
CREATE DATABASE scd_assignment;
USE scd_assignment;

-- 1. Create the three dimension tables

DROP TABLE IF EXISTS DimProduct_Type1;
CREATE TABLE DimProduct_Type1 (
    ProductID   INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category    VARCHAR(50)  NOT NULL,
    Price       DECIMAL(10,2) NOT NULL,
    Supplier    VARCHAR(50)  NOT NULL
);

DROP TABLE IF EXISTS DimProduct_Type2;
CREATE TABLE DimProduct_Type2 (
    ProductID   INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Category    VARCHAR(50)  NOT NULL,
    Price       DECIMAL(10,2) NOT NULL,
    Supplier    VARCHAR(50)  NOT NULL,
    StartDate   DATE NOT NULL,
    EndDate     DATE NULL,
    IsCurrent   TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (ProductID, StartDate)
);

DROP TABLE IF EXISTS DimProduct_Type3;
CREATE TABLE DimProduct_Type3 (
    ProductID        INT PRIMARY KEY,
    ProductName      VARCHAR(100) NOT NULL,
    Category         VARCHAR(50)  NOT NULL,
    PreviousCategory VARCHAR(50)  NULL,
    Price            DECIMAL(10,2) NOT NULL,
    PreviousPrice    DECIMAL(10,2) NULL,
    Supplier         VARCHAR(50)  NOT NULL,
    PreviousSupplier VARCHAR(50)  NULL
);

-- 2. Load the baseline 10 products into each table

INSERT INTO DimProduct_Type1 (ProductID, ProductName, Category, Price, Supplier) VALUES
(101,'Wireless Mouse','Electronics',799,'TechSource'),
(102,'Office Chair','Furniture',4500,'ComfortWorks'),
(103,'Notebook Set','Stationery',150,'PaperPlus'),
(104,'LED Monitor','Electronics',9500,'TechSource'),
(105,'Standing Desk','Furniture',12000,'ComfortWorks'),
(106,'Backpack','Accessories',1200,'UrbanGear'),
(107,'Water Bottle','Accessories',350,'UrbanGear'),
(108,'Desk Lamp','Furniture',899,'ComfortWorks'),
(109,'Bluetooth Speaker','Electronics',2500,'TechSource'),
(110,'Notebook Cover','Stationery',99,'PaperPlus');

INSERT INTO DimProduct_Type2 (ProductID, ProductName, Category, Price, Supplier, StartDate, EndDate, IsCurrent) VALUES
(101,'Wireless Mouse','Electronics',799,'TechSource','2026-01-01',NULL,1),
(102,'Office Chair','Furniture',4500,'ComfortWorks','2026-01-01',NULL,1),
(103,'Notebook Set','Stationery',150,'PaperPlus','2026-01-01',NULL,1),
(104,'LED Monitor','Electronics',9500,'TechSource','2026-01-01',NULL,1),
(105,'Standing Desk','Furniture',12000,'ComfortWorks','2026-01-01',NULL,1),
(106,'Backpack','Accessories',1200,'UrbanGear','2026-01-01',NULL,1),
(107,'Water Bottle','Accessories',350,'UrbanGear','2026-01-01',NULL,1),
(108,'Desk Lamp','Furniture',899,'ComfortWorks','2026-01-01',NULL,1),
(109,'Bluetooth Speaker','Electronics',2500,'TechSource','2026-01-01',NULL,1),
(110,'Notebook Cover','Stationery',99,'PaperPlus','2026-01-01',NULL,1);

INSERT INTO DimProduct_Type3 (ProductID, ProductName, Category, PreviousCategory, Price, PreviousPrice, Supplier, PreviousSupplier) VALUES
(101,'Wireless Mouse','Electronics',NULL,799,NULL,'TechSource',NULL),
(102,'Office Chair','Furniture',NULL,4500,NULL,'ComfortWorks',NULL),
(103,'Notebook Set','Stationery',NULL,150,NULL,'PaperPlus',NULL),
(104,'LED Monitor','Electronics',NULL,9500,NULL,'TechSource',NULL),
(105,'Standing Desk','Furniture',NULL,12000,NULL,'ComfortWorks',NULL),
(106,'Backpack','Accessories',NULL,1200,NULL,'UrbanGear',NULL),
(107,'Water Bottle','Accessories',NULL,350,NULL,'UrbanGear',NULL),
(108,'Desk Lamp','Furniture',NULL,899,NULL,'ComfortWorks',NULL),
(109,'Bluetooth Speaker','Electronics',NULL,2500,NULL,'TechSource',NULL),
(110,'Notebook Cover','Stationery',NULL,99,NULL,'PaperPlus',NULL);

-- 3. SCD Type 1 — direct UPDATE, no history kept

UPDATE DimProduct_Type1 SET Price    = 699        WHERE ProductID = 101;
UPDATE DimProduct_Type1 SET Supplier = 'VisionTech' WHERE ProductID = 104;
UPDATE DimProduct_Type1 SET Category = 'Travel'     WHERE ProductID = 106;
UPDATE DimProduct_Type1 SET Price    = 749          WHERE ProductID = 108;

SELECT * FROM DimProduct_Type1 ORDER BY ProductID;

-- 4. SCD Type 2 — expire-then-insert

UPDATE DimProduct_Type2 SET EndDate = CURDATE(), IsCurrent = 0
WHERE ProductID = 101 AND IsCurrent = 1;
INSERT INTO DimProduct_Type2 (ProductID, ProductName, Category, Price, Supplier, StartDate, EndDate, IsCurrent)
VALUES (101,'Wireless Mouse','Electronics',699,'TechSource',CURDATE(),NULL,1);

UPDATE DimProduct_Type2 SET EndDate = CURDATE(), IsCurrent = 0
WHERE ProductID = 104 AND IsCurrent = 1;
INSERT INTO DimProduct_Type2 (ProductID, ProductName, Category, Price, Supplier, StartDate, EndDate, IsCurrent)
VALUES (104,'LED Monitor','Electronics',9500,'VisionTech',CURDATE(),NULL,1);

UPDATE DimProduct_Type2 SET EndDate = CURDATE(), IsCurrent = 0
WHERE ProductID = 106 AND IsCurrent = 1;
INSERT INTO DimProduct_Type2 (ProductID, ProductName, Category, Price, Supplier, StartDate, EndDate, IsCurrent)
VALUES (106,'Backpack','Travel',1200,'UrbanGear',CURDATE(),NULL,1);

UPDATE DimProduct_Type2 SET EndDate = CURDATE(), IsCurrent = 0
WHERE ProductID = 108 AND IsCurrent = 1;
INSERT INTO DimProduct_Type2 (ProductID, ProductName, Category, Price, Supplier, StartDate, EndDate, IsCurrent)
VALUES (108,'Desk Lamp','Furniture',749,'ComfortWorks',CURDATE(),NULL,1);

-- Query 1: current version of every product
SELECT * FROM DimProduct_Type2 WHERE IsCurrent = 1 ORDER BY ProductID;

-- Query 2: full history for ProductID 101
SELECT * FROM DimProduct_Type2 WHERE ProductID = 101 ORDER BY StartDate;

-- 5. SCD Type 3 — shift old value into "Previous" column

UPDATE DimProduct_Type3
SET PreviousPrice = Price, Price = 699
WHERE ProductID = 101;

UPDATE DimProduct_Type3
SET PreviousSupplier = Supplier, Supplier = 'VisionTech'
WHERE ProductID = 104;

UPDATE DimProduct_Type3
SET PreviousCategory = Category, Category = 'Travel'
WHERE ProductID = 106;

UPDATE DimProduct_Type3
SET PreviousPrice = Price, Price = 749
WHERE ProductID = 108;

SELECT * FROM DimProduct_Type3 ORDER BY ProductID;

-- 6. Query that only works correctly on Type 2

-- "What was the price of ProductID 101 before the most recent change?"
SELECT Price AS PriceBeforeMostRecentChange
FROM DimProduct_Type2
WHERE ProductID = 101 AND IsCurrent = 0
ORDER BY StartDate DESC
LIMIT 1;

