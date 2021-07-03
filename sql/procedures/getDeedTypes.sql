drop procedure  if exists dbo.getDeedTypes
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-03-21
-- Description: справочник типов деяний
-- =============================================
CREATE PROCEDURE dbo.getDeedTypes
(
    @res nvarchar(max) output
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    select * from deedTypes
	order by id
END
GO
