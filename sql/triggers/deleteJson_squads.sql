CREATE TRIGGER deleteJson_squad
on dbo.squads
AFTER delete
as

declare @json nvarchar(max),
@id int
, @name nvarchar(255)
, @sideId int
, @members nvarchar(max)
, @reserve nvarchar(max)
, @leaderId int
, @exterminated bit 

DECLARE squads_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN squads_del_cur  
  
FETCH NEXT FROM squads_del_cur   
INTO @id
, @name
, @sideId
, @members 
, @reserve 
, @leaderId 
, @exterminated  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='squad')


    FETCH NEXT FROM squads_del_cur   
    INTO @id
, @name
, @sideId
, @members 
, @reserve 
, @leaderId 
, @exterminated  
END   
CLOSE squads_del_cur;  
DEALLOCATE squads_del_cur;  