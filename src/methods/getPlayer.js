const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			//console.log(req)
		try{
			result = await pool.request()
							.input('id',sql.Int, req.params.playerId)
							.execute('dbo.getPlayer');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения персонажа: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset.map(el=>{el.resourсes=JSON.parse(el.resourсes);el.equipment=JSON.parse(el.equipment);el.deeds=JSON.parse(el.deeds);el.transactions=JSON.parse(el.transactions);el.password='***';return el})); 

		return;
		
	  };
}