drop procedure  if exists dbo.deleteLink 
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-01-28
-- Description:	удаляет связь

--exec dbo.deleteLink 43004, 'player', 43005,'player', @res out
-- =============================================
CREATE PROCEDURE dbo.deleteLink 
	-- Add the parameters for the stored procedure here
	@objIdFrom int
	,@objTypeFrom varchar(255)
	,@objIdTo int
	,@objTypeTo varchar(255)
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

		select @id_

	CREATE TABLE #MyTempTable  (id int);  

delete top(1) from links
OUTPUT deleted.id INTO #MyTempTable
where id=@id_

	select @res=id from #MyTempTable
	
END
GO

