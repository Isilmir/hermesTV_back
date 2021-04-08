//const sql = require('mssql');
//const url = require('url');
const fs = require('fs/promises');

module.exports = function (conf) {
      return async function (req,res){ 
	let files_male;
	let files_female;
	let files={};	
	try{
	files_male = await fs.readdir('./src/faces/male');
	//console.log(result);
	}catch(e){console.warn('\x1b[31m%s\x1b[0m',e.message)}

	try{
	files_female = await fs.readdir('./src/faces/female');
	//console.log(result);
	}catch(e){console.warn('\x1b[31m%s\x1b[0m',e.message)}

	files.male=files_male;
	files.female=files_female;


	//sql.close();
		
		res.send(files); 
		return;
	  };
}