-------------------------------------------------------------------------------------------
--Step1: Findnames
Declare @TableName sysname = N'tbl_Factor',							---type table name
		@ColumnName sysname = N'fa_type'							---type columne name

Select *
From INFORMATION_SCHEMA.COLUMNS
Where COLUMN_NAME = @ColumnName and TABLE_NAME like 'tbl%'
Go
-------------------------------------------------------------------------------------------
Declare		/*table:1 Column:2*/	@aim			smallint	= '2',									
			/*توضیحات جدول/ستون*/ @Description	sql_variant	= N'فاکتور فروش1، فروش قطعه2، اجرت3',
			/*نام جدول*/			@tbl			sysname		= N'tbl_Factor',						
			/*نام ستون*/			@Column			sysname		= N'fa_type'							

If  @aim = 1
	begin
	IF NOT EXISTS (	SELECT null 
					FROM SYS.EXTENDED_PROPERTIES 
					WHERE	[major_id]	= OBJECT_ID(@tbl) AND 
							[name]		= N'MS_Description' AND 
							[minor_id]	= 0)
	EXECUTE sp_addextendedproperty 
			@name		= N'MS_Description',
			@value		= @Description,
			@level0type = N'SCHEMA',
			@level0name = N'dbo',
			@level1type = N'TABLE',
			@level1name = @tbl;
	End

	Else if @aim = 2
			Begin
			IF NOT EXISTS (	SELECT NULL 
							FROM SYS.EXTENDED_PROPERTIES 
							WHERE [major_id] =	OBJECT_ID(@tbl) AND
												[name] = N'MS_Description' AND 
												[minor_id] = (	SELECT [column_id] 
																FROM SYS.COLUMNS 
																WHERE	[name]		= @Column AND 
																		[object_id] = OBJECT_ID(@tbl)))
			EXECUTE sp_addextendedproperty 
					@name		= N'MS_Description', 
					@value		= @Description, 
					@level0type = N'SCHEMA',
					@level0name = N'dbo',
					@level1type = N'TABLE',
					@level1name = @tbl,
					@level2type = N'COLUMN',
					@level2name = @Column;
			End
			Else Print N'									****خطا در داده های ورودی****
			برای توضیحات //جدول// هدف را **یک** و برای //ستون// عدد **دو** را قرار دهید.'

Select * 
From SYS.EXTENDED_PROPERTIES
Where value = @Description