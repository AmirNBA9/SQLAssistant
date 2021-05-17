CREATE TABLE PERSON (
        ID INT IDENTITY PRIMARY KEY, 
        FIRSTNAME NVARCHAR (30), 
		LASTNAME NVARCHAR (30), 
        CITY NVARCHAR (30)
 ) AS NODE;
--2
INSERT INTO PERSON VALUES ('HAMED','NAEEMAEI','TEHRAN')
INSERT INTO PERSON VALUES ('REZA','JENABI','TEHRAN')
INSERT INTO PERSON VALUES ('AMIN','GOLMAHALLE','TEHRAN')
INSERT INTO PERSON VALUES ('SAEED','REZVANI','CHALUS')
--3
CREATE TABLE Friendship (DateOfEvent DateTime,Status bit) AS EDGE;
--4
INSERT INTO Friendship
VALUES (
(SELECT $node_id FROM Person WHERE ID = 1),  -- کد نود مبدا
(SELECT $node_id FROM Person WHERE id = 3),  -- کد نود مقصد
getdate() -- تاریخ
,1 -- ارتباط دوستی/قطع دوستی
);
--5
SELECT 
p1.id,p1.FirstName, p1.LastName
,p2.id,p2.FirstName, p2.LastName--,Status
FROM 
    Person p1 , Person p2  
				, Friendship f
WHERE 
    MATCH(p1-(f)->p2)
