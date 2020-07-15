-- Load Flat File --

CREATE TABLE masterSales (
	orderID VARCHAR(15),
	orderDate VARCHAR(30),
	customerName VARCHAR(250),
	states VARCHAR(250),
	city VARCHAR(250),
	amount MONEY,
	profit INT,
	Quantity INT,
	category VARCHAR(250)
);

-- Flat File to 1NF --

/* 
Break table into two tables
	- Customer Information
	- Orders table
*/

CREATE TABLE customerInfo AS
SELECT orderID, customerName, states, city
FROM masterSales;

CREATE TABLE orders AS 
SELECT orderID, orderDate, amount, profit, quantity, category
FROM masterSales;
 

-- Flat File to 2NF --

/* 
check customerInfo table for duplicate recordes 
*/
SELECT customerName, COUNT(*)
FROM customerInfo GROUP BY customerName
HAVING COUNT(customerName)>1 ORDER BY customerName;

DELETE FROM customerInfo a USING customerInfo b
WHERE a.orderID < b.orderID AND a.customerName=b.customerName;

/* 
check orders table for duplicate recordes 
*/
SELECT orderID, COUNT(*)
FROM orders GROUP BY orderID
HAVING COUNT(orderID)>1 ORDER BY orderID;

SELECT category, COUNT(*)
FROM orders GROUP BY category
HAVING COUNT(category)>1 ORDER BY category;

/*
Add a catID calumn
*/
ALTER TABLE orders
ADD COLUMN catID INT;

/*
update catID calumn to be populated based on a condition
*/
UPDATE orders
SET catID = CASE 
	WHEN category='Furniture' THEN 1
	WHEN category='Clothing' THEN 2
	WHEN category='Electronics' THEN 3
	ELSE 0
END
WHERE category IN ('Furniture', 'Clothing', 'Electronics');

/*
Drop the category column from orders table
*/
ALTER TABLE orders
DROP COLUMN category;

/*
 Defining primary and foregin keys 
 */
ALTER TABLE customerInfo
ADD CONSTRAINT pk_orderID PRIMARY KEY (orderID);

ALTER TABLE orders
ADD CONSTRAINT fk_orderID FOREIGN KEY (orderID) 
REFERENCES customerInfo(orderID);

ALTER TABLE category
ADD CONSTRAINT pk_catID PRIMARY KEY (catID);

ALTER TABLE orders
ADD CONSTRAINT fk_catID FOREIGN KEY (catID) 
REFERENCES category(catID);

-- Flat File to 3NF --

/*
Define category table
*/
CREATE TABLE category AS
SELECT category, catID 
FROM orders 
WHERE catID=1 OR catID=2 OR catID=3

/*
Update category column for catID 3
*/
UPDATE category
SET category='Electronics'
WHERE catID=3;

-- Result table after normalization --

CREATE TABLE clothingSales AS 
SELECT customerInfo.orderID, customerInfo.customerName
	   , orders.orderDate, orders.amount, category.category
FROM customerInfo INNER JOIN orders
ON customerInfo.orderID = orders.orderID
INNER JOIN category
ON category.catID = orders.catID
WHERE orders.catID = 2;

CREATE TABLE ElectronicsSales AS 
SELECT customerInfo.orderID, customerInfo.customerName
	   , orders.orderDate, orders.amount, category.category
FROM customerInfo INNER JOIN orders
ON customerInfo.orderID = orders.orderID
INNER JOIN category
ON category.catID = orders.catID
WHERE orders.catID = 3;

CREATE TABLE FurnitureSales AS 
SELECT customerInfo.orderID, customerInfo.customerName
	   , orders.orderDate, orders.amount, category.category
FROM customerInfo INNER JOIN orders
ON customerInfo.orderID = orders.orderID
INNER JOIN category
ON category.catID = orders.catID
WHERE orders.catID = 1;

-- SELECT Statements to test results --

SELECT * FROM masterSales;
SELECT * FROM customerInfo;
SELECT * FROM category;
SELECT * FROM orders;
SELECT * FROM clothingSales;
SELECT * FROM electronicsSales;
SELECT * FROM furnitureSales;