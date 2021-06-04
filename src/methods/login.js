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
		
		
		let privateKey = fs.readFileSync('./src/rsa/key.pem');
		let cert = fs.readFileSync('./src/rsa/publickey.pem'); 
		
		//console.log(privateKey,cert);
		
		//let test_token = jwt.sign({user:req.body.user,exp: Math.floor(Date.now() / 1000) + (60*60*24),isAdmin:req.body.user==100083/*result.recordset[0]['sideId']==16333*/?true:false, permissions:['admin']},privateKey,{ algorithm: 'RS256'})
		//console.log(test_token)
		//let test_data = jwt.verify(test_token,cert,{ algorithms: ['RS256'] })
		//console.log(test_data)
	
		
		let pool = await sql.connect(conf.sqlConfig)
		let result;
		try{
			result = await pool.request()
							.input('id',sql.Int,req.body.user)
							.execute('dbo.doLogin');
			//console.dir(result);
/*		await sql.connect(conf.sqlConfig);
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
  where p.id='${req.body.user}'`);*/
		}catch(e){
			res.status(500);
			res.send(e.message); 
			return;
		}
		//console.log()
		sql.close();
	//console.log(result.recordset[0]);
		if(!result.recordset[0]){
			res.status(403);
			res.send('Доступ запрещен'); 
			return;
		}
		let password = result.recordset[0].password;
		//console.log(password,req.body.password);
		if(password==req.body.password){
			let token = jwt.sign({user:req.body.user,exp: Math.floor(Date.now() / 1000) + (60*60*24),isAdmin:req.body.user==100083/*result.recordset[0]['sideId']==16333*/?true:false, permissions:JSON.parse(result.recordset[0]['permissions']).map(el=>el.value)},privateKey,{ algorithm: 'RS256'}/*,'password'*/)
			//let decoded = jwt.verify(token,'password');
			//console.log('влогине',decoded);
						//await sql.connect(conf.sqlConfig);
				//const result = await sql.query(`select qr from objects`);
				//sql.close();
			res.send({"user":{"id":`${req.body.user}`,"name":`${result.recordset[0]['name']}`,
				//"equipment":JSON.parse(result.recordset[0]['equipment']),
				//"resourсes":JSON.parse(result.recordset[0]['resourсes']),
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