drop procedure  if exists dbo.insertOrUpdateLink 
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-01-28
-- Description:	создает или апдейтит сюжет

--exec dbo.insertOrUpdateLink 43004, 1, 43005,1,'братья', @res out
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateLink 
	-- Add the parameters for the stored procedure here
	@objIdFrom int
	,@objTypeFrom int
	,@objIdTo int
	,@objTypeTo int
	,@description nvarchar(max)
	,@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @id_ int

	select top 1 @id_=id
		from links
		where ([objIdFrom]=@objIdFrom
		and [objTypeFrom]=@objTypeFrom
		and [objIdTo]=@objIdTo
		and [objTypeTo]=@objTypeTo)
		or([objIdFrom]=@objIdTo
		and [objTypeFrom]=@objTypeTo
		and [objIdTo]=@objIdFrom
		and [objTypeTo]=@objTypeFrom)


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
	values(@objIdFrom,@objTypeFrom,@objIdTo,@objTypeTo,@description)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

