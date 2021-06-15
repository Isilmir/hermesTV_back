const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			//console.log('insertOrUpdateConfig',req.body)
		try{
			result = await pool.request()
							.input('id',sql.Int, req.body.id)
							.input('description',sql.NVarChar(sql.MAX), req.body.description)
							.input('storage',sql.NVarChar(255), req.body.storage)
							.input('key_',sql.NVarChar(255), req.body.key_)
							.input('value',sql.NVarChar(sql.MAX), req.body.value)
							.input('valueType',sql.NVarChar(255), req.body.valueType)
							.output('res',sql.Int).execute('dbo.insertOrUpdateConfig');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления спутника: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id}); 

		return;
		
	  };
}