drop procedure  if exists dbo.makeBjziTransfer
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �������� ����
-- Create Date: 2020-04-22
-- Description: ���������� �������� �������� 

-- exec dbo.makeBjziTransfer 43636,'player',398,'bjzi'
-- =============================================
CREATE PROCEDURE dbo.makeBjziTransfer
(
    @id_SUBJECT int, --id ���� ������������ ��������
	@objectType_SUBJECT varchar(255), -- ��� ���� ���� ��������
	@id_OBJECT int, --id ���� ���� ��������
	@objectType_OBJECT varchar(255) -- ��� ���� ���� ��������
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @query nvarchar(max)
	,@side_SUBJECT int
	,@side_OBJECT int
	,@id_SUBJECT_p int
	,@objectType_SUBJECT_p varchar(255) 
	,@state_OBJECT int

	DECLARE @errmsg nvarchar(max)

	set @objectType_SUBJECT_p='player'
    -- ���������� ��� ������

	---- ���������� ������, ���� ��� �������� �������� �������� ��������
	if @objectType_SUBJECT='bjzi'
	begin
		select @id_SUBJECT_p=playerId from dbo.bjzi b left join dbo.players p on p.id=b.playerid where b.id=@id_SUBJECT
	end
	else if @objectType_SUBJECT='player'
	begin
		set @id_SUBJECT_p=@id_SUBJECT
	end 
	else
	begin
		raiserror('����������� ��� �������� ��� �������� ��������',18,5)
		RETURN;
	end

	---- ���������� ������� ������, ������������ ��������
		select @side_SUBJECT=sideId from dbo.players where id=@id_SUBJECT_p


	---- ���������� ������� � ������ ������������� ��������
	if @objectType_OBJECT='bjzi'
	begin
		select @side_OBJECT=p.sideId, @state_OBJECT=b.utilized  from dbo.bjzi b left join dbo.players p on p.id=b.playerid where b.id=@id_OBJECT
	end
	else
	begin
		raiserror('����������� ��� ������� ��� ��������',18,5)
		RETURN;
	end
	
    ---- �������� �� ������ ������, ��� ������ ��� �� ��������� � ������� �����
	if  @objectType_OBJECT='bjzi' and @state_OBJECT=1
	begin
		raiserror('�������, �������� �������� �����',18,5)
		RETURN;
	end


--BEGIN TRANSACTION
	-- ������ ��������� ��������

	update top(1) dbo.bjzi
	set playerid=@id_SUBJECT_p
	where id=@id_OBJECT

	select 1

END
GO
