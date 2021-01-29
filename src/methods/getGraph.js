const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		
		try{
			if(!req.body.id||!req.body.type){ 
				res.status(400);
				res.send(`Не заполнены данные начального узла`);
				return;
			}
		}catch(e){
			res.status(400);
			res.send(`Не заполнены данные начального узла.`);
			return;
		}
		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('id',sql.Int, req.body.id)
							.input('type',sql.NVarChar(255), req.body.type)
							.input('deep',sql.Int, req.body.deep)
							.execute('dbo.getGraph');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения графа: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset.map(el=>{return {from:{
													id:el.id_from,
													objectType:el.type_from_desc,
													name:el.name_from
												 },to:{
													 id:el.id_to,
													objectType:el.type_to_desc,
													name:el.name_to
												 },description:el.description}
											})); 

		return;
		
	  };
}