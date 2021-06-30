drop procedure  if exists dbo.insertOrUpdateTransaction
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-06-29
-- Description:	создает или апдейтит транзакцию

--exec dbo.insertOrUpdateTransaction null, 44559,'Гера','Спутники',1,1,'Покупка в храме Геры', @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateTransaction 
	-- Add the parameters for the stored procedure here
	@id int null,
	@playerId int,
	@god nvarchar(255),
	@resource nvarchar(255),
	@quantity int,
	@gold int,
	@description nvarchar(255),
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.transactions as target
USING (select top 1 @id,@playerId,@god,@resource,@quantity,@gold,@description) as source (id,playerId,god,resource,quantity,gold,description)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	god=source.god,
	resource=source.resource,
	quantity=source.quantity,
	gold=source.gold,
	description=source.description
when not matched then
	insert (playerId,god,resource,quantity,gold,description)
	values(source.playerId,source.god,source.resource,source.quantity,source.gold,source.description)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

