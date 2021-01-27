CREATE TRIGGER setJson_guns
on dbo.guns
AFTER insert,update
as

declare @json nvarchar(max),
@id int
,@gunTypeId int
,@power decimal(5,2)
,@hasrapidFire bit
,@isTurret bit
,@playerId int


DECLARE guns_cur CURSOR FOR   
SELECT * from inserted
  
OPEN guns_cur  
  
FETCH NEXT FROM guns_cur   
INTO @id
,@gunTypeId
,@power
,@hasrapidFire
,@isTurret
,@playerId
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_gun @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='gun'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='gun'),0,source.json);


    FETCH NEXT FROM guns_cur   
    INTO @id
,@gunTypeId
,@power
,@hasrapidFire
,@isTurret
,@playerId 
END   
CLOSE guns_cur;  
DEALLOCATE guns_cur;  