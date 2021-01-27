CREATE TRIGGER deleteJson_player
on dbo.players
AFTER delete
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

DECLARE players_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN players_del_cur  
  
FETCH NEXT FROM players_del_cur   
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

	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='player')

	exec dbo.compileJson_squad_members @squadId,@json out

	update top(1) squads
	set members=@json
	where id=@squadId


    FETCH NEXT FROM players_del_cur   
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
CLOSE players_del_cur;  
DEALLOCATE players_del_cur;  