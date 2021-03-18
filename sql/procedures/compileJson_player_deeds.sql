drop procedure  if exists dbo.compileJson_player_deeds
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-18
-- Description:	Компилирует json деяний игрока

--exec dbo.compileJson_player_resources '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_player_deeds
	-- Add the parameters for the stored procedure here
	@id int,
	@res nvarchar(max) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select @res=isnull((
select d.id,'deed' as objectType,d.playerId as [player.id],p.name as [player.name],d.honor,d.description,d.date
from deeds d
left join players p on p.id=d.playerId
where d.playerid=@id for json path
),'[]')

END
GO
