CREATE TRIGGER setJson_gold
on dbo.gold
AFTER insert,update
as

declare @json nvarchar(max),
@id int,
--@name nvarchar(255),
--@sideId int,
--@playerId int,
--@squadId int,
--@description nvarchar(max),
--@utilized bit,
--@bjziChannelTypeId int,
--@deathCaseId int
@date date


DECLARE gold_cur CURSOR FOR   
SELECT * from inserted
  
OPEN gold_cur  
  
FETCH NEXT FROM gold_cur   
INTO @id,
--@name,
--@sideId,
--@playerId ,
--@squadId ,
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId   
@date
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_gold @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='gold'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='gold'),0,source.json);


    FETCH NEXT FROM gold_cur   
    INTO @id,
--@name,
--@sideId,
--@playerId ,
--@squadId ,
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId  ,
@date
END   
CLOSE gold_cur;  
DEALLOCATE gold_cur;  


