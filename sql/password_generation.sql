--/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
--SELECT TOP (1000) *
--  FROM [HermesTV].[dbo].[players]

 -- alter table [HermesTV].[dbo].[players] add password nvarchar(255)
 declare @pwt nvarchar(max),
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

 DECLARE cur1 CURSOR FOR   
SELECT * from players
  
OPEN cur1  
  
FETCH NEXT FROM cur1 
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

update top (1) players
set password = left(lower(newid()),5)
where id=@id


    FETCH NEXT FROM cur1   
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
CLOSE cur1;  
DEALLOCATE cur1;  
