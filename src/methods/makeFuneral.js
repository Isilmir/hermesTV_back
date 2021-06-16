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
							.input('id_SUBJECT',sql.Int, req.body.SUBJECT.id)
							.input('objectType_SUBJECT',sql.NVarChar(255), req.body.SUBJECT.type)
							.input('id_OBJECT',sql.Int, req.body.OBJECT.id)
							.input('objectType_OBJECT',sql.NVarChar(255), req.body.OBJECT.type)
							.input('expired',sql.Bit, req.body.expired||false)
							.execute('dbo.makeFuneral');
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