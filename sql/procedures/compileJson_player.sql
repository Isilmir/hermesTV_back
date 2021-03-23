drop procedure  if exists dbo.compileJson_player
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json карточки игрока

--exec dbo.compileJson_player '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_player
	-- Add the parameters for the stored procedure here
	@id int,
	@res nvarchar(max) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select @res=json_query((
select top 1 
t.id
,'player' as objectType
,t.name
----,ttt.name as squad
--,t.name
--,t.utilized
----,tt.name as side
--,t.power 
--,t.hasRapidFire
--,t.isTurret
--,t.utilized
--,t.name as bjziChannelType 
from dbo.players t
--join dbo.sides tt on tt.id=t.sideId
--left join dbo.squads ttt on ttt.id=t.squadId
--join sides side on side.id=bjzi.sideid
--join bjziChannelTypes bct on bct.id=bjzi.bjziChannelTypeId 
where t.id=@id
for json path
),'$[0]')

END
GO
