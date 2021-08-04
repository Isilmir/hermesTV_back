drop procedure  if exists dbo.makeReinforcementsAwaiting
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-06-01
-- Description: Проставляет всем героям причитающееся количество спутников

-- exec dbo.makeReinforcementsAwaiting
-- =============================================
CREATE PROCEDURE dbo.makeReinforcementsAwaiting

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @reinforcements_1 int, @reinforcements_2 int,
	@reinforcements_3 int,
	@reinforcements_4 int,
	@reinforcements_5 int,
	@reinforcements_6 int,
	@reinforcements_7 int,
	@reinforcements_8 int,
	@reinforcements_9 int,
	@reinforcements_10 int

	select @reinforcements_1=value from keyValueStorage where storage='honor' and key_='reinforcements_1'
	select @reinforcements_2=value from keyValueStorage where storage='honor' and key_='reinforcements_2'
	select @reinforcements_3=value from keyValueStorage where storage='honor' and key_='reinforcements_3'
	select @reinforcements_4=value from keyValueStorage where storage='honor' and key_='reinforcements_4'
	select @reinforcements_5=value from keyValueStorage where storage='honor' and key_='reinforcements_5'
	select @reinforcements_6=value from keyValueStorage where storage='honor' and key_='reinforcements_6'
	select @reinforcements_7=value from keyValueStorage where storage='honor' and key_='reinforcements_7'
	select @reinforcements_8=value from keyValueStorage where storage='honor' and key_='reinforcements_8'
	select @reinforcements_9=value from keyValueStorage where storage='honor' and key_='reinforcements_9'
	select @reinforcements_10=value from keyValueStorage where storage='honor' and key_='reinforcements_10'

	insert into [deeds](typeId,playerId,honor,description,heroic)
  select 61,p.id,0,
  case 
  when honor > (@reinforcements_10-1) then '10 спутников уже в пути к герою'  
  when honor between @reinforcements_9 and (@reinforcements_10-1) then '8 спутников уже в пути к герою'
  when honor between @reinforcements_8 and (@reinforcements_9-1) then '8 спутников уже в пути к герою'
  when honor between @reinforcements_7 and (@reinforcements_8-1) then '7 спутников уже в пути к герою'
  when honor between @reinforcements_6 and (@reinforcements_7-1) then '6 спутников уже в пути к герою'
  when honor between @reinforcements_5 and (@reinforcements_6-1) then '5 спутников уже в пути к герою'
  when honor between @reinforcements_4 and (@reinforcements_5-1) then '4 спутника уже в пути к герою'
  when honor between @reinforcements_3 and (@reinforcements_4-1) then '3 спутника уже в пути к герою'
  when honor between @reinforcements_2 and (@reinforcements_3-1) then '2 спутника уже в пути к герою'
  when honor between @reinforcements_1 and (@reinforcements_2-1) then '1 спутник уже в пути к герою'
  when honor < @reinforcements_1 then 'Увы, война не оставила никого, кто пришел бы к герою'
  else '//ошибка алгоритмов работы ВЦ зала славы' 
  end
  ,1
  FROM [dbo].[players] p
  join objects o on o.id=p.id and o.typeid=1
  where realname is not null 
  and o.active=1
  and p.stateId!=3
  and p.honor >= @reinforcements_1
  and not exists (select top 1 id from deeds d where d.playerid=p.id and d.typeId=50)
  order by honor desc

END
GO
