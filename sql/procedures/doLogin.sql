drop procedure  if exists dbo.doLogin
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-05-14
-- Description: возвращает информацию для логина по конкретному персонажу

-- exec dbo.doLogin 42866
-- =============================================
CREATE PROCEDURE dbo.doLogin
(
    @id int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
   SELECT TOP 1000 p.[name]
      ,p.[equipment]
      ,p.[resourсes]
      ,p.[sideId]
	  ,si.[description] as sideName
      ,p.[squadId]
	  ,sq.[name] as squadName
      --,isnull(p.[honor],0) as honor
      ,p.[password]
	  ,isnull((select value from keyvalueStorage where storage='permission' and key_=p.id for json path),'[]') as permissions
  FROM [players]p
  left join sides si on si.id=p.sideId
  left join squads sq on sq.id=p.squadId
  where p.id=@id

END
GO
