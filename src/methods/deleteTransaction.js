const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		
		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('transactionId',sql.Int, req.body.id)
							.output('res',sql.Int).execute('dbo.deleteTransaction');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка удаления транзакции: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res,
					type:'transaction'}); 

		return;
		
	  };
}