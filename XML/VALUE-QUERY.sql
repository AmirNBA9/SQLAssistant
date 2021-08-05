/* sample data
SET @XmlDocument = '
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
*/
Select Posts.Post_xml
	,Post_xml.value('(/Root/Users/@Id)[1]','int') AS PostId
	,Post_xml.value('(/Root/Users/@DisplayName)[1]','nvarchar(500)') AS PostDisplayName
	,Post_xml.query('(/Root/Users/Posts/Comments)') AS Comments
From posts
Where Post_xml.value('(/Root/Users/@Reputation)[1]','int') > 100