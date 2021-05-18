SELECT 'ServerRole' = A.name, 'MemberName' =
	B.name FROM master.dbo.spt_values A, master.dbo.sysxlogins B WHERE A.low = 0 AND	A.type = 'SRV' AND	B.srvid IS NULL
	AND A.number & B.xstatus = A.number