drop procedure  if exists dbo.getMessages
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-05-22
-- Description: получить сообщения
-- =============================================
CREATE PROCEDURE dbo.getMessages
(
    @res nvarchar(max) output
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    select m.id,m.description
	,d.id as deedId,dt.id as deedTypeId,dt.name as deedTypeName,dt.description as deedTypeDescription,d.description as deedDescription,d.date as deedDate,d.heroic as deedHeroic
	,p.id as playerId,p.name as playerName
	,sq.id as squadId,sq.name as squadName,s.id as sideId,s.description as sideDescription 
	from messages m
	join deeds d on d.id=m.deedId
	join deedTypes dt on dt.id=d.typeId
	join players p on p.id=d.playerId
	join squads sq on sq.id=p.squadId 
	join sides s on s.id=p.sideId 
END
GO
