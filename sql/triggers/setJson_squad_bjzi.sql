CREATE TRIGGER setJson_squad_bjzi
on dbo.bjzi
AFTER insert,update
as

declare @json nvarchar(max),
--@id int,
--@name nvarchar(255),
--@sideId int ,
--@playerId int ,
@squadId int 
--@description nvarchar(max),
--@utilized bit ,
--@bjziChannelTypeId int,
--@deathCaseId int ,
--@printform varchar(max)

DECLARE bjziscur CURSOR FOR   
SELECT squadId from inserted
  
OPEN bjziscur  
  
FETCH NEXT FROM bjziscur   
INTO --@id,
--@name,
--@sideId  ,
--@playerId  ,
@squadId  
--@description ,
--@utilized  ,
--@bjziChannelTypeId ,
--@deathCaseId ,
--@printform
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

if @squadId is not null
begin
exec dbo.compileJson_squad_reserve @squadId,@json out
--print @json

	update top(1) squads
	set reserve=@json
	where id=@squadId
end

    FETCH NEXT FROM bjziscur   
    INTO --@id,
--@name,
--@sideId  ,
--@playerId  ,
@squadId  
--@description ,
--@utilized  ,
--@bjziChannelTypeId, 
--@deathCaseId ,
--@printform
END   
CLOSE bjziscur;  
DEALLOCATE bjziscur;  