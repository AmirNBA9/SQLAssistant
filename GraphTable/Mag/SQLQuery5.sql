Create view vw_MagazineByTags
as(

Select	m.MagazineID,
		m.[Title],
		m.[Note],
		m.UserCode,
		m.[EstimateRead],
		m.CreateDate,
		String_agg(t.[Tag],'//') as TagsForMag
from [Mag].[Edge_MagazineTags] mt , [Mag].[Node_Magazine] m,[Mag].[Node_Tags] t
Where Match (m-(mt)->t)
Group by MagazineID,m.[Title],m.[Note],m.[UserCode],m.usercode,m.[EstimateRead],m.CreateDate
)
Go

Create view vw_MagazineByCategory
as(
SELECT	dbo.vw_MagazineByTags.MagazineID, dbo.vw_MagazineByTags.Title, dbo.vw_MagazineByTags.Note, 
		dbo.vw_MagazineByTags.UserCode, dbo.vw_MagazineByTags.EstimateRead, 
        dbo.vw_MagazineByTags.CreateDate, dbo.vw_MagazineByTags.TagsForMag,
		Mag.Category.CategoryDesc, 
		Mag.Category.CategoryID,
		String_agg(Mag.Pictures.PictureID, '//') AS PictureID, 
		String_agg(Mag.Pictures.NamePath, '//') AS PicturesName, 
		String_agg(Mag.Pictures.Path, '//') AS PicPath
FROM    Mag.Pictures RIGHT OUTER JOIN
        dbo.vw_MagazineByTags ON Mag.Pictures.MagazineID = dbo.vw_MagazineByTags.MagazineID LEFT OUTER JOIN
        Mag.Category RIGHT OUTER JOIN
        Mag.MagToCategory ON Mag.Category.CategoryID = Mag.MagToCategory.CategoryID ON dbo.vw_MagazineByTags.MagazineID = Mag.MagToCategory.MagazineID
GROUP BY dbo.vw_MagazineByTags.MagazineID, dbo.vw_MagazineByTags.Title, dbo.vw_MagazineByTags.Note, 
		dbo.vw_MagazineByTags.UserCode, dbo.vw_MagazineByTags.EstimateRead, 
        dbo.vw_MagazineByTags.CreateDate, dbo.vw_MagazineByTags.TagsForMag,
		Mag.Category.CategoryDesc, 
		Mag.Category.CategoryID
)