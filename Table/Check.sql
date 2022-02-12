CREATE TABLE Personel (PersonelID int NOT NULL PRIMARY KEY ,
                       FirstName nvarchar(50) NOT NULL ,
					   LastName nvarchar(50) NOT NULL ,
					   Age int NOT NULL ,
					   Gender nchar(1) NOT NULL CHECK ( Gender IN ('M' , 'F') ) ,
					   Salary int NOT NULL
                      )

/*

AgeRange    Male    Female   Total
--------   ------  -------   ------
            Avergae Salary 
			*/

