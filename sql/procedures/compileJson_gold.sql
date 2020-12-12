drop procedure if exists dbo.compileJson_gold
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json золотого слитка

--exec dbo.compileJson_gold '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_gold
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
select top 1 gold.id,'gold' as objectType from gold
where gold.id=@id
for json path
),'$[0]')

END
GO



