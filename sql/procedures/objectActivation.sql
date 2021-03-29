drop procedure  if exists dbo.objectActivation
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-29
-- Description:	активирует/деактивирует объект

--exec dbo.objectActivation 42849, 'player',1, @res out
-- =============================================
CREATE PROCEDURE dbo.objectActivation
	-- Add the parameters for the stored procedure here
	@id int,
	@type varchar(255),
	@active bit,
	@res bit out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (active bit);  

	update top(1) objects
	set active=@active
	OUTPUT inserted.active INTO #MyTempTable
	where id=@id and typeId=(select top 1 id from objectTypes where name=@type) 

	select @res=active from #MyTempTable
	
END
GO

