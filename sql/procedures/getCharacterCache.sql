drop procedure  if exists dbo.getCharacterCache
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-22
-- Description:	создает деяние для нескольких персонажей

--exec dbo.getCharacterCache
-- =============================================
CREATE PROCEDURE dbo.getCharacterCache
	-- Add the parameters for the stored procedure here
	@id int = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select top 1 json from charactersCache order by date desc

	
END
GO

