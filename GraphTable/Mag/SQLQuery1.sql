
--Create table Node for Collate Magazine
CREATE TABLE Mag.Node_Magazine(
    [MagazineID]	bigint IDENTITY(1,1)	NOT NULL primary key,
	[Note]			Nvarchar(max)			Not null,
	[Title]			Nvarchar(50)			Not Null,
	[CreateDate]	datetime				null,
	[UpdateDate]	datetime				null,
	[LanguageID]	tinyint					null,
	[Status]		tinyint
) AS NODE
GO

CREATE TABLE Mag.Node_Tages(
	[TageID]		bigint IDENTITY(1,1) NOT NULL primary key,
	[Tage]			Nvarchar(30),
	Flag			bit default '1', 
	[CreateDate]	datetime, 
	[LastUpDate]	datetime,
	[Status]		tinyint
) AS NODE
GO

 
CREATE TABLE Mag.Edge_MagazineTages (CreateDate datetime null,Status bit null)
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
--values (1,3,N'??? ????'),(2,5,N'??? ????'),(3,2,N'??? ????'),(4,8,N'??? ????'),(5,7,N'??? ????'),(6,6,N'??? ????')
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