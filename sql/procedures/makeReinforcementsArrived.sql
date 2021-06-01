drop procedure  if exists dbo.makeReinforcementsArrived
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-06-01
-- Description: Проставляет всем героям причитающееся количество спутников

-- exec dbo.makeReinforcementsArrived 100085, @deedRes out
-- =============================================
CREATE PROCEDURE dbo.makeReinforcementsArrived(
@playerId int
,@deedRes int out
)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	DECLARE @errmsg nvarchar(max)

	if exists (select top 1 id from deeds where playerId=@playerId and typeId=62)
	begin
		raiserror('Герой уже получил подкрепление!',18,5)
		RETURN;
	end

	if not exists (select top 1 id from deeds where playerId=@playerId and typeId=61)
	begin
		raiserror('Герою не положено подкреплений!',18,5)
		RETURN;
	end

BEGIN TRANSACTION
	BEGIN TRY
		exec dbo.insertOrUpdateDeed null, 'Последние подкрепления прибыли',62,@playerId, 0,1,null, @deedRes out
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		set @errmsg = 'Ошибка получения подкреплений: '+error_message()  
        RAISERROR (@errmsg, 16, 1)
        RETURN;
	END CATCH

	BEGIN TRY
		delete top (5)[deeds]
		where id in (SELECT [id]
		FROM [dbo].[deeds]
		where typeId = 61 
		and playerId = @playerId)
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		set @errmsg = 'Ошибка получения подкреплений: '+error_message()  
        RAISERROR (@errmsg, 16, 1)
        RETURN;
	END CATCH
COMMIT
END
GO
