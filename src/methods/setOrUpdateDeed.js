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
							.input('description',sql.NVarChar(255), req.body.description)
							.input('typeId',sql.Int, req.body.typeId)
							.input('playerId',sql.Int, req.body.playerId)
							.input('honor',sql.Int, req.body.honor)
							.input('honor',sql.Int, req.body.heroic||false)
							.output('res',sql.Int).execute('dbo.insertOrUpdateDeed');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления спутника: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id,
					type:'deed',
					description:req.body.description}); 

		return;
		
	  };
}