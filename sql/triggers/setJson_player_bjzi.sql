CREATE TRIGGER setJson_player_bjzi
on dbo.bjzi
AFTER insert,update
as

declare @json nvarchar(max),@json_del nvarchar(max),
--@id int,
--@name nvarchar(255),
--@sideId int ,
@playerId int ,
--@squadId int ,
--@description nvarchar(max),
--@utilized bit ,
--@bjziChannelTypeId int,
--@deathCaseId int ,
--@printform varchar(max),
--@id_del int,
--@name_del nvarchar(255),
--@sideId_del int ,
@playerId_del int 
--@squadId_del int ,
--@description_del nvarchar(max),
--@utilized_del bit ,
--@bjziChannelTypeId_del int,
--@deathCaseId_del int ,
--@printform_del varchar(max)

DECLARE bjziscur CURSOR FOR   
SELECT i.playerId,d.playerId from inserted i
left join deleted d on d.id=i.id
  
OPEN bjziscur  
  
FETCH NEXT FROM bjziscur   
INTO --@id,
--@name,
--@sideId  ,
@playerId  ,
--@squadId  ,
--@description ,
--@utilized  ,
--@bjziChannelTypeId ,
--@deathCaseId ,
--@printform,
--@id_del,
--@name_del,
--@sideId_del  ,
@playerId_del  
--@squadId_del  ,
--@description_del ,
--@utilized_del  ,
--@bjziChannelTypeId_del ,
--@deathCaseId_del ,
--@printform_del

  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_player_resources @playerId,@json out
exec dbo.compileJson_player_resources @playerId_del,@json_del out
--print @json

	update top(1) players
	set resourñes=@json
	where id=@playerId

	update top(1) players
	set resourñes=@json_del
	where id=@playerId_del


    FETCH NEXT FROM bjziscur   
    INTO --@id,
--@name,
--@sideId  ,
@playerId  ,
--@squadId  ,
--@description ,
--@utilized  ,
--@bjziChannelTypeId, 
--@deathCaseId ,
--@printform,
--@id_del,
--@name_del,
--@sideId_del  ,
@playerId_del  
--@squadId_del  ,
--@description_del ,
--@utilized_del  ,
--@bjziChannelTypeId_del ,
--@deathCaseId_del ,
--@printform_del
END   
CLOSE bjziscur;  
DEALLOCATE bjziscur;  