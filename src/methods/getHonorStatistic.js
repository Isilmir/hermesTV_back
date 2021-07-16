const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('deedTypes',sql.VarChar(sql.MAX),JSON.stringify(req.body.deedTypes)||`[]`)
							.input('start',sql.Date,JSON.stringify(req.body.start)||`2021-01-01`)
							.input('end',sql.Date,JSON.stringify(req.body.end)||`2022-01-01`)
							.input('n',sql.Int,JSON.stringify(req.body.n)||`10`)
							.execute('dbo.getHonorStatistic');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset); 

		return;
		
	  };
}