var tiny = require('../tiny');

exports.start = function() {
};

tiny.init("init_data");            // 本文件名
tiny.start("9998");                // ID

var dataProcess = require("../module/dataprocess/pvp_handle");
var Robot = require("../module/robot/robot");
var areas = [1,2,3];

var cb = function(err, pvpDay) {
	if (err) {
		tiny.log.error("init_data pvpDay", err);
	} else {
		tiny.log.info("init_data pvpDay", JSON.stringify(pvpDay));
	}
};

exports.run = function() {
	var i = 0;
	tiny.log.debug("init_data start");
	// 初始化pvpWeek
	dataProcess.createPvpWeek(function(err, pvpWeek){
		if (err) {
			tiny.log.error("init_data pvpWeek error", err);
		} else {
			tiny.log.info("init_data pvpWeek success", JSON.stringify(pvpWeek));
		}
	});
	// 初始化globalInfo
	dataProcess.createGlobalInfo(areas, function(err, globalInfo){
		if (err) {
			tiny.log.error("init_data globalInfo error", err);
		}
		tiny.log.info("init_data globalInfo success", JSON.stringify(globalInfo));
	});
	// 初始化pvpDay
	for (i = 0; i < areas.length; i++) {
		tiny.log.debug("createPvpDay", areas[i]);
		dataProcess.createPvpDay(areas[i], cb);
	}
	// 打印机器人信息
	Robot.displayRobot();

	return;
};

exports.run();
