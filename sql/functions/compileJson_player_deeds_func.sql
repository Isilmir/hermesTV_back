drop function  if exists dbo.compileJson_player_deeds_func
-- ======================================================
-- Create Scalar Function Template for Azure SQL Database
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Илья Воронков
-- Create Date: 2021-03-18
-- Description: Компилирует json деяний игрока
-- =============================================
CREATE FUNCTION dbo.compileJson_player_deeds_func
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
		select d.id,'deed' as objectType,d.typeId as [type.id],dt.name as [type.name],dt.description as [type.description],d.honor,d.description,dateadd(hh,3,d.date) as date,dt.visible
		from deeds d
		left join deedTypes dt on dt.id=d.typeId
		left join players p on p.id=d.playerId
		where d.playerid=@id for json path
		),'[]')

    -- Return the result of the function
    RETURN @res
END
GO

