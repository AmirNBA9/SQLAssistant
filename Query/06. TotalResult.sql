Select year(orderdate) as OrderYear, CustomerID, count(OrderID) as ordercount, sum(freight) as TotalFreight
from Orders
Group by 
Grouping sets ((year(orderdate), CustomerID),
						(year(orderdate)),
						()
						)

--
Select case 
			when UnitPrice <10 then N'cheap'
			when unitprice between 10 and 50 then N'Moderate'
			else N'Expensive'
		END as PriceRang,
		Count(productid) as ProdCount,
		sum(unitsinstock) as TotalStock
From Products
Group by case 
			when UnitPrice <10 then N'cheap'
			when unitprice between 10 and 50 then N'Moderate'
			else N'Expensive'
		END
order by PriceRang

--
Select case	
			when age <40 then N'young'
			when age <=60 then N'Middle aged'
			else N'Old'
		End as agerange,
		Count(employeeID) as EmpCount
From Employees
Group by case	
			when age <40 then N'young'
			when age <=60 then N'Middle aged'
			else N'Old'
		End

--
With T
as
(
Select EmployeeID, datediff(year,BirthDate,getdate()) as Age
From Employees
)
select case	
			when age <40 then N'young'
			when age <=60 then N'Middle aged'
			else N'Old'
		End as agerange,
		Count(employeeID) as EmpCount
From T
Group by case	
			when age <40 then N'young'
			when age <=60 then N'Middle aged'
			else N'Old'
		End

--
select CategoryID,	case when unitprice <10 then 1 end as cheap,
					case when UnitPrice between 10 and 50 then 1 end as Moderate,
					case when unitprice >50 then 1 end as expensive,
					UnitPrice
From products

--
Select CategoryID,	count(case when unitprice <10 then 1 end) as cheap,
					count(case when UnitPrice between 10 and 50 then 1 end) as Moderate,
					count(case when unitprice >50 then 1 end) as expensive,
					count(ProductID) as total

From Products
Group by grouping sets ((CategoryID),())

--
