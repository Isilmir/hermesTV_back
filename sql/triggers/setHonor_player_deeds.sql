CREATE TRIGGER setHonor_player_deeds
on dbo.deeds
AFTER insert,update
as

declare @honorSum int,@json nvarchar(max),
@id int,
--@typeId int,
@playerId int 
--@honor int,
--@heroic bit,
--@description nvarchar(255),
--@date datetime

DECLARE deedscur CURSOR FOR   
SELECT id,playerId from inserted
  
OPEN deedscur  
  
FETCH NEXT FROM deedscur   
INTO @id,
--@typeId,
@playerId
--@honor,
--@description,
--@date,
--@heroic
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

select @honorSum=sum(honor) from dbo.deeds
where playerId=@playerId
group by playerId
--print @honorSum

	update top(1) players
	set honor=@honorSum
	where id=@playerId


FETCH NEXT FROM deedscur   
INTO @id,
--@typeId,
@playerId
--@honor,
--@description,
--@date,
--@heroic
END   
CLOSE deedscur;  
DEALLOCATE deedscur;  