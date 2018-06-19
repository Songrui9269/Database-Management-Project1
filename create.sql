rem EE 562 Project 1
rem Songrui Li
rem LI884

/*Step1: create STUDENT table.*/
CREATE TABLE STUDENT 
(
	sid number PRIMARY KEY,
	sname varchar2(15),
	major varchar2(3),
	levels varchar2(2),
	age number
);

/*Step2: create CLASS table.*/
CREATE TABLE CLASS
(
	cnum varchar2(6) PRIMARY KEY,
	meets_at date,
	room varchar2(6),
	fid number
);

/*Step3: create FACULTY table.*/
CREATE TABLE FACULTY
(
	fid number PRIMARY KEY,
	fname varchar2(20),
	dept varchar2(5)
);

/*Step4: create ENROLLED table.*/
CREATE TABLE ENROLLED
( 
	cnum varchar2(6),
	sid number,
	PRIMARY KEY (cnum,sid)
);

/*Step5: create PREREQUISITE table.*/
CREATE TABLE PREREQUISITE
(
	cnum varchar2(6),
	prereq varchar2(6),
	PRIMARY KEY (cnum,prereq)
);


/*END*/


