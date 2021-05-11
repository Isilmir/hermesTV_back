const fetch = require('node-fetch');
const fs = require('fs');
const url = require('url');
const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		//let since = url.parse(req.url,true).query.since;
		console.log(process.env.joinrpgToken);
		
		let projectId = '642'
		let sinceDate = url.parse(req.url,true).query.since||'2017-01-01';
		let uri=`https://joinrpg.ru/x-game-api/${projectId}/characters?modifiedSince=${sinceDate}`
		
		let characters = await (await fetch(uri,{
			method:'GET',
			headers:{
			'Accept':'application/json',
			'Authorization':`Bearer ${process.env.joinrpgToken}`
			}
			}) ).json();
		
		console.log(new Date(),`начинаем обработку персонажей через for`);
		//console.log(characters)
		let charactersFull=[];
		for(let i=0;i < characters.length; i++){
			console.log(characters[i]);
			console.log(new Date(),`for. начало обработки ${characters[i].characterId}`);
			let data = await (await fetch(`https://joinrpg.ru${characters[i].characterLink}`,{
			method:'GET',
			headers:{
			'Accept':'application/json',
			'Authorization':`Bearer ${process.env.joinrpgToken}`
					}
				}
			) ).json();
			data.CharacterLink = characters[i].characterLink;
			//console.log(data);
			console.log(new Date(),`for. конец обработки ${characters[i].characterId}`);
			charactersFull.push(data);
		}
		
		console.log(new Date(),`закончили обработку персонажей через for`);
		
		//console.log(charactersFull_map)
		//console.log(charactersFull)
		
		//fs.writeFile('./cache/charactersFull_cache.json', JSON.stringify(charactersFull), (err) => {
		//  if (err) {
		//	console.error(err)
		//	return
		//}})
		
		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			//console.log(req)
		try{
			result = await pool.request()
							.input('json',sql.NVarChar(sql.MAX),JSON.stringify(charactersFull))
							.execute('dbo.setCharacterCache');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка сохранения кэша персонажей: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		
		
		res.send(charactersFull); 
		return;
	  };
}