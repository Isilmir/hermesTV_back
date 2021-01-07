CREATE TRIGGER deleteJson_insult
on dbo.insults
AFTER delete
as

declare @json nvarchar(max),
@id int
,@description nvarchar(255)
,@longDescription nvarchar(max)
,@finished bit 

DECLARE insults_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN insults_del_cur  
  
FETCH NEXT FROM insults_del_cur   
INTO @id
,@description
,@longDescription
,@finished
  
WHILE @@FETCH_STATUS = 0  
BEGIN  


	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='insult')


    FETCH NEXT FROM insults_del_cur   
    INTO @id
,@description
,@longDescription
,@finished
END   
CLOSE insults_del_cur;  
DEALLOCATE insults_del_cur;  