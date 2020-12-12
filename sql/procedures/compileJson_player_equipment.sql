drop procedure  if exists dbo.compileJson_player_equipment
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json обиды

--exec dbo.compileJson_player_equipment '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_player_equipment
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
select g.id,'gun' as objectType,gt.name as gunType,g.power,g.hasRapidfire,g.isTurret 
from guns g
join gunTypes gt on gt.id=g.guntypeid
where playerid=@id for json path
),'[]')

END
GO
