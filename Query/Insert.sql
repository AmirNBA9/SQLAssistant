-- INSERT multiple rows of data
INSERT INTO USERS VALUES
(2, 'Michael', 'Blythe'),
(3, 'Linda', 'Mitchell'),
(4, 'Jillian', 'Carson'),
(5, 'Garrett', 'Vargas');

-- To insert multiple rows of data in earlier versions of SQL Server, use "UNION ALL" like so:
INSERT INTO USERS (FIRST_NAME, LAST_NAME)
SELECT 'James', 'Bond' UNION ALL
SELECT 'Miss', 'Moneypenny' UNION ALL
SELECT 'Raoul', 'Silva'

-- Use OUTPUT to get the new Id
-- CREATE TABLE OutputTest ([Id] INT NOT NULL PRIMARY KEY IDENTITY, [Name] NVARCHAR(50))
INSERT INTO OutputTest ([Name])
OUTPUT INSERTED.[Id]
VALUES ('Testing')

-- If the ID of the recently added row is required inside the same set of query or stored procedure.
-- CREATE a table variable having column with the same datatype of the ID
DECLARE @LastId TABLE ( id int);
INSERT INTO OutputTest ([Name])
OUTPUT INSERTED.[Id] INTO @LastId
VALUES ('Testing')
SELECT id FROM @LastId
-- We can set the value in a variable and use later in procedure
DECLARE @LatestId int = (SELECT id FROM @LastId)

-- Insert from select query
INSERT INTO Table_name (FirstName, LastName, Position)
SELECT FirstName, LastName, 'student' FROM Another_table_name

-- INSERT a single row of data
INSERT INTO USERS(Id, FirstName, LastName)
VALUES (1, 'Mike', 'Jones');
-- Or
INSERT INTO USERS
VALUES (1, 'Mike', 'Jones');
--  INSERT on specific columns
INSERT INTO USERS (FIRST_NAME, LAST_NAME)
VALUES ('Stephen', 'Jiang');



