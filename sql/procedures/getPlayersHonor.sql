drop procedure  if exists dbo.getPlayersHonor
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-03-21
-- Description: возвращает данные для зала славы

-- exec dbo.getPlayersHonor
-- =============================================
CREATE PROCEDURE dbo.getPlayersHonor
(
    @id int
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
	  --,p.honor --временно убрал чтобы игроки не палили. на игре вернуть
	  ,cast(row_number() over(order by p.honor) as int) as honor
	  ,stateId
	  --,(select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-7 and getdate()) --временно убрал от игроков
	  ,case when(select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-7 and getdate())!=0 then (select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-7 and getdate())/abs((select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-7 and getdate())) else (select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-7 and getdate())end
	  ---(select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-14 and getdate()-7) 
	  as honorChange
	  ,dbo.compileJson_player_deeds_group_by_types_func(p.id,@id) as deedGroups
	  ,isnull((select id,god,resource,quantity,description,dateadd(hh,3,date)as date from transactions where playerid=p.id for json path),'[]') as transactions 
  FROM [dbo].[players]p
  left join objects o on o.id=p.id and o.typeId=1
  where realName is not null
  and p.sideId!=16333
  and o.active=1
END
GO
