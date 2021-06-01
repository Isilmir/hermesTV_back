const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	
		const sqlConfig = conf.sqlConfig;

		let pool = await sql.connect(sqlConfig)
		let result;	
			console.log(req.body)
		try{
			result = await pool.request()
							.input('playerId',sql.Int, req.body.playerId)
							.output('deedRes',sql.Int)
							.execute('dbo.makeReinforcementsArrived');
			//console.dir(result);
		}catch(e){console.log(e)
			res.status(500);
			res.send(`Ошибка при передаче: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(); 

		return;
		
	  };
}