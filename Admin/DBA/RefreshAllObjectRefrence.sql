IF OBJECT_ID('[dba].[RefreshAllObjectRefrence]') IS NOT NULL
	DROP PROCEDURE [dba].[RefreshAllObjectRefrence];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dba].[RefreshAllObjectRefrence]
AS
BEGIN

    DECLARE @ExcludeSchema TABLE (SchemaId INT);
    INSERT  @ExcludeSchema (SchemaId)
    SELECT  SCHEMA_ID('tSQLt');


    DECLARE @Time DATETIME = GETDATE();

    EXEC dsp.Log_TraceTime @Time = @Time OUTPUT, @Tag = 'Refreshing all VIEWS.';
    DECLARE @stmt_refresh_object NVARCHAR(400);
    DECLARE c_refresh_view CURSOR FOR
    SELECT DISTINCT 'EXEC sp_refreshview ''' + QUOTENAME(ss.name) + '.' + QUOTENAME(so.name) + '''' AS stmt_refresh_views
      FROM  sys.objects AS so
            INNER JOIN sys.sql_expression_dependencies AS sed ON so.object_id = sed.referencing_id
            INNER JOIN sys.schemas AS ss ON so.schema_id = ss.schema_id
     WHERE  so.type = 'V' AND   sed.is_schema_bound_reference = 0 --
        AND so.schema_id NOT IN ( SELECT    ES.SchemaId FROM    @ExcludeSchema AS ES );
    OPEN c_refresh_view;
    FETCH NEXT FROM c_refresh_view
     INTO @stmt_refresh_object;
    WHILE @@FETCH_STATUS = 0
    BEGIN

        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = @stmt_refresh_object;
        EXEC sp_executesql @stmt_refresh_object;
        FETCH NEXT FROM c_refresh_view
         INTO @stmt_refresh_object;
    END;
    CLOSE c_refresh_view;
    DEALLOCATE c_refresh_view;

    EXEC dsp.Log_TraceTime @Time = @Time OUTPUT, @Tag = 'Refreshing all DML TRIGGERS.';
    DECLARE c_refresh_trigger CURSOR FOR
    SELECT DISTINCT 'EXEC sp_refreshsqlmodule ''' + QUOTENAME(schemas.name) + '.' + QUOTENAME(triggers.name) + '''' AS stmt_refresh_dml_triggers
      FROM  sys.triggers AS triggers WITH (NOLOCK)
            INNER JOIN sys.objects AS objects WITH (NOLOCK) ON objects.object_id = triggers.parent_id
            INNER JOIN sys.schemas AS schemas WITH (NOLOCK) ON schemas.schema_id = objects.schema_id
            LEFT JOIN sys.sql_modules AS sql_modules WITH (NOLOCK) ON sql_modules.object_id = triggers.object_id
            LEFT JOIN sys.assembly_modules AS assembly_modules WITH (NOLOCK) ON assembly_modules.object_id = triggers.object_id
            LEFT JOIN sys.assemblies AS assemblies WITH (NOLOCK) ON assemblies.assembly_id = assembly_modules.assembly_id
            LEFT JOIN sys.database_principals AS principals WITH (NOLOCK) ON principals.principal_id = assembly_modules.execute_as_principal_id OR
                                                                             principals.principal_id = sql_modules.execute_as_principal_id
     WHERE  RTRIM(objects.type) IN ( 'U', 'V' ) AND parent_class = 1 AND sql_modules.is_schema_bound = 0 --
        AND objects.schema_id NOT IN ( SELECT   ES.SchemaId FROM    @ExcludeSchema AS ES );
    OPEN c_refresh_trigger;
    FETCH NEXT FROM c_refresh_trigger
     INTO @stmt_refresh_object;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = @stmt_refresh_object;
        EXEC sp_executesql @stmt_refresh_object;
        FETCH NEXT FROM c_refresh_trigger
         INTO @stmt_refresh_object;
    END;
    CLOSE c_refresh_trigger;
    DEALLOCATE c_refresh_trigger;

    EXEC dsp.Log_TraceTime @Time = @Time OUTPUT, @Tag = 'Refreshing all PROCEDURES.';
    DECLARE c_refresh_procedure CURSOR FOR
    SELECT DISTINCT 'EXEC sp_refreshsqlmodule ''' + QUOTENAME(s.name) + '.' + QUOTENAME(p.name) + '''' AS stmt_refresh_procedures
      FROM  sys.procedures AS p WITH (NOLOCK)
            LEFT JOIN sys.schemas AS s WITH (NOLOCK) ON p.schema_id = s.schema_id
            LEFT JOIN sys.sql_modules AS sm WITH (NOLOCK) ON p.object_id = sm.object_id
            LEFT JOIN sys.assembly_modules AS am WITH (NOLOCK) ON p.object_id = am.object_id
            LEFT JOIN sys.assemblies AS a ON a.assembly_id = am.assembly_id
            LEFT JOIN sys.objects AS o WITH (NOLOCK) ON sm.object_id = o.object_id
            LEFT JOIN sys.database_principals AS dp WITH (NOLOCK) ON sm.execute_as_principal_id = dp.principal_id OR
                                                                     am.execute_as_principal_id = dp.principal_id
            LEFT JOIN sys.database_principals AS dp1 WITH (NOLOCK) ON o.principal_id = dp1.principal_id
     WHERE  (CAST(CASE
                      WHEN p.is_ms_shipped = 1
                          THEN 1
                      WHEN (   SELECT   major_id
                                 FROM   sys.extended_properties
                                WHERE   major_id = p.object_id AND  minor_id = 0 AND class = 1 AND  name = 'microsoft_database_tools_support') IS NOT NULL
                          THEN 1 ELSE 0
                  END AS BIT) = 0) --
        AND o.schema_id NOT IN ( SELECT ES.SchemaId FROM    @ExcludeSchema AS ES ) AND p.name <> 'RefreshAllObjectRefrence';
    OPEN c_refresh_procedure;
    FETCH NEXT FROM c_refresh_procedure
     INTO @stmt_refresh_object;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = @stmt_refresh_object;
        EXEC sp_executesql @stmt_refresh_object;
        FETCH NEXT FROM c_refresh_procedure
         INTO @stmt_refresh_object;
    END;
    CLOSE c_refresh_procedure;
    DEALLOCATE c_refresh_procedure;

    EXEC dsp.Log_TraceTime @Time = @Time OUTPUT, @Tag = 'Refreshing all FUNCTIONS.';
    DECLARE c_refresh_function CURSOR FOR
    SELECT DISTINCT 'EXEC sp_refreshsqlmodule ''' + QUOTENAME(SCHEMA_NAME(o.schema_id)) + '.' + QUOTENAME(o.name) + '''' AS stmt_refresh_functions
      FROM  sys.objects AS o WITH (NOLOCK)
            LEFT JOIN sys.sql_modules AS sm WITH (NOLOCK) ON o.object_id = sm.object_id
            LEFT JOIN sys.assembly_modules AS am WITH (NOLOCK) ON o.object_id = am.object_id
            LEFT JOIN sys.database_principals p1 WITH (NOLOCK) ON p1.principal_id = o.principal_id
            LEFT JOIN sys.database_principals p2 WITH (NOLOCK) ON p2.principal_id = am.execute_as_principal_id
            LEFT JOIN sys.database_principals p3 WITH (NOLOCK) ON p3.principal_id = sm.execute_as_principal_id
            LEFT JOIN sys.assemblies AS ass WITH (NOLOCK) ON ass.assembly_id = am.assembly_id
     WHERE  o.type IN ( 'FN', 'IF', 'TF', 'AF', 'FS', 'FT' ) AND sm.is_schema_bound = 0 --
        AND o.schema_id NOT IN ( SELECT ES.SchemaId FROM    @ExcludeSchema AS ES );
    OPEN c_refresh_function;
    FETCH NEXT FROM c_refresh_function
     INTO @stmt_refresh_object;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = @stmt_refresh_object;
        EXEC sp_executesql @stmt_refresh_object;
        FETCH NEXT FROM c_refresh_function
         INTO @stmt_refresh_object;
    END;
    CLOSE c_refresh_function;
    DEALLOCATE c_refresh_function;


    EXEC dsp.Log_TraceTime @Time = @Time OUTPUT, @Tag = 'Refreshing all DDL TRIGGERS.';
    DECLARE c_refresh_ddl_trigger CURSOR FOR
    SELECT DISTINCT 'EXEC sp_refreshsqlmodule ''' + QUOTENAME(t.name) + ''',' + '''DATABASE_DDL_TRIGGER''' AS stmt_refresh_ddl_triggers
      FROM  sys.triggers AS t WITH (NOLOCK)
            LEFT JOIN sys.sql_modules AS sm WITH (NOLOCK) ON t.object_id = sm.object_id
            LEFT JOIN sys.assembly_modules AS am WITH (NOLOCK) ON t.object_id = am.object_id
            LEFT JOIN sys.assemblies AS assemblies WITH (NOLOCK) ON assemblies.assembly_id = am.assembly_id
            LEFT JOIN sys.database_principals AS principals WITH (NOLOCK) ON principals.principal_id = sm.execute_as_principal_id OR
                                                                             principals.principal_id = am.execute_as_principal_id
     WHERE  parent_class = 0;
    OPEN c_refresh_ddl_trigger;
    FETCH NEXT FROM c_refresh_ddl_trigger
     INTO @stmt_refresh_object;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dsp.Log_Trace @ProcId = @@PROCID, @Message = @stmt_refresh_object;
        EXEC sp_executesql @stmt_refresh_object;
        FETCH NEXT FROM c_refresh_ddl_trigger
         INTO @stmt_refresh_object;
    END;
    CLOSE c_refresh_ddl_trigger;
    DEALLOCATE c_refresh_ddl_trigger;


    EXEC dsp.Log_TraceTime @Time = @Time OUTPUT, @Tag = 'Metadata update /*NCQ*/ for non-schema-bound objects is done.';
END;

GO
