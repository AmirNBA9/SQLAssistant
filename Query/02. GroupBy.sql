use Northwind

select Country,city
from Customers
group by Country,city

select distinct Country,city
from Customers


--

select count(ProductID), sum(UnitsInStock)
from Products
where Discontinued=0
group by CategoryID


Select top 1 count(customerid) as customercount
from Customers
group by Country
order by customercount desc

--
Select EmployeeID, year(orderdate) as OrderYear, count(OrderID) as OrderCount, sum(Freight) as TotalFreight
From Orders
Group by EmployeeID, year(orderdate)
Order by OrderYear, EmployeeID

--

Select ShipVia, year(ShippedDate) as ShipYear, count(OrderID) as OrderCount, sum(Freight) as TotalFreight, AVG(Freight) as AvgFreight
From Orders
where ShippedDate is not null
Group by shipvia, year(shippeddate)
order by ShipYear, ShipVia

--
-- Grouping sets ---2008

Select ShipVia, year(ShippedDate) as ShipYear, count(OrderID) as OrderCount, sum(Freight) as TotalFreight, AVG(Freight) as AvgFreight
From Orders
where ShippedDate is not null
Group by GROUPING sets (	year(shippeddate),
							(ShipVia),
							()
						)
order by ShipVia desc, year(ShippedDate) desc

--
Drop table if exists Salcube

Select EmployeeID,CustomerID,Shipvia,count(orderID) as OrderCount, sum(Freight) as TotalFreght, AVG(Freight) as AVGFreight
INTO Salcube
From Orders
Group by Grouping Sets (
						(EmployeeID,CustomerID,ShipVia),
						(EmployeeID ,CustomerID),
						(EmployeeID,ShipVia),
						(EmployeeID),
						(CustomerID),
						(ShipVia),
						()
						)

select * from Salcube

--
select * 
from Salcube
Where Employeeid = 1 and CustomerID='ALFKI' --and Shipvia  is null


select * 
from Salcube
where Shipvia=1 and CustomerID is null

--
-- Grouping sets ---2008
Select	year(OrderDate) as N'سال سفارش',
		CustomerID as N'کد مشتری',
		Count(orderid) as N'تعداد سفارش',
		Sum(Freight) as N'هزینه حمل'
From Orders
Group by GROUPING sets (	(year(OrderDate),(CustomerID)),
							(year(OrderDate)),
							()
						)

--
Select Case
			When UnitPrice <10 Then N'ارزان'
			When UnitPrice Between 10 and 50 Then N'متوسط'
			Else N'گران'
		End as PriceRange,
		Count(ProductID) as N'تعداد محصولات',
		Sum(UnitsinStock) as N'موجودی محصولات'
From Products
Group By Case
			When UnitPrice <10 Then N'ارزان'
			When UnitPrice Between 10 and 50 Then N'متوسط'
			Else N'گران'
		End
Order by PriceRange


--
Select Case
			When Age <35 Then N'جوان'
			When Age <= 50 Then N'میانسال'
			Else N'پیر'
		End as N'دسته بندی سن',
		Count(employeeID) as N'تعداد کارمندان'
From Employees
Group By Case
			When Age <35 Then N'جوان'
			When Age <= 50 Then N'میانسال'
			Else N'پیر'
		End


--
With T
as
(
Select EmployeeID, DateDiff(Year,BirthDate,GetDate()) as Age
From Employees
)
Select Case
			When Age <35 Then N'جوان'
			When Age <= 50 Then N'میانسال'
			Else N'پیر'
		End as N'دسته بندی سن',
		Count(employeeID) as N'تعداد کارمندان'
From T
Group By Case
			When Age <35 Then N'جوان'
			When Age <= 50 Then N'میانسال'
			Else N'پیر'
		End

--
Select Distinct Country
From Customers

--
Select	CategoryID,
		Case When UnitPrice<10 Then 1 End as Cheap,
		Case When UnitPrice Between 10 and 50 Then 1 End as Moderate,
		Case When UnitPrice>50 Then 1 End as Expensive,
		UnitPrice
From Products

--
Select	CategoryID,
		count(Case When UnitPrice<10 Then 1 End) as Cheap,
		count(Case When UnitPrice Between 10 and 50 Then 1 End) as Moderate,
		count(Case When UnitPrice>50 Then 1 End) as Expensive
From Products
Group by Grouping Sets	(	(CategoryID),
							()
						)

--
Select	CategoryID,
		Isnull(Sum(Case When UnitPrice<10 Then UnitsInStock End),0) As N'ارزان',
		Isnull(Sum(Case When UnitPrice Between 10 and 50 Then UnitsInStock End),0) As N'متوسط',
		Isnull(Sum(Case When UnitPrice>50 Then UnitsInStock End),0) As N'گران'
From Products
Group by Grouping Sets	(	(CategoryID),
							()
						)

--
Select	EmployeeID,
		Count(Case When Year(OrderDate)=2016 Then 1 End) As Count2016,
		isnull(Sum(Case When Year(OrderDate)=2016 Then Freight End),0) As Sum2016,
		Count(Case When Year(OrderDate)=2017 Then 1 End) As Count2017,
		isnull(Sum(Case When Year(OrderDate)=2017 Then Freight End),0) As Sum2017,
		Count(Case When Year(OrderDate)=2018 Then 1 End) As Count2018,
		isnull(Sum(Case When Year(OrderDate)=2018 Then Freight End),0) As Sum2018,
		Count(OrderID) As TotalCount,
		Sum(Freight) As TotalFreight
From Orders
Group by Grouping Sets	(	(EmployeeID),
							()
						)


--
