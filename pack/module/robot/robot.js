var heroHandle =   require('../dataprocess/hero_handle');
var playerHandle = require('../dataprocess/player_handle');
var equipHandle =  require('../dataprocess/equip_handle');
var tiny = require('../../tiny');
var utils = require('../utils');

var convertRobotHeroInfo = function(RobotHero) {
	var robotHeroList = {}, i;
	for (i in RobotHero) {
		if (RobotHero.hasOwnProperty(i)) {
			robotHeroList[i] = heroHandle.createHero(RobotHero[i].HeroId);
			robotHeroList[i].level = RobotHero[i].Level;
			robotHeroList[i].star = RobotHero[i].Star;
			robotHeroList[i].quality = RobotHero[i].Quality;
			robotHeroList[i].skillSlotList = {
				1 : {skillId : 0, level : RobotHero[i].SkillLv[1]},
				2 : {skillId : 0, level : RobotHero[i].SkillLv[2]},
				3 : {skillId : 0, level : RobotHero[i].SkillLv[3]},
				4 : {skillId : 0, level : RobotHero[i].SkillLv[4]},
				5 : {skillId : 0, level : RobotHero[i].SkillLv[5]},
				6 : {skillId : 0, level : RobotHero[i].SkillLv[6]}
			};
		}
	}
	return robotHeroList;
};

var convertRobotEquip = function(RobotEquip) {
	var robotEquipList = {}, i, tmp;
	for (i in RobotEquip) {
		if (RobotEquip.hasOwnProperty(i)) {
			//tiny.log.error("......heroHandle", JSON.stringify(heroHandle.createHero(10012)));
			tmp = equipHandle.createEquip(RobotEquip[i].EquipId);
			//tiny.log.debug("createEquip", JSON.stringify(tmp));
			robotEquipList[i] = tmp.equipInfo;
			//robotEquipList[i] = {};
			//robotEquipList[i].star = RobotEquip[i].Star;
			if (RobotEquip[i].HP) {
				robotEquipList[i].a1 = 5;
				if (RobotEquip[i].HP[1] < RobotEquip[i].HP[2]) {
					robotEquipList[i].n1 = utils.randomInt(RobotEquip[i].HP[1], RobotEquip[i].HP[2]);
				} else {
					robotEquipList[i].n1 = utils.randomInt(RobotEquip[i].HP[2], RobotEquip[i].HP[1]);
				}
			}
			if (RobotEquip[i].ATK) {
				robotEquipList[i].a2 = 6;
				if (RobotEquip[i].ATK[1] < RobotEquip[i].ATK[2]) {
					robotEquipList[i].n2 = utils.randomInt(RobotEquip[i].ATK[1], RobotEquip[i].ATK[2]);
				} else {
					robotEquipList[i].n2 = utils.randomInt(RobotEquip[i].ATK[2], RobotEquip[i].ATK[1]);
				}
			}
			if (RobotEquip[i].DEF) {
				robotEquipList[i].a3 = 7;
				if (RobotEquip[i].DEF[1] < RobotEquip[i].DEF[2]) {
					robotEquipList[i].n3 = utils.randomInt(RobotEquip[i].DEF[1], RobotEquip[i].DEF[2]);
				} else {
					robotEquipList[i].n3 = utils.randomInt(RobotEquip[i].DEF[2], RobotEquip[i].DEF[1]);
				}
			}
		}
	}
	return robotEquipList;
};

var convertRobot = function(Robot) {
	var robotInfo = [], i, tmpRobot, RobotHero, RobotEquip;
	RobotEquip = convertRobotEquip(require('../config/pvp/RobotEquip'));
	RobotHero = convertRobotHeroInfo(require('../config/pvp/RobotHero'));
	for (i in Robot) {
		if (Robot.hasOwnProperty(i)) {
			tmpRobot = playerHandle.createRobotBaseInfo(i, 0, "");
			tmpRobot.teamList = {
				1 :  RobotHero[Robot[i].Hero1],
				2 :  RobotHero[Robot[i].Hero2],
				3 :  RobotHero[Robot[i].Hero3],
			};
			tmpRobot.teamList[1].pos = 4;
			tmpRobot.teamList[2].pos = 5;
			tmpRobot.teamList[3].pos = 6;
			tmpRobot.equipList = {
				1 : {
					1 : RobotEquip[Robot[i].Equip1],
				},
				2 : {
					1 : RobotEquip[Robot[i].Equip2],
				},
				3 : {
					1 : RobotEquip[Robot[i].Equip3],
				},
			};
			tmpRobot.level = Robot[i].TeamLv;
			tmpRobot.power = parseInt((heroHandle.getHeroPower(tmpRobot.teamList[1]) +
			heroHandle.getHeroPower(tmpRobot.teamList[2]) + heroHandle.getHeroPower(tmpRobot.teamList[3])) +
			equipHandle.getEquipPower(RobotEquip[Robot[i].Equip1]) + equipHandle.getEquipPower(RobotEquip[Robot[i].Equip2]) +
			equipHandle.getEquipPower(RobotEquip[Robot[i].Equip3]), 10);
			//tiny.log.debug("tmpRobot", JSON.stringify(tmpRobot));
			robotInfo.push(tmpRobot);
		}
	}
	return robotInfo;
};

var Robot;
var getRobot = function() {
	if (!Robot) {
		Robot = convertRobot(require('../config/pvp/Robot'));
	}
};

// 改变装备属性
var changeEquipPower = function(equip, n) {
	if (equip.a1 === 5) {
		equip.n1 += n;
		if (equip.n1 <= 0) {
			equip.n1 = 10;
		}
	}
	if (equip.a2 === 6) {
		equip.n2 += n;
		if (equip.n2 <= 0) {
			equip.n2 = 10;
		}
	}
	if (equip.a3 === 7) {
		equip.n3 += n;
		if (equip.n3 <= 0) {
			equip.n3 = 10;
		}
	}
};

var changeEquipListPower = function(equipList, n) {
	var i, p = parseInt(n / 5, 10);
	for (i in equipList) {
		if (equipList.hasOwnProperty(i)) {
			changeEquipPower(equipList[i][1], p);
		}
	}
};

exports.getRobotInfoByPower = function(id) {
	var i, minId = 0, minPower = 99999999, tmp = 0, robot;
	getRobot();
	for (i in Robot) {
		if (Robot.hasOwnProperty(i)) {
			tmp = Robot[i].power - id;
			if (tmp < 0 && minPower < 0) {
				if (tmp > minPower) {
					minPower = tmp;
					minId = i;
				}
			} else {
				if (tmp < minPower) {
					minPower = tmp;
					minId = i;
				}
			}
		}
	}
	/*
	if (rand.length !== 0) {
		r = utils.randomArray(rand);
	} else {
		r = utils.randomArray(Robot);
		tiny.log.error("Robot getRobotInfoByPower error", id);//, JSON.stringify(r));
	}
	*/
	robot = Robot[minId];
	tiny.log.debug("Robot getRobotInfoByPower ", robot.power, id, minPower, -minPower);//, JSON.stringify(r));
	minPower = -minPower;
	if (minPower > 0) {
		// 增加偏移值
		minPower = utils.randomInt(0, minPower);
		tiny.log.debug("Robot getRobotInfoByPower R", id, minPower);
		changeEquipListPower(robot.equipList, minPower);
	} else {
		// 减少偏移值
		minPower = utils.randomInt(minPower, 0);
		tiny.log.debug("Robot getRobotInfoByPower R", id, minPower);
		changeEquipListPower(robot.equipList, minPower);
	}
	// 重新计算战斗力
	robot.power = parseInt((heroHandle.getHeroPower(robot.teamList[1]) +
			heroHandle.getHeroPower(robot.teamList[2]) + heroHandle.getHeroPower(robot.teamList[3])) +
			equipHandle.getEquipPower(robot.equipList[1][1]) + equipHandle.getEquipPower(robot.equipList[2][1]) +
			equipHandle.getEquipPower(robot.equipList[3][1]), 10);
	//返回
	return robot;
};

exports.getRobotPlayerInfo = function(ua) {
	getRobot();
	var i = ua.uuid % Robot.length, tmpRobot;
	if (ua.id !== undefined) {
		tmpRobot = exports.getRobotInfoByPower(ua.id);
	} else {
		if (!Robot.hasOwnProperty(i)) {
			tiny.log.error("Robot getPlayerInfo error", ua.uuid);
			tmpRobot = utils.randomArray(Robot);
		} else {
			tmpRobot = Robot[i];
		}
	}
	tmpRobot.uuid = ua.uuid;
	tmpRobot.area = ua.area;
	return tmpRobot;
};

exports.getPvpDayReward = function(pos, num) {
	getRobot();
	return { diamand : 100, ticketWeek : 100 };
};

exports.checkIsRobot = function(uuid) {
	//getRobot();
	if (uuid < 200) {
		return true;
	}
	return false;
};

exports.displayRobot = function() {
	var i;
	getRobot();
	for (i = 0; i < Robot.length; i++) {
		tiny.log.debug("Robot", i, JSON.stringify(Robot[i]));
	}
};
