/*
--	Readme:	Add document in database
--	Author:	Ah.Ghasemi
--	Date:	1397/04/30
*/
Declare @What_happen int  = 0  ,-- 0-add-caption // 1-Schema //	2-table // 3-column 
		@Setdata smallint = 1	-- 0-Insert 1-view 2-Update 9-drop
/*************First Step SET @What_happen you need for write Description*************/
Declare @Cpation Varchar(50),			--Caption of extended
		@Schema	 Nvarchar(20)	= 'Lang',		--Set Schema name like dbo and etc
		@table	 Nvarchar(20)	= '',	--Set Table	name like Person and etc		--AGGREGATE, DEFAULT, FUNCTION, LOGICAL FILE NAME, PROCEDURE, QUEUE, RULE, SYNONYM, TABLE, TABLE_TYPE, TYPE, VIEW, XML SCHEMA COLLECTION
		@Column	 NvarChar(30)	= '',			--Set Column name like PostalCode and etc	--COLUMN, CONSTRAINT, EVENT NOTIFICATION, INDEX, PARAMETER, TRIGGER
		@Desc	 Nvarchar(250)	= N'زبان ها'			--Value descripton
/*************Just Set Variable Values and don't check other scripts*************/
--Add a caption to the Database object itself.  (Adding an extended property to a database)
If @Setdata = 0
Begin
	If @What_happen = 0
		EXEC sp_addextendedproperty   
		@name = @Cpation,   
		@value = @Desc;
	If @What_happen = 1
	Set @Cpation = 'SchemaDesc'
	--توضیحات برای اسکیما
	EXECUTE sys.sp_addextendedproperty   
		@name = @Cpation,  
		@value = @Desc		,			--N'Contains objects related to employees and departments.' 
		@level0type = N'SCHEMA',	@level0name = @Schema;			--توضیح نویسی برای کدام اسکیما
	--توضیحات برای جداول
	If @What_happen = 2
	Set @Cpation = 'TableDesc'
	EXEC sys.sp_addextendedproperty   
		@name = @Cpation,		--Example:	MS_description	--Set by Viriable
		@value = @Desc,			--Example:	N'Street address information for customers, employees, and vendors.'	--Set by Viriable
		@level0type = N'SCHEMA',	@level0name = @Schema,	--Example:	dbo , Acc , Hr		--Set by Viriable
		@level1type = N'TABLE', 	@level1name = @table;	--Example:	Person , Base , Setting		--Set by Viriable
	--توضیحات برای ستون ها
	If @What_happen = 3
	Set @Cpation = 'ColumnDesc'
	EXEC sp_addextendedproperty   
		@name = @Cpation,			--Example:	MS_description, InputMask --Set by Viriable
		@value = @Desc,				--Example:	N'Street address information for customers, employees, and vendors.'  --Set by Viriable
		@level0type = N'SCHEMA',	@level0name = @Schema,		--Example:	dbo , Acc , Hr	--Set by Viriable
		@level1type = N'TABLE',		@level1name = @table,		--Example:	Person , Base , Setting	--Set by Viriable
		@level2type = N'Column',	@level2name = @Column;		--Example:	'PostalCode' , Phone number		--Set by Viriable
End

--گزارش
If @Setdata = 1
BEGIN
	--Displaying extended properties on a database
	IF @What_happen = 1
		SELECT objtype, objname, name, value  
		FROM fn_listextendedproperty(null, 'schema', @Schema, default, default, default, default);
	--Displaying extended properties on all tables in a schema
	IF @What_happen = 2
		SELECT objtype, objname, name, value  
		FROM fn_listextendedproperty (NULL, 'schema', @Schema, 'table', default, NULL, NULL); 
	--Displaying extended properties on all columns in a table
	IF @What_happen = 3	
		SELECT objtype, objname, name, value  
		FROM fn_listextendedproperty (NULL, 'schema', @Schema, 'table', @table, 'column', default); 

	IF @What_happen = 0
		SELECT S.name as [Schema Name], O.name AS [Object Name],  c.name As [Column Name],ep.name AS [Kind of extended], ep.value AS [Value of Extended property]
		FROM sys.extended_properties EP
			LEFT JOIN sys.all_objects O ON ep.major_id = O.object_id 
			LEFT JOIN sys.schemas S on O.schema_id = S.schema_id
			LEFT JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
		Where ep.name not like 'microsoft%'
End

--حذف
If @Setdata = 9
begin
	--Dropping an extended property on a database  
	IF @Schema = ''
	EXEC sp_dropextendedproperty   
		@name = @Cpation; 
	--Dropping an extended property on a schema
	ELSE IF @TABLE = ''
	EXEC sp_dropextendedproperty   
	     @name = @Cpation  
	    ,@level0type = 'schema'		,@level0name = @Schema  
	--Dropping an extended property on a table
	ELSE IF @Column = ''
	EXEC sp_dropextendedproperty   
	     @name = @Cpation  
	    ,@level0type = 'schema'		,@level0name = @Schema  
	    ,@level1type = 'table'		,@level1name = @table
	--Dropping an extended property on a column
	ELSE
	EXEC sp_dropextendedproperty   
	     @name = @Cpation  
	    ,@level0type = 'schema'		,@level0name = @Schema  
	    ,@level1type = 'table'		,@level1name = @table
	    ,@level2type = 'column'		,@level2name = @Column;
END

--Updating an extended property on a column
if @Setdata = 2
Begin
	EXEC sp_updateextendedproperty   
	    @name = @Cpation  
	    ,@value = @Desc
	    ,@level0type = N'Schema', @level0name = @Schema
	    ,@level1type = N'Table',  @level1name = @table
	    ,@level2type = N'Column', @level2name = @Column;  
End