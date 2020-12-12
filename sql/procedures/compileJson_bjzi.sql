drop procedure  if exists dbo.compileJson_bjzi
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2020-12-07
-- Description:	Компилирует json БЖЗИ

--exec dbo.compileJson_bjzi '1'

-- =============================================
CREATE PROCEDURE dbo.compileJson_bjzi
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
select top 1 bjzi.id,'bjzi' as objectType, bjzi.name,side.name as side , bjzi.description, bjzi.utilized,bct.name as bjziChannelType from bjzi
join sides side on side.id=bjzi.sideid
join bjziChannelTypes bct on bct.id=bjzi.bjziChannelTypeId 
where bjzi.id=@id
for json path
),'$[0]')

END
GO
