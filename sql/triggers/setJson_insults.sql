CREATE TRIGGER setJson_insult
on dbo.insults
AFTER insert,update
as

declare @json nvarchar(max),
@id int
,@description nvarchar(255)
,@longDescription nvarchar(max)
,@finished bit 

DECLARE insult_cur CURSOR FOR   
SELECT * from inserted
  
OPEN insult_cur  
  
FETCH NEXT FROM insult_cur   
INTO @id
,@description
,@longDescription
,@finished
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_insult @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='insult'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='insult'),0,source.json);


    FETCH NEXT FROM insult_cur   
    INTO @id
,@description
,@longDescription
,@finished
END   
CLOSE insult_cur;  
DEALLOCATE insult_cur;  