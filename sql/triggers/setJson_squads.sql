CREATE TRIGGER setJson_squad
on dbo.squads
AFTER insert,update
as

declare @json nvarchar(max),
@id int
, @name nvarchar(255)
, @sideId int
, @members nvarchar(max)
, @reserve nvarchar(max)
, @leaderId int
, @exterminated bit 

DECLARE cur CURSOR FOR   
SELECT * from inserted
  
OPEN cur  
  
FETCH NEXT FROM cur   
INTO @id
, @name
, @sideId
, @members 
, @reserve 
, @leaderId 
, @exterminated  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_squad @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='squad'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='squad'),0,source.json);


    FETCH NEXT FROM cur   
    INTO @id
, @name
, @sideId
, @members 
, @reserve 
, @leaderId 
, @exterminated  
END   
CLOSE cur;  
DEALLOCATE cur;  