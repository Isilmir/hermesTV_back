CREATE TRIGGER setJson_heavyWeapon
on dbo.heavyWeapons
AFTER insert,update
as

declare @json nvarchar(max),
@id int,
@typeId int
,@utilized bit
,@channelTypeId int


DECLARE heavyWeapons_cur CURSOR FOR   
SELECT * from inserted
  
OPEN heavyWeapons_cur  
  
FETCH NEXT FROM heavyWeapons_cur   
INTO @id,
@typeId,
@utilized,
@channelTypeId
  
WHILE @@FETCH_STATUS = 0  
BEGIN  

exec dbo.compileJson_heavyWeapon @id,@json out

MERGE dbo.objects as target
USING (select @id,@json) as source (id,json)
on (target.id=source.id and target.typeId=(select top 1 id from dbo.objectTypes where name='heavyWeapon'))
when matched then
	update set qr=@json
when not matched then
	insert (id,typeId,active,qr)
	values(source.id,(select top 1 id from dbo.objectTypes where name='heavyWeapon'),0,source.json);


    FETCH NEXT FROM heavyWeapons_cur   
    INTO @id,
	@typeId,
@utilized,
@channelTypeId
END   
CLOSE heavyWeapons_cur;  
DEALLOCATE heavyWeapons_cur;  