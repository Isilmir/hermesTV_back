const sql = require('mssql');

function getSideName(side){
	switch(side.CharacterGroupId){
		case 14906:
			return 'achaeans';
		break;
		case 14920:
			return 'troy';
		break;
		case 15680:
			return 'peacekeeping';
		break;
		case 16333:
			return 'olymp';
		break;
	}
}

module.exports = function (conf) {
      return async function (req,res){ 
		
		const sqlConfig = conf.sqlConfig;
		const getCurSide = conf.getCurSide;
		
		let data = conf.charactersFull_cache.reduce((res,cur)=>{
				let curSide = getCurSide(cur);
				if(res.filter(el=>el.id == curSide.CharacterGroupId).length==0){res.push({
					id:curSide.CharacterGroupId,
					name:getSideName(curSide),
					description:curSide.CharacterGroupName
					})}
				return res;
		},[]).map(el=>`(${el.id?el.id:'null'},${el.name?"'"+el.name+"'":'null'},${el.description?"'"+el.description+"'":'null'})`).join(',')
		
		let query = 
`declare @tab table (id int, name varchar(255),description varchar(255))

insert into @tab
values ${data}

SET IDENTITY_INSERT hermestv..sides ON;

MERGE dbo.sides as target
USING (select *from @tab) as source (id,name,description)
on (target.id=source.id)
when matched then
	update set name=source.name,description=source.description

when not matched then
	insert (id,name,description)
	values(source.id,source.name,source.description);`
		
		await sql.connect(sqlConfig);
	try{
	const result = await sql.query(query);
	//console.log(result);
	}catch(e){console.log(e.message)}

	sql.on('error',err=>console.log(err));
	sql.close();
		
		res.send(); 
		return;
	  };
}