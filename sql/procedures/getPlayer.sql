drop procedure  if exists dbo.getPlayer
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

-- exec dbo.getPlayer 42866
-- =============================================
CREATE PROCEDURE dbo.getPlayer
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
	'player' as objectType
	,p.* 
	,o.active
	,dbo.compileJson_player_deeds_func(@id) as deeds
	from players p
	left join objects o on o.id=p.id and typeid=1
	where p.id=@id
END
GO
