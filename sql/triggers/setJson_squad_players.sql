CREATE TRIGGER setJson_squad_player
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

DECLARE sq_pl_cur CURSOR FOR   
SELECT * from inserted
  
OPEN sq_pl_cur  
  
FETCH NEXT FROM sq_pl_cur   
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

exec dbo.compileJson_squad_members @squadId,@json out

	update top(1) squads
	set members=@json
	where id=@squadId


    FETCH NEXT FROM sq_pl_cur   
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
CLOSE sq_pl_cur;  
DEALLOCATE sq_pl_cur;  