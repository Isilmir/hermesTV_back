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
							.input('id',sql.Int, req.params.bjziId)
							.execute('dbo.getBjziSingle');
			//console.dir(result);
		}catch(e){console.log(e.message)
			sql.close();
			res.status(500);
			res.send(`Ошибка получения спутника: ${e.message}`); 
			return;
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset); 

		return;
		
	  };
}