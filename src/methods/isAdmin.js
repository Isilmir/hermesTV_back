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
		let result={};
		if(req.headers['authorization']){
			const token = req.headers['authorization'].split(' ')[1]
			let data;
			try{
				data = await jwt.verify(req.headers['authorization'].split(' ')[1],'password');
			}catch(e){
				res.status(403);
				res.send('Ошибка авторизации'); 
				return;
			}
			const isAdmin = data.isAdmin;
			console.log('Является ли пользователь админом - ',isAdmin);
			result={isAdmin:isAdmin};
			res.send(result); 
		}else{
			res.status(403);
			res.send('Ошибка авторизации'); 
			return;
		}
		
	  };
}