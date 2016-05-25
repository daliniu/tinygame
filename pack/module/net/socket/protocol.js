var rpc = require('../mdp/remote_proxy');
var Parse = require('./parse');
var tiny = require('../../../tiny');

module.exports.process = function(sessionid, data) {
	var msg = {};
	if (data && data.hasOwnProperty("serverName")) {
		msg.funcName = data.funcName;
		msg.inArgs = data.args;
		msg.callbackFunc = "clientResponse";
		msg.current = {};
		msg.current.sessionId = sessionid;
		msg.current.funcName = data.funcName;
		msg.current.serverName = data.serverName;
		msg.current.funcId = data.funcId;
		msg.current.clientCallFunc = data.funcName;

		tiny.log.trace("..................NewProcess............", data.funcId);
		// server相同不需要远程调用直接给本server处理
		if (data.serverName === tiny.type) {
			// tiny.log.debug("processMsg.tcp.local", JSON.stringify(msg));
			msg.current.clientRequest = true;
			rpc.processClient(msg);
		} else {
			 //tiny.log.debug("processMsg.tcp.other", JSON.stringify(msg));
			rpc.processClientToOtherServer(data.serverName, msg);
		}
	}
};
