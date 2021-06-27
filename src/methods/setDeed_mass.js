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
							.input('description',sql.NVarChar(255), req.body.description)
							.input('typeId',sql.Int, req.body.typeId)
							.input('players',sql.NVarChar(sql.MAX), req.body.players)
							.input('honor',sql.Int, req.body.honor)
							.input('heroic',sql.Bit, req.body.heroic)
							.output('res',sql.Int).execute('dbo.insertDeed_mass');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления спутника: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset); 

		return;
		
	  };
}