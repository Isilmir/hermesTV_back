drop procedure  if exists dbo.getConfig
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-03-29
-- Description: возвращает данные по персонажам

-- exec dbo.getConfig
-- =============================================
CREATE PROCEDURE dbo.getConfig

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
SELECT [id]
      ,[storage]
      ,[key_]
      ,[value]
      ,[valueType]
	  ,description
  FROM [dbo].[keyValueStorage] 
  where storage!='permission'

END
GO
