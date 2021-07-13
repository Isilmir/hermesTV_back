drop procedure  if exists dbo.insertOrUpdateMessage
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-05-22
-- Description:	создает или апдейтит сообщение

--declare @res int
--exec dbo.insertOrUpdateMessage null,null,null,null,null,'изменили текст сообщения 2',100084,@res out
--select @res
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateMessage 
	-- Add the parameters for the stored procedure here
	@id int null,
	@deedDescription nvarchar(255) ='Послание от богов',
	@typeId int = 58,
	@honor int = 0,
	@heroic bit = 0,
	@description nvarchar(255),
	@playerId int,
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @deedDescription is null  set @deedDescription = 'Послание от богов' 
	if @typeId is null set @typeId = 58
	if @honor is null set @honor = 0
	if @heroic is null set @heroic = 0

	print 'Начали обработку. @honor: '+isnull(cast(@honor as varchar(max)),'NULL')+', @deedDescription: '+isnull(cast(@deedDescription as varchar(max)),'NULL')+', @typeId: '+isnull(cast(@typeId as varchar(max)),'NULL')+', @heroic: '+isnull(cast(@heroic as varchar(max)),'NULL')+' '

	declare @deedId int,@errmsg nvarchar(max)

	CREATE TABLE #MyTempTable  (id int);  

	select @deedId=deedId from messages where id = @id

	print 'Получили деяние. @deedId: '+isnull(cast(@deedId as varchar(max)),'NULL')

BEGIN TRANSACTION
	--создать деяние
	BEGIN TRY

		exec dbo.insertOrUpdateDeed @deedId, @deedDescription,@typeId,@playerId, @honor, @heroic,'#7733dd',@deedId out
	END TRY
	BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
	END CATCH
	--создать сообщение
	BEGIN TRY

		

		MERGE dbo.messages as target
		USING (select top 1 @id,@deedId,@description) as source (id,deedId,description)
		on (target.id=isnull(source.id,0))
		when matched then
			update set 
			description=source.description
		when not matched then
			insert (deedId,description)
			values(source.deedId,source.description)
			OUTPUT inserted.id INTO #MyTempTable;

			--RAISERROR ('Error raised in TRY block.', -- Message text.  
   --            16, -- Severity.  
   --            1 -- State.  
   --            );  
	END TRY
	BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
	END CATCH
COMMIT

	select @res=id from #MyTempTable
	
END
GO

