--readme:			find table/view diffrent or columns diffrent
--author:			A.Ghasemi
--finaleditedate:	1398/06/10,1398/08/06,1398/08/20
--requirement:		Linked Server run

Declare @t table (tbl_name varchar(20),Column_name varchar(20),tbl_name2 varchar(20),Column_name2 varchar(20))
Declare @adv int = 0;		--table or view diffrents= 0 columns diffrents = 1 Datatype diffrents=2



If (@adv = 0 )
	with t as(
		select distinct TABLE_NAME
		from [91.98.33.151,16070].OMEGADB.INFORMATION_SCHEMA.COLUMNS 
		where TABLE_NAME like 'vw_%' or  TABLE_NAME like 'tbl_%'
		)
	select TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS from t where TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS not in (select distinct TABLE_NAME  collate SQL_Latin1_General_CP1_CI_AS from INFORMATION_SCHEMA.COLUMNS  where TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'vw_%' or  TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'tbl_%')
	order by 1
else If (@adv = 1 )
	with t as(
		select TABLE_NAME,column_name,s.DATA_TYPE,s.CHARACTER_MAXIMUM_LENGTH,
				case	when TABLE_NAME like 'vw_%' then N'Alter view as other DB'
						when CHARACTER_MAXIMUM_LENGTH is null and s.DATA_TYPE in ('image','datetime') then 'Alter table '+TABLE_NAME+' add '+column_name+' '+s.DATA_TYPE
						when CHARACTER_MAXIMUM_LENGTH is null then 'Alter table '+TABLE_NAME+' add '+column_name+' '+s.DATA_TYPE +' null' 
				else  'Alter table '+TABLE_NAME+' add '+column_name+' '+s.DATA_TYPE +'('+convert(nvarchar,CHARACTER_MAXIMUM_LENGTH)+')'
				end as Command
		from [91.98.33.151,16070].OMEGADB.INFORMATION_SCHEMA.COLUMNS s where TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'vw_%' or  TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'tbl_%'
		)
	Select TABLE_NAME,column_name,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH , Command
	from t 
	where  TABLE_NAME+column_name collate SQL_Latin1_General_CP1_CI_AS not in ( select TABLE_NAME+column_name collate SQL_Latin1_General_CP1_CI_AS from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'vw_%' or  TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'tbl_%')
	order by 1,2

else If (@adv = 2 )
	with t as(
		select TABLE_NAME ,column_name,s.DATA_TYPE,s.CHARACTER_MAXIMUM_LENGTH
		from [91.98.33.151,16070].OMEGADB.INFORMATION_SCHEMA.COLUMNS s 
		where TABLE_NAME like 'vw_%' or  TABLE_NAME like 'tbl_%'
		)
	Select TABLE_NAME,column_name,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH 
	from t 
	where  TABLE_NAME+column_name+DATA_TYPE collate SQL_Latin1_General_CP1_CI_AS not in ( select (TABLE_NAME+column_name+DATA_TYPE) collate SQL_Latin1_General_CP1_CI_AS from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME collate SQL_Latin1_General_CP1_CI_AS like 'tbl_%')
	order by 1,2



--	if exists (select 1 from @t) delete @t
--	begin
--		insert into @t (tbl_name)
--		select distinct TABLE_NAME 
--		from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME like 'tbl_%' or TABLE_NAME like 'vw_%'
--	end
----select distinct 'values ('''+TABLE_NAME+'''),' from INFORMATION_SCHEMA.COLUMNS
--insert into @t (tbl_name2)
--/*paste valuse of reference by up select*/

