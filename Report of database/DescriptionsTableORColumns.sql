/*توضیحات جداول*/
SELECT S.name as [Schema Name], O.name AS [Object Name], ep.name, ep.value AS [Extended property]
FROM sys.extended_properties EP
LEFT JOIN sys.all_objects O ON ep.major_id = O.object_id 
LEFT JOIN sys.schemas S on O.schema_id = S.schema_id
LEFT JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id

Where type_desc = 'USER_TABLE' AND column_id is null

/*توضیحات ستون ها*/
SELECT	 S.name as [Schema Name]
		,O.name AS [Table Name]
		,c.name AS [Column Name]
		,t.name	AS [Data Types]
		,ep.value AS [Extended property]
FROM sys.extended_properties EP
LEFT JOIN sys.all_objects O ON ep.major_id = O.object_id 
LEFT JOIN sys.schemas S on O.schema_id = S.schema_id
LEFT JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
LEFT JOIN sys.types t ON t.user_type_id = c.user_type_id 

Where type_desc = 'USER_TABLE' AND column_id is not null 
Order by 1,2