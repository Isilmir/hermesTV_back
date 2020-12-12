drop procedure  if exists dbo.compileJson_squad_members
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json состав отрядов

--exec dbo.compileJson_squad_members '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_squad_members
	-- Add the parameters for the stored procedure here
	@id int,  -- id отряда
	@res nvarchar(max) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select @res=isnull((
select b.id,'player' as objectType,b.name
from players b
where squadid=@id for json path
),'[]')

END
GO
