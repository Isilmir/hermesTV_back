drop procedure  if exists dbo.compileJson_insult
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json обиды

--exec dbo.compileJson_insult '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_insult
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
,'insult' as objectType
,t.description
--,t.longDescription
--,t.name
--,t.utilized
--,tt.name as side
--,ttt.id as "leader.id"
--,ttt.name as "leader.name"
--,t.power 
--,t.hasRapidFire
--,t.isTurret
--,t.utilized
--,t.name as bjziChannelType 
from insults t
--join dbo.sides tt on tt.id=t.sideId
--left join dbo.players ttt on ttt.id=t.leaderId
--join sides side on side.id=bjzi.sideid
--join bjziChannelTypes bct on bct.id=bjzi.bjziChannelTypeId 
where t.id=@id
for json path
),'$[0]')

END
GO
