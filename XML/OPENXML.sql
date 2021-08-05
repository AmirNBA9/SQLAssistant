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