const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			console.log(req.body)
		try{
			result = await pool.request()
							.input('id',sql.Int, req.user)
							.execute('dbo.getBlesses');
			console.dir(result);
		}catch(e){console.log(e)
			res.status(500);
			res.send(`Ошибка при получения блессов: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset); 

		return;
		
	  };
}