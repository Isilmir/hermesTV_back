const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
	

		const sqlConfig = conf.sqlConfig;

		//await sql.connect(sqlConfig);
		let pool = await sql.connect(sqlConfig)
		let result;	
			
		try{
			result = await sql.query(`SELECT 
	  'player' as objectType
	  ,p.id
	  ,p.name
	  ,p.honor
	  ,dbo.compileJson_player_deeds_func(id) as deeds
  FROM [dbo].[players]p`);
			//console.dir(result);
		}catch(e){console.log(e.message)
			res.status(500);
			res.send(`Ошибка получения персонажей: ${e.message}`); 
		}

		sql.on('error',err=>console.log(err));
		sql.close();
				
		res.send(result.recordset.map(el=>{el.deeds=JSON.parse(el.deeds).filter(deed=>deed.honor!=0).map(deed=>{deed.honor=deed.honor>0?1:-1;return deed});return el})); 

		return;
		
	  };
}