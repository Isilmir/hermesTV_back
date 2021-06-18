drop procedure  if exists dbo.setHonorforCheckpoint
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		»ль€ ¬оронков
-- Create date: 2021-06-18
-- Description:	проставл€ет славу отр€ду за контрольную точку

--exec dbo.setHonorforCheckpoint 1
-- =============================================
CREATE PROCEDURE dbo.setHonorforCheckpoint
	-- Add the parameters for the stored procedure here
	@id int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--
	declare @squadId int,@deedDesc nvarchar(255),@playerId int,@honorToSet int,@deedHonor float,@res int,@errmsg nvarchar(max),@isgiven bit

	-- получаем отр€д и название точки
	select top(1) @squadId=squadId ,@deedDesc='”держание точки '+chp.name,@isgiven=isHonorGiven
	from warProgress wp
	left join checkpoints chp on chp.id=wp.checkpointId
	where wp.id=@id

	if @isgiven=1
	begin
		raiserror('«а эту точку в этом цикле уже была начислена слава',18,5)
		RETURN;
	end

	-- получаем славу за де€ние
	select top(1) @deedHonor=cast(defaultHonor as float) from deedTypes where id=35

	-- считаем сколько славы получит один игрок
	select top(1) @honorToSet=cast(floor(@deedHonor/count(*)) as int) from players where squadId=@squadId
	

	-- начисл€ем славу
BEGIN TRANSACTION
	DECLARE warProgress_setHonor_cur CURSOR FOR   
	SELECT id from players where squadId=@squadId
  
	OPEN warProgress_setHonor_cur  
  
	FETCH NEXT FROM warProgress_setHonor_cur   
	INTO @playerId
  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
   
			BEGIN TRY
				exec dbo.insertOrUpdateDeed null, @deedDesc,35,@playerId,@honorToSet, 0,null, @res out
				--print 'начисл€ем за де€ние '+@deedDesc+' '+cast(@honorToSet as varchar(max))+' славы игроку '+cast(@playerId as varchar(max))
			END TRY
			BEGIN CATCH
				IF @@trancount > 0 ROLLBACK TRANSACTION
				set @errmsg = error_message()  
				RAISERROR (@errmsg, 16, 1)
				RETURN;
			END CATCH

		FETCH NEXT FROM warProgress_setHonor_cur   
		INTO @playerId
	END   
	CLOSE warProgress_setHonor_cur;  
	DEALLOCATE warProgress_setHonor_cur;  
COMMIT
	-- ставим отметку, что выдали славу
	update top(1) warProgress
	set isHonorGiven=1
	where id=@id

END
GO

