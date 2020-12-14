const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const sql = require('mssql');
const fs = require('fs');
const http = require('http');
const https = require('https');
const { Client } = require('pg');



const privateKey  = fs.readFileSync('src/sslcert/35442480_localhost.key', 'utf8');
const certificate = fs.readFileSync('src/sslcert/35442480_localhost.cert', 'utf8');
const credentials = {key: privateKey, cert: certificate};

const app = express();
app.use(morgan('combined'));
app.use(bodyParser.json());
app.use(cors());

//const httpServer = http.createServer(app);
const httpsServer = https.createServer(credentials, app);


const sqlConfig={
	  user: 'admin',
		password: '12345',
		server: 'localhost\\ILION', // You can use 'localhost\\instance' to connect to named instance
		database: 'HermesTV'
	}; 

const PORT = process.env.PORT || 5000	
	
//console.log(`Server started on port ${process.env.PORT || 8081}`);

app.get('/',(req,res)=>{
	res.send(`<h1>Гермес-ТВ</h1>
	<div>Cайт сейчас находится на реконструкции но мы надеемся уже к КОМКОНу удивить наших зрителей</div>
	<br>
	<div>${process.env.DATABASE_URL}</div>`);
})

app.get('/pg/get-objects',(req,res)=>{
	const client = new Client({
	  connectionString: process.env.DATABASE_URL,
	  ssl: {
		rejectUnauthorized: false
	  }
	});
	client.connect();
	client.query('SELECT qr,active FROM hermestv.objects;', (err, result) => {
	  if (err) throw err;
	  res.send(result.rows);
	  client.end();
	});
})

app.get('/test',async (req,res)=>{
	
	await sql.connect(sqlConfig);
	
	const result = await sql.query(`select qr from objects`);
	
	console.dir(result);
	//sql.connect(config).then(pool=>{
	//	return pool.request()
	//	.input('input_parameter', sql.Int, 5)
	//	.query('select top 2 @input_parameter,@input_parameter+1,* from policyregistry order by documentdate desc')
	//}).then(result=>{/*console.dir(result);*/return result;}).then((result)=>{
	//	res.send(
	//			[{
	//				title: "Sql Connection (from testdb5\stage)",
	//				description: result.recordset[0].ID+'|'+result.recordset[0].NUMBAR+'|'+result.recordset[0].InsuredName
	//			}]
	//			);
	//	sql.close();
	//}).catch(err=>console.log(err));

	sql.on('error',err=>console.log(err));
	sql.close();
	res.send(result.recordsets[0]);
})

app.post('/test-action',async (req,res)=>{
	
	await sql.connect(sqlConfig);
	
	let query =`update top(1) o
  set active=${+req.body.activationToggle}
    FROM [HermesTV].[dbo].[objects] o
  join objectTypes ot on ot.id=o.typeId
  where o.id=${req.body.id}
  and ot.name='${req.body.objectType}'`
	console.log(query);
	const result = await sql.query(query);
	
	res.send(`${req.body.activationToggle?'активировали':'деактивировали'} объект с типом ${req.body.objectType} и id ${req.body.id}`);
})

app.listen(PORT,()=>console.log(`Listening on port ${PORT}`))

//httpServer.listen(process.env.PORT || 8081);
//httpsServer.listen(PORT,()=>console.log(`Listening on port ${PORT}`));

//app.listen(process.env.PORT || 8081); 