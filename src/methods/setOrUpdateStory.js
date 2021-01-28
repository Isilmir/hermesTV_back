const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		
		if(!req.body.description||!req.body.longDescription){ 
			res.status(400);
			res.send(`Не заполнено название или описание сюжета`);
			return;
		}

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('id',sql.Int, req.body.id)
							.input('description',sql.NVarChar(255), req.body.description)
							.input('longDescription',sql.NVarChar(sql.MAX), req.body.longDescription)
							.output('res',sql.Int)
							.execute('dbo.insertOrUpdateStory');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка обновления сюжета: ${e.message}`); 
			return;
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id,
					type:'story',
					name:req.body.description}); 

		return;
		
	  };
}