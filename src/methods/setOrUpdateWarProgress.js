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
							.input('cycleId',sql.NVarChar(255), req.body.cycleId)
							.input('checkpointId',sql.Int, req.body.checkpointId)
							.input('squadId',sql.Int, req.body.squadId)
							.output('res',sql.Int).execute('dbo.insertOrUpdateWarProgress');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id,
					type:'warProgress'}); 

		return;
		
	  };
}