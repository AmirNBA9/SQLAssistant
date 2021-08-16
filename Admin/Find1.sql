Declare @TableName sysname = N'',							---type table name
		@ColumnName sysname = N're_postid',							---type columne name
		@Description sql_variant = N'Type Discription of COLUMN',	---find column in step 1
		@Objectid int = null

--1. Find your needed tables (by column name)
Select *
  		From INFORMATION_SCHEMA.COLUMNS
  		Where COLUMN_NAME = @ColumnName and TABLE_NAME like 'tbl%'
--1.1 insert Object ID for Update in next step and check Selected item
Select 
        st.name [Table],
        sc.name [Column],
        sep.value [Description],
		sep.name,
		st.object_id

From sys.tables st	inner join 
					sys.columns sc on st.object_id = sc.object_id left join 
					sys.extended_properties sep on	st.object_id = sep.major_id
												and sc.column_id = sep.minor_id
												and sep.name = 'MS_Description'
Where	st.name = @TableName
		and sc.name = @ColumnName

Set @Objectid = (Select st.object_id
				From sys.tables st	inner join 
					 sys.columns sc on st.object_id = sc.object_id left join 
					 sys.extended_properties sep on	st.object_id = sep.major_id
												and sc.column_id = sep.minor_id
												and sep.name = 'MS_Description'
				Where	st.name = @TableName
--2. Update Columns discription of table


EXEC sp_addextendedproperty   
@name = N'MS_Description', @value = @Description

--3. Result
Select  st.name [Table],
        sc.name [Column],
        sep.value [Description],
		sep.name,
		st.object_id
				From sys.tables st	inner join 
					 sys.columns sc on st.object_id = sc.object_id left join 
					 sys.extended_properties sep on	st.object_id = sep.major_id
												and sc.column_id = sep.minor_id
												and sep.name = 'MS_Description'
				Where	st.name = @TableName
						and sc.name = @ColumnName


 select * from sys.extended_properties

 CREATE TABLE T1 (id int , name char (20));  
GO  
EXEC sp_addextendedproperty   
     @name = 'caption'   
    ,@value = 'Employee ID'   
    ,@level0type = 'schema'   
    ,@level0name = dbo  
    ,@level1type = 'table'  
    ,@level1name = 'T1'  
    ,@level2type = 'column'  
    ,@level2name = id;   
