CREATE TRIGGER deleteJson_heavyWeapon
on dbo.heavyWeapons
AFTER delete
as

declare @json nvarchar(max),
@id int,
@typeId int
,@utilized bit
,@channelTypeId int


DECLARE heavyWeapons_del_cur CURSOR FOR   
SELECT * from deleted
  
OPEN heavyWeapons_del_cur  
  
FETCH NEXT FROM heavyWeapons_del_cur   
INTO @id,
@typeId,
@utilized,
@channelTypeId
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

	delete top(1) dbo.objects
	where id=@id and typeId = (select top 1 id from dbo.objectTypes where name='heavyWeapon')


    FETCH NEXT FROM heavyWeapons_del_cur   
    INTO @id,
	@typeId,
@utilized,
@channelTypeId
END   
CLOSE heavyWeapons_del_cur;  
DEALLOCATE heavyWeapons_del_cur;  