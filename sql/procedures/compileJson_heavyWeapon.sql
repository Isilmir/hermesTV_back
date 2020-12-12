drop procedure  if exists dbo.compileJson_heavyWeapon
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json карточки гуманитарки

--exec dbo.compileJson_heavyWeapon '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_heavyWeapon
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
,'heavyWeapon' as objectType
,ttt.name as heavyWeaponType
--,t.name
--,t.utilized
,tt.name as channelType
--,t.power 
--,t.hasRapidFire
--,t.isTurret
--,t.utilized
--,t.name as bjziChannelType 
from heavyWeapons t
join dbo.channelTypes tt on tt.id=t.channelTypeId
join dbo.heavyWeaponTypes ttt on ttt.id=t.typeId
--join sides side on side.id=bjzi.sideid
--join bjziChannelTypes bct on bct.id=bjzi.bjziChannelTypeId 
where t.id=@id
for json path
),'$[0]')

END
GO
