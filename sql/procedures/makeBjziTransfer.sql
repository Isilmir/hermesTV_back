drop procedure  if exists dbo.makeBjziTransfer
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-04-22
-- Description: производит передачу спутника 

-- exec dbo.makeBjziTransfer 43636,'player',398,'bjzi'
-- =============================================
CREATE PROCEDURE dbo.makeBjziTransfer
(
    @id_SUBJECT int, --id кому производится передача
	@objectType_SUBJECT varchar(255), -- тип того кому передают
	@id_OBJECT int, --id того кого передают
	@objectType_OBJECT varchar(255) -- тип того кого передают
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
	,@state_OBJECT int

	DECLARE @errmsg nvarchar(max)

	set @objectType_SUBJECT_p='player'
    -- Определить тип деяния

	---- Определяем игрока, если при передаче показали карточку спутника
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
		raiserror('Неизвестный тип субъекта для передачи спутника',18,5)
		RETURN;
	end

	---- Определяем сторону игрока, принимающего спутника
		select @side_SUBJECT=sideId from dbo.players where id=@id_SUBJECT_p


	---- Определяем сторону и статус передаваемого спутника
	if @objectType_OBJECT='bjzi'
	begin
		select @side_OBJECT=p.sideId, @state_OBJECT=b.utilized  from dbo.bjzi b left join dbo.players p on p.id=b.playerid where b.id=@id_OBJECT
	end
	else
	begin
		raiserror('Неизвестный тип Объекта для передачи',18,5)
		RETURN;
	end
	
    ---- проверка на всякий случай, что объект уже не находится в статусе Мертв
	if  @objectType_OBJECT='bjzi' and @state_OBJECT=1
	begin
		raiserror('Спутник, которого передают мертв',18,5)
		RETURN;
	end


--BEGIN TRANSACTION
	-- меняем владельца спутника

	update top(1) dbo.bjzi
	set playerid=@id_SUBJECT_p
	where id=@id_OBJECT

	select 1

END
GO
