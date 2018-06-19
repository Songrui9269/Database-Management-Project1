rem EE 562 Project 1
rem Songrui Li
rem LI884


/* Query1 */
DBMS_OUTPUT.PUT_LINE('Query   #1');
SELECT MAX(S#.age)
FROM STUDENT S#, Class C#, ENROLLED E#,FACULTY F#
WHERE S#.maJOr = 'CS' OR
	(S#.sid = E#.sid
	AND E#.cnum = C#.cnum
	AND C#.fid = F#.fid
	AND F#.Fname = 'Prof.Brown');


/* Query2 */
DBMS_OUTPUT.PUT_LINE('Query   #2');
SELECT DISTINCT C#.cnum
FROM Class C#
WHERE C#.room = '115' OR
	C#.cnum IN (SELECT E#.cnum
		   FROM   ENROLLED E#
		   GROUP BY E#.cnum
		   HAVING COUNT(*) >= 5);

/* Query3 */
DBMS_OUTPUT.PUT_LINE('Query  #3');
SELECT DISTINCT S#.sname
FROM STUDENT S#
WHERE S#.sid IN (SELECT E1#.sid
		FROM ENROLLED E1#, ENROLLED E2#, Class C1#, Class C2#
		WHERE E1#.sid = E2#.sid AND E1#.cnum <> E2#.cnum
		AND E1#.cnum = C1#.cnum AND E2#.cnum = C2#.cnum
		AND C1#.meets_at = C2#.meets_at);


/* Query4 */
 DBMS_OUTPUT.PUT_LINE('Query  #4');
SELECT DISTINCT F#.fname
FROM FACULTY F#
WHERE NOT EXISTS ((SELECT C#.room
		   FROM  Class C#)
		   MINUS
		   (SELECT C1#.room
	   	   FROM   Class C1#
		   WHERE C1#.fid = F#.fid));

/* Query5 */
DBMS_OUTPUT.PUT_LINE('Query  #5');
SELECT DISTINCT F#.fname
FROM FACULTY F#
WHERE 8 < (SELECT COUNT(E#.sid)
	   FROM  Class C#, ENROLLED E#
	   WHERE C#.cnum = E#.cnum
	   AND C#.fid = F#.fid);


/* Query6 */
 DBMS_OUTPUT.PUT_LINE('Query  #6');
SELECT DISTINCT S#.levels, AVG(S#.age)
FROM STUDENT S#
WHERE S#.levels <>'JR'
GROUP BY S#.levels;

/* Query7 */
DBMS_OUTPUT.PUT_LINE('Query  #7');
SELECT DISTINCT S#.sname
FROM STUDENT S#
WHERE S#.sid IN (SELECT E#.sid
		FROM  ENROLLED E#
		GROUP BY E#.sid
		HAVING COUNT(*) >= ALL(SELECT  COUNT(*)
				       FROM  ENROLLED E2#
				       GROUP BY E2#.sid));


/* Query8 */
DBMS_OUTPUT.PUT_LINE('Query  #8');
SELECT DISTINCT S#.sname
FROM STUDENT S#
WHERE S#.sid NOT IN (SELECT E#.sid
		     FROM  ENROLLED E#);


/* Query9 */
 DBMS_OUTPUT.PUT_LINE('Query  #9');
SELECT S#.age, S#.levels
FROM STUDENT S#
GROUP BY S#.age, S#.levels
HAVING S#.levels IN (SELECT  S1#.levels
		     FROM  STUDENT S1#
		     WHERE S1#.age = S#.age
	   	     GROUP BY S1#.levels, S1#.age
		     HAVING  COUNT(*)  >= ALL (SELECT  COUNT(*)
					       FROM STUDENT S2#
					       WHERE S1#.age = S2#.age
					       GROUP BY S2#.levels, S2#.age));


/* Query10 */
DBMS_OUTPUT.PUT_LINE('Query  #10');
SELECT A#.AVG,A#.dept,B#.AVG,B#.dept,A#.AVG-B#.AVG AS mINuses 
FROM (SELECT COUNT(DISTINCT A#.sid)/COUNT(DISTINCT B#.fid) AS AVG,'EE' AS dept FROM enrolled A# JOIN Class B# ON A#.cnum = B#.cnum JOIN faculty c ON B#.fid = c.fid AND c.dept = 'EE' ) A#,
(SELECT COUNT(DISTINCT A#.sid)/COUNT(DISTINCT B#.fid) AS AVG,'CS' AS dept FROM enrolled A# JOIN Class B# ON A#.cnum = B#.cnum JOIN faculty c ON B#.fid = c.fid AND c.dept = 'CS' ) B#;


/* Query11 */
 DBMS_OUTPUT.PUT_LINE('Query  #11');
SELECT Fname 
FROM faculty WHERE fid IN (SELECT fid FROM Class WHERE cnum IN (SELECT cnum FROM enrolled GROUP BY cnum HAVING COUNT(distINct sid) > (SELECT COUNT(distINct A#.sid)/COUNT(distINct B#.fid) AS avg FROM enrolled A# JOIN Class B# ON A#.cnum = B#.cnum JOIN faculty c ON B#.fid = c.fid AND c.dept = 'EE' ) ));



/* Query12 */
DBMS_OUTPUT.PUT_LINE('Query  #12');
SELECT Fname 
FROM faculty WHERE fid NOT IN(SELECT fid FROM Class WHERE meets_at IN (SELECT meets_at FROM Class WHERE fid = (SELECT fid FROM faculty WHERE fname = 'Prof.WASfi'))) AND dept = (SELECT dept FROM Faculty WHERE Fname = 'Prof.WASfi');



/* Query13 */
DBMS_OUTPUT.PUT_LINE('Query  #13');
SELECT sname 
FROM student WHERE sid NOT IN (SELECT sid FROM enrolled WHERE cnum NOT IN (SELECT cnum FROM prerequisite));


/* Query14 */
 DBMS_OUTPUT.PUT_LINE('Query  #14');
SELECT A#.* FROM
(SELECT cnum,meets_at FROM Class WHERE cnum IN (
(SELECT prereq FROM prerequisite WHERE cnum IN
 (SELECT cnum FROM Prerequisite GROUP BY cnum HAVING COUNT(cnum)>1)))) A# ,
(SELECT cnum,meets_at FROM Class WHERE cnum IN (
(SELECT prereq FROM prerequisite WHERE cnum IN
 (SELECT cnum FROM Prerequisite GROUP BY cnum HAVING COUNT(cnum)>1)))) B#
WHERE A#.cnum<> B#.cnum AND A#.meets_at <> B#.meets_at;



/* Query15 */
 DBMS_OUTPUT.PUT_LINE('Query  #15');
SELECT A#.Fname 
FROM (SELECT B#.cnum,A#.Fname FROM Faculty A# JOIN Class B# ON A#.fid = B#.fid WHERE B#.cnum IN (SELECT cnum FROM prerequisite) )A#
JOIN 
(SELECT A#.Fname,B#.cnum FROM Faculty A# JOIN Class B# ON A#.fid = B#.fid WHERE B#.cnum IN (SELECT prereq FROM prerequisite)) B#
ON A#.Fname = B#.Fname;

/* Query16 */
DBMS_OUTPUT.PUT_LINE('Query  #16');
SELECT cnum 
FROM Class WHERE cnum NOT IN 
(SELECT cnum FROM prerequisite GROUP BY cnum HAVING COUNT(prereq) > 3);




/* Query17 */
DBMS_OUTPUT.PUT_LINE('Query  #17');
SELECT A#.cnum,B#.cnum,c.prereq FROM enrolled A# 
JOIN enrolled B# ON A#.sid = B#.sid 
JOIN prerequisite c ON B#.cnum = c.cnum GROUP BY A#.cnum,B#.cnum c.prereq HAVING COUNT(prereq) = 1;




/* VIEWA */
CREATE VIEW VIEWA
	AS SELECT F#.fid,F#.fname, C#.cnum
	FROM FACULTY F#, Class C#
	WHERE F#.fid = C#.fid;


/* VIEWB */
CREATE VIEW VIEWB
	AS SELECT S#.sid, S#.sname, E#.cnum
	FROM STUDENT S#, ENROLLED E#
	WHERE S#.sid = E#.sid;

