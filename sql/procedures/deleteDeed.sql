drop procedure  if exists dbo.deleteDeed
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-21
-- Description:	удаляет связь

--exec dbo.deleteDeed 2050, @res out
-- =============================================
CREATE PROCEDURE dbo.deleteDeed
	-- Add the parameters for the stored procedure here
	@deedId int
	,@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

delete top(1) from deeds
OUTPUT deleted.id INTO #MyTempTable
where id=@deedId

	select @res=id from #MyTempTable
	
END
GO

