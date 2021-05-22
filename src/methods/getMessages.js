const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							//.input('playerId',sql.Int, req.user)
							.output('res',sql.NVarChar(sql.MAX))
							.execute('dbo.getMessages');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения сообщений: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset.map(message=>{return{
													objectType:'message',
													id:message.id,
													description:message.description,
													deed:{
														objectType:'deed',
														id:message.deedId,
														deedType:{
															id:message.deedTypeId,
															name:message.deedTypeName,
															description:message.deedTypeDescription
														},
														description:message.deedDescription,
														date:message.deedDate,
														heroic:message.deedHeroic
													},
													player:{
														objectType:'player',
														id:message.playerId,
														name:message.playerName
													},
													squad:{
														objectType:'squad',
														id:message.squadId,
														name:message.squadName
													},
													side:{
														objectType:'side',
														id:message.sideId,
														description:message.sideDescription
													}
													}})); 

		return;
		
	  };
}