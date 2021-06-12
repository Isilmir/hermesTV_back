const sql = require('mssql');
const url = require('url');

function generatePassword() {
    var length = 6,
        charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
        retVal = "";
    for (var i = 0, n = charset.length; i < length; ++i) {
        retVal += charset.charAt(Math.floor(Math.random() * n));
    }
    return retVal;
}

module.exports = function (conf) {
      return async function (req,res){ 
		
		const sqlConfig = conf.sqlConfig;
		const getCurSide = conf.getCurSide;
		
		let dryrun = url.parse(req.url,true).query.dryrun;
		dryrun = dryrun=='true'?true:false;
		
		let charactersFull_cache;
		
		let pool = await sql.connect(sqlConfig)
		let cache;	
			//console.log(req)
		try{
			cache = await pool.request()
							.execute('dbo.getCharacterCache');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения кэша персонажей: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
		
		try{
		charactersFull_cache=JSON.parse(cache.recordset[0].json)
		}catch(e){
			res.status(500);
			res.send(`Ошибка парсинга кэша персонажей: ${e.message}`);
			return;
		}
		
		let data = charactersFull_cache.map(el=>{
			//console.log(el);
			return {
		id:el.characterId,
		name:el.characterName,
		stateId:1,
		sideId:getCurSide(el).characterGroupId,
		squadId:el.groups[0].characterGroupId,
		honor:0,
		updatedAt:el.updatedAt,
		realName:el.playerUserId?el.fields.filter(field=>field.projectFieldId==5525)[0].value:null,
		// тут надо будет указать id реального свойства с паролем
		password:generatePassword()//el.playerUserId?(el.fields.filter(field=>field.projectFieldId==55250)[0]?el.fields.filter(field=>field.projectFieldId==55250)[0].value:null):null
	}}).map(el=>`(${el.id?el.id:'null'}
				  ,${el.name?"N'"+el.name+"'":'null'}
				  ,${el.stateId?el.stateId:'null'}
				  ,${el.sideId?el.sideId:'null'}
				  ,${el.squadId?el.squadId:'null'}
				  ,${el.honor?el.honor:'null'}
				  ,${el.updatedAt?"'"+el.updatedAt+"'":'null'}
				  ,${el.realName?"'"+el.realName+"'":'null'}
				  ,${el.password?"'"+el.password+"'":'null'})`).join(',')
		
		if (!data){
			res.status(501);
			res.send('С последнего обновления нет изменений по персонажам'); 
			return;
		}
		
		let query = 
`declare @tab table (id int, name varchar(255),stateId int, sideId int, squadId int, honor int, updatedAt datetime, realName nvarchar(255), password nvarchar(255))

insert into @tab
values ${data}

SET IDENTITY_INSERT hermestv..players ON;

MERGE dbo.players as target
USING (select *from @tab) as source (id,name,stateId,sideId,squadId,honor,updatedAt,realName,password)
on (target.id=source.id)
when matched then
	update set name=source.name,sideId=source.sideId,stateId=source.stateId,squadId=source.squadId/*,honor=source.honor*/,updatedAt=source.updatedAt,realName=source.realName/*,password=source.password*/

when not matched then
	insert (id,name,stateId,sideId,squadId,honor,updatedAt,realName,password)
	values(source.id,source.name,source.stateId,source.sideId,source.squadId,source.honor,source.updatedAt,source.realName,source.password);`
	
		//если нужно проверить корректность запроса без обновления данных
		if(dryrun){res.send(query);return;};
		
		await sql.connect(sqlConfig);
	try{
	const result = await sql.query(query);
	//console.log(result);
	}catch(e){console.warn('\x1b[31m%s\x1b[0m',e.message)}


	sql.close();
		
		res.send(); 
		return;
	  };
}