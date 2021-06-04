const jwt = require('jsonwebtoken');
const fs = require('fs');

module.exports = function (conf) {
      return async function (req,res,next){
		let cert = fs.readFileSync('./src/rsa/publickey.pem');
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
			
			const isAdmin = data.isAdmin;
			if(isAdmin) {
				console.log('юзер является админом');
				next();
			}else{
				console.log('пользователь не админ');
				res.status(403);
				res.send('Доступ разрешен только для администратора');
			}
		}else{
			console.log('не смогли авторизоваться');
			res.status(403);
			res.send('Ошибка авторизации'); 
			return;
		}
};
}