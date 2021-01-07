CREATE TRIGGER setJson_player
on dbo.players
AFTER insert,update
as

declare @json nvarchar(max),
@id int
,@name nvarchar(255)
,@equipment nvarchar(max)
,@resourses nvarchar(max)
,@stateId int
,@sideId int
,@squadId int
,@honor int
,@updatedAt datetime 
,@realName nvarchar(255)
,@password nvarchar(255)
,@printForm varchar(max)

DECLARE cur_player CURSOR FOR   
SELECT * from inserted
  
OPEN cur_player  
  
FETCH NEXT FROM cur_player   
INTO @id
,@name
,@equipment
,@resourses
,@stateId
,@sideId
,@squadId
,@honor
,@updatedAt  
,@realName 
,@password 
,@printForm
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_player @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='player'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='player'),0,source.json);


    FETCH NEXT FROM cur_player   
    INTO @id
,@name
,@equipment
,@resourses
,@stateId
,@sideId
,@squadId
,@honor
,@updatedAt  
,@realName 
,@password 
,@printForm

END   
CLOSE cur_player;  
DEALLOCATE cur_player;  