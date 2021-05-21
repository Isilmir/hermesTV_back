Create TRIGGER deleteJson_bjzi
on dbo.bjzi
AFTER delete
as

declare 
@id int,
--@name nvarchar(255),
--@sideId int,
@playerId int,
@squadId int,
--@description nvarchar(max),
--@utilized bit,
--@bjziChannelTypeId int,
--@deathCaseId int,
--@printform varchar(max),
@players_json nvarchar(max),
@squads_json nvarchar(max)


DECLARE bjzi_del_cur CURSOR FOR   
SELECT id,playerId,squadId from deleted
  
OPEN bjzi_del_cur  
  
FETCH NEXT FROM bjzi_del_cur   
INTO @id,
--@name,
--@sideId,
@playerId ,
@squadId 
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId ,
--@printform
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='bjzi')

	exec dbo.compileJson_player_resources @playerId,@players_json out
--print @json

	update top(1) players
	set resourñes=@players_json
	where id=@playerId

	exec dbo.compileJson_squad_reserve @squadId,@squads_json out
--print @json

	update top(1) squads
	set reserve=@squads_json
	where id=@squadId

    FETCH NEXT FROM bjzi_del_cur   
    INTO @id,
--@name,
--@sideId,
@playerId ,
@squadId 
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId ,
--@printform
END   
CLOSE bjzi_del_cur;  
DEALLOCATE bjzi_del_cur;  


