create table [EmployeeTB]
(
employee int identity primary key,
name nvarchar(50),
hourlyrate money,
managerid int -- parent in personnel tree
);


 set identity_insert dbo.[EmployeeTB] on;
 insert into [EmployeeTB] (employee, name, hourlyrate, managerid)
 values
 (1, 'Big Boss', 1000.00, 1),
 (2, 'Joe', 10.00, 1),
 (8, 'Mary', 20.00, 1),
 (14, 'Jack', 15.00, 1),
 (3, 'Jane', 10.00, 2),
 (5, 'Max', 35.00, 2),
 (9, 'Lynn', 15.00, 8),
 (10, 'Miles', 60.00, 8),
 (12, 'Sue', 15.00, 8),
 (15, 'June', 50.00, 14),
 (18, 'Jim', 55.00, 14),
 (19, 'Bob', 40.00, 14),
 (4, 'Jayne', 35.00, 3),
 (6, 'Ann', 45.00, 5),
 (7, 'Art', 10.00, 5),
 (11, 'Al', 70.00, 10),
 (13, 'Mike', 50.00, 12),
 (16, 'Marty', 55.00, 15),
 (17, 'Barb', 60.00, 15),
 (20, 'Bart', 1000.00, 19);
  set identity_insert dbo.[EmployeeTB] off;
  
select * from [EmployeeTB]
order by managerid


  --Big Boss   / 
  --Joe        /1/
  --Jane       /1/1/
  --Max        /1/2/
  --Ann        /1/2/1/
  --Art        /1/2/2/

alter table [EmployeeTB]
add [node] hierarchyid;

-- fills all nodes
with sibs
as
(
select managerid, 
employee, 
cast(row_number() over (partition by managerid order by employee) as varchar) + '/' as sib
from [EmployeeTB]
where employee != managerid
) 
--select * from sibs
,[nonode]
as
(
select managerid, employee, hierarchyid::GetRoot() as node   from [EmployeeTB]
where employee = managerid
UNION ALL
select P.managerid, P.employee, cast([nonode].node.ToString() + sibs.sib as hierarchyid)  as node
from [EmployeeTB] as P
join [nonode] on P.managerid = [nonode].employee
join sibs on 
P.employee = sibs.employee
)
--select node.ToString(), * from [nonode]
update [EmployeeTB] 
set node = [nonode].node
 from  [EmployeeTB] as P join [nonode]
 on P.employee = [nonode].employee
 
 select node.ToString(), * from [EmployeeTB]
 order by managerid
 


 

 yogesh.mehla@gmail.com
 kingconspiracy
 +91-9023262520

