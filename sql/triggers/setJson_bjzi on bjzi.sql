CREATE TRIGGER setJson_bjzi
on dbo.bjzi
AFTER insert,update
as

declare @json nvarchar(max),
@id int
--@name nvarchar(255),
--@sideId int,
--@playerId int,
--@squadId int,
--@description nvarchar(max),
--@utilized bit,
--@bjziChannelTypeId int,
--@deathCaseId int,
--@printform varchar(max)


DECLARE bjzi_cur CURSOR FOR   
SELECT id from inserted
  
OPEN bjzi_cur  
  
FETCH NEXT FROM bjzi_cur   
INTO @id
--@name,
--@sideId,
--@playerId ,
--@squadId ,
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId   ,
--@printform
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_bjzi @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='bjzi'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='bjzi'),0,source.json);


    FETCH NEXT FROM bjzi_cur   
    INTO @id
--@name,
--@sideId,
--@playerId ,
--@squadId ,
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId  ,
--@printform
END   
CLOSE bjzi_cur;  
DEALLOCATE bjzi_cur;  


