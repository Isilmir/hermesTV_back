drop procedure  if exists dbo.compileJson_humanitaryCard
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json карточки гуманитарки

--exec dbo.compileJson_humanitaryCard '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_humanitaryCard
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
,'humanitaryCard' as objectType
--,t.name
--,t.utilized
,tt.name as channelType
--,t.power 
--,t.hasRapidFire
--,t.isTurret
--,t.utilized
--,t.name as bjziChannelType 
from humanitaryCards t
join dbo.channelTypes tt on tt.id=t.channelTypeId
--join sides side on side.id=bjzi.sideid
--join bjziChannelTypes bct on bct.id=bjzi.bjziChannelTypeId 
where t.id=@id
for json path
),'$[0]')

END
GO
