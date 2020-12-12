drop procedure  if exists dbo.compileJson_gun
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json привода

--exec dbo.compileJson_gun '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_gun
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
g.id
,'gun' as objectType
--,g.name
,gt.name as gunType
,g.power 
,g.hasRapidFire
,g.isTurret
--,bjzi.utilized
--,bct.name as bjziChannelType 
from guns g
join dbo.gunTypes gt on gt.id=g.gunTypeId
--join sides side on side.id=bjzi.sideid
--join bjziChannelTypes bct on bct.id=bjzi.bjziChannelTypeId 
where g.id=@id
for json path
),'$[0]')

END
GO
