drop procedure  if exists dbo.compileJson_player_deeds_group_by_types
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-03-20
-- Description:	Компилирует json деяний игрока с разбивкой по типам

--exec dbo.compileJson_player_resources '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_player_deeds_group_by_types
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
select 
dt.name as [name]
,dt.description as [description]
,case
when d.honor>0 then 'good'
else 'bad'
end as degree
,count(*) as count
from deeds d
left join deedTypes dt on dt.id=d.typeId
left join players p on p.id=d.playerId
where dt.visible=1
and d.playerId=@id
group by dt.name,dt.description,case
when d.honor>0 then 'good'
else 'bad'
end
for json path
),'[]')

END
GO
