var tiny = require('../tiny');

exports.start = function() {
};
tiny.init("pvp_day");            // 本文件名
tiny.start("9999");              // ID

var pvp = require("../module/pvp/pvp_imp");

var areas = [1];

var forFightPvpDay = function(i, areas, callback) {
	if (i >= areas.length) {
		callback(null);
	} else {
		tiny.log.debug("forFightPvpDay round", i);
		pvp.test.fightPvpDay(areas[i], function(err) {
			if (err) {
				callback(err);
			} else {
				i++;
				forFightPvpDay(i, areas, callback);
			}
		});
	}
};

exports.run = function() {
	var i = 0;
	tiny.log.debug("pvp_day start");
	// 开始战斗
	forFightPvpDay(i, areas, function(err) {
		if (err) {
			tiny.log.error("forFightPvpDay", err);
		}
	});
};

// 到达某一时间点统一发奖
//
//
//
exports.run();
