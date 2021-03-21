drop procedure  if exists dbo.insertOrUpdateDeedType
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-21
-- Description:	создает или апдейтит тип деяния

-- exec dbo.insertOrUpdateDeedType null, 'trial','Публичный поединок',15, 1, @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateDeedType
	-- Add the parameters for the stored procedure here
	@id int null,
	@name varchar(255),
	@description nvarchar(255),
	@defaultHonor int,
	@visible bit,
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.deedTypes as target
USING (select top 1 @id,@name,@description,@defaultHonor,@visible) as source (id,name,description,defaultHonor,visible)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	defaultHonor=source.defaultHonor,
	description=source.description,
	visible=source.visible
when not matched then
	insert (name,description,defaultHonor,visible)
	values(source.name,source.description,source.defaultHonor,source.visible)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

