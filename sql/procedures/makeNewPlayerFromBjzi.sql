drop procedure  if exists dbo.makeNewPlayerFromBjzi
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2021-06-07
-- Description: создает нового персонажа из спутника:
--              1. Создает нового персонажа с именем спутника
--				2. Перемещает спутника к новому персонажу и проставляет ему isPlayer=true
--              3. При необходимости, перемещает всех спутников от старого персонажа к новому

-- exec dbo.makeNewPlayerFromBjzi 211,14913,'гоша',0
-- =============================================
CREATE PROCEDURE dbo.makeNewPlayerFromBjzi
(
    @id int, --id спутника
	@squadId int, -- id отряда где будет создан новый персонаж
	@name nvarchar(255), -- имя нового персонажа
	@transferBjzi bit = 0 -- нужно ли перемещать спутников
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare 
	@oldPlayerId int,
	@bjziName nvarchar(255),
	@bjziIsPlayer bit,
	@sideId int,
	@oldPlayerSide int,
	@oldPlayerSquad int,
	@oldPlayerRealName nvarchar(255),
	@oldPlayerPassword nvarchar(255),
	@newPlayerId int

	DECLARE @errmsg nvarchar(max)

	--отбираем начальные данные

	select top 1 @oldPlayerId=b.playerId,@bjziName=b.name,@bjziIsPlayer=b.isPlayer,@oldPlayerSide=p.sideId,@oldPlayerSquad=p.squadId,@oldPlayerRealName=p.realName,@oldPlayerPassword=p.password
	from bjzi b 
	join players p on p.id=b.playerId
	where b.id=@id

	select @sideId=sideId from squads where id=isnull(@squadId,@oldPlayerSquad)

	if isnull(@bjziIsPlayer,0)=1
	begin
		RAISERROR ('Нельзя делать героя из спутника, который уже стал героем!', 16, 1)
		 RETURN;
	end

	CREATE TABLE #MyTempTable  (id int);  


BEGIN TRANSACTION
	--создаем нового персонажа
	BEGIN TRY
		insert into players(name,stateId,sideId,squadId,realName,password)
			OUTPUT inserted.id INTO #MyTempTable
		values(isnull(@name,@bjziName),1,@sideId,isnull(@squadId,@oldPlayerSquad),@oldPlayerRealName,@oldPlayerPassword)
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		set @errmsg = error_message()  
        RAISERROR (@errmsg, 16, 1)
        RETURN;
	END CATCH

	select top 1 @newPlayerId=id from #MyTempTable

	--переносим к нему изначального спутника c isPlayer=true
	BEGIN TRY
		update top(1) bjzi
		set playerId=@newPlayerId,
		isPlayer=1,
		sideId=@sideId
		where id=@id
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		set @errmsg = error_message()  
        RAISERROR (@errmsg, 16, 1)
        RETURN;
	END CATCH

	--переносим всех спутников новому персонажу если нужно
	if isnull(@transferBjzi,0) = 1
	begin
		BEGIN TRY
			update bjzi
			set playerId=@newPlayerId,
			isPlayer=0,
			sideId=@sideId
			where playerId=@oldPlayerId
			and isPlayer!=1
		END TRY
		BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
		END CATCH
	end
COMMIT

	select @newPlayerId

END
GO
