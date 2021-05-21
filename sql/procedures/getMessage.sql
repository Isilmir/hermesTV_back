drop procedure  if exists dbo.getMessage
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-05-21
-- Description: возвращает сообщение, прикрепленное к деянию

-- exec dbo.getMessage 1
-- =============================================
CREATE PROCEDURE dbo.getMessage
(
    @id int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    select top 1 m.description,d.playerId
	from dbo.messages m
	join dbo.deeds d on d.id=m.deedId
	where m.id=@id


END
GO
