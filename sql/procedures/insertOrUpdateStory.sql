drop procedure  if exists dbo.insertOrUpdateStory
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-01-28
-- Description:	создает или апдейтит сюжет

--exec dbo.insertOrUpdateStory null, 'Новый сюжет', 'В этом сюжеье кто-то кого-то убивает', @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateStory 
	-- Add the parameters for the stored procedure here
	@id int null,
	@description nvarchar(255),
	@longDescription nvarchar(max),
	@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.stories as target
USING (select top 1 @id,@description,@longDescription) as source (id,description,longDescription)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	description=source.description,
	longDescription=source.longDescription
when not matched then
	insert (description,longDescription)
	values(source.description,source.longDescription)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

