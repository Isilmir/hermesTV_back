CREATE TRIGGER setJson_squad_bjzi
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

exec dbo.compileJson_player_resources @squadId,@json out
--print @json

	update top(1) squads
	set reserve=@json
	where id=@squadId


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