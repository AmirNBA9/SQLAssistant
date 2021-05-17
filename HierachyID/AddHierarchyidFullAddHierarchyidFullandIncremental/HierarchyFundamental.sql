DECLARE @hid HIERARCHYID
SET @hid='/1/2/3/'
--SELECT @hid as [HierarchyID]
--ToString and CAST on hierarchy id
--SELECT @hid [Var Binary],@hid.ToString() [As String],
--CAST(@hid AS VARCHAR) [As String by CAST]
--GetAncestor(nth) on hierarchy id
SELECT @hid.ToString(),@hid.GetAncestor(1).ToString() [Parent],
 @hid.GetAncestor(2).ToString() [Grand Parent]
, @hid.GetAncestor(3).ToString() [Root]
, @hid.GetAncestor(4).ToString() [No Parent]

WITH CTE(chain,Name)
AS
(
SELECT CAST('/1/' as HIERARCHYID) , 'Ram' 
UNION ALL 
SELECT '/2/','Ron'
UNION ALL
SELECT '/1/1/','Sahil'
UNION ALL
SELECT '/1/2/','Mohit'
UNION ALL
SELECT '/2/1/','Maze'
UNION ALL
SELECT '/','Boss'
)
SELECT * INTO #TEMP FROM CTE

--INSERT INTO #TEMP VALUES('/1/2/1/','Don')
SELECT *,chain.ToString() FROM #TEMP
--GetRoot, GetLevel() on hierarchyid

SELECT Name,chain,chain.ToString() [String Value],
hierarchyID::GetRoot().ToString() [Root],chain.GetLevel() [Level] 
FROM #TEMP
ORDER BY chain.GetLevel()

--IsDescendantOf(node) on hierarchyid
DECLARE @node HIERARCHYID
SET @node='/1/';
SELECT  Name,chain,chain.ToString() [String Value],
hierarchyID::GetRoot().ToString() [Root],chain.GetLevel() [Level] 
FROM #TEMP
WHERE chain.IsDescendantOf(@node)=1  AND chain!=@node 
AND chain.GetLevel()=@node.GetLevel()+1
ORDER BY chain.GetLevel()


--GetDescendant() on hierarchyid
DECLARE @leftNode HIERARCHYID
DECLARE @rightNode HIERARCHYID
SET @leftNode = '/2/1/';
SET @rightNode = '/2/1/';

WITH CTE(node)
AS
(
SELECT @leftNode.GetAncestor(1).GetDescendant(MAX(@rightnode),null) [GeneratedID]
)
SELECT node,'More' FROM CTE


--GetReparentedValue(oldNode,newNode) on hierarchyid
DECLARE @oldNode HIERARCHYID,@newNode HIERARCHYID
SET @oldNode='/1/';
SET @newNode='/2/3/';
SELECT chain.ToString() [OldNode],Name,
chain.GetReparentedValue(@oldNode,@newNode).ToString() [NewNode] 
FROM #TEMP WHERE chain.IsDescendantOf(@oldNode)=1

DROP TABLE #TEMP