Select t.name+'.'+cc.name Name,cc.definition,cc.max_length,cc.precision,cc.scale,cc.collation_name
from sys.computed_columns cc inner join sys.tables t 
	on cc.object_id=t.object_id