drop procedure  if exists dbo.getBjziSingle
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-04-17
-- Description: возвращает информацию по конкретному спутнику

-- exec dbo.getBjziSingle 1
-- =============================================
CREATE PROCEDURE dbo.getBjziSingle
(
    @id int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    select 
	'bjzi' as objectType
	,b.id,b.name,b.sideId,b.playerId,b.squadId,b.description,b.utilized,bjziChannelTypeId,deathCaseId
	,p.name as playerName,p.squadId as playerSquad, p.sideId as playerSide
	,o.active
	from bjzi b 
	left join players p on b.playerId=p.id
	left join objects o on o.id=p.id and typeid=1
	where b.id=@id
END
GO
