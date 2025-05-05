CREATE TABLE Course
(
   CourseID int,   
   CourseName varchar(1000),
   Rating numeric(2,1)
);

INSERT INTO Course(CourseID,CourseName,Rating) VALUES(1, 'Docker and Kubernetes',4.5);

INSERT INTO Course(CourseID,CourseName,Rating) VALUES(2,'AZ-204 Azure Developer',4.6);

INSERT INTO Course(CourseID,CourseName,Rating) VALUES(3,'AZ-104 Administrator',4.7);