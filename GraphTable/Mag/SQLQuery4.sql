--Noramal tabls for magazine

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Mag].[MagToCategory](
	[MagToCategoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[MagazineID] [bigint] NOT NULL,
	[CategoryID] [int] NOT NULL
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ارتباط مقالات و چارت' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'MagToCategory'
GO

CREATE TABLE [Mag].[Pictures](
	[PictureID] [bigint] IDENTITY(1,1) NOT NULL,
	[MagazineID] [bigint] NOT NULL,
	[NamePath] [nvarchar](50) NOT NULL,
	[Path] [nvarchar](200) NULL,
	[Title] [nvarchar](50) NULL,
	[Info] [nvarchar](50) NULL,
	[Sort] [smallint] NULL,
 CONSTRAINT [PK_Pictures] PRIMARY KEY CLUSTERED 
(
	[PictureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Mag].[Pictures]  WITH CHECK ADD  CONSTRAINT [FK_Pictures_Magazine] FOREIGN KEY([MagazineID])
REFERENCES [Mag].[Magazine] ([MagazineID])
ON UPDATE CASCADE
GO

ALTER TABLE [Mag].[Pictures] CHECK CONSTRAINT [FK_Pictures_Magazine]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کلید اصلی' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'PictureID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کلیدخارجی' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'MagazineID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام فایل با پسوند' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'NamePath'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'مسیر فایل در سرور' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'Path'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'عنوان' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'نام جایگزین تصویر در زمان اجرا' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'Info'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ترتیب نمایش' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures', @level2type=N'COLUMN',@level2name=N'Sort'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'تصویرهای مقالات' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Pictures'
GO


CREATE TABLE [Mag].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NOT NULL,
	[CategoryDesc] [nvarchar](50) NULL,
	[IconID] [int] NULL,
	[LevelID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[MagazineID] [nchar](10) NULL,
	[LastUpDate] [datetime] NULL,
 CONSTRAINT [PK_tbl_MagCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Mag].[Category] ADD  CONSTRAINT [DF_Category_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'کلید اصلی که هیچ گاه صفر نیست' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Category', @level2type=N'COLUMN',@level2name=N'CategoryID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' که وجود صفر نمایانگر گروه اصلی است قبل از آن وابستگی نیست، هر عدد دیگری جز صفر باید حتما در کلید اصلی موجود باشد. مثلا اگر یک باشد یعنی زیر مجموعه گروه اصلی است.' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Category', @level2type=N'COLUMN',@level2name=N'ParentID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'متن های دسته بندی چارت محصول' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Category', @level2type=N'COLUMN',@level2name=N'CategoryDesc'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'برای هر مورد می توان آیکون خاصی لحاظ کرد..' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Category', @level2type=N'COLUMN',@level2name=N'IconID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'برای چیدمان و ذخیره چیدمان استفاده می شود.' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Category', @level2type=N'COLUMN',@level2name=N'LevelID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'دسته بندی مقالات' , @level0type=N'SCHEMA',@level0name=N'Mag', @level1type=N'TABLE',@level1name=N'Category'
GO