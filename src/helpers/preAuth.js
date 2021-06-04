const jwt = require('jsonwebtoken');
const fs = require('fs');

module.exports = function (conf) {
      return async function (req,res,next){
		  let cert = fs.readFileSync('./src/rsa/publickey.pem');
		  //console.log(req.headers);
		if(req.headers['authorization']){
			const token = req.headers['authorization'].split(' ')[1]
			let data;
			try{
				data = await jwt.verify(req.headers['authorization'].split(' ')[1],cert,{ algorithms: ['RS256'] }/*'password'*/);
			}catch(e){
				res.status(403);
				res.send('Ошибка авторизации'); 
				return;
			}
			const user = data.user;
			console.log('юзер преавторизован - ',user);
			req.user=user;
			next();
		}else{
			next();
		}
};
}