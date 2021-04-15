drop procedure  if exists dbo.setCharacterCache
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-22
-- Description:	создает деяние для нескольких персонажей

--exec dbo.setCharacterCache '[]'
-- =============================================
CREATE PROCEDURE dbo.setCharacterCache
	-- Add the parameters for the stored procedure here
	@json nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	insert into dbo.charactersCache(json)
	select @json

	
END
GO

