const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	
		const sqlConfig = conf.sqlConfig;

		let pool = await sql.connect(sqlConfig)
		let result;	
			console.log(req.body)
		try{
			result = await pool.request()
							.input('id',sql.Int, req.body.id)
							.input('squadId',sql.Int, req.body.squadId)
							.input('name',sql.NVarChar(255), req.body.name)
							.input('transferBjzi',sql.Bit, req.body.transferBjzi)
							.execute('dbo.makeNewPlayerFromBjzi');
			//console.dir(result);
		}catch(e){console.log(e)
			res.status(500);
			res.send(`Ошибка при передаче: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(); 

		return;
		
	  };
}