const sql = require('mssql');

module.exports = function (conf) {
      return async function (req,res){ 
		
		const sqlConfig = conf.sqlConfig;
		const getCurSide = conf.getCurSide;
		
		let data = conf.charactersFull_cache.reduce((res,cur)=>{
			let curSide = getCurSide(cur);
			if(res.filter(el=>el.id == cur.Groups[0].CharacterGroupId).length==0){res.push({
				id:cur.Groups[0].CharacterGroupId,
				name:cur.Groups[0].CharacterGroupName,
				sideId:curSide.CharacterGroupId,
				leaderId:null
				})}
			return res;
		},[]).map(el=>`(${el.id?el.id:'null'},${el.name?"'"+el.name+"'":'null'},${el.sideId?el.sideId:'null'},${el.leaderId?el.leaderId:'null'})`).join(',')
		
		let query = 
`declare @tab table (id int, name nvarchar(255),sideId int, leaderId int)

insert into @tab
values ${data}

SET IDENTITY_INSERT hermestv..squads ON;

MERGE dbo.squads as target
USING (select *from @tab) as source (id,name,sideId,leaderId)
on (target.id=source.id)
when matched then
	update set name=source.name,sideId=source.sideId,leaderId=source.leaderId

when not matched then
	insert (id,name,sideId,leaderId)
	values(source.id,source.name,source.sideId,source.leaderId);`
		
		await sql.connect(sqlConfig);
	try{
	const result = await sql.query(query);
	//console.log(result);
	}catch(e){console.log(e.message)}


	sql.close();
		
		res.send(); 
		return;
	  };
}