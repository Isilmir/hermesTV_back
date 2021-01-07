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
							.input('name',sql.NVarChar(255), req.body.name)
							.input('description',sql.NVarChar(255), req.body.description)
							.input('playerId',sql.Int, req.user)
							.input('channelTypeId',sql.Int, req.body.channelTypeId||1)
							.output('res',sql.Int).execute('dbo.insertOrUpdateBjzi');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления спутника: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id,
					type:'bjzi',
					name:req.body.name}); 

		return;
		
	  };
}