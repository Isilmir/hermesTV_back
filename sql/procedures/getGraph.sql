USE [hermestv]
drop procedure  if exists dbo.getGraph
GO
/****** Object:  StoredProcedure [usr].[getGraph]    Script Date: 04.08.2020 15:07:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Воронков Илья
-- Create date: 2021-01-28
-- Description:	Процедура выводит полный граф по одной вершине
-- Пример
-- exec dbo.getGraph 43031, 'player', 9
-- =============================================
Create PROCEDURE [dbo].[getGraph]
	-- Add the parameters for the stored procedure here
	@id int
	,@type varchar(255) = null
	,@deep int = 9
	--,@straightforward bit = 0

AS
BEGIN
------значения для дебага
--declare @id int = 43031--2
--	,@type int = 1--19
--	,@deep int = 9
--	--,@straightforward bit = 0
------


  DECLARE @id_from int,@id_to int,@n int=1,@type_ int

  select @type_=id from objectTypes where name=@type

  if object_id('tempdb..#tab') is not null drop table #tab
create table #tab (id int,id_from int, type_from int,id_to int, type_to int)


insert into #tab (id,id_from, type_from,id_to, type_to)
  select l.id,l.objidfrom,l.objtypefrom,l.objidto,l.objtypeto from links l
  where (objTypeFrom = @type_ and objIdFrom = @id)
  or (objTypeTo = @type_ and objIdTo = @id)


  if object_id('tempdb..#cur') is not null drop table #cur
  select * into #cur
  from #tab
if object_id('tempdb..#cur0') is not null drop table #cur0
  select * into #cur0
  from #cur

  truncate table #tab
  truncate table #cur0

  print '-----'
WHILE exists (select * from #cur) and @n<@deep+1
BEGIN
    PRINT cast(@n as varchar(10))+'. '

 insert into #tab
 select* from #cur


        insert into #cur0 --следующая итерация
        select distinct m.id,m.objidfrom,m.objtypefrom,m.objidto,m.objtypeto
        from links m
        join #cur l on ((m.objidfrom=l.id_to and m.objtypefrom=l.type_to) 
					 or (m.objidfrom=l.id_from and m.objtypefrom=l.type_from)
					 or (m.objidto=l.id_from and m.objtypeto=l.type_from)
					 or (m.objidto=l.id_to and m.objtypeto=l.type_to))
        where cast(m.objidfrom as varchar(100)) +'|'+cast(m.objtypefrom as varchar(100)) +'->'+cast(m.objidto as varchar(100)) +'|'+cast(m.objtypeto as varchar(100))  
			not in (select cast(id_from as varchar(100)) +'|'+cast(type_from as varchar(100)) +'->'+cast(id_to as varchar(100)) +'|'+cast(type_to as varchar(100))  from #tab)
		

		truncate table #cur

		insert into #cur
		select * from #cur0

		truncate table #cur0

  set @n=@n+1

END
	
	if not exists (select top 1 id from #tab) and ((exists(select top 1 id from players where id=@id) and @type='player') or (exists(select top 1 id from stories where id=@id) and @type='story'))
	begin
		insert into #tab
		select null,@id,@type_,null,null
	end

  select t.id,t.id_from,t.type_from, isnull(sfrom.description,pfrom.name) as name_from , otfrom.name as type_from_desc,t.id_to,t.type_to, isnull(sto.description,pto.name) as name_to, otTo.name as type_to_desc,l.description   
  from #tab t
  left join links l on l.id=t.id
  left join stories sFrom on sfrom.id=t.id_from--l.objidfrom 
							and t.type_from=19--l.objtypefrom=19
  left join stories sTo on sto.id=t.id_to--l.objidto 
							and t.type_to=19--l.objtypeto=19
  left join players pFrom on pfrom.id=t.id_from--l.objidfrom 
							and t.type_from=1--l.objtypefrom=1
  left join players pTo on pto.id=t.id_to--l.objidto 
							and t.type_to=1--l.objtypeto=1
  left join objectTypes otFrom on otFrom.id=t.type_from
  left join objectTypes otTo on otTo.id=t.type_to

END
