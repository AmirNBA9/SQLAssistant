SELECT *
FROM Products
ORDER BY ProductID
FOR XML AUTO , ELEMENTS , ROOT('ProductsData') , XMLSCHEMA