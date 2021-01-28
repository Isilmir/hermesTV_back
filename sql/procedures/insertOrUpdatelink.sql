drop procedure  if exists dbo.insertOrUpdateLink 
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-01-28
-- Description:	создает или апдейтит связь

--exec dbo.insertOrUpdateLink 42863, 'player', 42849,'player','братья', @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateLink 
	-- Add the parameters for the stored procedure here
	@objIdFrom int
	,@objTypeFrom varchar(255)
	,@objIdTo int
	,@objTypeTo varchar(255)
	,@description nvarchar(255)
	,@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @id_ int,@objTypeFrom_ int,@objTypeTo_ int

	select @objTypeFrom_=id from objectTypes where name=@objTypeFrom
	select @objTypeTo_=id from objectTypes where name=@objTypeTo

	select top 1 @id_=id
		from links
		where ([objIdFrom]=@objIdFrom
		and [objTypeFrom]=@objTypeFrom_
		and [objIdTo]=@objIdTo
		and [objTypeTo]=@objTypeTo_)
		or([objIdFrom]=@objIdTo
		and [objTypeFrom]=@objTypeTo_
		and [objIdTo]=@objIdFrom
		and [objTypeTo]=@objTypeFrom_)


	CREATE TABLE #MyTempTable  (id int);  

	MERGE dbo.links as target
USING (select top 1 @id_

		) as source (id)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	description=@description
when not matched then
	insert ([objIdFrom],[objTypeFrom],[objIdTo],[objTypeTo],description)
	values(@objIdFrom,@objTypeFrom_,@objIdTo,@objTypeTo_,@description)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

