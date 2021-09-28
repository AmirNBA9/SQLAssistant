
Alter table Mag.Node_Magazine
add
	SeoTitle	Nvarchar(140) Null,
	SeoDesc		Nvarchar(500) Null,
	SeoTags		Nvarchar(200) Null

-- Add description to a specific column
EXEC sys.sp_addextendedproperty 
	@name=N'MS_Description', 
	@value=N'نگارش عنوان مورد استفاده در SEO' ,
	@level0type=N'SCHEMA', 
	@level0name=N'Mag', 
	@level1type=N'TABLE', 
	@level1name=N'Node_Magazine', 
	@level2type=N'COLUMN', 
	@level2name=N'SeoTitle'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'MS_Description', 
	@value=N'نگارش MetaDesc مورد استفاده در SEO' ,
	@level0type=N'SCHEMA', 
	@level0name=N'Mag', 
	@level1type=N'TABLE', 
	@level1name=N'Node_Magazine', 
	@level2type=N'COLUMN', 
	@level2name=N'SeoDesc'
GO
EXEC sys.sp_addextendedproperty 
	@name=N'MS_Description', 
	@value=N'SEO MetaTags, Seprate by [ , ] For all tags, One by One. 
Tag Source is Mag.Node_Tags table and you need use this tags.' ,
	@level0type=N'SCHEMA', 
	@level0name=N'Mag',
	@level1type=N'TABLE', 
	@level1name=N'Node_Magazine', 
	@level2type=N'COLUMN', 
	@level2name=N'SeoTags'
GO

