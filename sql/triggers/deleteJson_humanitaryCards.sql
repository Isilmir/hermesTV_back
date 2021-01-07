CREATE TRIGGER deleteJson_humanitaryCards
on dbo.humanitaryCards
AFTER delete
as

declare @json nvarchar(max),
@id int
,@utilized bit
,@channelTypeId int


DECLARE humanitaryCards_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN humanitaryCards_del_cur  
  
FETCH NEXT FROM humanitaryCards_del_cur   
INTO @id,
@utilized,
@channelTypeId
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='humanitaryCard')


    FETCH NEXT FROM humanitaryCards_del_cur   
    INTO @id,
@utilized,
@channelTypeId
END   
CLOSE humanitaryCards_del_cur;  
DEALLOCATE humanitaryCards_del_cur;  