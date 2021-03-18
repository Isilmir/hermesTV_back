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

		let transporter = nodemailer.createTransport({
		  service: 'gmail',
		  auth: {
			user: 'hermes.tv.troy@gmail.com',
			pass: '!Q2w3e4r'
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