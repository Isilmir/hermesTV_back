drop procedure  if exists dbo.makeReinforcementsAwaiting
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      ¬оронков »ль€
-- Create Date: 2020-06-01
-- Description: ѕроставл€ет всем геро€м причитающеес€ количество спутников

-- exec dbo.makeReinforcementsAwaiting
-- =============================================
CREATE PROCEDURE dbo.makeReinforcementsAwaiting

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	insert into [deeds](typeId,playerId,honor,description,heroic)
  select 61,p.id,0,
  case 
  when honor > 2499 then '9 спутников уже в пути к герою'  
  when honor between 2000 and 2499 then '8 спутников уже в пути к герою'
  when honor between 1500 and 1999 then '7 спутников уже в пути к герою'
  when honor between 1000 and 1499 then '6 спутников уже в пути к герою'
  when honor between 750 and 999 then '5 спутников уже в пути к герою'
  when honor between 500 and 749 then '4 спутника уже в пути к герою'
  when honor between 300 and 499 then '3 спутника уже в пути к герою'
  when honor between 150 and 299 then '2 спутника уже в пути к герою'
  when honor < 150 then '1 спутник уже в пути к герою'
  else '//ошибка алгоритмов работы ¬÷ зала славы' 
  end
  ,1
  FROM [dbo].[players] p
  join objects o on o.id=p.id and o.typeid=1
  where realname is not null 
  and o.active=1
  and p.stateId!=3
  and not exists (select top 1 id from deeds d where d.playerid=p.id and d.typeId=50)
  order by honor desc

END
GO
