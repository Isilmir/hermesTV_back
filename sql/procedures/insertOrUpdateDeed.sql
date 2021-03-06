drop procedure  if exists dbo.insertOrUpdateDeed
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		���� ��������
-- Create date: 2021-03-21
-- Description:	������� ��� �������� ������

--exec dbo.insertOrUpdateDeed null, '������ ���������',1,44559, 1,'#FFFFFF', @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateDeed 
	-- Add the parameters for the stored procedure here
	@id int null,
	@description nvarchar(255),
	@typeId int,
	@playerId int,
	@honor int,
	@heroic bit,
	@color varchar(7),
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.deeds as target
USING (select top 1 @id,@description,@typeId,@playerId,@honor,@heroic,@color) as source (id,description,typeId,playerId,honor,heroic,color)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	honor=source.honor,
	description=source.description,
	heroic=source.heroic,
	color=source.color
when not matched then
	insert (typeId,description,playerId,honor,heroic,color)
	values(source.typeId,source.description,source.playerId,source.honor,source.heroic,source.color)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

