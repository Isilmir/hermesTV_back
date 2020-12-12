CREATE TRIGGER setJson_humanitaryCards
on dbo.humanitaryCards
AFTER insert,update
as

declare @json nvarchar(max),
@id int
,@utilized bit
,@channelTypeId int


DECLARE cur CURSOR FOR   
SELECT * from inserted
  
OPEN cur  
  
FETCH NEXT FROM cur   
INTO @id,
@utilized,
@channelTypeId
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_humanitaryCard @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='humanitaryCard'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='humanitaryCard'),0,source.json);


    FETCH NEXT FROM cur   
    INTO @id,
@utilized,
@channelTypeId
END   
CLOSE cur;  
DEALLOCATE cur;  