DECLARE @SQL nvarchar(MAX) = N'';

WITH PK_Index
AS
(
	SELECT		TName.object_id ObjID, M.[name] PKName, S.name + '.' + TName.name TableFullName, C.name ColumnName, S.name SchemaAsFilegroupName, C.column_id CID
	FROM		sys.all_objects		M
		JOIN	sys.all_objects		TName	ON	M.parent_object_id = TName.object_id
		JOIN	sys.schemas			S		ON	TName.schema_id = S.schema_id
		JOIN	sys.indexes			I		ON	TName.object_id = I.object_id
		JOIN	sys.index_columns	IC		ON	I.object_id = IC.object_id AND I.index_id = IC.index_id
		JOIN	sys.columns			C		ON	TName.object_id = C.object_id AND C.column_id = IC.column_id
	WHERE		M.[type] = N'PK' AND TName.schema_id > 2 AND TName.schema_id = 6 AND I.name like 'PK_%'
)
, XML_Spatial_Index
AS
(
	SELECT		object_id XS_ObjID
	FROM		sys.indexes		I
	WHERE		I.type = 3 OR I.type = 4
)
SELECT	@SQL = @SQL + N'CREATE UNIQUE CLUSTERED  INDEX '+PKName+' ON '+TableFullName+' ('+STRING_AGG( ColumnName, ',') WITHIN GROUP(ORDER BY CID)+') WITH (DROP_EXISTING = ON) ON '+ SchemaAsFilegroupName + ';
'
FROM	PK_Index
WHERE	PK_Index.ObjID NOT IN (SELECT XS_ObjID FROM XML_Spatial_Index)
GROUP BY PKName, SchemaAsFilegroupName, TableFullName

PRINT(@SQL)

--EXEC(@SQL)

SELECT		T.object_id, S.name + '.' + T.name TablesHave_XMLSpatial_Indexes
FROM		sys.tables	T
	JOIN	sys.schemas S ON T.schema_id = S.schema_id
WHERE	T.object_id IN (
						SELECT		object_id XS_ObjID
						FROM		sys.indexes		I
						WHERE		I.type = 3 OR I.type = 4
					   )


