var pm2 = require('pm2');
var http = require('http');
var exec = require('child_process').exec;
var crypto = require('crypto');
var rpc = require('../module/net/mdp/remote_proxy');
var tiny = require('../tiny');
var mail = require('../module/mail/mail_imp');
var MailConst = require('../module/const').MAIL;
var mailHandle = require('../module/dataprocess/mail_handle');

function aesDecrypt(str) {
	var jsonStr,
	AES_DECIPHER = crypto.createDecipheriv('aes-192-ecb', tiny.aesKey, "");
	jsonStr = AES_DECIPHER.update(str, 'base64', 'utf8');
	jsonStr += AES_DECIPHER.final('utf8');
	return jsonStr;
}

function aesCrypt(msg) {
	var base64str,
	AES_CIPHER = crypto.createCipheriv('aes-192-ecb', tiny.aesKey, "");
	base64str = AES_CIPHER.update(msg, 'utf8', 'base64');
	base64str += AES_CIPHER.final('base64');
	return base64str;
}

function setupApp(env) {
	pm2.connect(function() {
		pm2.start({
			"name"        : env.id,
		    "script"      : "app.js",
		    "cwd"         : "/home/tinygame/server/tinygame",
		    "log_date_format"  : "YYYY-MM-DD HH:mm Z",
		    "watch"       : false,
		    "merge_logs"  : true,
		    "force"       : true,
		    "autorestart" : true,
		    "min_uptime"  : "5000",
		    "env": env
		}, function(err) {
			if (err) {
				tiny.log.error('启动新进程失败');
			} else {
				tiny.log.info('启动新进程成功');
			}

			pm2.disconnect();
		});
	});
}

function deleteApp(id) {
	if (id) {
		pm2.connect(function() {
			pm2.delete(id, function(err) {
				if (err) {
					tiny.log.error('删除进程失败');
				} else {
					tiny.log.info('删除进程成功');
				}

				pm2.disconnect();
			});
		});
	}
}

exports.start = function() {
	// 启动rpc连接
	rpc.start();

	// 开启http服务等待指令
	var server = http.createServer(function(req, rsp) {
		var postData = "";
		console.log('receive msg from: ', req.connection.remoteAddress, req.method);
		req.setEncoding('utf8');
		req.on('data', function(postDataChunk) {
			postData += postDataChunk;
		});
		req.on('end', function() {
			var op = req.url, msg, inArgs = {}, env = {};
			console.log(op, postData);
			if (op === '/mail') {
				msg = JSON.parse(aesDecrypt(postData));
				tiny.log.trace(msg, JSON.stringify(msg));
				inArgs.msg = msg;
				if (parseInt(msg.type, 10) === MailConst.TYPE_PERSON) {
					tiny.log.trace('!!!!!!!!!!!发送邮件');
					mail.sendPersonMail(inArgs);
				}
				if (parseInt(msg.type, 10) === MailConst.TYPE_GLOBAL) {
					mail.sendGlobalMail(inArgs);
				}
				rsp.writeHead(200, {
					"Content-Type": "application/json",
					"Access-Control-Allow-Origin": "*"
				});
				rsp.end();
			} else if (op === '/startSvr') {
				msg = JSON.parse(aesDecrypt(postData));
				tiny.log.trace(msg, JSON.stringify(msg));
				if (msg.op === "1") {
					if (msg.id && msg.type && msg.host) {
						env.type = msg.type;
						env.id = msg.id;
						env.host = msg.host;
						env.router = 3000;
						if (msg.type === 'gate') {
							env.clientPort = msg.clientPort;
							setupApp(env);
						}
						if (msg.type === 'conn') {
							env.clientPort = msg.clientPort;
							setupApp(env);
						}
						if (msg.type === 'loc') {
							setupApp(env);
						}
						if (msg.type === 'chat') {
							setupApp(env);
						}
					}
				}
				if (msg.op === "2") {
					deleteApp(msg.id);
				}
				rsp.writeHead(200, {
					"Content-Type": "application/json",
					"Access-Control-Allow-Origin": "*"
				});
				rsp.end();
			} else if (op === '/grepSvr') {
				pm2.connect(function() {
					pm2.list(function(err, list) {
						rsp.statusCode = 200;
						rsp.setHeader('Content-Type', "application/json");
						rsp.setHeader("Access-Control-Allow-Origin", "*");
						if (err) {
							tiny.log.error('获取进程信息失败');
						} else {
							tiny.log.info('获取进程信息成功', list);
							var cipher = aesCrypt(JSON.stringify(list));
							rsp.setHeader('Content-Length', Buffer.byteLength(cipher, 'utf8'));
							rsp.write(cipher);
						}
						rsp.end();
						pm2.disconnect();
					});
				});
			} else if (op === '/refreshConfig') {
				// console.log(1111111111111111111111122222222221);
				// exec('/home/tinygame/server/tinygame/updateConfig', function(err) {
				// 	if (err) {
				// 		tiny.log.error('更新配置表失败', err);
				// 	} else {
				// 		console.log(111111111111111111111111);
				// 		pm2.connect(function() {
				// 			pm2.restart('all', function(err) {
				// 				if (err) {
				// 					tiny.log.error('更新配置表重启服务器失败', err);
				// 				} else {
				// 					tiny.log.info('更新配置表重启服务器成功');
				// 				}
				// 			});
				// 		});
				// 	}
				// });
			} else {
				rsp.end();
			}
		});
	});

	server.listen(tiny.httpPort);

	tiny.log.debug("|start|" + tiny.host);
};

exports.stop = function() {
	rpc.stop();

	tiny.log.debug("|stop|");
};

