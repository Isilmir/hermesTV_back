drop procedure  if exists dbo.getResourсesByPlayer
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-01-06
-- Description:	возвращает все ресурсы игрока

--exec dbo.getBjziByPlayer 44559, @res out
-- =============================================
CREATE PROCEDURE dbo.getResourсesByPlayer 
	-- Add the parameters for the stored procedure here
	@playerId int,
	@res varchar(max) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select @res=p.resourсes from dbo.players p
	where p.id=@playerId
	
END
GO

