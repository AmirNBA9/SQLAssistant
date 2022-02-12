--Select * from sys.tables

Declare @name sysname;

DECLARE A CURSOR  
    FOR Select name from sys.tables
		Where  name like 'tbl%'
		Order by name
OPEN A 
FETCH NEXT FROM A INTO @name
	While (@@FETCH_STATUS <>-1)
		Begin
			Exec sp_help tbl_acc

			FETCH NEXT FROM A INTO @name;
		End
		
close A
Deallocate A