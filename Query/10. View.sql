CREATE VIEW V_SaleData
AS
SELECT        Employees.EmployeeID, Employees.LastName, Customers.Country, [Order Details].UnitPrice * [Order Details].Quantity AS LinePrice
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID

GO

--
SELECT * FROM V_SaleData

--
USE [Northwind]
GO

/****** Object:  View [dbo].[V_SaleData]    Script Date: 10/19/2018 5:58:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_SaleData]
AS
SELECT        Employees.EmployeeID, Employees.LastName, Customers.Country, [Order Details].UnitPrice * [Order Details].Quantity AS LinePrice , YEAR(Orders.OrderDate) AS OrderYear
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID

GO


--
