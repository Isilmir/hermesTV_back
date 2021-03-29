const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('dicts',sql.VarChar(sql.MAX),JSON.stringify(req.body.dicts)||`[]`)
							.execute('dbo.getDictionaries');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения справочников: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset.map(el=>{el.data=JSON.parse(el.data);return el;})); 

		return;
		
	  };
}