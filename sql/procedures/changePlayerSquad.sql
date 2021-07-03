drop procedure  if exists dbo.changePlayerSquad
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      ¬оронков »ль€
-- Create Date: 2020-07-03
-- Description: производит изменение €зыка

-- exec dbo.changePlayerSquad 43636,null
-- =============================================
CREATE PROCEDURE dbo.changePlayerSquad
(
    @id int, --id кому мен€ем отр€д
	@squadId varchar(255) -- отр€д на который мен€ем
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @newSide int, @actualSide int

	select @actualSide=sideId from players where id=@id
	print '@actualSide '+cast(@actualSide as varchar(255))

	select @newSide = isnull(sideId,@actualSide) from squads where id=@squadId
	print '@newSide '+cast(isnull(@newSide,@actualSide) as varchar(255))

	update top(1)players
	set squadId=@squadId,sideId=@newSide
	where id=@id

END
GO
