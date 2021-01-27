CREATE TRIGGER deleteJson_guns
on dbo.guns
AFTER delete
as

declare 
@id int
,@gunTypeId int
,@power decimal(5,2)
,@hasrapidFire bit
,@isTurret bit
,@playerId int
,@json nvarchar(max)

DECLARE guns_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN guns_del_cur  
  
FETCH NEXT FROM guns_del_cur   
INTO @id
,@gunTypeId
,@power
,@hasrapidFire
,@isTurret
,@playerId
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='gun')

	exec dbo.compileJson_player_equipment @playerId,@json out
--print @json

	update top(1) players
	set equipment=@json
	where id=@playerId

    FETCH NEXT FROM guns_del_cur   
    INTO @id
,@gunTypeId
,@power
,@hasrapidFire
,@isTurret
,@playerId 
END   
CLOSE guns_del_cur;  
DEALLOCATE guns_del_cur;  