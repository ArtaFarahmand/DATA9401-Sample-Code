--Code to create tables-- 
CREATE TABLE masterTable (
	studentID SERIAL,
	firstName VARCHAR(150),
	lastName VARCHAR(150),
	midTermExam FLOAT,
	finalExam FLOAT,
	assignment1 FLOAT,
	assignment2 FLOAT,
	studentAverage FLOAT,
	grade VARCHAR(10)
);

CREATE TABLE studentInfo 
AS SELECT studentID, firstName, LastName
FROM masterTable;

CREATE TABLE studentMarks 
AS SELECT studentID, midtermexam, finalexam, assignment1, assignment2, studentaverage
FROM masterTable;

CREATE TABLE studentGrade
AS SELECT studentID, Grade
FROM MasterTable;

-- Define Primary and Foreign Keys --
ALTER TABLE studentInfo
ADD CONSTRAINT pk_studentID PRIMARY KEY(studentID);

ALTER TABLE studentMarks
ADD CONSTRAINT fk_studentID FOREIGN KEY (studentID) 
REFERENCES studentInfo(studentID);

ALTER TABLE studentgrade
ADD CONSTRAINT fk_studentID FOREIGN KEY (studentID) 
REFERENCES studentInfo(studentID);

-- Consolidated table --
SELECT studentInfo.studentID, studentInfo.firstName, studentInfo.lastName, studentMarks.studentAverage, studentGrade.grade
INTO studentFinalMark
FROM studentInfo INNER JOIN studentMarks
ON studentInfo.studentID = studentMarks.studentID
INNER JOIN studentGrade
On studentMarks.studentID = studentGrade.studentID;