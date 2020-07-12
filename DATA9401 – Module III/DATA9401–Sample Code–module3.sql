-- Code to Create the master table --

CREATE TABLE salesMaster (
	orderNumber INT,
	qunatityOrdered INT,
	priceEach INT,
	sales Int,
	orderDate DATE,
	status VARCHAR(50),
	productLine VARCHAR(100),
	customerName VARCHAR(250),
	phone VARCHAR(20),
	address VARCHAR(400),
	city VARCHAR(100),
	usState VARCHAR(100),
	postalCode VARCHAR(50),
	country VARCHAR(100)
);

-- Code to create two sub-tables --

CREATE TABLE orders AS
SELECT ordernumber, qunatityordered, priceeach, sales, orderDate, 
	   status, productLine 
FROM salesMaster
LIMIT 50;

CREATE TABLE customerInformation AS
SELECT orderNumber, customerName, address, city, usState, postalCode, phone
FROM salesMaster
LIMIT 50;

-- Code to alter table columns --

ALTER TABLE salesMaster
ALTER COLUMN priceEach TYPE NUMERIC(10,2);

ALTER TABLE salesMaster
ALTER COLUMN sales TYPE NUMERIC(10,2);

ALTER TABLE customerInformation
RENAME usstate TO provinceAndState;

ALTER TABLE customerInformation
RENAME postalCode TO zipCode;

ALTER TABLE customerInformation
ADD CONSTRAINT pk_orderNumber PRIMARY KEY(orderNumber);

ALTER TABLE orders
ADD CONSTRAINT fk_orderNumber FOREIGN KEY (orderNumber) 
REFERENCES customerInformation(orderNumber);

-- Code to update records --

UPDATE customerInformation
SET city = 'New York'
WHERE city = 'NYC';

-- Code to insert new record --

INSERT INTO customerInformation VALUES (
	10207,
	'CORE Shopping Centre',
	'324 8 Ave SW',
	'Calgary',
	'AB',
	'T2P 2Z2',
	'+14034414940'
);

INSERT INTO customerInformation VALUES (
	10209,
	'UNDRCARD Boxing Studio',
	'349 10 Ave SW',
	'Calgary',
	'AB',
	'T2R 0A5',
	'+15873563779'
);

INSERT INTO orders (orderNumber, priceEach) VALUES (
	10207,
	23.50
);

INSERT INTO orders (orderNumber, priceEach) VALUES (
	10209,
	26.50
);
-- Code to delete records form the table --

DELETE FROM customerInformation
WHERE customerName = 'UNDRCARD Boxing Studio';

DELETE FROM customerInformation
WHERE customerName = 'CORE Shopping Centre';

-- Code to create tables that have joins --

CREATE TABLE innerJoinTable AS
SELECT customerInformation.orderNumber, customerInformation.customerName,
	   orders.qunatityordered, orders.priceEach, orders.sales, orders.orderDate
FROM customerInformation INNER JOIN orders 
ON customerInformation.orderNumber = orders.orderNumber; 

CREATE TABLE leftOuterJoinTable AS
SELECT customerInformation.orderNumber, customerInformation.customerName,
	   orders.qunatityordered, orders.priceEach, orders.sales, orders.orderDate
FROM customerInformation LEFT OUTER JOIN orders 
ON customerInformation.orderNumber = orders.orderNumber; 

CREATE TABLE rightOuterJoinTable AS
SELECT customerInformation.orderNumber, customerInformation.customerName,
	   orders.qunatityordered, orders.priceEach, orders.sales, orders.orderDate
FROM customerInformation RIGHT OUTER JOIN orders 
ON customerInformation.orderNumber = orders.orderNumber; 

CREATE TABLE fullOuterJoinTable AS
SELECT customerInformation.orderNumber, customerInformation.customerName,
	   orders.qunatityordered, orders.priceEach, orders.sales, orders.orderDate
FROM customerInformation FULL OUTER JOIN orders 
ON customerInformation.orderNumber = orders.orderNumber; 

-- Code to create tables with union, intersect and except --

CREATE TABLE unionTable AS 
SELECT orderNumber, priceEach
FROM Orders
UNION 
SELECT orderNumber, qunatityordered
FROM Orders;

CREATE TABLE intersectTable AS 
SELECT orderNumber,qunatityordered, priceEach
FROM Orders
INTERSECT
SELECT orderNumber, qunatityordered, priceEach
FROM Orders
WHERE priceEach >=94;

CREATE TABLE ExceptTable AS 
SELECT orderNumber,qunatityordered, priceEach
FROM Orders
EXCEPT
SELECT orderNumber, qunatityordered, priceEach
FROM Orders
WHERE priceEach <=60;


-- Code to view the results of the query --

SELECT * FROM salesMaster;
SELECT * FROM orders;
SELECT * FROM customerInformation;
SELECT * FROM customerInformation
WHERE customerName = 'CORE Shopping Centre';
SELECT * FROM customerInformation
WHERE customerName = 'UNDRCARD Boxing Studio';
SELECT * FROM innerJoinTable;
SELECT * FROM leftOuterJoinTable;
SELECT * FROM rightOuterJoinTable;
SELECT * FROM fullOuterJoinTable;
SELECT * FROM unionTable;
SELECT * FROM intersectTable;
SELECT * FROM exceptTable;