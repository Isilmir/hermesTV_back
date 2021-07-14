const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	
		//console.log(req.user);
		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			//console.log(req)
		try{
			result = await pool.request()
							.input('id',sql.Int, req.params.messageId)
							.execute('dbo.getMessage');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения сообщения: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
		console.log('проверка сообщения',req.user)
		if(result.recordset.length==0){
			res.send({description:'Похоже такого сообщения не существует'}); 
		}else if(result.recordset[0].playerId==req.user||req.user==100083){
			res.send({description:result.recordset[0].description}); 
		}else{
			res.send({description:'Похоже это сообщение адресовано кому-то другому'}); 
		}
		return;
		
	  };
}