drop procedure  if exists dbo.makeRegistration
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-07-07
-- Description: производит регистрацию персонажа

-- exec dbo.makeRegistration 100098
-- =============================================
CREATE PROCEDURE dbo.makeRegistration
(
    @id int --id доктора
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare 
	@deedHonor int
	,@deedDesc nvarchar(255)
	,@deedRes int

	if exists(select top 1 TypeId from deeds where TypeId=70 and playerId=@id)
	begin
		raiserror('Герой уже прошел регистрацию под стенами Трои',18,5)
		RETURN;
	end

	DECLARE @errmsg nvarchar(max)

	select @deedHonor = defaultHonor, @deedDesc=description from deedTypes where id=70

	exec dbo.insertOrUpdateDeed null, @deedDesc,70,@id, @deedHonor,1,'#ccaa00', @deedRes out

	
	select @deedRes

END
GO
