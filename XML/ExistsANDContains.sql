
-- Exists and contains
SELECT *
FROM AnyXmlData
Where Xml_Data.exist('//Comments') = 1
	AND Xml_Data.exist('(//Posts[contains(@Tags,"dataset2")])[1]') = 1