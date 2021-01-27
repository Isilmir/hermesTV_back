const jwt = require('jsonwebtoken');

module.exports = function (conf) {
      return async function (req,res,next){
		if(req.headers['authorization']){
			const token = req.headers['authorization'].split(' ')[1]
			let data;
			try{
				data = await jwt.verify(req.headers['authorization'].split(' ')[1],'password');
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