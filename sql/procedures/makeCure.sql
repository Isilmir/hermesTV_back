drop procedure  if exists dbo.makeCure
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �������� ����
-- Create Date: 2020-06-07
-- Description: ���������� ��������� ����� ��� �������� �������:
--              1. ��������� ������ �������
--				2. ��������� ������ ���� �����

-- exec dbo.makeCure 61773,100098,'player'
-- =============================================
CREATE PROCEDURE dbo.makeCure
(
    @id_SUBJECT int, --id �������
	@id_OBJECT int, --id ��������
	@objectType_OBJECT varchar(255) -- ��� ��������
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @query nvarchar(max)
	,@side_SUBJECT int
	,@side_OBJECT int
	,@squad_OBJECT int
	,@id_OBJECT_p int
	,@id_SUBJECT_p int
	,@name_SUBJECT nvarchar(255)
	,@objectType_SUBJECT_p varchar(255) 
	,@deedType int
	,@deedHonor_doctor int
	,@deedHonor_patient int
	,@deedDesc nvarchar(255)
	,@healedDeedDesc nvarchar(255)
	,@state_OBJECT int
	,@deedRes int
	,@deathCase int
	,@honorCoeff float
	,@bonusHonor int
	,@resultHonor_doctor int

	DECLARE @errmsg nvarchar(max)

	-- ���������� ����������� ����� �� �����
	select top 1 @honorCoeff=cast(value as float) from keyValueStorage where storage='honor' and key_='player_cure_honor_bonus'  

	---- ����� ����� ��� ������ ��������
		select --@side_SUBJECT=sideId ,
		@healedDeedDesc='�������� ��������� �������
������ - '+name
		from dbo.players where id=@id_SUBJECT


	---- ����� ����� ��� ������ �������
	if @objectType_OBJECT='player'
	begin
		select @side_OBJECT=sideId, @state_OBJECT=stateId,@squad_OBJECT=squadId
		,@deedDesc=
'������� ����� '+name+' 

// ������������� �������� ����� �� ��������� ����������� �����:  '+cast(floor(@honorCoeff*honor) as varchar)
,@bonusHonor=case when cast(floor(@honorCoeff*honor) as int)>0 then cast(floor(@honorCoeff*honor) as int) else 0 end 
		from dbo.players where id=@id_OBJECT
	end
	else if @objectType_OBJECT='bjzi'
	begin
		select @id_OBJECT_p=p.id,@side_OBJECT=p.sideId,@squad_OBJECT=p.squadId, @state_OBJECT=b.utilized,@deedDesc='������� �������� '+b.name+' (�������� - '+p.name+')'  
		,@healedDeedDesc=@healedDeedDesc+' (������� '+b.name+')'
		from dbo.bjzi b left join dbo.players p on p.id=b.playerid where b.id=@id_OBJECT
	end
	else
	begin
		raiserror('����������� ��� ��������',18,5)
		RETURN;
	end

	-- ���������� ����� �� ������

	select @deedHonor_doctor = defaultHonor from deedTypes where id=72

	select @deedHonor_patient = defaultHonor from deedTypes where id=71

	set @resultHonor_doctor=@deedHonor_doctor--+isnull(@bonusHonor,0)

BEGIN TRANSACTION
	-- �������� ������ �������
	
		BEGIN TRY
			exec dbo.insertOrUpdateDeed null, @deedDesc,72,@id_SUBJECT, @resultHonor_doctor,0,null, @deedRes out
		END TRY
		BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
		END CATCH

	-- ��������� ������ "�������" ��������
	if @objectType_OBJECT='player'
	begin
		BEGIN TRY
			exec dbo.insertOrUpdateDeed null, @healedDeedDesc,71,@id_OBJECT, @deedHonor_patient,0,null, @deedRes out
		END TRY
		BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
		END CATCH
	end

	if @objectType_OBJECT='bjzi'
	begin
		BEGIN TRY
			exec dbo.insertOrUpdateDeed null, @healedDeedDesc,71,@id_OBJECT_p, @deedHonor_patient,0,null, @deedRes out
		END TRY
		BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
		END CATCH
	end

COMMIT
	select @deedRes

END
GO
