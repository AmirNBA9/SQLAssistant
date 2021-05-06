CREATE CLUSTERED INDEX Ci_ProsuctDescriptions
ON   [Product].[Descriptions] ([ProductID],[LanguageID])
WITH ( online = on );