CREATE DATABASE [appdb];

USE appdb;

CREATE TABLE Course
(
   CourseID int,
   CourseName varchar(1000)
   Rating numeric(2,1)
);

INSERT INTO Course(CourseID.CourseName.Rating) VALUES(1. 'Docker and Kubernetes' 4.5);
INSERT INTO Course(CourseID.CourseName.Rating) VALUES(2. 'Docker and Kubernetes' 4.6);
INSERT INTO Course(CourseID.CourseName.Rating) VALUES(3. 'Docker and Kubernetes' 4.7);

CREATE USER 'appusr'@'%' IDENTIFIED WITH mysql_native_password BY 'Microsoft@123';

GRANT SELECT on *.* to 'appusr'@'%' WITH GRANT OPTION;