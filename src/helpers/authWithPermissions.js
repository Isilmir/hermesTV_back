const jwt = require('jsonwebtoken');
const fs = require('fs');

module.exports = function (conf,permissions) {
      return async function (req,res,next){
		  //console.log(req.headers);
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
			const user = data.user;
			const userPermissions = data.permissions;
			const isAdmin = data.isAdmin;
			
			//console.log('method permissions: ',permissions)
			
			//console.log('user permissions: ',userPermissions)
			
			//console.log('isAdmin: ',isAdmin)
			
			let permission = permissions.filter(methodPermission=>{
														//console.log('methodPermission - ',methodPermission)
														return userPermissions.filter(userPermission=>{
																				//console.log('userPermission - ',userPermission,userPermission==methodPermission)
																				return userPermission==methodPermission||userPermission=='admin';
																				}
																				).length>0;
														}
														).length>0;
			
			//console.log('permission: ',permission)
			
			//console.log('юзер авторизован - ',user);
			
			if(permission||isAdmin){
				if(isAdmin) {
					console.log('юзер является админом');
				}
				console.log('юзер авторизован с разрешениями - ',user);
				req.user=user;
				next();
			}else{
				console.log('у юзера нет нужных разрешений');
				res.status(403);
				res.send('У пользователя нет нужных разрешений'); 
				return;
			}
		}else{
			console.log('не смогли авторизоваться');
			res.status(403);
			res.send('Ошибка авторизации'); 
			return;
		}
};
}