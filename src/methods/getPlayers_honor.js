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
	  ,(select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-7 and getdate())
	  -(select top 1 isnull(sum(honor),0) from deeds where playerid=p.id and date between getdate()-14 and getdate()-7) as honorChange
	  ,dbo.compileJson_player_deeds_group_by_types_func(id) as deedGroups
  FROM [dbo].[players]p`);
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