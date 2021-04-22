drop procedure  if exists dbo.makeFuneral
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-04-20
-- Description: производит похороны героя или спутника:
--              1. Добавляет деяние тому кто сдает тело
--              2. Переводит сданное тело в статус 

-- exec dbo.makeFuneral 43636,'player',43634,'player'
-- =============================================
CREATE PROCEDURE dbo.makeFuneral
(
    @id_SUBJECT int, --id того кто сдает
	@objectType_SUBJECT varchar(255), -- тип того кто сдает
	@id_OBJECT int, --id того кого сдают
	@objectType_OBJECT varchar(255) -- тип того кого сдают
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @query nvarchar(max)
	,@side_SUBJECT int
	,@side_OBJECT int
	,@id_SUBJECT_p int
	,@objectType_SUBJECT_p varchar(255) 
	,@deedType int
	,@deedHonor int
	,@deedDesc nvarchar(255)
	,@state_OBJECT int
	,@deedRes int
	,@deathCase int

	DECLARE @errmsg nvarchar(max)

	set @objectType_SUBJECT_p='player'
    -- Определить тип деяния

	---- Определяем игрока, если при сдаче показали карточку спутника
	if @objectType_SUBJECT='bjzi'
	begin
		select @id_SUBJECT_p=playerId from dbo.bjzi b left join dbo.players p on p.id=b.playerid where b.id=@id_SUBJECT
	end
	else if @objectType_SUBJECT='player'
	begin
		set @id_SUBJECT_p=@id_SUBJECT
	end 
	else
	begin
		raiserror('Неизвестный тип субъекта похорон (кто сдает тело)',18,5)
		RETURN;
	end

	---- Определяем сторону игрока, сдающего тело
		select @side_SUBJECT=sideId from dbo.players where id=@id_SUBJECT_p


	---- Определяем сторону сдаваемого тела
	if @objectType_OBJECT='player'
	begin
		select @side_OBJECT=sideId, @state_OBJECT=stateId,@deedDesc=name+' ('+cast(id as varchar(255))+')' from dbo.players where id=@id_OBJECT
	end
	else if @objectType_OBJECT='bjzi'
	begin
		select @side_OBJECT=p.sideId, @state_OBJECT=b.utilized,@deedDesc=b.name+' ('+cast(b.id as varchar(255))+')'  from dbo.bjzi b left join dbo.players p on p.id=b.playerid where b.id=@id_OBJECT
	end
	else
	begin
		raiserror('Неизвестный тип Объекта похорон (чье тело сдают)',18,5)
		RETURN;
	end


	--select @id_SUBJECT as [@id_SUBJECT],@objectType_SUBJECT as[@objectType_SUBJECT],@id_SUBJECT_p as [@id_SUBJECT_p],@objectType_SUBJECT_p as [@objectType_SUBJECT_p],@side_SUBJECT as[@side_SUBJECT],@id_OBJECT as[@id_OBJECT],@objectType_OBJECT as [@objectType_OBJECT],@side_OBJECT as [@side_OBJECT],@state_OBJECT as [@state_OBJECT]
	
	select @deedType = id, @deedHonor = defaultHonor,@deathCase = case when name='bodyally' then 1 when name='bodyenemy' then 2 else null end 
	from dbo.deedTypes
	where name=case
		when @objectType_OBJECT='player' then 'bodyhero'
		when @objectType_OBJECT='bjzi' and @side_SUBJECT=@side_OBJECT then 'bodyally'
		when @objectType_OBJECT='bjzi' and @side_SUBJECT!=@side_OBJECT then 'bodyenemy'
		else null
	end

	if @deedType is null
	begin
		raiserror('Не удалось определить тип деяния',18,5)
		RETURN;
	end

	--select @deedType as [@deedType],@deedHonor as [@deedHonor],@deedDesc as [@deedDesc],@deathCase as [@deathCase]
	
    ---- проверка на всякий случай, что объект уже не находится в статусе Мертв
	if  (@objectType_OBJECT='player' and @state_OBJECT=3) or (@objectType_OBJECT='bjzi' and @state_OBJECT=1)
	begin
		raiserror('Тело, которое сдают уже было похоронено',18,5)
		RETURN;
	end


BEGIN TRANSACTION
	-- добавить деяние субъету
	BEGIN TRY
		exec dbo.insertOrUpdateDeed null, @deedDesc,@deedType,@id_SUBJECT_p, @deedHonor,0, @deedRes out
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		set @errmsg = error_message()  
        RAISERROR (@errmsg, 16, 1)
        RETURN;
	END CATCH
	-- перевести объект в статус Мертв
	BEGIN TRY
		--raiserror('тестируем ошибку и откат транзакции',18,5)
		if @objectType_OBJECT='player'
		begin
			update top(1) dbo.players
			set stateId=3
			where id=@id_OBJECT
		end

		if @objectType_OBJECT='bjzi'
		begin
			update top(1) dbo.bjzi
			set utilized=1
			,deathCaseId=@deathCase
			where id=@id_OBJECT
		end
	END TRY
	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		set @errmsg = error_message()  
        RAISERROR (@errmsg, 16, 1)
        RETURN;
	END CATCH
COMMIT
	select @deedRes

END
GO
