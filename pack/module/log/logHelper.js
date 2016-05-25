var fs = require("fs");
var path = require("path");
var log4js = require('log4js');

var svrConfig = require('../../tiny.json').apps;

var Helper = function(id, type) {
	var appenders = [], tmpAppend = {}, logConfig = {}, absPath;
	tmpAppend.type = "console"; // ???console?log
	appenders.push(tmpAppend);

	absPath = path.resolve(process.cwd(), "log/", type);
	if (!fs.existsSync(absPath)) {
		fs.mkdirSync(absPath);
	}

	tmpAppend = {};
	tmpAppend.type = "dateFile";
	tmpAppend.pattern = "-yyyyMMdd.log";
	tmpAppend.category = id;
	tmpAppend.alwaysIncludePattern = true;
	tmpAppend.filename = 'log/' + type + '/' + id;
	appenders.push(tmpAppend);

	tmpAppend = {};
	tmpAppend.type = "file";
	tmpAppend.category = id + '-roll';
	tmpAppend.filename = 'log/' + type + '/' + id + "-roll.log";
	tmpAppend.maxLogSize = 1024 * 1000 * 1000;
	appenders.push(tmpAppend);

	logConfig.appenders = appenders;
	logConfig.replaceConsole = true;
	log4js.configure(logConfig);

	this.logger = log4js.getLogger(id);
	this.roll = log4js.getLogger(id + '-roll');
	this.id = id;
};

module.exports = Helper;

Helper.prototype.display = function(co) {
	var str = "", tmp, e;
	for (e in co) {
		if (co.hasOwnProperty(e)) {
			tmp = "";
			if (typeof co[e] === "object" ) {
				tmp = "{" + e.toString() + ":{ " + this.display(co[e]) + " }}";
			} else {
				tmp = "{" + e.toString() + ":" + co[e] + "}";
			}
			str += tmp;
			str += "|";
		}
	}
	return str;
};

Helper.prototype.trace = function() {
	// if (arguments === null)  {
	// 	msg = "";
	// }
	this.roll.trace("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//console.log("|" + this.id + msg);
};

Helper.prototype.debug = function() {
	// if (msg === null)  {
	// 	msg = "";
	// }
	this.roll.debug("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//console.log("|" + this.id + msg);
};

Helper.prototype.info = function() {
	// if (msg === null)  {
	// 	msg = "";
	// }
	this.logger.info("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//this.roll.info("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//console.log("|" + this.id + msg);
};

Helper.prototype.warn = function() {
	// if (msg === null)  {
	// 	msg = "";
	// }
	this.logger.warn("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	this.roll.warn("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//console.log("|" + this.id + msg);
};

Helper.prototype.error = function() {
	// if (msg === null)  {
	// 	msg = "";
	// }
	this.logger.error("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//this.roll.error("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//console.log("|" + this.id + msg);
};

Helper.prototype.fatal = function() {
	// if (msg === null)  {
	// 	msg = "";
	// }
	this.logger.fatal("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	this.roll.fatal("|" + this.id + "|" + Array.prototype.join.call(arguments, '|'));
	//console.log("|" + this.id + msg);
};

