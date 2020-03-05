CREATE TABLE NYAIRBNB (
	host_ID INT NOT NULL,
	host_Name VARCHAR(200),
	Neighbourhood_group VARCHAR(200)
);

INSERT INTO NYAIRBNB VALUES (
	2787,
	'John',
	'Brooklyn'
);

INSERT INTO NYAIRBNB VALUES (
	2845,
	'Jennifer',
	'Manhattan'
);

INSERT INTO NYAIRBNB VALUES (
	4632,
	'Elisabeth',
	'Manhattan'
);

SELECT * FROM NYAIRBNB;

CREATE TABLE NYAIRBNB_LOCATION (
	host_ID INT NOT NULL,
	Neighbourhood VARCHAR(200),
	Latitude NUMERIC(2,5) NOT NULL,
	Longitude NUMERIC(2,5) NOT NULL
);

INSERT INTO NYAIRBNB_LOCATION VALUES (
	2787,
	'John',
	'Kensington',
	40.64749,
	-73.97237
);

INSERT INTO NYAIRBNB_LOCATION VALUES (
	2845,
	'Jennifer',
	'Midtown',
	40.75362,
	-73.98377
);

INSERT INTO NYAIRBNB_LOCATION VALUES (
	4632,
	'Elisabeth',
	'Harlem',
	40.80902,
	-73.9419
);

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB INNER JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID;

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB LEFT JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID
ORDER BY neighbourhood

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB RIGHT JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID
ORDER BY neighbourhood

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB RIGHT JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID
ORDER BY host_name

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB RIGHT JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID
WHERE neighbourhood = 'Harlem';

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB FULL OUTER JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID;

SELECT NYAIRBNB.*, NYAIRBNB_Location.*
FROM NYAIRBNB FULL OUTER JOIN NYAIRBNB_Location ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID
WHERE neighbourhood = 'Harlem';

CREATE TABLE NYAIRBNB_RESULTS (
	host_ID INT NOT NULL,
	host_Name VARCHAR(200),
	Neighbourhood_group VARCHAR(200),
	Neighbourhood VARCHAR(200),
	Latitude DECIMAL(2,2) NOT NULL,
	Longitude DECIMAL(2,2) NOT NULL
);

INSERT INTO NYAIRBNB_RESULTS SELECT NYAIRBNB.host_ID, NYAIRBNB.host_Name, 
NYAIRBNB.Neighbourhood_group,  NYAIRBNB_Location.Neighbourhood, NYAIRBNB_Location.Latitude, NYAIRBNB_Location.Longitude
FROM NYAIRBNB RIGHT JOIN NYAIRBNB_Location 
ON NYAIRBNB.host_ID = NYAIRBNB_Location.host_ID
ORDER BY host_name

ALTER TABLE NYAIRBNB_RESULTS 
ALTER COLUMN Longitude  TYPE DECIMAL(5,2);

INSERT INTO NYAIRBNB VALUES (
	4869,
	'LisaRoxanne',
	'Brooklyn'
);

INSERT INTO NYAIRBNB VALUES (
	7192,
	'Laura',
	'Manhattan'
);

INSERT INTO NYAIRBNB VALUES (
	7322,
	'Chris',
	'Manhattan'
);

ALTER TABLE NYAIRBNB_LOCATION 
ALTER COLUMN Latitude  TYPE DECIMAL(5,2)

ALTER TABLE NYAIRBNB_LOCATION 
ALTER COLUMN Longitude  TYPE DECIMAL(5,2)

INSERT INTO NYAIRBNB_LOCATION VALUES (
	4869,
	'Clinton Hill',
	40.68514,
	-73.95976
);

INSERT INTO NYAIRBNB_LOCATION VALUES (
	7192,
	'East Harlem',
	40.79851,
	-73.94399
);

INSERT INTO NYAIRBNB_LOCATION VALUES (
	7322,
	'Murray Hill',
	40.74767,
	-73.975
);

ALTER TABLE nyairbnb_results 
ALTER COLUMN Latitude  TYPE Decimal(9,6);

ALTER TABLE nyairbnb_results 
ALTER COLUMN Longitude  TYPE Decimal(9,6);

SELECT * FROM nyairbnb_results;

UPDATE nyairbnb_results
SET latitude = 40.64749, longitude = -73.97237
WHERE host_name = 'John';

UPDATE nyairbnb_results
SET latitude = 40.75362, longitude = -73.98377
WHERE host_name = 'Jennifer';

UPDATE nyairbnb_results
SET latitude = 40.80902, longitude = -73.9419
WHERE host_name = 'Elisabeth';

UPDATE nyairbnb_results
SET latitude = 40.68514, longitude = -73.95976
WHERE host_name = 'LisaRoxanne';

UPDATE nyairbnb_results
SET latitude = 40.79851, longitude = -73.94399
WHERE host_name = 'Laura';

UPDATE nyairbnb_results
SET latitude = 40.74767, longitude = -73.975
WHERE host_name = 'Chris';

SELECT * FROM nyairbnb_results 
WHERE neighbourhood_group = 'Manhattan'
