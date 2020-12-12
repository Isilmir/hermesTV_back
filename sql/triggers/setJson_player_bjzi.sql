CREATE TRIGGER setJson_player_bjzi
on dbo.bjzi
AFTER insert,update
as

declare @json nvarchar(max),
@id int,
@name nvarchar(255),
@sideId int ,
@playerId int ,
@squadId int ,
@description nvarchar(max),
@utilized bit ,
@bjziChannelTypeId int,
@deathCaseId int 

DECLARE bjziscur CURSOR FOR   
SELECT * from inserted
  
OPEN bjziscur  
  
FETCH NEXT FROM bjziscur   
INTO @id,
@name,
@sideId  ,
@playerId  ,
@squadId  ,
@description ,
@utilized  ,
@bjziChannelTypeId ,
@deathCaseId 
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_player_resources @playerId,@json out
--print @json

	update top(1) players
	set resources=@json
	where id=@playerId


    FETCH NEXT FROM bjziscur   
    INTO @id,
@name,
@sideId  ,
@playerId  ,
@squadId  ,
@description ,
@utilized  ,
@bjziChannelTypeId, 
@deathCaseId 
END   
CLOSE bjziscur;  
DEALLOCATE bjziscur;  