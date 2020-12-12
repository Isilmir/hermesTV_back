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
('bjzi','БЖЗИ' ),
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

insert into hermestv..sides (name,description) 
values('troy','Троя'),
('achaeans','Ахейцы'),
('peacekeeping','Миротворцы'),
('olymp','Олимп')

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

--insert into hermestv..equipmentTypes (name,description) 
--values('gun','Привод'),
--('skirmish','Холодное оружие')

--insert into hermestv..resourceTypes (name,description) 
--values('ceasefire','Перемирие'),
--('skirmish','Война')

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

-- Игровые объекты

insert into hermestv..squads (name,sideId) 
values('Отряд менелая',(select top 1 id from hermestv..sides where name='troy')),
('Дом Гектора',(select top 1 id from hermestv..sides where name='achaeans')),
('Взвод Альфа',(select top 1 id from hermestv..sides where name='peacekeeping')),
('Храм Аида',(select top 1 id from hermestv..sides where name='olymp'))

truncate table players
insert into hermestv..players (name,stateId,sideId,squadId,honor) 
values('Менелай',(select top 1 id from hermestv..states where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..states)+1,0))),(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0))),(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0))),round(rand()*10+1,0)),
('Гектор',(select top 1 id from hermestv..states where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..states)+1,0))),(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0))),(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0))),round(rand()*10+1,0)),
('Марк',(select top 1 id from hermestv..states where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..states)+1,0))),(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0))),(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0))),round(rand()*10+1,0)),
('Эврикус',(select top 1 id from hermestv..states where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..states)+1,0))),(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0))),(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0))),round(rand()*10+1,0)),
('Елена',(select top 1 id from hermestv..states where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..states)+1,0))),(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0))),(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0))),round(rand()*10+1,0)),
('Парис',(select top 1 id from hermestv..states where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..states)+1,0))),(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0))),(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0))),round(rand()*10+1,0))
update sq
set sq.leaderId=(select top 1 p.id from players p where p.sideId=sq.sideId)
from squads sq

--update players
--set name=name


insert into insults (description,longDescription)
values ('менелай хочет навалять гектору за то что тот мудак','подробное объяснение кто кому плюнул в борщ и какие действия были совершены в ответ. изложение сути претензий на 50 страницах за подписью нотариуса')
,('елена недовольна тем что парис не опускает стульчак','елена ехала в трою чтобы жить в роскоши и шелках. а у этих нищебродов ни одного модного магазина и всего три служанки вместо обещанных тридцати. А ко всему прочему муж, который клялся всеми богами что любит ее вытворяет подобные непотребства в уборной!')

insert into insultParticipants (insultId,participantId,insultRoleId)
values ((select top 1 id from insults where description='менелай хочет навалять гектору за то что тот мудак'),(select top 1 id from players where name='Менелай'),(select top 1 id from insultParticipantRoles where name='initiator'))
,((select top 1 id from insults where description='менелай хочет навалять гектору за то что тот мудак'),(select top 1 id from players where name='Гектор'),(select top 1 id from insultParticipantRoles where name='respondent'))
,((select top 1 id from insults where description='менелай хочет навалять гектору за то что тот мудак'),(select top 1 id from players where name='Марк'),(select top 1 id from insultParticipantRoles where name='other'))
,((select top 1 id from insults where description='елена недовольна тем что парис не опускает стульчак'),(select top 1 id from players where name='Елена'),(select top 1 id from insultParticipantRoles where name='initiator'))
,((select top 1 id from insults where description='елена недовольна тем что парис не опускает стульчак'),(select top 1 id from players where name='Парис'),(select top 1 id from insultParticipantRoles where name='respondent'))

insert into insultLogs (playerId,insultId,honor,description, date)
values ((select top 1 id from players where name='Менелай'),(select top 1 id from insults where description='менелай хочет навалять гектору за то что тот мудак'),5,'заявил обиду на тв','2020-12-04 12:30:00')
,((select top 1 id from players where name='Гектор'),(select top 1 id from insults where description='менелай хочет навалять гектору за то что тот мудак'),2,'остроумно ответил оппоеннту','2020-12-04 12:35:00')
,((select top 1 id from players where name='Елена'),(select top 1 id from insults where description='елена недовольна тем что парис не опускает стульчак'),5,'публично объявила свое недовольство','2020-12-04 11:30:00')


insert into gold (date)
values (getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate()),(getdate())


truncate table heavyWeapons
insert into hermestv..heavyWeapons (typeId,channelTypeId) 
values((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..heavyWeaponTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..heavyWeaponTypes)+1,0))),(select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0))))

truncate table humanitaryCards
insert into hermestv..humanitaryCards (channelTypeId) 
values((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0)))),
((select top 1 id from hermestv..channelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..channelTypes)+1,0))))

insert into hermestv..bjzi (name,description,sideId,playerId,squadId,bjziChannelTypeId) 
values('Иван','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Жора','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Вася','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Феофан','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Дрейфус','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Диоген','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Леха','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Тоха','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Лена','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Маша','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0)))
,null
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Дуня','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,null
,(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0)))
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Гена','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,null
,(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0)))
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Петя','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,null
,(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0)))
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) ),
('Шурик','Друг детства'
,(select top 1 id from hermestv..sides where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..sides)+1,0)))
,null
,(select top 1 id from hermestv..squads where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..squads)+1,0)))
,(select top 1 id from hermestv..bjziChannelTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..bjziChannelTypes)+1,0))) )

truncate table guns
insert into hermestv..guns (gunTypeId,power,hasrapidFire,isTurret,playerId) 
values((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),1,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),1,0,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),0,1,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) ),
((select top 1 id from hermestv..gunTypes where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..gunTypes)+1,0))),round(rand()*(50)+100,2),1,1,(select top 1 id from hermestv..players where id=(select top 1 round(rand()*(select count(*)-1 from hermestv..players)+1,0))) )





--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='player'),'data:image/gif;base64,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'
--from hermestv..players

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='squad'),'data:image/gif;base64,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'
--from hermestv..squads

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='insult'),'data:image/gif;base64,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'
--from hermestv..insults

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='gold'),'data:image/gif;base64,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'
--from hermestv..gold

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='heavyWeapon'),'data:image/gif;base64,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'
--from hermestv..heavyWeapons

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='humanitaryCard'),'data:image/gif;base64,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'
--from hermestv..humanitaryCards

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='bjzi'),null
--from hermestv..bjzi

--insert into hermestv..objects (id,typeId,qr) 
--select id,(select top 1 id from hermestv..objectTypes where name='gun'),'data:image/gif;base64,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'
--from hermestv..guns





--delete from hermestv..objects
--where typeid=(select top 1 id from hermestv..objectTypes where name='gun')

--delete from hermestv..objects
--where typeid=(select top 1 id from hermestv..objectTypes where name='humanitaryCard')

--delete from hermestv..objects
--where typeid=(select top 1 id from hermestv..objectTypes where name='heavyWeapon')

--delete from hermestv..objects
--where typeid=(select top 1 id from hermestv..objectTypes where name='squad')





-- Смотрим что получилось


--select * from hermestv..objectTypes

--select p.id,p.name,p.equipment,p.resourses,state.name as state,side.name as side ,sq.name as squad, p.honor from hermestv..players p
--join sides side on side.id=p.sideId
--join squads sq on sq.id=p.squadId
--join states state on state.id=p.stateId

--select sq.id,sq.name,side.name as side,sq.members,sq.reserve,p.name as leader,sq.exterminated from hermestv..squads sq
--join sides side on side.id=sq.sideId
--left join players p on p.id=sq.leaderId

select o.id,ot.name,ot.description,o.active,o.qr from hermestv..objects o
join hermestv..objectTypes ot on ot.id=o.typeId
order by 2,1
---- декодировать изображение тут https://snipp.ru/tools/base64-img-decode

--select gc.id,gc.startTime,gc.endTime,ct.description FROM gameCycles gc
--join cycleTypes ct on ct.id=gc.cycleTypeId

--select i.id,i.description,i.longDescription,i.finished,p.name,ipr.description ,(select isnull(sum(honor),0) from insultLogs il where il.insultId=i.id and il.playerId=ip.participantId) as totalHonor 
--from insults i
--left join insultParticipants ip on ip.insultId=i.id
--left join players p on p.id=ip.participantId
--left join insultParticipantRoles ipr on ipr.id=ip.insultRoleId

--select il.id, il.insultId,i.description,i.longDescription,i.finished,p.name,ipr.description,il.description,il.honor,il.date 
--from insultLogs il
--left join insults i on i.id=il.insultId
--left join players p on p.id=il.playerId
--left join insultParticipants ip on ip.insultId=il.insultId and ip.participantId=il.playerId
--left join insultParticipantRoles ipr on ipr.id=ip.insultRoleId
--order by il.id,il.date desc

