DECLARE @XmlDocument xml;

SET @XmlDocument = '
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

-- Update
SET @XmlDocument.modify('
replace value of (/root/Post/Title/text())[1]
with "Best learning"');

SELECT @XmlDocument

-- Insert
SET @XmlDocument.modify('
insert <Title>testtesttest</Title>
into (/root/Post)[1]');

SELECT @XmlDocument

-- Delete
SET @XmlDocument.modify('
delete (/root/Post/Title)[2]');

SELECT @XmlDocument