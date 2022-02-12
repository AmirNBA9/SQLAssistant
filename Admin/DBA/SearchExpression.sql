IF OBJECT_ID('[dba].[SearchExpression]') IS NOT NULL
	DROP PROCEDURE [dba].[SearchExpression];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dba].[SearchExpression]
    @Expression NVARCHAR(MAX), @WholeWord BIT = 0
AS
BEGIN
    SET @WholeWord = ISNULL(@WholeWord, 0);
    --SELECT DISTINCT OBJECT_NAME(id) FROM syscomments WHERE [text] LIKE @Expression
    IF @WholeWord = 0
        SET @Expression = CONCAT('%', @Expression, '%');

    SELECT  sm.object_id, CONCAT(SCHEMA_NAME(o.schema_id), '.[', OBJECT_NAME(sm.object_id), ']') AS object_name, o.type, o.type_desc, sm.definition
      FROM  sys.sql_modules AS sm
            JOIN sys.objects AS o ON sm.object_id = o.object_id
     WHERE  sm.definition LIKE @Expression --COLLATE SQL_Latin1_General_CP1_CI_AS
     ORDER BY SCHEMA_NAME(o.schema_id), o.type;
END;
GO
