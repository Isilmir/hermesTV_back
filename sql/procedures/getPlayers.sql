drop procedure  if exists dbo.getPlayers
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-03-29
-- Description: возвращает данные по персонажам

-- exec dbo.getPlayers 1
-- =============================================
CREATE PROCEDURE dbo.getPlayers
(
    @res int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
       SELECT 
	  'player' as objectType
	  ,p.id
	  ,p.name
	  ,p.stateId
	  ,p.sideId
	  ,s.description as sideDescription
	  ,p.squadId
	  ,sq.name as squadName
	  ,p.honor
	  ,p.updatedAt
	  ,p.realName
	  ,p.password
	  ,o.active
  FROM [dbo].[players]p
  left join dbo.objects o on o.id=p.id and o.typeId=1
  left join sides s on s.id=p.sideid
  left join squads sq on sq.id=p.squadid
  where 1=1
  and p.sideId!=16333
  --and p.realName is not null
END
GO
