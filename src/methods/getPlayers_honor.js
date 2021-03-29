const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await pool.request()
							.input('res',sql.Int, 1)
							.execute('dbo.getPlayersHonor');
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения персонажей: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset.map(el=>{el.deedGroups=JSON.parse(el.deedGroups)/*.filter(deed=>deed.type.name!='default').map(deed=>{deed.honor=deed.honor>0?1:-1;return deed})*/;return el;})); 

		return;
		
	  };
}