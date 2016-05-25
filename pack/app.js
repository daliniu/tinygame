// var d = require('domain').create();
// d.on('error', function(err) {
// 	console.log('Domain Caught exception:');
// 	console.log(err);
// 	process.exit(0);
// });
var tiny = require('./tiny');
var memwatch = require('memwatch-next');
memwatch.on('leak', function(info) {
	console.error('Memory leak detected: ', info);
});
//memwatch.on('stats', function(info) {
//	console.info('Full gc: ', info);
//});
//setInterval(function() {
//	console.log('native: ', process.memoryUsage().heapUsed);
//}, 5000);

// var config = JSON.parse(process.env.serverConfig);

// d.run(function() {

tiny.init(process.env.type);

tiny.set('seq', process.env.id.split('-')[1]);
tiny.set('id', process.env.id);
tiny.set('type', process.env.type);
tiny.set('host', process.env.host);
tiny.set('router', process.env.router);

tiny.set('port', process.env.clientPort);

tiny.set('DEFAULT_CONN_SERVER', process.env.DEFAULT_CONN_SERVER);
tiny.set('DEFAULT_CONN_IP', process.env.DEFAULT_CONN_IP);
tiny.set('DEFAULT_CONN_PORT', process.env.DEFAULT_CONN_PORT);

tiny.set('httpPort', process.env.httpPort);
if (process.env.aesKey) {
	tiny.set('aesKey', process.env.aesKey.slice(0, 24));
}

// tiny.configure('gate|conn|loc|route|chat|gm|pvp', function() {
// 	tiny.set('seq', process.env.id.split('-')[1]);
// 	tiny.set('id', process.env.id);
// 	tiny.set('type', process.env.type);
// 	tiny.set('host', process.env.host);
// 	tiny.set('router', process.env.router);
// });

// tiny.configure('gate|conn', function() {
// 	tiny.set('port', process.env.clientPort);
// });

// tiny.configure('gate', function() {
// 	tiny.set('DEFAULT_CONN_SERVER', process.env.DEFAULT_CONN_SERVER);
// 	tiny.set('DEFAULT_CONN_IP', process.env.DEFAULT_CONN_IP);
// 	tiny.set('DEFAULT_CONN_PORT', process.env.DEFAULT_CONN_PORT);
// });

// tiny.configure('gm', function() {
// 	tiny.set('httpPort', process.env.httpPort);
// 	tiny.set('aesKey', process.env.aesKey.slice(0, 24));
// });


tiny.start(process.env.id);

// });



process.on('uncaughtException', function(err) {
	try {
		var killtimer = setTimeout(function() {
			process.exit(1);
		}, 5000);

		killtimer.unref();

		console.error('uncaughtException Caught exception: ' + err.stack);

		tiny.stop();

	} catch(e) {
		console.error('Death Error!', e.stack);
	}
});

// process.on('SIGINT', function() {
// 	tiny.stop();
// });

