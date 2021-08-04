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
							.input('id_SUBJECT',sql.Int, req.user)
							.input('id_OBJECT',sql.Int, req.body.object)
							.input('objectType_OBJECT',sql.NVarChar(255), req.body.objectType)
							.input('god',sql.NVarChar(255), req.body.god)
							.input('deedDesc',sql.NVarChar(sql.MAX), req.body.deedDesc)
							.input('deedType',sql.Int, req.body.deedType)
							.execute('dbo.makeBless');
			console.dir(result);
		}catch(e){console.log(e)
			res.status(500);
			res.send(`${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset); 

		return;
		
	  };
}