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
							.input('id',sql.Int, req.body.id)
							.input('playerId',sql.Int, req.body.playerId)
							.input('god',sql.NVarChar(255), req.body.god)
							.input('resource',sql.NVarChar(255), req.body.resource)
							.input('quantity',sql.Int, req.body.quantity)
							.input('gold',sql.Int, req.body.gold)
							.input('description',sql.NVarChar(255), req.body.description)
							.output('res',sql.Int).execute('dbo.insertOrUpdateTransaction');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления транзакции: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id,
					type:'transaction',
					description:req.body.description}); 

		return;
		
	  };
}