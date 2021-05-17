
--Step1
CREATE TABLE [dbo].[ForumMembers](
    [MemberID] [int] IDENTITY(1,1) NOT NULL,
    [MemberName] [Nvarchar](100) NULL
) AS NODE
GO
 
CREATE TABLE [dbo].[ForumPosts](
    [PostID] [int] NULL,
    [PostTitle] [Nvarchar](100) NULL,
    [PostBody] [Nvarchar](1000) NULL,
    [OwnerID] [int] NULL
) AS NODE
GO

--CREATE TABLE [dbo].[ForumReplies](
--    [ReplyID] [int] NULL,
--    [PostID] [int] NULL,
--    [ReplyPostID] [Nvarchar](1000) NULL
--) AS NODE
--GO
 
CREATE TABLE [dbo].[Likes]
AS EDGE
GO
 
CREATE TABLE [dbo].[Replies]
AS EDGE
GO


--Step2
INSERT ForumMembers values('Peter'),('ABC'),('PQR'),('George'),('Mary'),('XYZ')
GO
 
INSERT INTO [dbo].[ForumPosts](
    [PostID],[PostTitle],[PostBody],OwnerID
)
VALUES
    (1,'Intro','Hi There This is ABC',2),
    (2,'Intro','Hello I''m PQR',3),
    (3,'Re: Intro','Hey PQR This is XYZ',6),
    (4,'Geography','Im George from USA',4),
    (5,'Re:Geography','I''m Mary from OZ',5),
    (6,'Re:Geography','I''m Peter from UK',1),
    (7,'Intro','I''m Peter from UK',1),
    (8,'Intro','nice to see all here!',1)
GO

--Insert into ForumReplies
--values (1,3,N'متن پاسخ'),(2,5,N'متن پاسخ'),(3,2,N'متن پاسخ'),(4,8,N'متن پاسخ'),(5,7,N'متن پاسخ'),(6,6,N'متن پاسخ')
--Go

INSERT Replies VALUES
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 4),(SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 6)),
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 1),(SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 7)),
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 1),(SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 8)),
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 1),(SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 2)),
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 4),(SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 5)),
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 2),(SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 3))
GO
 
INSERT Likes VALUES
((SELECT $node_id FROM dbo.ForumPosts WHERE PostID = 4),(SELECT $node_id FROM dbo.ForumMembers WHERE MemberID = 1))
GO


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