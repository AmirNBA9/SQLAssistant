SELECT p.FirstName + ' ' + p.LastName, + CHAR(2)  + pe.EmailAddress   
FROM Person.Person p 
				INNER JOIN Person.EmailAddress pe ON	p.BusinessEntityID = pe.BusinessEntityID  
														AND p.BusinessEntityID = 1;  
