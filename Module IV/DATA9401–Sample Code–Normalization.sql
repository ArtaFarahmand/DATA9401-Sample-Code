-- Code to create tables in DB
CREATE TABLE parentAirlines (
	airlineID SERIAL NOT NULL,
	parentAirline VARCHAR(150),
	airline VARCHAR(150),
	aircraftType VARCHAR(150),
	currents INT,
	future INT,
	historic INT,
	total INT,
	orders INT,
	unitCost VARCHAR(50),
	totalCost VARCHAR(50),
	average decimal(2,2)
);

-- SELECT statment to create new tables 
CREATE TABLE Airlines
AS SELECT airlineID, parentAirline, airline
FROM parentAirlines;

CREATE TABLE airCraftType
AS SELECT airlineID, aircrafttype
FROM parentAirlines;

CREATE TABLE airCraftInventory
AS SELECT aircrafttype, currents, future, 
		  historic, total
FROM parentAirlines;

CREATE TABLE AircraftOrders
AS SELECT aircrafttype, orders, unitcost, 
		  totalcost, average
FROM parentAirlines;


-- Code for table alterations
ALTER TABLE parentAirlines
ALTER COLUMN average TYPE DECIMAL(10,2);

-- Code to define Primary and Foreign Keys
ALTER TABLE Airlines
ADD CONSTRAINT pk_airlineID PRIMARY KEY(airlineID);

ALTER TABLE aircrafttype
ADD CONSTRAINT pk_aircrafttype PRIMARY KEY(aircrafttype);

ALTER TABLE airCraftType
ADD CONSTRAINT fk_airlineID FOREIGN KEY (airlineID) 
REFERENCES airlines(airlineID);

ALTER TABLE airCraftInventory
ADD CONSTRAINT fk_aircrafttype FOREIGN KEY (aircrafttype) 
REFERENCES aircrafttype(aircrafttype);

ALTER TABLE AircraftOrders
ADD CONSTRAINT fk_aircrafttype FOREIGN KEY (aircrafttype) 
REFERENCES aircrafttype(aircrafttype);

--Code to remove duplicates (if i need it) SOLUTION A
SELECT aircrafttype, COUNT(aircrafttype)
FROM aircrafttype GROUP BY aircrafttype
HAVING COUNT(aircrafttype)>1 ORDER BY aircrafttype

DELETE FROM aircrafttype a USING aircrafttype b
WHERE a.airlineID < b.airlineID AND a.aircrafttype=b.aircrafttype;

-- Code to inner join 4 tables togather
SELECT airlines.airlineID, airlines.airline, 
aircrafttype.aircrafttype, aircraftinventory.currents,
aircraftorders.orders, aircraftorders.unitcost, 
aircraftorders.totalcost 
FROM airlines INNER JOIN aircrafttype
ON airlines.airlineID = aircrafttype.airlineID
INNER JOIN aircraftinventory
ON aircrafttype.aircrafttype = aircraftinventory.aircrafttype
INNER JOIN aircraftorders
ON aircraftinventory.aircrafttype = aircraftorders.aircrafttype;

-- code to inner join 4 tables and create a new table at the sametime
SELECT airlines.airlineID, airlines.airline, 
aircrafttype.aircrafttype, aircraftinventory.currents,
aircraftorders.orders, aircraftorders.unitcost, 
aircraftorders.totalcost 
INTO joinedAirlines
FROM airlines INNER JOIN aircrafttype
ON airlines.airlineID = aircrafttype.airlineID
INNER JOIN aircraftinventory
ON aircrafttype.aircrafttype = aircraftinventory.aircrafttype
INNER JOIN aircraftorders
ON aircraftinventory.aircrafttype = aircraftorders.aircrafttype;







SELECT * FROM parentAirlines
