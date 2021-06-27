drop procedure  if exists dbo.getLastUpdate
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-03-21
-- Description: возвращает информацию по конкретному персонажу

-- exec dbo.getLastUpdate
-- =============================================
CREATE PROCEDURE dbo.getLastUpdate
(
    @id int = 0
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
	SELECT TOP 1 
      cast(cast([date] as date) as varchar(100)) as date
	  from charactersCache
	  order by date desc
  --FROM [dbo].[players]
  --where sideid!=16333
  --order by updatedAt desc
END
GO
