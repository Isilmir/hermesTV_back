drop procedure  if exists dbo.getWarProgress
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-06-18
-- Description: получить прогресс захвата контрольных точек
-- 
-- exec getWarProgress
-- =============================================
CREATE PROCEDURE dbo.getWarProgress

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
	select  gc.id as cycleId,gc.startTime,gc.endTime,ct.description as cycleType
	,chp.id as checkpointId,chp.name as checkpointName
	,wp.id as warProgressId,isnull(wp.checkpointStateId,chp.stateId) as checkpointStateId,squadId,wp.ishonorgiven
	from gameCycles gc
	cross apply checkpoints chp
	left join cycleTypes ct on ct.id=gc.cycleTypeId
	left join warProgress wp on wp.cycleId=gc.id and wp.checkpointid=chp.id
	order by gc.id,chp.id

END
GO
