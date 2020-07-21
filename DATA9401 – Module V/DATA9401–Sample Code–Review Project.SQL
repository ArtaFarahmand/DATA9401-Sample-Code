-- RAW data table --

CREATE TABLE studentMaster(
	studentID BIGINT,
	firstName VARCHAR(150),
	lastName VARCHAR(150),
	midTermExams NUMERIC(5,2),
	finalExam NUMERIC(5,2),
	cw1 NUMERIC(5,2),
	cw2 NUMERIC(5,2),
	totalPoints VARCHAR(150),
	studentAverage NUMERIC(5,2),
	grade VARCHAR(150)
);

-- Auto–populate the table from RAW Data studentMaster --

CREATE TABLE studentInformation AS 
SELECT studentID, firstname, lastname
FROM studentMaster;

CREATE TABLE studentCourseGrades AS 
SELECT studentID, midTermExams, finalExam, cw1, cw2
FROM studentMaster;

CREATE TABLE avgGrade AS
SELECT studentID, studentAverage
FROM studentMaster;

CREATE TABLE letterGrade AS
SELECT grade FROM studentMaster;

-- Alteration to the table --

ALTER TABLE studentCourseGrades
RENAME COLUMN cw1 TO assignmentOne;

ALTER TABLE studentCourseGrades
RENAME COLUMN cw2 TO assignmentTwo;

ALTER TABLE avgGrade 
RENAME COLUMN gradID TO gradeID;

ALTER TABLE letterGrade
ADD COLUMN gradeID SERIAL;

ALTER TABLE avgGrade 
ADD COLUMN gradID INT;

-- Alteration to define PK and FK --

ALTER TABLE studentInformation
ADD CONSTRAINT pk_studentID PRIMARY KEY (studentID);

ALTER TABLE letterGrade
ADD CONSTRAINT pk_gradeID PRIMARY KEY(gradeID);

ALTER TABLE studentCourseGrades
ADD CONSTRAINT fk_studentID FOREIGN KEY (studentID) 
REFERENCES studentInformation(studentID);

ALTER TABLE avgGrade
ADD CONSTRAINT fk_studentID FOREIGN KEY (studentID) 
REFERENCES studentInformation(studentID);

ALTER TABLE avgGrade
ADD CONSTRAINT fk_gradeID FOREIGN KEY (gradeID) 
REFERENCES letterGrade(gradeID);

-- Check all table for duplicates --

SELECT studentID, firstName, lastName, COUNT(*)
FROM studentInformation GROUP BY studentID, firstName, lastName
HAVING COUNT(*)>1 ORDER BY firstName;

SELECT studentID, midTermExams, finalExam, assignmentOne, assignmentTwo, COUNT(*)
FROM studentCourseGrades GROUP BY studentID, midTermExams, finalExam, assignmentOne, assignmentTwo
HAVING COUNT(*)>1 ORDER BY midTermExams;

SELECT studentID, studentAverage, COUNT(*)
FROM avgGrade GROUP BY studentID, studentAverage
HAVING COUNT(*)>1 ORDER BY studentAverage

SELECT grade, COUNT(grade)
FROM letterGrade GROUP BY grade
HAVING COUNT(grade)>1 ORDER BY grade;

DELETE FROM letterGrade a USING letterGrade b
WHERE a.gradeID < b.gradeID AND a.grade=b.grade;

/* Here is an alternative method for deleting 
	Duplicate recordes */

DELETE FROM letterGrade
WHERE gradeID IN (
	SELECT gradeID
	FROM (
		SELECT gradeID,
		ROW_NUMBER() OVER (PARTITION BY grade ORDER BY gradeID) AS ROW_NUM
		FROM letterGrade) T
	WHERE T.ROW_NUM > 1);

-- Update statments to add lettergradeID --

UPDATE avgGrade
SET gradeID = CASE 
	WHEN studentAverage >= 0 AND studentaverage <= 0.49 THEN 10
	WHEN studentAverage >= 0.49 AND studentaverage <= 0.52 THEN 4
	WHEN studentAverage >= 0.52 AND studentaverage <= 0.55 THEN 6
	WHEN studentAverage >= 0.55 AND studentaverage <= 0.6 THEN 5
	WHEN studentaverage >= 0.61 AND studentaverage <= 0.64 THEN 7
	WHEN studentaverage >= 0.65 AND studentaverage <= 0.69 THEN 1
	WHEN studentaverage >= 0.69 AND studentaverage <= 0.75 THEN 3
	WHEN studentaverage >= 0.76 AND studentaverage <= 0.80 THEN 2
	WHEN studentaverage >= 0.81 AND studentaverage <= 0.89 THEN 8
	WHEn studentaverage >= 0.89 AND studentaverage <= 0.96 THEN 9
	ELSE 0
	END
WHERE studentaverage IN (0.42, 0.49, 0.5, 0.54, 0.55, 0.57, 0.58, 0.6, 0.61,
	 0.63, 0.66, 0.67, 0.7, 0.71, 0.75, 0.76, 0.77, 0.82, 0.88, 0.89,  0.93);

-- Delete Duplicate Records --

DELETE FROM studentInformation 
WHERE studentID = 35932;

DELETE FROM studentInformation 
WHERE studentID = 47058;

DELETE FROM studentInformation 
WHERE studentID = 64698;

DELETE FROM studentCourseGrades 
WHERE studentID = 35932;

DELETE FROM studentCourseGrades
WHERE studentID = 47058;

DELETE FROM studentCourseGrades 
WHERE studentID = 64698;

DELETE FROM avgGrade 
WHERE studentID = 35932;

DELETE FROM avgGrade 
WHERE studentID = 47058;

DELETE FROM avgGrade 
WHERE studentID = 64698;

-- Table to show student AVG and letter grade --

CREATE TABLE CourseGrade AS
SELECT studentInformation.studentID, studentInformation.firstName, 
studentInformation.lastName, avgGrade.studentAverage, letterGrade.grade
FROM studentInformation INNER JOIN avgGrade
ON studentInformation.studentID = avgGrade.studentID
INNER JOIN letterGrade
ON avgGrade.gradeID = letterGrade.gradeID

-- Student AVG grade views -- 

CREATE VIEW highGradeStudents AS
SELECT studentInformation.studentID, studentInformation.firstName, 
studentInformation.lastName, avgGrade.studentAverage, letterGrade.grade
FROM studentInformation INNER JOIN avgGrade
ON studentInformation.studentID = avgGrade.studentID
INNER JOIN letterGrade
ON avgGrade.gradeID = letterGrade.gradeID
WHERE studentaverage=0.93;

CREATE VIEW midGradeStudents AS
SELECT studentInformation.studentID, studentInformation.firstName, 
studentInformation.lastName, avgGrade.studentAverage, letterGrade.grade
FROM studentInformation INNER JOIN avgGrade
ON studentInformation.studentID = avgGrade.studentID
INNER JOIN letterGrade
ON avgGrade.gradeID = letterGrade.gradeID
WHERE studentaverage=0.70;

CREATE VIEW lowGradeStudents AS
SELECT studentInformation.studentID, studentInformation.firstName, 
studentInformation.lastName, avgGrade.studentAverage, letterGrade.grade
FROM studentInformation INNER JOIN avgGrade
ON studentInformation.studentID = avgGrade.studentID
INNER JOIN letterGrade
ON avgGrade.gradeID = letterGrade.gradeID
WHERE studentaverage=0.54;

-- Select statments to view results --

SELECT * FROM studentMaster;
SELECT * FROM studentInformation;
SELECT * FROM studentCourseGrades;
SELECT * FROM avgGrade ORDER BY studentAverage;
SELECT * FROM letterGrade ORDER BY gradeID;
SELECT * FROM CourseGrade;

-- Select statement for views --

SELECT * FROM highGradeStudents;
SELECT * FROM midGradeStudents;
SELECT * FROM lowGradeStudents;