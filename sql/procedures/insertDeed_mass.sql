drop procedure  if exists dbo.insertDeed_mass
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-22
-- Description:	создает деяние для нескольких персонажей

--exec dbo.insertDeed_mass 'Сделал заявление',1,44559, 1, @res out
-- =============================================
CREATE PROCEDURE dbo.insertDeed_mass
	-- Add the parameters for the stored procedure here
	@description nvarchar(255),
	@typeId int,
	@players nvarchar(max),
	@honor int,
	@heroic bit = 0,
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

	insert into dbo.deeds(typeId,description,playerId,honor,heroic)
	OUTPUT inserted.id INTO #MyTempTable
	select @typeId,@description,json_value(value,'$.id'),@honor,@heroic from openjson( JSON_QUERY(@players))


	select id from #MyTempTable
	
END
GO

