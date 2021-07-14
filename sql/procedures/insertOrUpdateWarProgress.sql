drop procedure  if exists dbo.insertOrUpdateWarProgress
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		���� ��������
-- Create date: 2021-06-18
-- Description:	��������� ���������� �� ��������� ����������� �����

--declare @res int
--exec dbo.insertOrUpdateWarProgress 1,1,1, 14907, @res out
--select @res
-- =============================================
CREATE PROCEDURE dbo.insertOrUpdateWarProgress
	-- Add the parameters for the stored procedure here
	@id int,
	@cycleId int,
	@checkpointId int,
	--@checkpointStateId int,
	@squadId int,
	--@isHonorGiven int = 0,
	@res int out

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--

	--����� ������
	--set @isHonorGiven = 0

	CREATE TABLE #MyTempTable  (id int);  

	-- ���������, ��� ����� � ���������� �������
	declare @actualCheckpointState int, @squadSide int

	select  @actualCheckpointState=stateId from checkpoints where id=@checkpointId
	select  @squadSide=sideId from squads where id=@squadId

	if @actualCheckpointState=3 and @squadSide=14920
	begin
		raiserror('��������� ����� �� ����� ��������� ����� � ������� LOST',18,5)
		RETURN;
	end
	if @actualCheckpointState=1 and @squadSide=14906
	begin
		raiserror('�������� ����� �� ����� ��������� ����� � ������� STAND',18,5)
		RETURN;
	end
	if @squadSide=15680
	begin
		raiserror('���������� �� ����� ����������� �����',18,5)
		RETURN;
	end
	if @squadSide=16333
	begin
		raiserror('�������� �� ����������� �����',18,5)
		RETURN;
	end

	-- ���������, ��� �� ����� ��� �� ��������� �����
	create table #tab(cycleId int,startTime datetime,endTime datetime,cycleType nvarchar(100),checkpointId int,checkpointName nvarchar(255),warProgressId int,checkpointStateId int,squadId int,ishonorgiven bit)

	insert into #tab
	exec getWarProgress

	if exists(select top 1 * from #tab where cycleId=@cycleId and checkpointId=@checkpointId and isHonorGiven=1)
	begin
		raiserror('��� ����� ��� ���� �������� � ���� ����� � �� ��� ��������� �����',18,5)
		RETURN;
	end

	if @id is null
	begin
		select @id=warprogressid from #tab where checkpointId=@checkpointId and cycleId=@cycleId
	end


	drop table #tab


	MERGE dbo.warProgress as target
USING (select top 1 @id,@cycleId,@checkpointId,@actualCheckpointState,@squadId/*,@isHonorGiven*/) as source (id,cycleId,checkpointId,checkpointStateId,squadId/*,isHonorGiven*/)
on (target.id=isnull(source.id,0))
when matched then
	update set 
	cycleId=source.cycleId,
	checkpointId=source.checkpointId,
	checkpointStateId=source.checkpointStateId,
	squadId=source.squadId--,
	--isHonorGiven=source.isHonorGiven
when not matched then
	insert (cycleId,checkpointId,checkpointStateId,squadId)
	values(source.cycleId,source.checkpointId,source.checkpointStateId,source.squadId)
	OUTPUT inserted.id INTO #MyTempTable;

	select @res=id from #MyTempTable
	
END
GO

