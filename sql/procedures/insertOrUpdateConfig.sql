drop procedure  if exists dbo.insertOrUpdateConfig
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-21
-- Description:	создает или апдейтит деяние

--exec dbo.insertOrUpdateConfig null, 'Сделал заявление',1,44559, 1,'#FFFFFF', @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateConfig 
	-- Add the parameters for the stored procedure here
	@id int null,
	@storage nvarchar(255),
	@key_ nvarchar(255),
	@value nvarchar(max),
	@valueType nvarchar(255),
	@description nvarchar(max),
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.keyValueStorage as target
USING (select top 1 @id,@storage,@key_,@value,@valueType,@description) as source (id,storage,key_,value,valueType,description)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	value=source.value
when not matched then
	insert (storage,key_,value,valueType,description)
	values(source.storage,source.key_,source.value,source.valueType,source.description)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

