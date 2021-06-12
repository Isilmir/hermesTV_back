const sql = require('mssql');
const url = require('url');

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
		
		let data = charactersFull_cache.reduce((res,cur)=>{
			let curSide = getCurSide(cur);
			if(res.filter(el=>el.id == cur.groups[0].characterGroupId).length==0){res.push({
				id:cur.groups[0].characterGroupId,
				name:cur.groups[0].characterGroupName,
				sideId:curSide.characterGroupId,
				leaderId:null
				})}
			return res;
		},[]).map(el=>`(${el.id?el.id:'null'},${el.name?"N'"+el.name+"'":'null'},${el.sideId?el.sideId:'null'},${el.leaderId?el.leaderId:'null'})`).join(',')
		
		if (!data){
			res.status(501);
			res.send('С последнего обновления нет изменений по отрядам'); 
			return;
		}
		
		let query = 
`declare @tab table (id int, name nvarchar(255),sideId int, leaderId int)

insert into @tab
values ${data}

SET IDENTITY_INSERT hermestv..squads ON;

MERGE dbo.squads as target
USING (select *from @tab) as source (id,name,sideId,leaderId)
on (target.id=source.id)
when matched then
	update set name=source.name,sideId=source.sideId,leaderId=source.leaderId

when not matched then
	insert (id,name,sideId,leaderId)
	values(source.id,source.name,source.sideId,source.leaderId);`
		
		//если нужно проверить корректность запроса без обновления данных
		if(dryrun){res.send(query);return;};
		
		await sql.connect(sqlConfig);
	try{
	const result = await sql.query(query);
	//console.log(result);
	}catch(e){console.log(e.message)}


	sql.close();
		
		res.send(); 
		return;
	  };
}