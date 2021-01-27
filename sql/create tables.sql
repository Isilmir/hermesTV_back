--drop database if exists HermesTV

--create database HermesTV

USE hermestv

-- Дропаем таблицы чтобы пересоздать начисто
drop table if exists  hermestv..bjzi
drop table if exists  hermestv..guns
drop table if exists  hermestv..objects
drop table if exists  hermestv..insultLogs
drop table if exists  hermestv..insultParticipants
drop table if exists  hermestv..insultParticipantRoles
drop table if exists  hermestv..insults
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
drop table if exists  hermestv..guns
drop table if exists  hermestv..channelTypes
drop table if exists  hermestv..heavyWeaponTypes



--drop trigger if exists setJson_bjzi
--drop trigger if exists setJson_gold


-- Создаем таблицы


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
, members nvarchar(max) default '[]' -- вычисляемое поле с json
, reserve nvarchar(max) default '[]' -- вычисляемое поле с json список бжзи отряда
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
								,equipment nvarchar(max) default '[]'-- вычисляемое поле с json
								,resourсes nvarchar(max) default '[]'-- вычисляемое поле с json
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
--,initiatorId int not null --nvarchar(max)-- вычисляемое поле с json
--,respondentId int not null --nvarchar(max)-- вычисляемое поле с json
--,others nvarchar(max)-- вычисляемое поле с json
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
,participantId int not null --nvarchar(max)-- вычисляемое поле с json
,insultRoleId int not null
--,respondentId int not null --nvarchar(max)-- вычисляемое поле с json
--,others nvarchar(max)-- вычисляемое поле с json
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
bjziChannelTypeId int,
deathCaseId int null,
printForm varchar(max)
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

----Наполняем первоначальными данными

--Справочники



insert into hermestv..objectTypes (name,description) 
values
('player','Игрок'),
('gameCycle','Игровой цикл'),
('resource','Ресурс'),
('equipment','Снаряжение'),
('vehicle','Техника'),
('squad','Отряд'),
('insult','Обида'),
('goldbox','Ящик для золота в шахте'),
('goldmine','Шахта'),
('gold','Золотой слиток'),
('bjzi','Спутник' ),
('heavyWeapon','Тяжелое вооружение'),
('humanitaryCard','Карточка гуманитарки'),
('gun','Привод'),
('melee','Холодное оружие'),
('pyro','Пиротехника'),
('shield','Щит'),
('armor','СИБЗ')

insert into hermestv..states (name,description) 
values('well','Здоров'),
('wounded','Ранен'),
('dead','Мертв')

insert into hermestv..insultParticipantRoles (name,description) 
values('initiator','Инициатор'),
('respondent','Ответчик'),
('other','Прочие')

insert into hermestv..cycleTypes (name,description) 
values('ceasefire','Перемирие'),
('skirmish','Война')

insert into hermestv..heavyWeaponTypes (name,description) 
values('grenade','Граната'),
('mortarShell','Минометный снаряд'),
('mine','Мина')

insert into hermestv..gunTypes (name,description) 
values('electropneumo','Электропневматический'),
('greengaz','Грингаз'),
('pneumo','Сжатый воздух'),
('spring','Спринг'),
('co2','CO2')

insert into hermestv..channelTypes (name,description) 
values('free','Бесплатно от Олимпа'),
('byCash','За деньги через эмиссаров Олимпа'),
('blackMarket','Черный рынок')

insert into hermestv..bjziChannelTypes (name,description) 
values('native','Уже есть на начало игры'),
('volunteer','Доброволец не из зоны конфликта'),
('mercenary','Наемник проплаченный официально через олимп')

insert into hermestv..deathCaseTypes(name,description)
values('byAlly','похоронил союзник'),
('byEmemy','Похоронил враг')

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