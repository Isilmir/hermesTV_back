drop procedure  if exists dbo.deleteTransaction
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-06-29
-- Description:	удаляет связь

--exec dbo.deleteTransaction 1, @res out
-- =============================================
CREATE PROCEDURE dbo.deleteTransaction
	-- Add the parameters for the stored procedure here
	@transactionId int
	,@res int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable  (id int);  

delete top(1) from transactions
OUTPUT deleted.id INTO #MyTempTable
where id=@transactionId

	select @res=id from #MyTempTable
	
END
GO

