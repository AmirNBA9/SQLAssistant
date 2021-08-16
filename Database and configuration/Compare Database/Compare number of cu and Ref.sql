with t as(
	select isc.TABLE_NAME ,count(isc.column_name) as column1,isc2.TABLE_NAME as [table_name_Ref] ,count(isc2.column_name) as columnRef
	from INFORMATION_SCHEMA.COLUMNS isc 
		right outer join [185.88.154.94,16070].OMEGADB.INFORMATION_SCHEMA.COLUMNS isc2 on isc2.table_name=isc.table_name
	group by isc.TABLE_NAME,isc2.TABLE_NAME
	)
Select * 
from t where column1<>columnRef 
order by 1,3,2,4