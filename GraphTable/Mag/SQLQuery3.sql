
--Entry data and test


--Entry data for NODes
INSERT [Mag].[Node_Tags] (tage)
values(N'کیف'),(N'کیف زنانه'),(N'کیبورد'),(N'Bag'),(N'چرم'),(N'Computer device'),(N'Keyboard')
GO
Select *
From [Mag].[Node_Tags]

INSERT INTO [Mag].[Node_Magazine]([Title],[Note],[LanguageID],[Usercode],[EstimateRead])
VALUES
    (N'خرید مناسب یک کیف',N'در این مقاله در خصوص کیف ها به زبان انگلیسی bags صحبت خواهیم کرد... این بررسی غیر منطقی است. اما کیبورد ها از کیف ها بهتر نیستند.',33,2,'00:05:00'),
    (N'کیف زنانه یا مردانه',N'بطور قطع اینکه شما یک مرد باشید یا زن در خرید کیف زنانه تاثیرگذار است. اما در خصوص کیفیت چرم های گاوی در کیف مردها نخصص بیشتری دارند',33,2,'00:05:00'),
    (N'کیف پول',N'تفاوتی بین کیف پول و عابر بانک های الکترونیکی وجود ندارد. برای بررسی و اثبات آن باید به عملکرد کیبورهای مکانیکی توجه داشت.',33,2,'00:10:00'),
    (N'کیبوردهای اگونومیک',N'فاکتور اصلی خرید همه ما از کیبورد نرمی و راحتی آن نیست بلکه فقط به این فکر میکنیم که کلیدهای زیبا با قیمت مناسب داشته باشد.',33,2,'00:02:00'),
    (N'Keyboard','I''m Mary from OZ',29,3,'00:01:00'),
    (N'Geography','I''m Peter from UK We can use Geo metric data for any project',29,2,'00:05:00'),
    (N'Intro','I''m Peter from UK',29,2,'00:05:10'),
    (N'Intro','nice to see all here!',29,2,'01:00:00')
GO
Select *
From mag.node_magazine
GO
--Update mag.node_magazine 
--set note = N'فاکتور اصلی خرید همه ما از کیبورد نرمی و راحتی آن نیست بلکه فقط به این فکر میکنیم که کلیدهای زیبا با قیمت مناسب داشته باشد.'
--where magazineid = 4


--Edge
--INSERT [Mag].[Edge_MagazineTags] ([$from_id_CD7439AC92F14FFEBAF54DF30413392F],[$to_id_77A7C4248208485ABF8BF8F75F950B0C])
--VALUES 
--((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 1),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 6)),
--((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 1),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 7)),
--((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 2),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 8)),
--((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 2),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 2)),
--((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 3),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 5)),
--((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 3),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 1))
--GO

INSERT [Mag].[Edge_MagazineTags] VALUES ((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 1),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 6),(Getdate()),(1))
INSERT [Mag].[Edge_MagazineTags] VALUES ((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 1),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 7),(Getdate()),(1))
INSERT [Mag].[Edge_MagazineTags] VALUES ((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 2),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 8),(Getdate()),(1))
INSERT [Mag].[Edge_MagazineTags] VALUES ((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 2),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 2),(Getdate()),(1))
INSERT [Mag].[Edge_MagazineTags] VALUES ((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 3),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 5),(Getdate()),(1))
INSERT [Mag].[Edge_MagazineTags] VALUES ((SELECT $node_id FROM [Mag].[Node_Magazine] WHERE [MagazineID] = 3),(SELECT $node_id FROM [Mag].[Node_Tags] WHERE TagID = 1),(Getdate()),(1))
GO


--Selects
select *
from [Mag].[Edge_MagazineTags] 
where JSON_VALUE([$from_id_CD7439AC92F14FFEBAF54DF30413392F],'$.id') = 0 and Json_value([$to_id_77A7C4248208485ABF8BF8F75F950B0C],'$.id')=6
--And Json_value([$edge_id_8CBFAC4E6BC04592AE423763F6097835],'$.id')=7

select *
from [Mag].[Edge_MagazineTags] mt , [Mag].[Node_Magazine] m,[Mag].[Node_Tags] t
Where Match (m-(mt)->t)




--step3
select * from ForumMembers
select * from [ForumPosts]
GO
select * from Replies
select * from Likes
GO

--SELECT p.[PostTitle]
--FROM [dbo].[ForumPosts] p
--	INNER JOIN [dbo].[ForumReplies] r    ON    r.PostID = p.PostID
--	INNER JOIN [dbo].[ForumPosts] p1     ON    p1.[PostID] = r.PostID
--	INNER JOIN [dbo].[ForumMembers] m    ON    m.[MemberID] = p1.[OwnerID]
--WHERE m.[MemberName] = N'Peter'
--GO

--SELECT p.[PostTitle]
--FROM [dbo].[ForumPosts] p
--INNER JOIN [dbo].[ForumLikes] l      ON    r.[PostID]  = p.PostID
--INNER JOIN [dbo].[ForumMembers] m    ON    m.[MemberID] = l.MemberID
--WHERE m.[MemberName] = 'Mary'
--GO


-- Members who liked and replied on same post
SELECT Member.MemberName,Post1.PostTitle
FROM dbo.ForumPosts Post1, Replies, dbo.ForumPosts Post2, Likes, dbo.ForumMembers Member
WHERE
    MATCH(Member<-(Likes)-Post1-(Replies)->Post2)
    AND Member.MemberID = Post2.OwnerID
GO

-- Members who replied to multiple posts
;With CTE AS(
    SELECT Post1.PostID,Post2.OwnerID
    FROM dbo.ForumPosts Post1, Replies, dbo.ForumPosts Post2
    WHERE MATCH(Post1-(Replies)->Post2)
)
SELECT m.MemberName
FROM CTE c
	INNER JOIN dbo.ForumMembers m ON m.MemberID = c.OwnerID
GROUP BY m.MemberName
HAVING COUNT(DISTINCT c.PostID) >= 1
GO
 
 
-- Members who replied multiple times to same post
;With CTE AS(
    SELECT Post1.PostID,Post1.PostTitle,Post2.OwnerID
    FROM dbo.ForumPosts Post1, Replies, dbo.ForumPosts Post2
    WHERE MATCH(Post1-(Replies)->Post2)
)
SELECT m.MemberName,c.PostTitle,COUNT(*) as CountReply
FROM CTE c
JOIN dbo.ForumMembers m ON m.MemberID = c.OwnerID
GROUP BY m.MemberName,c.PostTitle
HAVING COUNT(*) > 1
GO



select *
from forummembers f inner join person.users u on  u.usercode=f.[MemberID]