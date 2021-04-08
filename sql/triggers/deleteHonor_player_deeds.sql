CREATE TRIGGER deleteHonor_player_deeds
on dbo.deeds
AFTER delete
as

declare @honorSum int,
@id int,
@typeId int,
@playerId int ,
@description nvarchar(255),
@date datetime,
@heroic bit,
@honor int

DECLARE deeds_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN deeds_del_cur  
  
FETCH NEXT FROM deeds_del_cur   
INTO @id,
@typeId,
@playerId,
@honor,
@description,
@date,
@heroic
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

select @honorSum=sum(honor) from dbo.deeds
where playerId=@playerId
and id!=@id
group by playerId
--print @honorSum

	update top(1) players
	set honor=@honorSum
	where id=@playerId

    FETCH NEXT FROM deeds_del_cur   
    INTO @id,
@typeId,
@playerId,
@honor,
@description,
@date,
@heroic
END   
CLOSE deeds_del_cur;  
DEALLOCATE deeds_del_cur;  