SELECT  N'' as [Description],TABLE_NAME+'.'+COLUMN_NAME as Name,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,CHARACTER_OCTET_LENGTH,
		IS_NULLABLE,ORDINAL_POSITION,COLUMN_DEFAULT,IS_NULLABLE,NUMERIC_PRECISION,NUMERIC_PRECISION_RADIX,DATETIME_PRECISION,
		NUMERIC_SCALE,CHARACTER_SET_NAME,COLLATION_NAME,DOMAIN_NAME,COLLATION_CATALOG,DOMAIN_CATALOG,COLLATION_SCHEMA,DOMAIN_NAME,
		N'' as [Advantages]
FROM INFORMATION_SCHEMA.COLUMNS
Where table_name='vw_PrModel'