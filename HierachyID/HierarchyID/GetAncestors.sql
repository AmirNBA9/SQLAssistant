DECLARE @x HierarchyID
SET @x = '/2/1/4/3/'

SELECT @X.GetAncestor(1).ToString()
SELECT @X.GetAncestor(2).ToString()
SELECT @X.GetAncestor(3).ToString()
SELECT @X.GetAncestor(4).ToString()
SELECT @X.GetAncestor(5).ToString()

DECLARE @Level int = @x.GetLevel()
DECLARE @i int = 1
WHILE @i <= @Level
   BEGIN
      SELECT @X.GetAncestor(@i).ToString()
	  SET @i=@i+1
   END