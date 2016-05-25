var tiny = require('../tiny');

exports.start = function() {
};
tiny.init("pvp_day_reward");            // 本文件名
tiny.start("9997");                     // ID

var pvp = require("../module/pvp/pvp_imp");

var areas = [1];

var forFightPvpDayReward = function(i, areas, callback) {
	if (i >= areas.length) {
		callback(null);
	} else {
		tiny.log.debug("forFightPvpDayReward round", i);
		pvp.test.fightPvpDayReward(areas[i], function(err) {
			if (err) {
				callback(err);
			} else {
				i++;
				forFightPvpDayReward(i, areas, callback);
			}
		});
	}
};

exports.run = function() {
	var i = 0;
	tiny.log.debug("pvp_day start");
	// 开始战斗
	forFightPvpDayReward(i, areas, function(err) {
		if (err) {
			tiny.log.error("forFightPvpDayReward", err);
		}
	});
};

