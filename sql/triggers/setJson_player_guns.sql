CREATE TRIGGER setJson_player_guns
on dbo.guns
AFTER insert,update
as

declare @json nvarchar(max),
@id int,
@gunTypeId int ,
@power decimal(5,2),
@hasrapidFire bit,
@isTurret bit,
@playerId int

DECLARE gunscur CURSOR FOR   
SELECT * from inserted
  
OPEN gunscur  
  
FETCH NEXT FROM gunscur   
INTO @id,
@gunTypeId  ,
@power ,
@hasrapidFire ,
@isTurret ,
@playerId 
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_player_equipment @playerId,@json out
--print @json

	update top(1) players
	set equipment=@json
	where id=@playerId


    FETCH NEXT FROM gunscur   
    INTO @id,
@gunTypeId  ,
@power ,
@hasrapidFire ,
@isTurret ,
@playerId 
END   
CLOSE gunscur;  
DEALLOCATE gunscur;  