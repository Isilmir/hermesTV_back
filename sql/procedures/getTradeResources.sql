drop procedure  if exists dbo.getTradeResources
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-06-29
-- Description: возвращает доступные для торговли ресурсы

-- exec dbo.getTradeResources 42866
-- =============================================
CREATE PROCEDURE dbo.getTradeResources
(
    @id int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @nowCycle int, @nowCycleType int,@UC_leader varchar(255),@DBS_leader varchar(255),@playerHonor int

	create table #deeds (id int,objectType varchar(255),deedTypeId int,deedTypeName nvarchar(255),description nvarchar(max),date datetime)
	create table #restrictions (resource varchar(255))
	create table #transactions (resource varchar(255),cycleId int, cycleTypeId int)
	
	insert into #deeds
	select d.id,'deed',d.typeId,dt.name,d.description,d.date from deeds d left join deedTypes dt on dt.id=d.typeId where d.playerId=@id

	insert into #transactions
	select resource,isnull((select top 1 id from gameCycles where dateadd(hh,3,date) between startTime and endTime),case when getdate()<(select top 1 min(startTime) from gameCycles)then 0 else 17 end),isnull((select top 1 cycleTypeId from gameCycles where dateadd(hh,3,date) between startTime and endTime),1) from transactions where playerId=@id

	select @nowCycle=(select isnull((select top 1 id from gameCycles where dateadd(hh,3,getdate()) between startTime and endTime),case when getdate()<(select top 1 min(startTime) from gameCycles)then 0 else 17 end))

	select @nowCycleType=isnull((select top 1 cycleTypeId from gameCycles where dateadd(hh,3,getdate()) between startTime and endTime),1)

	select @UC_leader=value from keyValueStorage where storage='economy' and key_='UC_leader'
	select @DBS_leader=value from keyValueStorage where storage='economy' and key_='DBS_leader'
	select @playerHonor=honor from players where id=@id

	--select * from #deeds

	--select * from #transactions

	--select @nowCycle

	if exists(select top 1 deedTypeId from #deeds where deedTypeId=50)
	begin
		insert into #restrictions
		select resource from (values('bjzi'))as list(resource)
	end

	if exists(select top 1 deedTypeId from #deeds where deedTypeId=51)
	begin
		insert into #restrictions
		select resource from (values('grenades'))as list(resource)
	end

	if exists(select top 1 deedTypeId from #deeds where deedTypeId=52)
	begin
		insert into #restrictions
		select resource from (values('humanitary'))as list(resource)
	end

	if @id!=@UC_leader or exists(select top 1 resource from #transactions where cycleId=@nowCycle and resource='Гуманитарка командиру UC')
	begin
		insert into #restrictions
		select resource from (values('humanitary_all'))as list(resource)
	end

	if @id!=@DBS_leader or @nowCycleType=1 or exists(select top 1 resource from #transactions where cycleId=@nowCycle and resource='Гуманитарка командиру DBS (война)')
	begin
		insert into #restrictions
		select resource from (values('humanitary_war'))as list(resource)
	end

	if @id!=@DBS_leader or @nowCycleType=2 or exists(select top 1 resource from #transactions where cycleId=@nowCycle and resource='Гуманитарка командиру DBS (перемирие)')
	begin
		insert into #restrictions
		select resource from (values('humanitary_peace'))as list(resource)
	end

	if @playerHonor<1000
	begin
		insert into #restrictions
		select resource from (values('policy_gold'))as list(resource)
	end

	if not exists(select top 1 resource from #transactions where resource='Золотой полис')
	begin
		insert into #restrictions
		select resource from (values('policy_platinum'))as list(resource)
	end

	if exists(select top 1 deedTypeId from #deeds where deedTypeId=53)
	begin
		insert into #restrictions
		select resource from (values
		('license_grenadeLauncher'),
		('license_laser'),
		('license_collimator'),
		('license_optic'),
		('license_UV'),
		('license_drone'),
		('license_shield')
		)as list(resource)
	end

	if exists(select top 1 deedTypeId from #deeds where deedTypeId=54)
	begin
		insert into #restrictions
		select resource from (values('bjzi'))as list(resource)
	end

	if exists(select top 1 deedTypeId from #deeds where deedTypeId=67)
	begin
		insert into #restrictions
		select resource from (values('ares_squad'))as list(resource)
	end

	--select * from #restrictions
	
   select eco.id as id,god.value as god/*,eco.key_ as resourceCode*/,eco.value as quantity,eco.description as resource
from keyvaluestorage eco
left join keyvaluestorage god on god.storage='gods' and god.key_=substring(eco.storage,9,len(eco.storage))
where eco.storage like 'economy:%'
and eco.key_ not in (select resource from #restrictions)

	select * from #deeds where deedTypeId in (36,37,38,39,67,54,53,52,51,50,57,78)

drop table #restrictions
drop table #deeds
drop table #transactions

END
GO
