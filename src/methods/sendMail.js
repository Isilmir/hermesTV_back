const fetch = require('node-fetch');
const fs = require('fs');
const url = require('url');
const jwt = require('jsonwebtoken');
const sql = require('mssql');
const nodemailer = require('nodemailer');
//const formidable = require('formidable');

module.exports = function (conf) {
      return async function (req,res){ 
		
		//console.dir(req.headers);
		//console.log(req.body);
		//console.log(req.files[0]);

		//console.log(req.form);
		
		//const form = formidable({ multiples: false });
		//
		//form.on('file',(name,file)=>{
		//	console.log(name);
		//	console.log(file.attach);
		//});
		//
		//form.parse(req, (err, fields, files) => {
		//	if (err) {
		//	  next(err);
		//	  return;
		//	}
		//	//res.json({ fields, files });
		//	console.log(fields);
		//	console.log(files.attach);
		//  });
		console.log('!!!!!!');
		let uri=`https://oauth2.googleapis.com/token`;
		let authData;
		let token;
		try{
			authData = await (await fetch(uri,{
				method:'POST',
				body:`grant_type=refresh_token&client_id=944637236789-ed6mmeod4psnmf2j9c27ltu858uoukns.apps.googleusercontent.com&client_secret=9eyEoMlNKP-pSpn5b5ZFUAkO&access_type=offline&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&refresh_token=1%2F%2F0cfP3auLOtS5cCgYIARAAGAwSNwF-L9IrZToA3MKI90rLvXO26LXpDVR5M5z_zvot3rjdfpXPnMpBUiF126aDq8_N_jf52KGffWg`,
				headers:{
				'Content-Type':'application/x-www-form-urlencoded'
				}
				}) ).json();
		}catch(e){
			res.status(500);
			res.send(e);
			return;
		}
		console.log(authData);
		token=authData.access_token;
		//console.log(token);

		let transporter = nodemailer.createTransport({
		  service: 'gmail',
		//  auth: {
		//	user: 'hermes.tv.troy@gmail.com',
		//	pass: '!Q2w3e4r'
		//  }
		  auth:{
			    type: 'OAuth2',
				user: 'hermes.tv.troy@gmail.com',
				accessToken: token
		  }
		});

		let mailOptions = {
		  from: 'hermes.tv.troy@gmail.com',
		  to: 'hermes.tv.troy@gmail.com',
		  subject: `${req.body.userId} ${req.body.userName}`,
		  text: `Печатная форма для персонажа ${req.body.userName}`,
		  attachments:[
				{filename:`${req.body.userId}_${req.body.userName}.pdf`,content:req.files[0].buffer}
			]
		};

		transporter.sendMail(mailOptions, function(error, info){
		  if (error) {
			//console.log(error);
			res.status(500);
			res.send(error);
		  } else {
			//console.log('Email sent: ' + info.response);
			res.send('Email sent: ' + info.response);
		  }
		}); 

		return;
		
	  };
}