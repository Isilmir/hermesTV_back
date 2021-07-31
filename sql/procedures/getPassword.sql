drop procedure  if exists dbo.getPassword
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-07-30
-- Description: возвращает пароль по конкретному персонажу

-- exec dbo.getPassword 42866
-- =============================================
CREATE PROCEDURE dbo.getPassword
(
    @id int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    select 
	password
	from players p
	where p.id=@id
END
GO
