drop procedure  if exists dbo.getBlesses
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      ¬оронков »ль€
-- Create Date: 2020-08-04
-- Description: возвращает доступные блессы богов

-- exec dbo.getBlesses 42866
-- =============================================
CREATE PROCEDURE dbo.getBlesses
(
    @id int -- персонаж открывший сканер
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	SELECT distinct 
	  kvs.description
	  ,substring(kvs.value,len('bless:')+1,len(kvs.value)) as god
	 ,blesses.value as blessCount
	 ,gods.value as godName
  FROM [dbo].[keyValueStorage]kvs
  left join keyValueStorage blesses on blesses.storage='bless' and blesses.key_=substring(kvs.value,len('bless:')+1,len(kvs.value))
  left join keyValueStorage gods on gods.storage='gods' and gods.key_=substring(kvs.value,len('bless:')+1,len(kvs.value))
  where kvs.storage='permission'
  and (kvs.key_=@id or @id=100083)
  and kvs.value like 'bless:%'
  order by 4

END
GO
