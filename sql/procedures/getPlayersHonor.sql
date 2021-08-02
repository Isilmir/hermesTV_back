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

	declare
	@display_honor_1 int,
	@display_honor_2 int,
	@display_honor_3 int,
	@display_honor_4 int,
	@display_honor_5 int,
	@display_honor_6 int,
	@display_honor_7 int,
	@display_honor_8 int,
	@display_honor_9 int,
	@display_honor_10 int,
	@display_honor_11 int,
	@display_honor_12 int,
	@display_honor_13 int,
	@display_honor_14 int,
	@display_honor_15 int,
	@display_honor_16 int

	select @display_honor_1=value from keyValueStorage where storage='honor:display' and key_='display_honor_1'
	select @display_honor_2=value from keyValueStorage where storage='honor:display' and key_='display_honor_2'
	select @display_honor_3=value from keyValueStorage where storage='honor:display' and key_='display_honor_3'
	select @display_honor_4=value from keyValueStorage where storage='honor:display' and key_='display_honor_4'
	select @display_honor_5=value from keyValueStorage where storage='honor:display' and key_='display_honor_5'
	select @display_honor_6=value from keyValueStorage where storage='honor:display' and key_='display_honor_6'
	select @display_honor_7=value from keyValueStorage where storage='honor:display' and key_='display_honor_7'
	select @display_honor_8=value from keyValueStorage where storage='honor:display' and key_='display_honor_8'
	select @display_honor_9=value from keyValueStorage where storage='honor:display' and key_='display_honor_9'
	select @display_honor_10=value from keyValueStorage where storage='honor:display' and key_='display_honor_10'
	select @display_honor_11=value from keyValueStorage where storage='honor:display' and key_='display_honor_11'
	select @display_honor_12=value from keyValueStorage where storage='honor:display' and key_='display_honor_12'
	select @display_honor_13=value from keyValueStorage where storage='honor:display' and key_='display_honor_13'
	select @display_honor_14=value from keyValueStorage where storage='honor:display' and key_='display_honor_14'
	select @display_honor_15=value from keyValueStorage where storage='honor:display' and key_='display_honor_15'
	select @display_honor_16=value from keyValueStorage where storage='honor:display' and key_='display_honor_16'

    -- Insert statements for procedure here
    SELECT 
	  'player' as objectType
	  ,p.id
	  ,p.name
	  --,p.honor --временно убрал чтобы игроки не палили. на игре вернуть
	  ,cast(case  
	  when p.honor<@display_honor_1 then cast(@display_honor_1 as nvarchar(100))+'-'
	  when p.honor>=@display_honor_1  and p.honor<@display_honor_2 then cast(@display_honor_1 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_2  and p.honor<@display_honor_3 then cast(@display_honor_2 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_3  and p.honor<@display_honor_4 then cast(@display_honor_3 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_4  and p.honor<@display_honor_5 then cast(@display_honor_4 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_5  and p.honor<@display_honor_6 then cast(@display_honor_5 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_6  and p.honor<@display_honor_7 then cast(@display_honor_6 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_7  and p.honor<@display_honor_8 then cast(@display_honor_7 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_8  and p.honor<@display_honor_9 then cast(@display_honor_8 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_9  and p.honor<@display_honor_10 then cast(@display_honor_9 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_10  and p.honor<@display_honor_11 then cast(@display_honor_10 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_11  and p.honor<@display_honor_12 then cast(@display_honor_11 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_12  and p.honor<@display_honor_13 then cast(@display_honor_12 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_13  and p.honor<@display_honor_14 then cast(@display_honor_13 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_14  and p.honor<@display_honor_15 then cast(@display_honor_14 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_15  and p.honor<@display_honor_16 then cast(@display_honor_15 as nvarchar(100))+'+'
	  when p.honor>=@display_honor_16 then cast(@display_honor_16 as nvarchar(100))+'+'
	  else 'ошибка алгритмов ВЦ АИД' 
	  end as nvarchar(100)) as displayHonor
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
  where 1=1 
  --and realName is not null
  and p.sideId!=16333
  and o.active=1
END
GO
