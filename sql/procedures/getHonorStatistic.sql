drop procedure  if exists dbo.getHonorStatistic
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-07-16
-- Description: возвращает данные статистики по славе

-- exec dbo.getHonorStatistic '','2021-01-01','2022-01-01',10
-- =============================================
CREATE PROCEDURE dbo.getHonorStatistic
(
    @deedTypes varchar(max),
	@start date,
	@end date,
	@n int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	print @deedTypes

	declare @query nvarchar(max) --@start date='2021-01-01', @end date='2022-01-01', @n int = 20,@deedTypes varchar(max)='[]'

	BEGIN TRY 
		if exists (select * from openjson(@deedTypes))
		begin 
			print @deedTypes
		end
	END TRY
	BEGIN CATCH
		set @deedTypes='[]'
	END CATCH 

	--select * from openjson(@deedTypes)

 IF OBJECT_ID('tempdb.dbo.#selectedDeeds', 'U') IS NOT NULL DROP TABLE #selectedDeeds; 
 create table #selectedDeeds (id int)

 if exists (select * from openjson(@deedTypes))
 begin 
	 insert into #selectedDeeds
	 select value from openjson(@deedTypes)
 end
 else
 begin
	 insert into #selectedDeeds
	 select id from deedTypes
	 where id not in (0)
 end
 
 set @query=N'SELECT distinct 
dt.description
,dt.id
,(select count(distinct pp.id) from deeds dp join players pp on pp.id=dp.playerid join objects op on op.id=pp.id and op.typeId=1 where op.active=1 and pp.realName is not null and dp.date between '''+convert(nvarchar(100),@start,23)+N''' and '''+convert(nvarchar(100),@end,23)+N''' and dp.typeid=d.typeid) as users_all /*всего игроков у кого есть это деяние*/
,count(*)over(partition by dt.id) as deeds_count /*количество деяний с данным типом*/
,sum(d.honor)over(partition by dt.id) as deeds_sum /*сумма славы всего по данному типу*/
,avg(d.honor)over(partition by dt.id) as avg_honor_by_deed /*среднее значение славы по типу на одно деяние*/
,sum(d.honor)over(partition by dt.id)/(select count(distinct pp.id) from deeds dp join players pp on pp.id=dp.playerid join objects op on op.id=pp.id and op.typeId=1 where op.active=1 and pp.realName is not null and dp.date between '''+convert(nvarchar(100),@start,23)+N''' and '''+convert(nvarchar(100),@end,23)+N''' and dp.typeid=d.typeid) as avg_honor_by_player /*среднее значение славы по типу деяния на одного персонажа*/
,(SELECT TOP (1) Percentile_Disc (0.5)
           WITHIN GROUP (ORDER BY dm.honor)
           OVER()
FROM deeds dm
join players pm on pm.id=dm.playerId
join objects om on om.id=pm.id and om.typeId=1
where dm.typeId=d.typeid
and om.active=1
  and pm.realName is not null
  and dm.date between '''+convert(nvarchar(100),@start,23)+N''' and '''+convert(nvarchar(100),@end,23)+N''') as honor_median /*медиана по данному типу*/
, isnull((select sum(dsn.honor) from deeds dsn where dsn.typeId=d.typeId and dsn.date between '''+convert(nvarchar(100),@start,23)+N''' and '''+convert(nvarchar(100),@end,23)+N''' and playerId in (select top '+cast(@N as nvarchar(100))+' pns.id from players pns join objects ons on ons.id=pns.id and ons.typeId=1 where ons.active=1 and pns.realName is not null order by honor desc)),0) as honor_sum_by_n_players/*Сумма славы по этому типу деяния для top N игроков по славе*/
,round(cast(isnull((select sum(dsn.honor) from deeds dsn where dsn.typeId=d.typeId and dsn.date between '''+convert(nvarchar(100),@start,23)+N''' and '''+convert(nvarchar(100),@end,23)+N''' and playerId in (select top '+cast(@N as nvarchar(100))+' pnp.id from players pnp join objects onp on onp.id=pnp.id and onp.typeId=1 where onp.active=1 and pnp.realName is not null order by honor desc)),0) as float)/cast((case when sum(d.honor)over(partition by dt.id) = 0 then 1 else sum(d.honor)over(partition by dt.id) end ) as float)*100,2) as honor_percent_by_n_players /*Процент славы по этому типу для top N игроков по славе*/
  FROM deeds d
  join #selectedDeeds sd on sd.id=d.typeId or not exists (select * from #selectedDeeds)
  join players p on p.id=d.playerId
  join deedTypes dt on dt.id=d.typeId
  join objects o on o.id=p.id and o.typeId=1
  where o.active=1
  and p.realName is not null
  and d.date between '''+convert(nvarchar(100),@start,23)+N''' and '''+convert(nvarchar(100),@end,23)+N'''
  order by 2 desc'

  exec sp_executesql @query

IF OBJECT_ID('tempdb.dbo.#selectedDeeds', 'U') IS NOT NULL DROP TABLE #selectedDeeds;
END
GO
