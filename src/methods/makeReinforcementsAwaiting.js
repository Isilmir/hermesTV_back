const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	
		const sqlConfig = conf.sqlConfig;

		let pool = await sql.connect(sqlConfig)
		let result;	
		try{
			result = await pool.request()
							.execute('dbo.makeReinforcementsAwaiting');
			console.dir(result);
		}catch(e){console.log(e)
			res.status(500);
			res.send(`Ошибка при подготовке подкреплений: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(); 

		return;
		
	  };
}