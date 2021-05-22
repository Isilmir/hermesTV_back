drop procedure  if exists dbo.deleteMessage
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-21
-- Description:	удаляет связь

--exec dbo.deleteMessage 7, @res out
-- =============================================
CREATE PROCEDURE dbo.deleteMessage
	-- Add the parameters for the stored procedure here
	@messageId int
	,@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	declare @deedId int,@errmsg nvarchar(max)
	select @deedId=deedId from messages where id = @messageId

BEGIN TRANSACTION
	--удаляем сообщение
	BEGIN TRY
		delete top(1) from messages
		OUTPUT deleted.id INTO #MyTempTable
		where id=@messageId
	END TRY
	BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
	END CATCH
	--удаляем деяние
	BEGIN TRY
		delete top(1) from deeds
		where id=@deedId

					--RAISERROR ('Error raised in TRY block.', -- Message text.  
     --          16, -- Severity.  
     --          1 -- State.  
     --          );  
	END TRY
	BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
	END CATCH
COMMIT

	select top 1 @res=id from #MyTempTable
	
END
GO

