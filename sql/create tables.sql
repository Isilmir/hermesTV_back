--drop database if exists HermesTV

--create database HermesTV

USE hermestv

-- ������� ������� ����� ����������� �������
drop table if exists  hermestv..bjzi
drop table if exists  hermestv..guns
drop table if exists  hermestv..objects
drop table if exists  hermestv..insultLogs
drop table if exists  hermestv..insultParticipants
drop table if exists  hermestv..insultParticipantRoles
drop table if exists  hermestv..insults
drop table if exists  hermestv..deeds
drop table if exists  hermestv..players
drop table if exists  hermestv..squads
drop table if exists  hermestv..objectTypes
drop table if exists  hermestv..states
drop table if exists  hermestv..sides
drop table if exists  hermestv..gameCycles
drop table if exists  hermestv..cycleTypes
drop table if exists  hermestv..gunTypes
drop table if exists  hermestv..gold
drop table if exists  hermestv..heavyWeapons
drop table if exists  hermestv..humanitaryCards
drop table if exists  hermestv..bjziChannelTypes
drop table if exists  hermestv..deathCaseTypes
drop table if exists  hermestv..deedTypes
drop table if exists  hermestv..guns
drop table if exists  hermestv..channelTypes
drop table if exists  hermestv..heavyWeaponTypes
drop table if exists  hermestv..stories
drop table if exists  hermestv..links
drop table if exists  hermestv..charactersCache



--drop trigger if exists setJson_bjzi
--drop trigger if exists setJson_gold


-- ������� �������


create table hermestv..objectTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_objectTypes PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..states(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_states PRIMARY KEY NONCLUSTERED (id)
)


create table hermestv..sides(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_sides PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..squads(
id int IDENTITY(1,1) not null
, name nvarchar(255)
--, description nvarchar(255)
, sideId int
, members nvarchar(max) default '[]' -- ����������� ���� � json
, reserve nvarchar(max) default '[]' -- ����������� ���� � json ������ ���� ������
, leaderId int
, exterminated bit default 0
, CONSTRAINT PK_squads PRIMARY KEY NONCLUSTERED (id)
, CONSTRAINT FK_squads_sides FOREIGN KEY (sideId)
									REFERENCES hermestv..sides (id)
									--ON DELETE CASCADE
									--ON UPDATE CASCADE
)


create table hermestv..objects (
								id int not null
								,typeId int not null
								,active bit default 0 not null
								,qr varchar(max)
								, CONSTRAINT PK_objects PRIMARY KEY NONCLUSTERED (id,typeId)
								, CONSTRAINT FK_objects_objectTypes FOREIGN KEY (typeId)
									REFERENCES hermestv..objectTypes (id)
									--ON DELETE CASCADE
									--ON UPDATE CASCADE
								)

create table hermestv..players(
								id int IDENTITY(1,1) not null
								,name nvarchar(255) not null
								,equipment nvarchar(max) default '[]'-- ����������� ���� � json
								,resour�es nvarchar(max) default '[]'-- ����������� ���� � json
								,stateId int not null
								,sideId int not null
								,squadId int null
								,honor int

									,updatedAt datetime default getdate()
									,realName nvarchar(255)
									,password nvarchar(255)
									,printForm varchar(max)

								, CONSTRAINT PK_players PRIMARY KEY NONCLUSTERED (id)
								, CONSTRAINT FK_players_states FOREIGN KEY (stateId)
									REFERENCES hermestv..states (id)
									--ON DELETE CASCADE
									--ON UPDATE CASCADE
								, CONSTRAINT FK_players_sides FOREIGN KEY (sideId)
									REFERENCES hermestv..sides (id)
									--ON DELETE CASCADE
									--ON UPDATE CASCADE
								, CONSTRAINT FK_players_squads FOREIGN KEY (squadId)
									REFERENCES hermestv..squads (id)
									--ON DELETE CASCADE
									--ON UPDATE CASCADE
								)

create table hermestv..cycleTypes(
id int IDENTITY(1,1)
,name nvarchar(255)
,description nvarchar(255)
CONSTRAINT PK_cycleType PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..gameCycles(
id int IDENTITY(1,1)
,startTime datetime
,endTime datetime
,cycleTypeId int
,CONSTRAINT PK_gameCycles PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_gameCycles_cycleType FOREIGN KEY (cycleTypeId)
								REFERENCES hermestv..cycleTypes (id)
)

create table hermestv..insults(
id int IDENTITY(1,1)
--,initiatorId int not null --nvarchar(max)-- ����������� ���� � json
--,respondentId int not null --nvarchar(max)-- ����������� ���� � json
--,others nvarchar(max)-- ����������� ���� � json
,description nvarchar(255)
,longDescription nvarchar(max)
,finished bit default 0
,CONSTRAINT PK_insults PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..insultParticipantRoles(
id int IDENTITY(1,1)
,name nvarchar(255)
,description nvarchar(max)
,CONSTRAINT PK_insultParticipantRoles PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..insultParticipants(
id int IDENTITY(1,1)
,insultId int not null
,participantId int not null --nvarchar(max)-- ����������� ���� � json
,insultRoleId int not null
--,respondentId int not null --nvarchar(max)-- ����������� ���� � json
--,others nvarchar(max)-- ����������� ���� � json
,CONSTRAINT PK_insultParticipants PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_insultParticipants_players FOREIGN KEY (participantId)
								REFERENCES hermestv..players (id)
,CONSTRAINT FK_insultParticipants_insults FOREIGN KEY (insultId)
								REFERENCES hermestv..insults (id)
)

create table hermestv..insultLogs(
id int IDENTITY(1,1)
,playerId int not null
,insultId int not null
--,insultRoleId int not null
,honor int default 0 not null
,description nvarchar(max)
,date datetime default getdate()
,updateUser nvarchar(255) default current_user
,CONSTRAINT PK_insultLogs PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_insultLogs_players FOREIGN KEY (playerId)
								REFERENCES hermestv..players (id)
,CONSTRAINT FK_insultLogs_insults FOREIGN KEY (insultId)
								REFERENCES hermestv..insults (id)
--,CONSTRAINT FK_insultLogs_insultParticipantRoles FOREIGN KEY (insultRoleId)
--								REFERENCES hermestv..insultParticipantRoles (id)
)

--create table hermestv..resourceTypes(
--id int IDENTITY(1,1) not null
--, name nvarchar(255)
--, description nvarchar(255)
--, CONSTRAINT PK_resourceTypes PRIMARY KEY NONCLUSTERED (id)
--)

create table hermestv..heavyWeaponTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_heavyWeaponTypes PRIMARY KEY NONCLUSTERED (id)
)

--create table hermestv..equipmentTypes(
--id int IDENTITY(1,1) not null
--, name nvarchar(255)
--, description nvarchar(255)
--, CONSTRAINT PK_equipmentTypes PRIMARY KEY NONCLUSTERED (id)
--)

create table hermestv..gunTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_gunTypes PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..channelTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_channelTypes PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..gold(
id int IDENTITY(1,1),
date datetime default getdate()
,CONSTRAINT PK_gold PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..heavyWeapons(
id int IDENTITY(1,1),
typeId int,
utilized bit default 0,
channelTypeId int
,CONSTRAINT PK_heavyWeapons PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_heavyWeapons_heavyWeaponTypes FOREIGN KEY (typeId)
								REFERENCES hermestv..heavyWeaponTypes (id)
,CONSTRAINT FK_heavyWeapons_channelTypes FOREIGN KEY (channelTypeId)
								REFERENCES hermestv..channelTypes (id)
)


create table hermestv..humanitaryCards(
id int IDENTITY(1,1),
utilized bit  default 0,
channelTypeId int
,CONSTRAINT PK_humanitaryCards PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_humanitaryCards_channelTypes FOREIGN KEY (channelTypeId)
								REFERENCES hermestv..channelTypes (id)
)

create table hermestv..bjziChannelTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_bjziChannelTypes PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..deathCaseTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, CONSTRAINT PK_deathCaseTypes PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..bjzi(
id int IDENTITY(1,1),
name nvarchar(255),
sideId int not null,
playerId int null,
squadId int null,
description nvarchar(max),
utilized bit  default 0,
bjziChannelTypeId int default 1,
deathCaseId int null,
printForm varchar(max),
isPlayer bit default 0
,CONSTRAINT PK_bjzi PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_bjzi_bjziChannelTypes FOREIGN KEY (bjziChannelTypeId)
								REFERENCES hermestv..bjziChannelTypes (id)
,CONSTRAINT FK_bjzi_deathCaseTypes FOREIGN KEY (deathCaseId)
								REFERENCES hermestv..deathCaseTypes (id)
,CONSTRAINT FK_bjzi_sides FOREIGN KEY (sideId)
								REFERENCES hermestv..sides (id)
,CONSTRAINT FK_bjzi_squads FOREIGN KEY (squadId)
								REFERENCES hermestv..squads (id)
,CONSTRAINT FK_bjzi_players FOREIGN KEY (playerId)
								REFERENCES hermestv..players (id)
)

create table hermestv..guns(
id int IDENTITY(1,1),
gunTypeId int not null,
power decimal(5,2),
hasrapidFire bit,
isTurret bit,
playerId int
,CONSTRAINT PK_guns PRIMARY KEY NONCLUSTERED (id)
,CONSTRAINT FK_guns_gunTypes FOREIGN KEY (gunTypeId)
								REFERENCES hermestv..gunTypes (id)
,CONSTRAINT FK_guns_players FOREIGN KEY (playerId)
								REFERENCES hermestv..players (id)
)

create table hermestv..stories(
id int IDENTITY(1,1)
,description nvarchar(255)
,longDescription nvarchar(max)
,CONSTRAINT PK_stories PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..links(
id int IDENTITY(1,1)
,objIdFrom int
,objTypeFrom int
,objIdTo int
,objTypeTo int
,description nvarchar(255)
,CONSTRAINT PK_links PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..deedTypes(
id int IDENTITY(1,1) not null
, name nvarchar(255)
, description nvarchar(255)
, defaultHonor int
, visible bit
, CONSTRAINT PK_deedTypes PRIMARY KEY NONCLUSTERED (id)
)

create table hermestv..deeds(
id int IDENTITY(1,1) not null
, typeId int not null
, playerId int not null
, honor int not null
, description nvarchar(255)
, date datetime default getdate()
, heroic bit default 0
, CONSTRAINT PK_deeds PRIMARY KEY NONCLUSTERED (id)
, CONSTRAINT FK_deeds_players FOREIGN KEY (playerId)
								REFERENCES hermestv..players (id)
, CONSTRAINT FK_deeds_deedTypes FOREIGN KEY (typeId)
								REFERENCES hermestv..deedTypes (id)
)

--��������� ������� ��� ���� ����������
create table hermestv..charactersCache(
id int IDENTITY(1,1) not null
,json nvarchar(max)
,date datetime default getdate()
)

----��������� ��������������� �������

--�����������



insert into hermestv..objectTypes (name,description) 
values
('player','�����'),
('gameCycle','������� ����'),
('resource','������'),
('equipment','����������'),
('vehicle','�������'),
('squad','�����'),
('insult','�����'),
('goldbox','���� ��� ������ � �����'),
('goldmine','�����'),
('gold','������� ������'),
('bjzi','�������' ),
('heavyWeapon','������� ����������'),
('humanitaryCard','�������� �����������'),
('gun','������'),
('melee','�������� ������'),
('pyro','�����������'),
('shield','���'),
('story','�����'),
('armor','����'),
('deed','������')

insert into hermestv..states (name,description) 
values('well','������'),
('wounded','�����'),
('dead','�����')

insert into hermestv..insultParticipantRoles (name,description) 
values('initiator','���������'),
('respondent','��������'),
('other','������')

insert into hermestv..cycleTypes (name,description) 
values('ceasefire','���������'),
('skirmish','�����')

insert into hermestv..heavyWeaponTypes (name,description) 
values('grenade','�������'),
('mortarShell','���������� ������'),
('mine','����')

insert into hermestv..gunTypes (name,description) 
values('electropneumo','���������������������'),
('greengaz','�������'),
('pneumo','������ ������'),
('spring','������'),
('co2','CO2')

insert into hermestv..channelTypes (name,description) 
values('free','��������� �� ������'),
('byCash','�� ������ ����� ��������� ������'),
('blackMarket','������ �����')

insert into hermestv..bjziChannelTypes (name,description) 
values('native','��� ���� �� ������ ����'),
('volunteer','���������� �� �� ���� ���������'),
('mercenary','������� ������������ ���������� ����� �����')

insert into hermestv..deathCaseTypes(name,description)
values('byAlly','��������� �������'),
('byEmemy','��������� ����')

insert into hermestv..deedTypes (name,description,defaultHonor,visible) 
values('default','������������ ������ ������',0,0),
('video','���������� �����������',10,1),
('insult','��������� ��������� �����',5,1),
('blasphemy','���� �� �����',-3,1),
('feat','������',1,1),
('foreignBjziFrag','���������� � ��� ���������� ��������',1,1),
('foreignPlayerFrag','���������� � ��� ���������� �����',10,1),
('mainBjziFrag','���������� � ��� ������ ��������',1,1),
('mainPlayerFrag','���������� � ��� ������ �����',5,1),
('feat','������',1,1),
('capture','������ ����������� �����',2,1)

insert into hermestv..gameCycles (startTime,endTime,cycleTypeId) 
values
(dateadd(hh,0*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,1*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,1*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,2*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,2*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,3*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,3*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,4*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,4*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,5*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,5*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,6*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,6*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,7*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,7*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,8*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,8*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,9*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,9*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,10*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,10*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,11*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,11*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,12*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,12*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,13*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,13*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,14*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish')),
(dateadd(hh,14*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,15*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='ceasefire')),
(dateadd(hh,15*4,convert(datetime,'2021-08-13 20:00:00',20)),dateadd(ss,-1,dateadd(hh,16*4,convert(datetime,'2021-08-13 20:00:00',20))),(select top 1 id from hermestv..cycleTypes where name='skirmish'))

  insert into hermestv..stories (description, longDescription)
  values('���� ��������','������� ������ ����� ���� ������� � ���������� ��� ����. �� ���� � ���� ��� �� ����� ����������'),
  ('������ ��������','�������� ���������� ������ ����� �� �� ��� �� ������ �� ����� �����. � ����� ����������� ���� ����� �������'),
  ('�������� ��������','� �������� ���� ���������� ��� ���� ����� �����. � �� ��� ��� ���-�� �� ���� ������')

    insert into hermestv..links ([objIdFrom],[objTypeFrom],[objIdTo],[objTypeTo],[description])
  values
  ((select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),(select top 1 id from players where name='�������'),(select top 1 id from objecttypes where name='player'),'������')
  --,((select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),(select top 1 id from players where name='�������'),(select top 1 id from objecttypes where name='player'),'����')
  ,((select top 1 id from stories where description='���� ��������'),(select top 1 id from objecttypes where name='story'),(select top 1 id from players where name='�������'),(select top 1 id from objecttypes where name='player'),'��������� � ������')
  ,((select top 1 id from stories where description='�������� ��������'),(select top 1 id from objecttypes where name='story'),(select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),'��������� � ������')
  ,((select top 1 id from stories where description='������ ��������'),(select top 1 id from objecttypes where name='story'),(select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),'����� ������')
  ,((select top 1 id from stories where description='������ ��������'),(select top 1 id from objecttypes where name='story'),(select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),'������ �����')
  ,((select top 1 id from stories where description='������ ��������'),(select top 1 id from objecttypes where name='story'),(select top 1 id from players where name='�������'),(select top 1 id from objecttypes where name='player'),'����� ������ �� ���������� ����')
  ,((select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),(select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),'����� ���� �����')
  ,((select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),(select top 1 id from players where name='�������'),(select top 1 id from objecttypes where name='player'),'������ �������')
  ,((select top 1 id from players where name='������'),(select top 1 id from objecttypes where name='player'),(select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),'������'),
  ((select top 1 id from players where name='�����'),(select top 1 id from objecttypes where name='player'),(select top 1 id from players where name='������'),(select top 1 id from objecttypes where name='player'),'����-���')


    insert into hermestv..deeds(playerId,honor,description,typeId,date)
  values
  ('42863',10,'�������� ����� ����� � ������',(select top 1 id from deedtypes where name='insult'),'2021-03-11 15:46:34.943'),
  ('42863',5,'������� ������ ����� � ����������',(select top 1 id from deedtypes where name='video'),'2021-03-19 15:46:34.943'),
  ('42863',-3,'����� �����',(select top 1 id from deedtypes where name='blasphemy'),'2021-03-18 15:46:34.943'),
  ('42864',5,'������� ������� �� ��� ����� ��� �����!',(select top 1 id from deedtypes where name='feat'),'2021-03-11 15:46:34.943'),
  ('42864',10,'������� ������ ����� ����� ��� ����� ��� �����!',(select top 1 id from deedtypes where name='video'),'2021-03-19 15:46:34.943'),
  ('43031',15,'������� ����� �� ��� ����� ��� �����!',(select top 1 id from deedtypes where name='video'),'2021-03-11 15:46:34.943'),
  ('43031',5,'�������� ������� �������',(select top 1 id from deedtypes where name='video'),'2021-03-19 15:46:34.943'),
  ('43030',15,'������� ����� �� ��� ����� ��� �����!',(select top 1 id from deedtypes where name='video'),'2021-03-11 15:46:34.943'),
  ('43030',-5,'������� �����, ��������� �����',(select top 1 id from deedtypes where name='video'),'2021-03-19 15:46:34.943')