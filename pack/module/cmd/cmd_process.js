var zmq = require('zmq');
var heapdump = require('heapdump');
var tiny = require('../../tiny');

var commandConfig = require('../../schema/command.json');
var report, cmd;

function OnCmd(data) {
	var commander, re, i, killtimer;
	commander = data.toString();
	commander = commander.split(' ');
	tiny.log.info(commander);
	if (commander[0] === 'list') {
		re = {};
		re.serverid = tiny.id;
		re.serverType = tiny.type;
		re.pid = process.pid;
		re.rss = (process.memoryUsage().rss / (1024 * 1024)).toFixed(2);
		re.heapTotal = (process.memoryUsage().heapTotal / (1024 * 1024)).toFixed(2);
		re.heapUsed = (process.memoryUsage().heapUsed / (1024 * 1024)).toFixed(2);
		re.uptime = (process.uptime() / 60).toFixed(2);
		report.send(JSON.stringify(re));
	} else if (commander[0] === 'stop') {
		if (commander.length === 1) {
			killtimer = setTimeout(function() {
				process.exit(0);
			}, 5000);

			killtimer.unref();
			tiny.stop();
		} else {
			for (i = 1; i < commander.length; ++i) {
				if (commander[i] === tiny.id) {
					killtimer = setTimeout(function() {
						process.exit(0);
					}, 5000);

					killtimer.unref();
					tiny.stop();
				}
			}
		}
	} else if (commander[0] === 'heapdump') {
		heapdump.writeSnapshot('dump/' + Date.now() + '-' + tiny.id  + '.heapsnapshot');
	}
}

exports.stop = function() {
	cmd.close();
	report.close();
	// tiny.log.info('|cmd stop|');
};

exports.start = function() {
	report = zmq.socket('pub');
	report.connect("tcp://" + commandConfig.routeSub.host + ":" + commandConfig.routeSub.port);

	cmd = zmq.socket('sub');
	cmd.subscribe('');
	cmd.connect("tcp://" + commandConfig.routePub.host + ":" + commandConfig.routePub.port);
	cmd.on('message', OnCmd);
};


