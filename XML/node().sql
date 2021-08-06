DECLARE @Xml xml;

SET @Xml = '
<root>
	<Post>
		<Id>123</Id>
		<Title>Test1</Title>
		<Score>256</Score>
	</Post>
	<Post>
		<Id>124</Id>
		<Title>Test2</Title>
		<Score>113</Score>
	</Post>
	<Post>
		<Id>125</Id>
		<Title>Test3</Title>
		<Score>1024</Score>
	</Post>
</root>';

SELECT 
	doc.col.value('Id[1]','int') id,
	doc.col.value('Title[1]','nvarchar(100)') title,
	doc.col.value('Score[1]','int') score
FROM @Xml.nodes('root/Post') doc(col)