/*-- Creating Tables --*/
CREATE TABLE student(
	studentID SERIAL PRIMARY KEY NOT NULL,
	firstName VARCHAR(100) NULL,
	lastName VARCHAR(100) NULL,
	Address VARCHAR(250) NULL
);

CREATE TABLE courses(
	courseID INT NOT NULL,
	courseNAME VARCHAR(100) NULL,
	StudentID INT NULL,
	FOREIGN KEY(studentID)REFERENCES student(studentID)
);

CREATE TABLE grades(
	StudentID INT NULL,
	gradeA INT NULL,
	gradeB INT NULL,
	gradeC INT NULL, 
	finalExam INT NULL,
	FOREIGN KEY(studentID)REFERENCES student(studentID)
);

/*-- Inserting Data --*/
INSERT INTO student (firstName , lastName, Address)
	VALUES('Arta', 'Farahmand', '55 Bow Ave S.W Calgary AB'),
		  ('Bart', 'Rock', '77 Bow valley Street S.W Calgary AB'),
	      ('Mark', 'Twine', '780 6 Ave S.W Calgary AB'),
		  ('huckleberry ', 'finn', '55 Bow Ave S.W Calgary AB');

INSERT INTO student (firstName , lastName, Address) VALUES('Arta', 'Farahmand', '55 Bow Ave S.W Calgary AB');
INSERT INTO student (firstName , lastName, Address) VALUES('Bart', 'Rock', '77 Bow valley Street S.W Calgary AB');
INSERT INTO student (firstName , lastName, Address) VALUES('Mark', 'Twine', '780 6 Ave S.W Calgary AB');
INSERT INTO student (firstName , lastName, Address) VALUES('huckleberry ', 'finn', '55 Bow Ave S.W Calgary AB');

INSERT INTO courses (courseID, courseName, studentID) VALUES(1, 'Math', 6);
INSERT INTO courses (courseID, courseName, studentID) VALUES(2, 'Chemistary', 11);
INSERT INTO courses (courseID, courseName, studentID) VALUES(3, 'Physics', 8);
INSERT INTO courses (courseID, courseName, studentID) VALUES(4, 'Social studies', 10);

/*-- Update Statement --*/
UPDATE Student
SET firstname = 'Huckleberry', lastname = 'Finn'
WHERE studentID = 8;

UPDATE Student
SET firstname = 'Huckleberry', lastname = 'Finn'
WHERE studentID = 12;

UPDATE Student
SET firstname = 'Atticus', lastname = 'Finch'
WHERE studentID = 6;

UPDATE Student
SET firstname = 'Jay ', lastname = 'Gatsby'
WHERE studentID = 10;

/*-- Delete & Drop Statment --*/
DELETE FROM student WHERE studentID = 12
DROP TABLE grades;

/*-- Alter Table --*/
ALTER TABLE student 
ADD COLUMN grade FLOAT;