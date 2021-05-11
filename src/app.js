const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');
const sql = require('mssql');
const fs = require('fs');
const http = require('http');
const https = require('https');
const { Client } = require('pg');
const jwt = require('jsonwebtoken');
const multer  = require('multer');
let upload = multer({ storage: multer.memoryStorage() });

const joinrpgTest = require('./methods/joinrpgTest.js');
const joinrpgSetSides = require('./methods/joinrpgSetSides.js');
const joinrpgSetSquads = require('./methods/joinrpgSetSquads.js');
const joinrpgSetPlayers = require('./methods/joinrpgSetPlayers.js');
const login = require('./methods/login.js');
const sendMail = require('./methods/sendMail.js');
const auth = require('./helpers/auth.js');
const adminAuth = require('./helpers/adminAuth.js');
const setOrUpdateBjzi = require('./methods/setOrUpdateBjzi.js');
const setOrUpdateDeed = require('./methods/setOrUpdateDeed.js');
const setDeed_mass = require('./methods/setDeed_mass.js');
const setOrUpdateDeedType = require('./methods/setOrUpdateDeedType.js');
const getBjzi = require('./methods/getBjzi.js');
const setOrUpdateStory = require('./methods/setOrUpdateStory.js');
const setOrUpdateLink = require('./methods/setOrUpdateLink.js');
const deleteLink = require('./methods/deleteLink.js');
const deleteDeed = require('./methods/deleteDeed.js');
const deleteDeedType = require('./methods/deleteDeedType.js');
const getStories = require('./methods/getStories.js');
const getPlayers = require('./methods/getPlayers.js');
const getPlayer = require('./methods/getPlayer.js');
const getPlayers_honor = require('./methods/getPlayers_honor.js');
const getGraph = require('./methods/getGraph.js');
const getDeedTypes = require('./methods/getDeedTypes.js');
const getDictionaries = require('./methods/getDictionaries.js');
const objectActivation = require('./methods/objectActivation.js');
const isAdmin = require('./methods/isAdmin.js');
const faces = require('./methods/faces.js');
const getFace = require('./methods/getFace.js');
const getLastUpdate = require('./methods/getLastUpdate.js');
const getBjziSingle = require('./methods/getBjziSingle.js');
const makeFuneral = require('./methods/makeFuneral.js');
const makeBjziTransfer = require('./methods/makeBjziTransfer.js');

const charactersFull_cache = require('../cache/charactersFull_cache.json')

const privateKey  = fs.readFileSync('src/sslcert/35442480_localhost.key', 'utf8');
const certificate = fs.readFileSync('src/sslcert/35442480_localhost.cert', 'utf8');
const credentials = {key: privateKey, cert: certificate};

const app = express();
const router = express.Router();
const joinrpgRouter = express.Router();

app.use(morgan('combined'));
app.use(bodyParser.json());
app.use(cors());

//const httpServer = http.createServer(app);
const httpsServer = https.createServer(credentials, app);

const azureConnect=process.env.AzurConnect.split(';')
const sqlConfig={
	  user: azureConnect[0],//'admin',
		password: azureConnect[1],//'12345',
		server: azureConnect[2],//'localhost\\ILION', // You can use 'localhost\\instance' to connect to named instance
		database: azureConnect[3]
	}; 

const PORT = process.env.PORT || 5000	
	
//console.log(`Server started on port ${process.env.PORT || 8081}`);

router.use(auth());

joinrpgRouter.use(adminAuth());

router.get('/',(req,res)=>{
	res.send(`<h1>API Гермес-ТВ</h1>
	<div>Если вы сюда попали, то знаете, что нужно делать;)</div>`);
})

router.get('/pg/get-objects',(req,res)=>{
	const client = new Client({
	  connectionString: process.env.DATABASE_URL,
	  ssl: {
		rejectUnauthorized: false
	  }
	});
	client.connect();
	client.query('SELECT qr,active FROM hermestv.objects order by typeId,id;', (err, result) => {
	  if (err) throw err;
	  res.send(result.rows);
	  client.end();
	});
})

router.get('/test',async (req,res)=>{
	
	await sql.connect(sqlConfig);
	
	const result = await sql.query(`select qr,active from objects`);

	sql.on('error',err=>console.log(err));
	sql.close();
	res.send(result.recordsets[0]);
})

router.get('/testAzure',async (req,res)=>{
	
	await sql.connect(sqlConfig);
	
	const result = await sql.query(`select * from objectTypes`);

	sql.on('error',err=>console.log(err));
	sql.close();
	res.send(result.recordsets[0]);
})

router.post('/test-action',async (req,res)=>{
	
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

router.post('/pg/activation',async (req,res)=>{
	console.dir(req.body);
	const client = new Client({
	  connectionString: process.env.DATABASE_URL,
	  ssl: {
		rejectUnauthorized: false
	  }
	});
	let query =`UPDATE hermestv.objects o set active=${req.body.activationToggle?'TRUE':'FALSE'} from hermestv.objectTypes ot where ot.id=o.typeId and o.id=${req.body.id} and ot.name='${req.body.objectType}';`
	console.log(query); 
	client.connect();
	client.query(query, (err, result) => {
	  if (err) throw err;
	  res.send(`${req.body.activationToggle?'активировали':'деактивировали'} объект с типом ${req.body.objectType} и id ${req.body.id}`);
	  client.end();
	});
})

// Для обновления БД игроков:
// 1. Вызвать /joinrpg/getPlayers. Закэшируется файл charactersFull_cache.
// 2. Вызвать /joinrpg/setSides. Обновятся стороны конфликта.
// 3. Вызвать /joinrpg/setSquads. Обновыятся отряды.
// 4. Вызвать /joinrpg/setPlayers. Обновится основная таблица игроков.

//http://192.168.0.181:5000/joinrpg/getPlayers?since=2017-01-01
joinrpgRouter.get('/getPlayers',joinrpgTest({sqlConfig:sqlConfig}));

joinrpgRouter.get('/setSides',joinrpgSetSides({sqlConfig:sqlConfig,
											getCurSide:getCurSide,
											charactersFull_cache:charactersFull_cache
											}));
joinrpgRouter.get('/setSquads',joinrpgSetSquads({sqlConfig:sqlConfig,
											getCurSide:getCurSide,
											charactersFull_cache:charactersFull_cache
											}));	
joinrpgRouter.get('/setPlayers',joinrpgSetPlayers({sqlConfig:sqlConfig,
											getCurSide:getCurSide,
											charactersFull_cache:charactersFull_cache
											}));	
/////////////////////////////////////////////////////////////////////////////////////		

router.post('/sendMail'
,upload.array('attach')// название поля должно соответствовать названию в отправляемой форме
,sendMail());	

router.post('/setOrUpdateBjzi',setOrUpdateBjzi({sqlConfig:sqlConfig}));	
router.post('/setOrUpdateDeed',setOrUpdateDeed({sqlConfig:sqlConfig}));
router.post('/setDeed/mass',setDeed_mass({sqlConfig:sqlConfig}));
router.post('/deedTypes',setOrUpdateDeedType({sqlConfig:sqlConfig}));
router.get('/getBjzi',getBjzi({sqlConfig:sqlConfig}));	
router.post('/setOrUpdateStory',adminAuth(),setOrUpdateStory({sqlConfig:sqlConfig}));	
router.post('/setOrUpdateLink',adminAuth(),setOrUpdateLink({sqlConfig:sqlConfig}));
router.post('/deleteLink',adminAuth(),deleteLink({sqlConfig:sqlConfig}));
router.post('/deleteDeed',adminAuth(),deleteDeed({sqlConfig:sqlConfig}));
router.post('/processing/makeFuneral',adminAuth(),makeFuneral({sqlConfig:sqlConfig}));	
router.post('/processing/makeBjziTransfer',adminAuth(),makeBjziTransfer({sqlConfig:sqlConfig}));	
router.delete('/deedTypes',adminAuth(),deleteDeedType({sqlConfig:sqlConfig}));
router.get('/getStories',adminAuth(),getStories({sqlConfig:sqlConfig}));	
router.get('/getPlayers',adminAuth(),getPlayers({sqlConfig:sqlConfig}));
router.get('/players/:playerId',adminAuth(),getPlayer({sqlConfig:sqlConfig}));
router.get('/bjzi/:bjziId',adminAuth(),getBjziSingle({sqlConfig:sqlConfig}));
router.get('/getDeedTypes',adminAuth(),getDeedTypes({sqlConfig:sqlConfig}));
router.get('/faces',adminAuth(),faces());
router.get('/faces/:filename',adminAuth(),getFace());
app.post('/getDictionaries',getDictionaries({sqlConfig:sqlConfig}));
app.get('/getPlayers/honor',getPlayers_honor({sqlConfig:sqlConfig}));	
router.post('/getGraph',adminAuth(),getGraph({sqlConfig:sqlConfig}));
router.post('/objectActivation',adminAuth(),objectActivation({sqlConfig:sqlConfig}));
router.get('/getLastUpdate',adminAuth(),getLastUpdate({sqlConfig:sqlConfig}));
app.get('/isAdmin',isAdmin());

											
app.post('/login',login({sqlConfig:sqlConfig}));		

app.use('/',router);
router.use('/joinrpg',joinrpgRouter)

app.listen(PORT,()=>console.log(`Listening on port ${PORT}`))

//httpServer.listen(process.env.PORT || 8081);
//httpsServer.listen(PORT,()=>console.log(`Listening on port ${PORT}`));

//app.listen(process.env.PORT || 8081); 

function getCurSide(cur){
	return cur.allGroups.filter(el=>el.characterGroupId!=cur.groups[0].characterGroupId&&el.characterGroupId!=14905)[0]||cur.allGroups.filter(el=>el.characterGroupId!=14905)[0];
}
