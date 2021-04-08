const sql = require('mssql');
const url = require('url');

module.exports = function (conf) {
      return async function (req,res){ 
		
		const sqlConfig = conf.sqlConfig;
		const getCurSide = conf.getCurSide;
		
		let dryrun = url.parse(req.url,true).query.dryrun;
		dryrun = dryrun=='true'?true:false;
		
		let data = conf.charactersFull_cache.map(el=>{return {
		id:el.CharacterId,
		name:el.CharacterName,
		stateId:1,
		sideId:getCurSide(el).CharacterGroupId,
		squadId:el.Groups[0].CharacterGroupId,
		honor:0,
		updatedAt:el.UpdatedAt,
		realName:el.PlayerUserId?el.Fields.filter(field=>field.ProjectFieldId==5525)[0].Value:null,
		// тут надо будет указать id реального свойства с паролем
		password:el.PlayerUserId?(el.Fields.filter(field=>field.ProjectFieldId==55250)[0]?el.Fields.filter(field=>field.ProjectFieldId==55250)[0].Value:null):null
	}}).map(el=>`(${el.id?el.id:'null'}
				  ,${el.name?"'"+el.name+"'":'null'}
				  ,${el.stateId?el.stateId:'null'}
				  ,${el.sideId?el.sideId:'null'}
				  ,${el.squadId?el.squadId:'null'}
				  ,${el.honor?el.honor:'null'}
				  ,${el.updatedAt?"'"+el.updatedAt+"'":'null'}
				  ,${el.realName?"'"+el.realName+"'":'null'}
				  ,${el.password?"'"+el.password+"'":'null'})`).join(',')
		
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