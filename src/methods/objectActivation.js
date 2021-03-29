const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('id',sql.Int, req.body.id)
							.input('type',sql.NVarChar(255), req.body.type)
							.input('active',sql.Bit, req.body.active)
							.output('res',sql.Bit).execute('dbo.objectActivation');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления спутника: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({active:result.output.res||req.body.active,
					type:req.body.type,
					id:req.body.id}); 

		return;
		
	  };
}