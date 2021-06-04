drop procedure  if exists dbo.makeReinforcementsAwaiting
-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      �������� ����
-- Create Date: 2020-06-01
-- Description: ����������� ���� ������ ������������� ���������� ���������

-- exec dbo.makeReinforcementsAwaiting
-- =============================================
CREATE PROCEDURE dbo.makeReinforcementsAwaiting

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	insert into [deeds](typeId,playerId,honor,description,heroic)
  select 61,p.id,0,
  case 
  when honor > 2499 then '9 ��������� ��� � ���� � �����'  
  when honor between 2000 and 2499 then '8 ��������� ��� � ���� � �����'
  when honor between 1500 and 1999 then '7 ��������� ��� � ���� � �����'
  when honor between 1000 and 1499 then '6 ��������� ��� � ���� � �����'
  when honor between 750 and 999 then '5 ��������� ��� � ���� � �����'
  when honor between 500 and 749 then '4 �������� ��� � ���� � �����'
  when honor between 300 and 499 then '3 �������� ��� � ���� � �����'
  when honor between 150 and 299 then '2 �������� ��� � ���� � �����'
  when honor < 150 then '1 ������� ��� � ���� � �����'
  else '//������ ���������� ������ �� ���� �����' 
  end
  ,1
  FROM [dbo].[players] p
  join objects o on o.id=p.id and o.typeid=1
  where realname is not null 
  and o.active=1
  and p.stateId!=3
  and not exists (select top 1 id from deeds d where d.playerid=p.id and d.typeId=50)
  order by honor desc

END
GO
