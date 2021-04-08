const fetch = require('node-fetch');
const fs = require('fs');
const url = require('url');

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
		let charactersFull=[];
		for(let i=0;i < characters.length; i++){
			console.log(new Date(),`for. начало обработки ${characters[i].CharacterId}`);
			let data = await (await fetch(`https://joinrpg.ru/${characters[i].CharacterLink}`,{
			method:'GET',
			headers:{
			'Accept':'application/json',
			'Authorization':`Bearer ${process.env.joinrpgToken}`
					}
				}
			) ).json();
			data.CharacterLink = characters[i].CharacterLink;
			//console.log(data);
			console.log(new Date(),`for. конец обработки ${characters[i].CharacterId}`);
			charactersFull.push(data);
		}
		
		console.log(new Date(),`закончили обработку персонажей через for`);
		
		//console.log(charactersFull_map)
		//console.log(charactersFull)
		
		fs.writeFile('./cache/charactersFull_cache.json', JSON.stringify(charactersFull), (err) => {
		  if (err) {
			console.error(err)
			return
		}})
		
		res.send(charactersFull); 
		return;
	  };
}