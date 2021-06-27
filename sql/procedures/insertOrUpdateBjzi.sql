drop procedure  if exists dbo.insertOrUpdateBjzi
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-01-06
-- Description:	создает или апдейтит спутника

--exec dbo.insertOrUpdateBjzi null, 'Иван', 'друг детства', 44559, 1, @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateBjzi 
	-- Add the parameters for the stored procedure here
	@id int null,
	@name nvarchar(255),
	@description nvarchar(255),
	@playerId int,
	@channelTypeId int = 1,
	@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @actualOwner int, @bjziCount int

	select top 1 @actualOwner=playerId from bjzi where id=@id

	select top 1 @bjziCount=count(*) from bjzi where playerid=@playerId and isplayer!=1

	if isnull(@actualOwner,@playerId)!=@playerId
	begin
		raiserror('Нельзя изменять чужих спутников!',18,5)
		RETURN;
	end

	if @bjziCount>=10 and @id is null
	begin
		raiserror('Уже добавлены все спутники! Обновите страницу!',18,5)
		RETURN;
	end

	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.bjzi as target
USING (select top 1 @id,@name,@description,@playerId, p.squadId,p.sideId,@channelTypeId
	from dbo.players p
	where p.id=@playerId) as source (id,name,description,playerId,squadId,sideId,bjziChannelTypeId)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	name=source.name,
	description=source.description	
	--squadId=source.squadId
when not matched then
	insert (name,description,playerId/*,squadId*/,sideId,bjziChannelTypeId)
	values(source.name,source.description,source.playerId/*,source.squadId*/,source.sideId,isnull(source.bjziChannelTypeId,1))
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

