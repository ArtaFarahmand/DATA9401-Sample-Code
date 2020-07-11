-- Code to create a stored procedure --

CREATE PROCEDURE sp_location (VARCHAR (200), VARCHAR (200), NUMERIC(9,6), NUMERIC(9,6))
LANGUAGE plpgsql AS $$
BEGIN
	CREATE TABLE manhattonneighbourhood AS
	SELECT host_name, neighbourhood, latitude, longitude 
	FROM nyairbnb_results
	WHERE neighbourhood = 'Manhattan';
	
	COMMIT;
END;
$$;

CREATE PROCEDURE sp_nyLocation (VARCHAR (200), VARCHAR (200), NUMERIC(9,6), NUMERIC(9,6))
LANGUAGE plpgsql AS $$
BEGIN
	CREATE TABLE brooklynneighbourhood AS
	SELECT host_name, neighbourhood, latitude, longitude 
	FROM nyairbnb_results
	WHERE neighbourhood = 'Brooklyn';
	
	COMMIT;
END;
$$;

-- Code to Execute a stored procedure --

CALL sp_location('Jennifer', 'Manhattan', 40.647490, -73.972370 );
CALL sp_nyLocation('LisaRoxanne', 'Brooklyn', 40.747670, -73.975000 );

-- Select statements to check if the stored procedure executed correctly --

SELECT * FROM nyairbnb_results
SELECT * FROM manhattonneighbourhood;
SELECT * FROM brooklynneighbourhood;

-- SQL built in Aggregate Functions -- 

SELECT * FROM studentMarks;
SELECT AVG(midtermexam) FROM studentMarks;
SELECT SUM(finalExam) FROM studentMarks;
SELECT COUNT(assignment1) FROM studentMarks;

-- SQL built in String Functions -- 

SELECT * FROM studentInfo;
SELECT UPPER(firstname), UPPER(lastname) FROM studentInfo;
SELECT LOWER(firstname), LOWER(lastname) FROM studentInfo;
SELECT LENGTH(firstname), LENGTH(lastname) FROM studentInfo;