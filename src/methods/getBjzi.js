const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('playerId',sql.Int, req.user)
							.output('res',sql.NVarChar(sql.MAX)).execute('dbo.getResourсesByPlayer');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения спутников: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(JSON.parse(result.output.res).filter(el=>el.objectType=='bjzi')); 

		return;
		
	  };
}