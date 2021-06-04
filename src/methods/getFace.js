//const sql = require('mssql');
const url = require('url');
const fs = require('fs/promises');

module.exports = function (conf) {
      return async function (req,res){ 
	  console.log(req.params.filename);
	let sex = url.parse(req.url,true).query.sex;
	let file	
	try{
	file = await fs.readFile(`./src/faces/${sex}/${req.params.filename}`);
	//console.log(result);
	}catch(e){//console.warn('\x1b[31m%s\x1b[0m',e.message);
		res.status(404);
				res.send('Фото не найдено'); 
				return;
	}
	//console.log(file);

	//sql.close();
		
		res.send(file.toString('base64')); 
		return;
	  };
}