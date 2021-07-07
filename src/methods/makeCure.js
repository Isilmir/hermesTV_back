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
							.input('id_SUBJECT',sql.Int, req.user)
							.input('id_OBJECT',sql.Int, req.body.patient)
							.input('objectType_OBJECT',sql.NVarChar(255), req.body.patientType)
							.execute('dbo.makeCure');
			console.dir(result);
		}catch(e){console.log(e)
			res.status(500);
			res.send(`Ошибка при похоронах: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(); 

		return;
		
	  };
}