drop procedure  if exists dbo.compileJson_player_resources
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json ресурсов игрока

--exec dbo.compileJson_player_resources '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_player_resources
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
select b.id,'bjzi' as objectType,b.name,b.description--,s.name as side,b.squadId as [squad.id],sq.name as [squad.name],bct.name as bjziChannelType
from bjzi b
left join sides s on s.id=b.sideId
left join squads sq on sq.id=b.squadId
left join bjziChannelTypes bct on bct.id=b.bjziChannelTypeId
where playerid=@id and isnull(isPlayer,0)!=1 for json path
),'[]')

END
GO
