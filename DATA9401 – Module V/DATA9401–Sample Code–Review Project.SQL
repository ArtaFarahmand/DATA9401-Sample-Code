-- Code to create the table to hold our RAW DATA 
CREATE TABLE studentMaster(
	studentID BIGINT,
	firstName VARCHAR(150),
	lastName VARCHAR(150),
	midTermExams VARCHAR(150),
	finalExam VARCHAR(150),
	cw1 VARCHAR(150),
	cw2 VARCHAR(150),
	totalPoints VARCHAR(150),
	studentAverage VARCHAR(150),
	grade VARCHAR(150)
);

-- Code to create tables and auto–populate the table from StudentGrade
CREATE TABLE studentName
AS SELECT studentID, firstName, lastName
FROM studentMaster;

CREATE TABLE studentExamGrades
AS SELECT studentID, midtermexams, finalExam
FROM studentMaster;

CREATE TABLE studentCWGrade
AS SELECT studentID, cw1, cw2
FROM studentMaster;

CREATE TABLE letterGrade
AS SELECT studentID, grade
FROM studentMaster;

--Code to check & remove duplicate records from a table
SELECT firstName, COUNT(firstName)
FROM studentName GROUP BY firstName
HAVING COUNT(firstName)>1 ORDER BY firstName;

DELETE FROM studentName a USING studentName b
WHERE a.studentID < b.studentID AND a.firstName=b.firstName;

--Code to define primary and foreign keys for our table
ALTER TABLE studentName
ADD CONSTRAINT pk_studentID PRIMARY KEY(studentID);

ALTER TABLE letterGrade
ADD CONSTRAINT pk_gradeID PRIMARY KEY(gradeID);

ALTER TABLE studentExamGrades
ADD CONSTRAINT fk_studentID FOREIGN KEY (studentID) 
REFERENCES studentName(studentID);

ALTER TABLE studentCWGrade
ADD CONSTRAINT fk_studentID FOREIGN KEY (studentID) 
REFERENCES studentName(studentID);

ALTER TABLE studentExamGrades
ADD CONSTRAINT fk_gradeID FOREIGN KEY (gradeID) 
REFERENCES letterGrade(gradeID);

--Code to add a column to a table for the letter letterGrade
ALTER TABLE letterGrade
ADD COLUMN gradeID INT GENERATED ALWAYS AS IDENTITY;

--Code to auto populate gradID with Random values between 1-10
UPDATE studentExamGrades
SET gradeID = FLOOR(RANDOM() * 10+1);

-- code to inner join 4 tables and create a new table at the sametime Limited to 500 records.
SELECT studentName.studentID, studentName.firstName, 
studentName.lastName, studentCWGrade.cw1,
studentCWGrade.cw2, studentExamGrades.midTermExams, 
studentExamGrades.finalExam, letterGrade.grade
INTO consolidatedGrades
FROM studentName RIGHT OUTER JOIN studentCWGrade
ON studentName.studentID = studentCWGrade.studentID
RIGHT OUTER JOIN studentExamGrades
ON studentName.studentID = studentExamGrades.studentID
RIGHT OUTER JOIN letterGrade
ON studentExamGrades.gradeID = letterGrade.GradeID
LIMIT 500;

SELECT * FROM consolidatedGrades;



