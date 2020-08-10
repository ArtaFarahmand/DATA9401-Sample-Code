-- RAW Data Table --

/* CSV file will be imported into this table
process maybe different for other server platforms */

CREATE TABLE rawDATA (
	fleetID VARCHAR(100),
	parentAirline VARCHAR(250),
	airline VARCHAR(250),
	aircraftType VARCHAR(250),
	currentOrder INT,
	futureOrder INT,
	historicOrder INT,
	totalOrders INT,
	orders INT,
	unitCost MONEY,
	totalCost MONEY
);

/* code to update fleetID with based on airline */
UPDATE rawData 
SET fleetID = CASE 
	WHEN parentairline = 'Aegean Airlines' THEN 'Aegean01'
	WHEN parentairline = 'Aeroflot' THEN 'Aero02'
	WHEN parentairline = 'Aerolineas Argentinas' THEN 'Aerolineas03'
	WHEN parentairline = 'Air Algerie' THEN 'Air04'
	WHEN parentairline = 'Air Arabia' THEN 'Air05'
	WHEN parentairline = 'Air Astana' THEN 'Air06'
	WHEN parentairline = 'Air Berlin' THEN 'Air07'
	WHEN parentairline = 'Air Canada' THEN 'Air08'
	WHEN parentairline = 'Air China' THEN 'Air09'
	WHEN parentairline = 'Air Europa' THEN 'Air10'
	WHEN parentairline = 'Air France/KLM' THEN 'Air11'
	WHEN parentairline = 'Air India' THEN 'Air12'
	WHEN parentairline = 'Air Malta' THEN 'Air13'
	WHEN parentairline = 'Air Mauritius' THEN 'Air14'
	WHEN parentairline = 'Air Nambia' THEN 'Air15'
	WHEN parentairline = 'Air Newzealannd' THEN 'Air16'
	WHEN parentairline = 'Air Transat' THEN 'Air17'
	WHEN parentairline = 'Air Transport International' THEN 'AirTransportI18'
	WHEN parentairline = 'Air Transport Service' THEN 'AirTransportS18'
	WHEN parentairline = 'Air Wisconsin' THEN 'Air19'
	WHEN parentairline = 'AirAsia' THEN 'Air20'
	WHEN parentairline = 'Alaska Airlines' THEN 'Air21'
	WHEN parentairline = 'Alitalia' THEN 'Air22'
	WHEN parentairline = 'All Nippon Airlways' THEN 'Air23'
	WHEN parentairline = 'Allegiant Air' THEN 'Air24'
	WHEN parentairline = 'American Airlines' THEN 'Air25'
	ELSE 'noID'
	END
WHERE parentairline IN ('Aegean Airlines', 'Aeroflot', 'Aerolineas Argentinas',
	 'Air Algerie', 'Air Arabia','Air Arabia','Air Astana', 'Air Berlin',
	 'Air Canada','Air China','Air Europa','Air France/KLM', 'Air India',
	 'Air Malta','Air Mauritius','Air Nambia','Air Newzealannd','Air Transat',
	 'Air Transport International','Air Transport Service',
	 'Air Wisconsin','AirAsia',
	 'Alaska Airlines','Alitalia','All Nippon Airlways','Allegiant Air',
	 'American Airlines');

/* To simplify data set i am going to delete rows where fleetID is NULL */
DELETE FROM rawData WHERE fleetID is NULL;
DELETE FROM airlines WHERE parentairline='';

-- seperating the table into 1NF, 2NF and 3NF --

/* 1NF table - removing repeating groups - */

/* Remove repeating groups in postgresql */
CREATE TABLE airlines AS
SELECT *, SPLIT_PART(parentairline::TEXT, '/', 1)::VARCHAR(250) AS parentairlineraw
FROM rawData
UNION
SELECT *, SPLIT_PART(parentairline::TEXT, '/', 2)::VARCHAR(250) AS parentairlineraw
FROM rawData;


CREATE TABLE airlines1NF AS
SELECT fleetID, parentairlineraw, airline, aircrafttype, currentorder, futureorder, historicorder, orders, totalorders
FROM airlines;

/* We no longer need the airlines tabel after removing our repeating groups after creating the airlines1NF which will be renamed to airlines */
DROP TABLE airlines;

/* Resolve parentairline issues after removing the columns */
ALTER TABLE airlines
RENAME COLUMN parentairlineraw TO parentairline;

UPDATE airlines
SET fleetID = 'KLM12'
WHERE parentairline = 'KLM';

UPDATE airlines
SET parentairline = CASE 
	WHEN airline = 'Air France' THEN parentairline = 'Air France'
	WHEN airline = 'KLM' THEN parentairline = 'KLM'
	WHEN airline = 'HOP!' THEN parentairline = 'KLM'
	WHEN airline = 'KLM cityhopper' THEN parentairline = 'KLM'
	WHEN airline = 'Martinair' THEN parentairline = 'Air France'
	WHEN airline = 'Transavia' THEN parentairline = 'Air France'
	WHEN airline = 'Transavia France' THEN parentairline = 'Air France'
	END
WHERE airline IN ('Air France', 'KLM', 'HOP!', 'KLM cityhopper', 
				  'Martinair', 'Transavia', 'Transavia France');
				  
UPDATE airlines
SET parentairline = 'KLM'
WHERE parentairline = 'false';

UPDATE airlines
SET parentairline = 'Air France'
WHERE airline = 'Air France';

UPDATE airlines
SET parentairline = 'KLM'
WHERE airline = 'KLM Cityhopper';

/* 2NF table - removing duplicates and partial dependencies  */

CREATE TABLE parentAirline AS
SELECT fleetID, parentAirline, airline
FROM airlines;

CREATE TABLE aircraftOrders AS
SELECT fleetID, currentOrder, futureOrder, orders, totalOrders, aircraftType
FROM airlines;

/* Count duplicates for parentAirline */
SELECT * FROM (
	SELECT *, COUNT(*)
	OVER (
		PARTITION BY fleetID, airline
	)AS COUNT FROM parentAirline) tableWidthCount
	WHERE tableWidthCount.count > 1;
	
/* Delete duplicates for parentAirline */
ALTER TABLE parentAirline
ADD COLUMN tempID SERIAL;

DELETE FROM parentAirline
WHERE tempID IN (
	SELECT tempID
	FROM (
		SELECT tempID,
		ROW_NUMBER() OVER w AS ROW_NUM
		FROM parentAirline WINDOW w AS (
			PARTITION BY parentAirline ORDER BY parentAirline
		)
	) T
	WHERE T.ROW_NUM > 1);

/* 3NF table - remove transative dependencies */
CREATE TABLE aircraftType AS
SELECT fleetID, aircraftType
FROM airlines;

CREATE TABLE unitCost AS
SELECT aircraftType, unitCost
FROM rawDATA;

ALTER TABLE aircraftType
ADD COLUMN aircraftTypeID SERIAL;

/* Count duplicates for aircraftType and unitCost */
SELECT * FROM (
	SELECT *, COUNT(*)
	OVER (
		PARTITION BY fleetID, aircraftType
	)AS COUNT FROM aircraftType) tableWidthCount
	WHERE tableWidthCount.count > 1;
	
SELECT * FROM (
	SELECT *, COUNT(*)
	OVER (
		PARTITION BY aircraftTypeID, aircraftType
	)AS COUNT FROM unitCost) tableWidthCount
	WHERE tableWidthCount.count > 1;

/* Delete duplicates for aircraftType & unitCost */

DELETE FROM aircraftType
WHERE aircraftTypeID IN (
	SELECT aircraftTypeID
	FROM (
		SELECT aircraftTypeID,
		ROW_NUMBER() OVER w AS ROW_NUM
		FROM aircraftType WINDOW w AS (
			PARTITION BY aircraftType ORDER BY aircraftType
		)
	) T
	WHERE T.ROW_NUM > 1);

/* Add a tempID to be able to correctly remove dupliates */
ALTER TABLE unitCost
ADD COLUMN tempID SERIAL;

DELETE FROM unitCost
WHERE aircraftTypeID IN (
	SELECT aircraftTypeID
	FROM (
		SELECT aircraftTypeID,
		ROW_NUMBER() OVER w AS ROW_NUM
		FROM unitCost WINDOW w AS (
			PARTITION BY aircraftType ORDER BY aircraftType
		)
	) T
	WHERE T.ROW_NUM > 1);

ALTER TABLE aircraftType
DROP COLUMN fleetID;

/* Drop tempID as it is no longer needed */
ALTER TABLE unitCost
DROP COLUMN tempID;

-- Add aircraft type id to orders and unitCost table as an fk --

ALTER TABLE aircraftOrders 
ADD COLUMN aircraftTypeID INT;

ALTER TABLE unitCost 
ADD COLUMN aircraftTypeID INT;

UPDATE aircraftOrders
SET aircraftTypeID = CASE
	WHEN aircraftType= 'Airbus A350' THEN 21
	WHEN aircraftType= 'Antonov AN-124' THEN 22
	WHEN aircraftType= 'Airbus A340' THEN 25
	WHEN aircraftType= 'Airbus A350-900' THEN 27
	WHEN aircraftType= 'Airbus A380' THEN 29
	WHEN aircraftType= 'irkut MC-21' THEN 32
	WHEN aircraftType= 'sukhoi superjet 100' THEN 37
	WHEN aircraftType= 'Tupolev Tu-134' THEN 38
	WHEN aircraftType= 'Yakovlev Yak-42' THEN 40
	WHEN aircraftType= 'Viking Air DHC 6-400 Twin Otter' THEN 44
	WHEN aircraftType= 'Antonov An-148/An-158' THEN 49
	WHEN aircraftType= 'Boeing 777' THEN 53
	WHEN aircraftType= 'Ilyushin il-62' THEN 54
	WHEN aircraftType= 'Ilyushin il-96' THEN 55
	WHEN aircraftType= 'Tupolev Tu-154' THEN 67
	WHEN aircraftType= 'Tupolev Tu-204' THEN 68
	WHEN aircraftType= 'Tupolev Tu-214' THEN 69
	WHEN aircraftType= 'Airbus A310' THEN 70
	WHEN aircraftType= 'Boeing 787 Dreeamliner' THEN 81
	WHEN aircraftType= 'ATR 42/72' THEN 88
	WHEN aircraftType= 'Boeing 747' THEN 102
	WHEN aircraftType= 'Airbus A320' THEN 117
	WHEN aircraftType= 'Airbus A319' THEN 118
	WHEN aircraftType= 'Fokker F50/F60' THEN 126
	WHEN aircraftType= 'Airbus A300' THEN 131
	WHEN aircraftType= 'Saab 340' THEN 135
	WHEN aircraftType= 'Airbus A321' THEN 139
	WHEN aircraftType= 'Aérospatiale/BAC Concorde' THEN 148
	WHEN aircraftType= 'Bombardier CS300' THEN 169
	WHEN aircraftType= 'Embraer ERJ-170' THEN 171
	WHEN aircraftType= 'McDonnell Douglas DC-9' THEN 174
	WHEN aircraftType= 'COMAC C919' THEN 195
	WHEN aircraftType= 'comac ARJ21' THEN 211
	WHEN aircraftType= 'Boeing 757' THEN 221
	WHEN aircraftType= 'Boeing 767' THEN 222
	WHEN aircraftType= 'Airbus A318' THEN 231
	WHEN aircraftType= 'British Aerospace BAe 146/Avro RJ' THEN 259
	WHEN aircraftType= 'Fokker F70/F100' THEN 260
	WHEN aircraftType= 'McDonnell Douglas DC-10' THEN 261
	WHEN aircraftType= 'Canadair CRJ-1000' THEN 265
	WHEN aircraftType= 'McDonnell Douglas DC-8' THEN 280
	WHEN aircraftType= 'Embraer ERJ-190' THEN 283
	WHEN aircraftType= 'Lockheed L-1011 TriStar' THEN 308
	WHEN aircraftType= 'Boeing 737' THEN 310
	WHEN aircraftType= 'Boeing 727' THEN 326
	WHEN aircraftType= 'British Aerospace BAe ATP' THEN 330
	WHEN aircraftType= 'Dornier Do-328' THEN 333
	WHEN aircraftType= 'Airbus A330' THEN 341
	WHEN aircraftType= 'McDonnel Douglas MD-11' THEN 373
	WHEN aircraftType= 'Boeing 717' THEN 389
	WHEN aircraftType= 'McDonnel Douglas MD-90' THEN 403
	WHEN aircraftType= 'Canadair CRJ-100 Series' THEN 411
	WHEN aircraftType= 'Canadair CRJ-900' THEN 413
	WHEN aircraftType= 'Embraer' THEN 416
	END

ALTER TABLE aircraftOrders
DROP COLUMN aircraftType

UPDATE unitCost 
SET aircraftTypeID = CASE
	WHEN aircraftType= 'Airbus A350' THEN 21
	WHEN aircraftType= 'Antonov AN-124' THEN 22
	WHEN aircraftType= 'Airbus A340' THEN 25
	WHEN aircraftType= 'Airbus A350-900' THEN 27
	WHEN aircraftType= 'Airbus A380' THEN 29
	WHEN aircraftType= 'irkut MC-21' THEN 32
	WHEN aircraftType= 'sukhoi superjet 100' THEN 37
	WHEN aircraftType= 'Tupolev Tu-134' THEN 38
	WHEN aircraftType= 'Yakovlev Yak-42' THEN 40
	WHEN aircraftType= 'Viking Air DHC 6-400 Twin Otter' THEN 44
	WHEN aircraftType= 'Antonov An-148/An-158' THEN 49
	WHEN aircraftType= 'Boeing 777' THEN 53
	WHEN aircraftType= 'llyushin il-62' THEN 54
	WHEN aircraftType= 'llyushin il-96' THEN 55
	WHEN aircraftType= 'Tupolev Tu-154' THEN 67
	WHEN aircraftType= 'Tupolev Tu-204' THEN 68
	WHEN aircraftType= 'Tupolev Tu-214' THEN 69
	WHEN aircraftType= 'Airbus A310' THEN 70
	WHEN aircraftType= 'Boeing 787 Dreeamliner' THEN 81
	WHEN aircraftType= 'ATR 42/72' THEN 88
	WHEN aircraftType= 'Boeing 747' THEN 102
	WHEN aircraftType= 'Airbus A320' THEN 117
	WHEN aircraftType= 'Airbus A319' THEN 118
	WHEN aircraftType= 'Fokker F50/F60' THEN 126
	WHEN aircraftType= 'Airbus A300' THEN 131
	WHEN aircraftType= 'Saab 340' THEN 135
	WHEN aircraftType= 'Airbus A321' THEN 139
	WHEN aircraftType= 'Aérospatiale/BAC Concorde' THEN 148
	WHEN aircraftType= 'Bombardier CS300' THEN 169
	WHEN aircraftType= 'Embraer ERJ-170' THEN 171
	WHEN aircraftType= 'McDonnell Douglas DC-9' THEN 174
	WHEN aircraftType= 'COMAC C919' THEN 195
	WHEN aircraftType= 'comac ARJ21' THEN 211
	WHEN aircraftType= 'Boeing 757' THEN 221
	WHEN aircraftType= 'Boeing 767' THEN 222
	WHEN aircraftType= 'Airbus A318' THEN 231
	WHEN aircraftType= 'British Aerospace BAe 146/Avro RJ' THEN 259
	WHEN aircraftType= 'Fokker F70/F100' THEN 260
	WHEN aircraftType= 'McDonnell Douglas DC-10' THEN 261
	WHEN aircraftType= 'Canadair CRJ-1000' THEN 265
	WHEN aircraftType= 'McDonnell Douglas DC-8' THEN 280
	WHEN aircraftType= 'Embraer ERJ-190' THEN 283
	WHEN aircraftType= 'Lockheed L-1011 TriStar' THEN 308
	WHEN aircraftType= 'Boeing 737' THEN 310
	WHEN aircraftType= 'Boeing 727' THEN 326
	WHEN aircraftType= 'British Aerospace BAe ATP' THEN 330
	WHEN aircraftType= 'Dornier Do-328' THEN 333
	WHEN aircraftType= 'Airbus A330' THEN 341
	WHEN aircraftType= 'McDonnell Douglas MD-11' THEN 373
	WHEN aircraftType= 'Boeing 717' THEN 389
	WHEN aircraftType= 'McDonnell Douglas MD-90' THEN 403
	WHEN aircraftType= 'Canadair CRJ-100 Series' THEN 411
	WHEN aircraftType= 'Canadair CRJ-900' THEN 413
	WHEN aircraftType= 'Embraer' THEN 416
	WHEN aircraftType = 'Fokker F70 / F100' THEN 260
	WHEN aircraftType = 'Fokker F50 / F60' THEN 126
	WHEN aircraftType = 'Boeing 787' THEN 124
	WHEN aircraftType = 'Boeing 787 Dreamliner' THEN 81
	WHEN aircraftType = 'Airbus A350 XWB' THEN 187
	WHEN aircraftType = 'COMAC C919' THEN 195
	WHEN aircraftType = 'Embraer ERJ-145' THEN 416
	WHEN aircraftType = 'Ilyushin Il-96' THEN 55
	WHEN aircraftType = 'Irkut MC-21' THEN 32
	WHEN aircraftType = 'Sukhoi Superjet 100' THEN 37
	END

-- Defining my pk and fk --

ALTER TABLE parentAirline
ADD CONSTRAINT pk_fleetID PRIMARY KEY (fleetID);

ALTER TABLE aircraftType
ADD CONSTRAINT pk_aircraftTypeID PRIMARY KEY (aircraftTypeID);

ALTER TABLE aircraftOrders
ADD CONSTRAINT fk_fleetID FOREIGN KEY (fleetID) 
REFERENCES parentAirline(fleetID);

ALTER TABLE aircraftOrders
ADD CONSTRAINT fk_aircraftTypeID FOREIGN KEY (aircraftTypeID) 
REFERENCES aircraftType(aircraftTypeID);

ALTER TABLE unitCost
ADD CONSTRAINT fk_aircraftTypeID FOREIGN KEY (aircraftTypeID) 
REFERENCES aircraftType(aircraftTypeID);

/* special delete to remove rows with null values */
DELETE FROM aircraftOrders WHERE currentOrder IS NULL 
	AND futureOrder IS NULL 
	AND orders IS NULL 
	AND totalOrders IS NULL;

-- Create result table for aircraft purchases --

CREATE TABLE airlineAircraftOrders AS
SELECT parentairline.fleetID, parentairline.airline, 
	aircrafttype.aircraftType, aircraftorders.currentorder, 
	aircraftorders.totalOrders, unitCost.unitCost
FROM parentairline INNER JOIN aircraftorders
ON parentairline.fleetID = aircraftorders.fleetID
INNER JOIN aircrafttype
ON aircrafttype.aircraftTypeID = aircraftorders.aircraftTypeID
INNER JOIN unitCost
ON aircrafttype.aircraftTypeID = unitCost.aircraftTypeID
WHERE currentOrder IS NOT NULL OR totalOrders IS NOT NULL;

-- Replaced NULL values with 0 in the airlineAircraftOrders table --

UPDATE airlineAircraftOrders
SET currentOrder = 0 
WHERE currentOrder IS NULL;

UPDATE airlineAircraftOrders
SET totalOrders = 0 
WHERE totalOrders IS NULL;

-- SELECT statement to view results --
SELECT * FROM rawData;
SELECT * FROM airlines;
SELECT * FROM parentAirline;
SELECT * FROM aircraftType;
SELECT * FROM unitCost;
SELECT * FROM aircraftOrders;
SELECT * FROM airlineAircraftOrders;
