update [EmployeeTB] set node = null;

-- incremental fill
with [sibs]
as
(
select managerid, 
employee, 
cast(row_number() over (partition by managerid order by employee) as varchar) + '/' as sib
from [EmployeeTB]
where employee != managerid
) 

--select * from [sibs]
,[nonode]
as
(
select  P2.node.ToString() + sibs.sib as node, P1.employee, 
P1.managerid
from [EmployeeTB] as P1
join [EmployeeTB] P2
on P2.employee = P1.managerid
join sibs on P1.employee = sibs.employee
where P2.node is not null
and P1.employee != P1.managerid
and P1.node is null
UNION
select '/' as node, P1.employee, P1.managerid from [EmployeeTB] as P1
where P1.employee = P1.managerid and P1.node is null
UNION ALL
select [nonode].node + sibs.sib as node, 
P.employee, P.managerid
from [EmployeeTB] as P
join [nonode] on [nonode].employee = P.managerid
join sibs on sibs.employee = P.employee
where P.employee != P.managerid
)
--select * from [nonode]
update TOP(3) [EmployeeTB] 
set node = [nonode].node
 from  [EmployeeTB] as P join [nonode]
 on P.employee = [nonode].employee
 
select node.ToString(), * from [EmployeeTB]

 

