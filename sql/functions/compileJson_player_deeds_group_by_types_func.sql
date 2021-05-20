drop function  if exists dbo.compileJson_player_deeds_group_by_types_func
-- ======================================================
-- Create Scalar Function Template for Azure SQL Database
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Илья Воронков
-- Create Date: 2021-03-20
-- Description: Компилирует json деяний игрока с разбивкой по типам
-- =============================================
CREATE FUNCTION dbo.compileJson_player_deeds_group_by_types_func
(
    -- Add the parameters for the function here
    	@id int
)
RETURNS nvarchar(max)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @res nvarchar(max)

    	select @res=isnull((
		select 
dt.name as [name]
,case
when d.heroic=0 then dt.description 
else d.description
end as [description]
,case
when d.honor>0 then 'good'
else 'bad'
end as degree
,heroic
,count(*) as count
,max(date) as date
from deeds d
left join deedTypes dt on dt.id=d.typeId
left join players p on p.id=d.playerId
where dt.visible=1
and d.playerId=@id
group by dt.name
,case
when d.heroic=0 then dt.description 
else d.description
end
,case
when d.honor>0 then 'good'
else 'bad'
end 
,heroic
order by max(date) desc
for json path
		),'[]')

    -- Return the result of the function
    RETURN @res
END
GO

