drop procedure  if exists dbo.makeBless
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Воронков Илья
-- Create Date: 2020-08-03
-- Description: накладывает благословение или покровительство

-- exec dbo.makeBless 100107,100098,'player','Hades','тестируем блесс Аида',38
-- =============================================
CREATE PROCEDURE dbo.makeBless
(
    @id_SUBJECT int, --id персонажа игротехника
	@id_OBJECT int, --id персонажа
	@objectType_OBJECT varchar(255), -- тип пациента
	@god nvarchar(255),
	@deedDesc nvarchar(max),
	@deedType int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare 
	@deedHonor int
	,@deedRes int
	,@blesses int
	,@bless_cost int
	,@kvs_id int


	DECLARE @errmsg nvarchar(max)

	select @blesses=value,@kvs_id=id from keyValueStorage where storage='bless' and key_=@god

	if @deedType=38 -- благосклонность
	begin
		set @bless_cost=1 
	end
	else if @deedType=39 -- покровительство
	begin 
		select @bless_cost=value from keyValueStorage where storage='bless' and key_='patronage_cost'
	end
	else
	begin
		raiserror('Неизвестный тип блесса',18,5)
		RETURN;
	end

	if not exists (select value from keyValueStorage where storage='permission' and key_=@id_SUBJECT and value='bless:'+@god)
	begin
		raiserror('Нет разрешения на блесс',18,5)
		RETURN;
	end

	if isnull(@blesses,0)-@bless_cost<0
	begin
		raiserror('Не хватает блессов!',18,5)
		RETURN;
	end

	---- Проверка что пришел id персонажа
	if @objectType_OBJECT!='player'
	begin
		raiserror('Неизвестный тип объекта',18,5)
		RETURN;

	end

	select @deedHonor = defaultHonor from deedTypes where id=@deedType

BEGIN TRANSACTION
	-- добавить деяние персонажу
	
		BEGIN TRY
			exec dbo.insertOrUpdateDeed null, @deedDesc,@deedType,@id_OBJECT, @deedHonor,1,null, @deedRes out
		END TRY
		BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
		END CATCH

		-- уменьшить число блессов
		BEGIN TRY
			update top(1) keyValueStorage
			set value = cast(cast(value as int)-@bless_cost as nvarchar(100))
			where id=@kvs_id
		END TRY
		BEGIN CATCH
			IF @@trancount > 0 ROLLBACK TRANSACTION
			set @errmsg = error_message()  
			RAISERROR (@errmsg, 16, 1)
			RETURN;
		END CATCH

COMMIT
	select key_,value,description from keyValueStorage where storage='bless' and key_=@god

END
GO
