const fetch = require('node-fetch');
const fs = require('fs');
const url = require('url');
const jwt = require('jsonwebtoken');
const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		//let since = url.parse(req.url,true).query.since;
		//console.log(since);
	//console.log(req.body);
		let result;
		try{
		await sql.connect(conf.sqlConfig);
		// исправить запрос чтобы не было инъекции
		result = await sql.query(`SELECT TOP 1 p.[name]
      ,p.[equipment]
      ,p.[resourсes]
      ,p.[sideId]
	  ,si.[description] as sideName
      ,p.[squadId]
	  ,sq.[name] as squadName
      ,isnull(p.[honor],0) as honor
      ,p.[password]
  FROM [players]p
  join sides si on si.id=p.sideId
  join squads sq on sq.id=p.squadId
  where p.id='${req.body.user}'`);
		}catch(e){
			res.status(500);
			res.send(e.message); 
			return;
		}
		//console.log()
		sql.close();
	//console.log(result.recordset[0]);
		if(!result.recordset[0]){
			res.status(404);
			res.send('Доступ запрещен'); 
			return;
		}
		let password = result.recordset[0].password;
		//console.log(password,req.body.password);
		if(password==req.body.password){
			let token = jwt.sign({user:req.body.user,isAdmin:result.recordset[0]['sideId']==16333?true:false},'password')
			//let decoded = jwt.verify(token,'password');
			//console.log('влогине',decoded);
						//await sql.connect(conf.sqlConfig);
				//const result = await sql.query(`select qr from objects`);
				//sql.close();
			res.send({"user":{"id":`${req.body.user}`,"name":`${result.recordset[0]['name']}`,
				"equipment":JSON.parse(result.recordset[0]['equipment']),
				"resourсes":JSON.parse(result.recordset[0]['resourсes']),
				"side":{"id":`${result.recordset[0]['sideId']}`,"name":`${result.recordset[0]['sideName']}`},
				"squad":{"id":`${result.recordset[0]['squadId']}`,"name":`${result.recordset[0]['squadName']}`},
				"honor":`${result.recordset[0]['honor']}`},
				"token":`${token}`
				}); 
			return;
		}
		res.status(404);
		res.send('Доступ запрещен'); 
		return;
		
	  };
}