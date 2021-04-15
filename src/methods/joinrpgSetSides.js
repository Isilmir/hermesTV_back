const sql = require('mssql');
const url = require('url');

function getSideName(side){
	switch(side.CharacterGroupId){
		case 14906:
			return 'achaeans';
		break;
		case 14920:
			return 'troy';
		break;
		case 15680:
			return 'peacekeeping';
		break;
		case 16333:
			return 'olymp';
		break;
	}
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
		
		let data = charactersFull_cache.reduce((res1,cur)=>{
				let curSide = getCurSide(cur);
				if(res1.filter(el=>el.id == curSide.CharacterGroupId).length==0){res1.push({
					id:curSide.CharacterGroupId,
					name:getSideName(curSide),
					description:curSide.CharacterGroupName
					})}
				return res1;
		},[]).map(el=>`(${el.id?el.id:'null'},${el.name?"'"+el.name+"'":'null'},${el.description?"'"+el.description+"'":'null'})`).join(',')
		
		if (!data){
			res.status(501);
			res.send('С последнего обновления нет изменений по сторонам конфликта'); 
			return;
		}
		
		let query = 
`declare @tab table (id int, name varchar(255),description varchar(255))

insert into @tab
values ${data}

SET IDENTITY_INSERT hermestv..sides ON;

MERGE dbo.sides as target
USING (select *from @tab) as source (id,name,description)
on (target.id=source.id)
when matched then
	update set name=source.name,description=source.description

when not matched then
	insert (id,name,description)
	values(source.id,source.name,source.description);`
		
		//если нужно проверить корректность запроса без обновления данных
		if(dryrun){res.send(query);return;};
		
		await sql.connect(sqlConfig);
	try{
	const result = await sql.query(query);
	//console.log(result);
	}catch(e){console.log(e.message)}
	
	sql.on('error',err=>console.log(err));
	sql.close();
		
		res.send(); 
		return;
	  };
}