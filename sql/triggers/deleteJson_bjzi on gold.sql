CREATE TRIGGER deleteJson_gold
on dbo.gold
AFTER delete
as

declare @json nvarchar(max),
@id int,
--@name nvarchar(255),
--@sideId int,
--@playerId int,
--@squadId int,
--@description nvarchar(max),
--@utilized bit,
--@bjziChannelTypeId int,
--@deathCaseId int
@date date


DECLARE gold_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN gold_del_cur  
  
FETCH NEXT FROM gold_del_cur   
INTO @id,
--@name,
--@sideId,
--@playerId ,
--@squadId ,
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId   
@date
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='gold')


    FETCH NEXT FROM gold_del_cur   
    INTO @id,
--@name,
--@sideId,
--@playerId ,
--@squadId ,
--@description ,
--@utilized ,
--@bjziChannelTypeId ,
--@deathCaseId  ,
@date
END   
CLOSE gold_del_cur;  
DEALLOCATE gold_del_cur;  


