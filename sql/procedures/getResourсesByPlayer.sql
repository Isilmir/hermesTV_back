drop procedure  if exists dbo.getResour�esByPlayer
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		���� ��������
-- Create date: 2021-01-06
-- Description:	���������� ��� ������� ������

--exec dbo.getBjziByPlayer 44559, @res out
-- =============================================
CREATE PROCEDURE dbo.getResour�esByPlayer 
	-- Add the parameters for the stored procedure here
	@playerId int,
	@res varchar(max) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select @res=p.resour�es from dbo.players p
	where p.id=@playerId
	
END
GO

