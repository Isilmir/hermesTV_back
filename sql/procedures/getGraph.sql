USE [RDM_stage]
GO
/****** Object:  StoredProcedure [usr].[getGraph]    Script Date: 04.08.2020 15:07:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Воронков Илья
-- Create date: 2019-12-16
-- Description:	Процедура выводит полный граф по одной вершине
-- 
-- UPD 2020-03-05: Добавлен входящий атрибут @deep - количество шагов вглубь графа от исходной вершины. Воронков Илья
-- UPD 2020-03-12: Добавлен входящий атрибут @straightforward - собирать ли весь граф или только по направлению вперед. Воронков Илья
-- =============================================
ALTER PROCEDURE [usr].[getGraph]
	-- Add the parameters for the stored procedure here
	@id varchar(255)
	,@link varchar(255)
	,@type varchar(255) = null
	,@sys varchar(255) = null
	,@deep int = 9
	,@straightforward bit = 0

AS
BEGIN
------значения для дебага
--declare @id varchar(255)='013900268045020206010000019478'--'240021262'--'013900268045020206010000019478'
--	,@link varchar(255)='mark_model_test_v2'
--	,@type varchar(255) = 'VEHICLES'--null
--	,@sys varchar(255) = null--'RSA'
--	,@deep int = 9
--	,@straightforward bit = 0
------
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare @ErrorMessage nvarchar(4000)
	Declare @ErrorSeverity int = 16
	Declare @ErrorState int = 1
	Declare @ErrorNumber int = 5000

	DECLARE @id_from int,@id_to int,@n int=1--,@timer datetime=getdate()
,@query varchar(max)

-- Убрал проверку на повторения одного идентификатора
/*set @query='
declare @count varchar(max),@ErrorMessage varchar(max),@ErrorNumber int = 5000
	select @count=count(*) from data.'+@link+' where objectid='''+@id+'''
	if @count>1
	begin
		set @ErrorMessage = N''В линке обнаружено более одного типа с идентификатором ['+@id+']''	
		raiserror(@ErrorMessage,16,1)
		--return @ErrorNumber
	end
	'
execute (@query)*/
if object_id('tempdb..#tab') is not null drop table #tab
create table #tab (id_from int,id_to int)


if @straightforward=0
	begin
	set @query='
	declare @type varchar(255)='+case when @type is null then 'null' else ''''+@type+'''' end+'
	declare @sys varchar(255)='+case when @sys is null then 'null' else ''''+@sys+'''' end+'
	insert into #tab
	select m.NodeIDFrom as id_from,m.NodeIDto as id_to
	from [map].['+@link+']m
	  left join [data].['+@link+'] dfrom on m.NodeIDFrom=dfrom.NodeID
	  left join [data].['+@link+'] dto on m.NodeIDto=dto.NodeID
	  where (dfrom.objectid='''+@id+''' and isnull(@type,dfrom.ObjectTypeID)=dfrom.ObjectTypeID and isnull(@sys,dfrom.SystemID)=dfrom.SystemID)
	  or (dto.objectid='''+@id+''' and isnull(@type,dto.ObjectTypeID)=dto.ObjectTypeID and isnull(@sys,dto.SystemID)=dto.SystemID)
	'
	end
	else
	begin
	set @query='
	declare @type varchar(255)='+case when @type is null then 'null' else ''''+@type+'''' end+'
	declare @sys varchar(255)='+case when @sys is null then 'null' else ''''+@sys+'''' end+'
	insert into #tab
	select m.NodeIDFrom as id_from,m.NodeIDto as id_to
	from [map].['+@link+']m
	  left join [data].['+@link+'] dfrom on m.NodeIDFrom=dfrom.NodeID
	  /*left join [data].['+@link+'] dto on m.NodeIDto=dto.NodeID*/
	  where (dfrom.objectid='''+@id+''' and isnull(@type,dfrom.ObjectTypeID)=dfrom.ObjectTypeID and isnull(@sys,dfrom.SystemID)=dfrom.SystemID)
	  /*or (dto.objectid='''+@id+''' and isnull(@type,dto.ObjectTypeID)=dto.ObjectTypeID and isnull(@sys,dto.SystemID)=dto.SystemID)*/
	'
	end


execute (@query)
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

if @straightforward=0
begin
 set @query='
        insert into #cur0 --следующая итерация
        select m.NodeIDFrom,m.NodeIDTo
        from [map].['+@link+']m
        join #cur l on (m.NodeIDFrom=l.id_to or m.NodeIDFrom=l.id_from or m.NodeIDTo=l.id_from or m.NodeIDTo=l.id_to)
        where cast(m.NodeIDFrom as varchar(100))+''->''+cast(m.NodeIDto as varchar(100)) not in (select cast(id_from as varchar(100))+''->''+cast(id_to as varchar(100))from #tab)
		'
end
else
begin
set @query='
        insert into #cur0 --следующая итерация
        select m.NodeIDFrom,m.NodeIDTo
        from [map].['+@link+']m
        join #cur l on (m.NodeIDFrom=l.id_to /*or m.NodeIDFrom=l.id_from or m.NodeIDTo=l.id_from or m.NodeIDTo=l.id_to*/)
        where cast(m.NodeIDFrom as varchar(100))+''->''+cast(m.NodeIDto as varchar(100)) not in (select cast(id_from as varchar(100))+''->''+cast(id_to as varchar(100))from #tab)
		'
end
		execute (@query)

		truncate table #cur

		insert into #cur
		select * from #cur0

		truncate table #cur0

  set @n=@n+1

END

set @query='
select distinct dfrom.NodeID as nodeFrom,dfrom.ObjectID as idFrom,dfrom.ObjectTypeID as objtypeFrom,dfrom.SystemID as sysFrom,dto.NodeID as nodeTo,dto.ObjectID as idTo,dto.ObjectTypeID as objtypeTo,dto.SystemID as sysTo
from #tab m
left join [data].['+@link+'] dfrom on m.id_from=dfrom.NodeID
left join [data].['+@link+'] dto on m.id_to=dto.NodeID
'
execute (@query)
 -- print datediff(ms,@timer,getdate())

END
