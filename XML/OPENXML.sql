-- Example 1 :
DECLARE @DocOutput INIT;
DECLARE @XmlDocument NVARCHAR(MAX) ;

SET @XmlDocument = N'
<Root>
	<Users Id="227" DisplayName="Amir Ali" Reputation="801">
		<Posts Title="Publicly" Tags="dataset">
			<Comments Text="1.This is a test XML data"/>
			<Comments Text="2.This is a test XML data"/>
			<Comments Text="3.This is a test XML data"/>
			<Comments Text="4.This is a test XML data"/>
		</Posts>
	</Users>
	<Users Id="228" DisplayName="Alex" Reputation="102">
		<Posts Title="Publicly available" Tags="dataset2">
			<Comments Text="1.This is a alex test XML data"/>
			<Comments Text="2.This is a alex test XML data"/>
			<Comments Text="3.This is a alex test XML data"/>
			<Comments Text="4.This is a alex test XML data"/>
		</Posts>
	</Users>
</Root>';

EXECUTE sp_xml_preparedocument @DocOutput OUTPUT, @XmlDocument

Select *
From OPENXML(@DocOutput,N'/Root/Users/Posts/Comments')
WITH (
	Author varchar(225) '../../@DisplayName',
	Title varchar(500) '../@Title',
	Tags varchar(500) '../@Tags',
	Comment varchar(500) '@Text'
)

-- Example 2 :
DECLARE @XmlDocument nvarchar(1000);
DECLARE @DocHandle int;

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

Exec sp_xml_preparedocument @DocHandle output, @XmlDocument

Select *
From OPENXML(@DocHandle,'/root/Post',2)
With (
	Id  int,
	Title nvarchar(50),
	Score int
)

Exec sp_xml_removedocument @DocHandle