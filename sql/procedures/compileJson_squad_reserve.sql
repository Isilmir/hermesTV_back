drop procedure  if exists dbo.compileJson_squad_reserve
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json резерв отрядов

--exec dbo.compileJson_squad_reserve '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_squad_reserve
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
select b.id,'bjzi' as objectType,b.name,s.name as side,bct.name as bjziChannelType
from bjzi b
join sides s on s.id=b.sideId
join bjziChannelTypes bct on bct.id=b.bjziChannelTypeId
where squadid=@id for json path
),'[]')

END
GO
