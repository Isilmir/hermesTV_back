const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		
		try{
			if(!req.body.from||!req.body.to||!req.body.from.id||!req.body.from.type||!req.body.to.id||!req.body.to.type){ 
				res.status(400);
				res.send(`Не заполнены данные связи`);
				return;
			}
		}catch(e){
			res.status(400);
			res.send(`Не заполнены данные связи.`);
			return;
		}
		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('objIdFrom',sql.Int, req.body.from.id)
							.input('objTypeFrom',sql.NVarChar(255), req.body.from.type)
							.input('objIdTo',sql.Int, req.body.to.id)
							.input('objTypeTo',sql.NVarChar(255), req.body.to.type)
							.output('res',sql.Int).execute('dbo.deleteLink');
			console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка удаления связи: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send({id:result.output.res||req.body.id,
					type:'link',
					name:req.body.name}); 

		return;
		
	  };
}