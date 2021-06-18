drop procedure  if exists dbo.setCheckpointState
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Илья Воронков
-- Create date: 2021-06-18
-- Description:	проставляет славу отряду за контрольную точку

--exec dbo.setCheckpointState 1,1
-- =============================================
CREATE PROCEDURE dbo.setCheckpointState
	-- Add the parameters for the stored procedure here
	@id int,
	@stateId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--
	update top(1)checkpoints
	set stateId=@stateId
	where id=@id

END
GO

