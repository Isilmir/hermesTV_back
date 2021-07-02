const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
		let player;
			//console.log(req)
		try{
			result = await pool.request()
							.input('id',sql.Int, req.params.bjziId)
							.execute('dbo.getBjziSingle');
			//console.dir(result);
		}catch(e){console.log(e.message)
			sql.close();
			res.status(500);
			res.send(`Ошибка получения спутника: ${e.message}`); 
			return;
		}
		if(!result.recordset[0]){
			res.send(result.recordset); 
			return;
		}
		if(result.recordset[0].isPlayer){
			try{
				player = await pool.request()
							.input('id',sql.Int, result.recordset[0].playerId)
							.execute('dbo.getPlayer');
			//console.dir(player);
			}catch(e){console.log(e.message)
				sql.close();
				res.status(500);
				res.send(`Ошибка получения персонажа: ${e.message}`); 
				return;
			}
			result.recordset[0].player=player.recordset.map(el=>{el.resourсes=JSON.parse(el.resourсes);el.equipment=JSON.parse(el.equipment);el.deeds=JSON.parse(el.deeds);el.password='***';return el})[0]
		}
		sql.on('error',err=>console.log(err));
		sql.close();
		
		res.send(result.recordset); 

		return;
		
	  };
}