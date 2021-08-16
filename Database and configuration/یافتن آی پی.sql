select IPAddress, COUNT(*) from LoginProblemLog
where IPAddress not in ('::1', '89.165.11.211')
group by IPAddress
order by COUNT(*)
