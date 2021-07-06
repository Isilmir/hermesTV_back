drop procedure  if exists dbo.getDictionaries
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

-- exec dbo.getDictionaries ''
-- =============================================
CREATE PROCEDURE dbo.getDictionaries
(
    @dicts varchar(max)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	print @dicts

	BEGIN TRY 
		if exists (select * from openjson(@dicts))
		begin 
			print @dicts
		end
	END TRY
	BEGIN CATCH
		set @dicts='[]'
	END CATCH 

	create table #res (dict varchar(255),data nvarchar(max))

    -- Insert statements for procedure here
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='sides')
	begin
		insert into #res
		  select 'sides',isnull((
			select 
		* from sides
		for json path
			),'[]')
	end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='squads')
	begin


		insert into #res
      select 'squads',isnull((
		select 
id,name,sideId from (select * from squads union select null,'без отряда',null,'[]','[]',null,0) squads
for json path
		),'[]')
	end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='deedTypes')
	begin
insert into #res
      select 'deedTypes',isnull((
		select 
* from deedTypes
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='bjziChannelTypes')
	begin
		insert into #res
      select 'bjziChannelTypes',isnull((
		select 
* from [dbo].[bjziChannelTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='channelTypes')
	begin
		insert into #res
      select 'channelTypes',isnull((
		select 
* from [dbo].[channelTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='deathCaseTypes')
	begin
		insert into #res
      select 'deathCaseTypes',isnull((
		select 
* from [dbo].[deathCaseTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='gunTypes')
	begin
		insert into #res
      select 'gunTypes',isnull((
		select 
* from [dbo].[gunTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='heavyWeaponTypes')
	begin		
		insert into #res
      select 'heavyWeaponTypes',isnull((
		select 
* from [dbo].[heavyWeaponTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='objectTypes')
	begin
		insert into #res
      select 'objectTypes',isnull((
		select 
* from [dbo].[objectTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='states')
	begin
		insert into #res
      select 'states',isnull((
		select 
* from [dbo].[states]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='cycleTypes')
	begin
		insert into #res
      select 'cycleTypes',isnull((
		select 
* from [dbo].[cycleTypes]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='gameCycles')
	begin
		insert into #res
      select 'gameCycles',isnull((
		select 
* from [dbo].[gameCycles]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='checkpointStates')
	begin
		insert into #res
      select 'checkpointStates',isnull((
		select 
* from [dbo].[checkpointStates]
for json path
		),'[]')
end
	if not exists (select top 1 * from openjson(@dicts)) or exists (select top 1 * from openjson(@dicts) where value='checkpoints')
	begin
		insert into #res
      select 'checkpoints',isnull((
		select 
* from [dbo].[checkpoints]
for json path
		),'[]')
end
		select * from #res

drop table #res
END
GO
