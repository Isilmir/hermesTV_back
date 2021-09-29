const sql = require('mssql');
const fs = require('fs');

module.exports = function (conf) {
      return async function (req,res){ 
	
	console.log(req.user);

		const sqlConfig = conf.sqlConfig;
		
		const players_honor  = JSON.parse(fs.readFileSync('cache/players_honor.json', 'utf8'));

		//await sql.connect(sqlConfig);
		//let pool = await sql.connect(sqlConfig)
		//let result;	
			
		//try{
		//	result = await pool.request()
		//					.input('id',sql.Int, req.user)
		//					.execute('dbo.getPlayersHonor');
		//	//console.dir(result);
		//}catch(e){console.log(e.message)
		//	res.status(500);
		//	res.send(`Ошибка получения славы персонажей: ${e.message}`); 
		//}

		//sql.on('error',err=>console.log(err));
		//sql.close();
		
		
		
		//console.log(result.recordset[0]);		
		res.send(players_honor);//(result.recordset.map(el=>{el.deedGroups=JSON.parse(el.deedGroups);el.transactions=JSON.parse(el.transactions);/*.filter(deed=>deed.type.name!='default').map(deed=>{deed.honor=deed.honor>0?1:-1;return deed})*/;return el;})); 

		return;
		
	  };
}