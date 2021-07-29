drop procedure  if exists dbo.getPlayers_for_printform
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		»ль€ ¬оронков
-- Create date: 2021-07-29
-- Description:	возвращает всех пресонажей дл€ генератора

--exec dbo.getPlayers_for_printform 
-- =============================================
CREATE PROCEDURE dbo.getPlayers_for_printform 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
	  'player' as objectType
	  ,p.id
	  ,p.name
  FROM [dbo].[players]p
  left join dbo.objects o on o.id=p.id and o.typeId=1
  left join sides s on s.id=p.sideid
  left join squads sq on sq.id=p.squadid
  where 1=1
  and p.sideId!=16333
  and realname is not null
  and stateid!=3
  and squadid not in (100003,100002,100001)
  and realname not in ('персонаж из мастерского резерва','test','виртуальный персонаж')
  order by p.name
	
END
GO

