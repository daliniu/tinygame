var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var utils = require('../utils');
var pvpHandle = require('../dataprocess/pvp_handle');
var playerHandle = require('../dataprocess/player_handle');
var heroHandle = require('../dataprocess/hero_handle');
var agentHandle = require('../dataprocess/agent_handle');
var Fight = require('../fight/fight');
var Robot = require('../robot/robot');
var SportsChest = require('../config/pvp/SportsChest');
var item = require('../item/item');

var getReadPvpInfo = function(dataValue) {
	var pvpInfo = {};
	pvpInfo.ticketN = dataValue.pvpInfo.ticketN;
 	pvpInfo.ticketDay = dataValue.pvpInfo.ticketDay;
	pvpInfo.ticketWeek = dataValue.pvpInfo.ticketWeek;
	pvpInfo.fightCount = dataValue.pvpInfo.fightCount;
	pvpInfo.startMark = dataValue.pvpInfo.startMark;
	pvpInfo.box1 = dataValue.pvpInfo.box1;
	pvpInfo.box2 = dataValue.pvpInfo.box2;
	pvpInfo.box3 = dataValue.pvpInfo.box3;
	pvpInfo.myTime = dataValue.pvpInfo.myTime;
	pvpInfo.refreshTime = dataValue.pvpInfo.refreshTime;
	pvpInfo.dayMark = dataValue.pvpInfo.dayMark;
	pvpInfo.weekMark = dataValue.pvpInfo.weekMark;
	pvpInfo.fightInfoListSng = [];
	pvpInfo.fightInfoListDay = [];
	pvpInfo.fightInfoListWeek = [];
	return pvpInfo;
};

var getReadPvpDay = function(dataValue) {
	var pvpDay = {};
	pvpDay.uuids = [];
 	pvpDay.area = dataValue.baseInfo.area;
	pvpDay.rewardPool = dataValue.globalInfo.pvpDay[dataValue.baseInfo.area].rewardPool;
 	pvpDay.nums = dataValue.globalInfo.pvpDay[dataValue.baseInfo.area].nums;
 	pvpDay.maxCount = dataValue.globalInfo.pvpDay[dataValue.baseInfo.area].maxCount;
 	pvpDay.updateTime = dataValue.globalInfo.pvpDay[dataValue.baseInfo.area].updateTime;
 	pvpDay.pvpF8Result = {
 		playerInfoList : [],
 		fightList8     : [],
 		fightList4     : [],
 		fightList2     : [],
 		fightList1     : [],
 	};
 	pvpDay.finalSort = [];
	return pvpDay;
};

var getReadPvpWeek = function(dataValue) {
	var pvpWeek = {};
	pvpWeek.userArea = [];
	pvpWeek.rewardPool = dataValue.globalInfo.pvpWeek.rewardPool;
 	pvpWeek.nums = dataValue.globalInfo.pvpWeek.nums;
 	pvpWeek.maxCount = dataValue.globalInfo.pvpWeek.maxCount;
 	pvpWeek.pvpF8Result = {
 		playerInfoList : [],
 		fightList8     : [],
 		fightList4     : [],
 		fightList2     : [],
 		fightList1     : [],
 	};
 	pvpWeek.finalSort = [];
	return pvpWeek;
};

var getReadFightReward = function() {
	var fightReward = {};
	fightReward.diamand = 0;
	fightReward.ticketN = 0;
	fightReward.ticketDay = 0;
	fightReward.ticketWeek = 0;
	fightReward.bagItem = { itemList : {}, equipList : {} };
	return fightReward;
};

var getReadMainList = function(dataValue) {
	var outArgs = {};
	outArgs.pvpInfo = getReadPvpInfo(dataValue);
	outArgs.pvpDay = getReadPvpDay(dataValue);
	outArgs.pvpWeek = getReadPvpWeek(dataValue);
	outArgs.curTime = utils.getDate();
	return outArgs;
};

var refresh = function(dataValue) {
	if (dataValue.pvpInfo.refreshTime < dataValue.globalInfo.pvpDay[dataValue.area].updateTime) {
		tiny.log.debug("refresh ticketN");
		dataValue.pvpInfo.ticketN = 5;
		dataValue.pvpInfo.refreshTime = dataValue.globalInfo.pvpDay[dataValue.area].updateTime;
	}
};

// 获取pvp主面板
//var getRewardTime = function(dataValue, inArgs, dataKey) {
var getPvpMainList = function(dataValue) {
	//tiny.log.debug("doing", JSON.stringify(inArgs), JSON.stringify(dataKey), JSON.stringify(dataValue));
	//tiny.log.debug("doing", JSON.stringify(dataValue));
	// 检查是否需要刷新门票
	refresh(dataValue);
	var outArgs = getReadMainList(dataValue);
	// 已经报名则取数据
	if (dataValue.pvpInfo.startMark === Const.PVP_SNG_START) {
		outArgs.pvpInfo.fightInfoListSng = dataValue.pvpInfo.fightInfoListSng;
	}
	outArgs.retCode = ErrCode.SUCCESS;
	return outArgs;
};

// 报名参加常规赛
var enrollPvpSng = function(dataValue) {
	// 1个1
	// 2个2
	// 3个3
	// 不够人数则取机器人
	var outArgs = {};
	outArgs.retCode = ErrCode.SUCCESS;

	if (dataValue.pvpInfo.startMark !== Const.PVP_SNG_START) {
		// 检查是否需要刷新门票
		refresh(dataValue);
	//if (1) {
		// 没开始战斗
		// 检查门票是否足够
		if (dataValue.pvpInfo.ticketN > 0) {
		//if (1) {
			// 扣除票
			dataValue.pvpInfo.ticketN -= 1;
		} else {
			tiny.log.debug("enrollPvpSng outArgs error", JSON.stringify(dataValue.pvpInfo));
			outArgs.retCode = ErrCode.PVP_EROLL_SNG_ERROR;
			return outArgs;
		}
		// 设置为战斗状态
		dataValue.pvpInfo.startMark = Const.PVP_SNG_START;
		// 清空临时战斗数据
		dataValue.pvpInfo.box1 = 0;
		dataValue.pvpInfo.box2 = 0;
		dataValue.pvpInfo.box3 = 0;
		dataValue.pvpInfo.fightCount = 0;
		// 读取数据
		outArgs.pvpInfo = getReadPvpInfo(dataValue);
		outArgs.pvpInfo.fightInfoListSng = [];
		outArgs.pvpInfo.fightInfoListSng = outArgs.pvpInfo.fightInfoListSng.concat(dataValue.pvpSng.fighterList1);
		outArgs.pvpInfo.fightInfoListSng = outArgs.pvpInfo.fightInfoListSng.concat(dataValue.pvpSng.fighterList2);
		outArgs.pvpInfo.fightInfoListSng = outArgs.pvpInfo.fightInfoListSng.concat(dataValue.pvpSng.fighterList3);
		// 保存随机敌人数据
		dataValue.pvpInfo.fightInfoListSng = outArgs.pvpInfo.fightInfoListSng;
	} else {
		// 已经在战斗中不需要重新随机
		tiny.log.debug("enrollPvpSng INGING");
		outArgs.pvpInfo.fightInfoListSng = dataValue.pvpInfo.fightInfoListSng;
	}
	//tiny.log.debug("enrollPvpSng outArgs", JSON.stringify(outArgs));
	return outArgs;
};

var getSngBoxRewardByCount = function(dataValue, boxCount, outArgs) {
	var pvpCoinId = 12010;  // pvp货币ID
	tiny.log.debug("getSngBoxReward ", boxCount);
	if (boxCount >= 1 && boxCount <= 3) {
		if (dataValue.pvpInfo["box" + boxCount] === 0
			&& dataValue.pvpInfo.fightCount >= SportsChest[boxCount].WinNum) {
			outArgs.ticketDay += SportsChest[boxCount].Reward1;
			tiny.log.debug("getSngBoxReward ticketDay", outArgs.ticketDay);
 			// 添加道具货币
 			if (!item.getItemAward(pvpCoinId, SportsChest[boxCount].Reward2, dataValue.bagList, outArgs.bagItem)) {
 				outArgs.retCode = ErrCode.BAG_ADD_ERROR;
 				return false;
 			}
 		}
 		return true;
	}
 	return false;
};

// 获取常规赛宝箱
var getSngBoxReward = function(dataValue, inArgs) {
	var outArgs = {}, boxCount = parseInt(inArgs.boxCount, 10);

	if (!outArgs.hasOwnProperty("bagItem")) {
		outArgs.bagItem = { itemList : {}, equipList : {} };
	}
	if (dataValue.pvpInfo.startMark === Const.PVP_SNG_START) {
		outArgs.ticketDay = 0;
		if (!getSngBoxRewardByCount(dataValue, boxCount, outArgs)) {
			outArgs.retCode = ErrCode.PVP_GET_BOX_REWARD_ERROR;
			return outArgs;
		}
		dataValue.pvpInfo.ticketDay += outArgs.ticketDay;
		dataValue.pvpInfo["box" + boxCount] = 1;
	} else {
		outArgs.retCode = ErrCode.PVP_GET_BOX_REWARD_ERROR;
	}

	return outArgs;
};

// 获取常规奖励
var getSngReward = function(dataValue, inArgs) {
	var reward, outArgs = {}, myPlayerInfo;
	if (inArgs.enemyType >= 1
		&& inArgs.enemyType <= 6
		&& dataValue.pvpInfo.startMark === Const.PVP_SNG_START) {
		// 取奖励
		reward = dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].ticketDay;
		if (dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].result === 0
			|| dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].result === Const.PVP_LOSER) {
			// 	取玩家数据
			myPlayerInfo = playerHandle.transBaseInfoToPlayerInfo(dataValue.baseInfo, dataValue.teamHeroList, dataValue.bagList);
			// 开始战斗
			Fight.fightPvp(myPlayerInfo, dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].enemy, function(err, result, seed) {
				if (err) {
					tiny.log.debug("getSngReward fightPvp err");
					outArgs.retCode = ErrCode.PVP_GET_SNG_REWARD_ERROR;
				} else {
					tiny.log.debug("getSngReward save result", result);
					dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].result = result;
					dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].seed = seed;
				}
			});
			if (outArgs.retCode === ErrCode.PVP_GET_SNG_REWARD_ERROR) {
				return outArgs;
			}
			// 保存获取奖励
			tiny.log.debug("getSngReward save reward", reward);
			if (dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].result === Const.PVP_WINNER) {
				dataValue.pvpInfo.ticketDay += reward;
			}
			dataValue.pvpInfo.fightCount++;
		}
		//tiny.log.debug("pvp data1", JSON.stringify(myPlayerInfo));
		//tiny.log.debug("pvp data2", JSON.stringify(dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].enemy));
		outArgs.fightReward = getReadFightReward();
		outArgs.fightReward.ticketDay = reward;
		outArgs.seed = dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].seed;
		outArgs.result = dataValue.pvpInfo.fightInfoListSng[inArgs.enemyType - 1].result;
		outArgs.retCode = ErrCode.SUCCESS;
	} else {
		outArgs.retCode = ErrCode.PVP_GET_SNG_REWARD_ERROR;
	}
	return outArgs;
};

// 退出常规赛
var exitPvpSng = function(dataValue) {
	var outArgs = {}, boxCount;
	outArgs.retCode = ErrCode.SUCCESS;
	dataValue.pvpInfo.startMark = Const.PVP_SNG_END;
	outArgs.startMark = dataValue.pvpInfo.startMark;
	outArgs.bagItem = { itemList : {}, equipList : {} };
	outArgs.ticketDay = 0;
	// 领完宝箱逻辑
	boxCount = 1;
	if (!getSngBoxRewardByCount(dataValue, boxCount, outArgs)) {
		outArgs.retCode = ErrCode.PVP_GET_BOX_REWARD_ERROR;
		return outArgs;
	}
	boxCount = 2;
	if (!getSngBoxRewardByCount(dataValue, boxCount, outArgs)) {
		outArgs.retCode = ErrCode.PVP_GET_BOX_REWARD_ERROR;
		return outArgs;
	}
	boxCount = 3;
	if (!getSngBoxRewardByCount(dataValue, boxCount, outArgs)) {
		outArgs.retCode = ErrCode.PVP_GET_BOX_REWARD_ERROR;
		return outArgs;
	}
	dataValue.pvpInfo.ticketDay += outArgs.ticketDay;
	// 清空临时战斗数据
	dataValue.pvpInfo.box1 = 0;
	dataValue.pvpInfo.box2 = 0;
	dataValue.pvpInfo.box3 = 0;
	dataValue.pvpInfo.fightCount = 0;
	dataValue.pvpInfo.fightInfoListSng = [];
	return outArgs;
};

// 设置最高战斗力
var setMaxPower = function(dataValue) {
	var outArgs = {};
	outArgs.retCode = ErrCode.SUCCESS;
	// 计算战斗力
	outArgs.maxPower = 0;
	outArgs.maxPower = playerHandle.getPlayerPower(dataValue.baseInfo, dataValue.teamHeroList, dataValue.bagList);

	//if (outArgs.maxPower >= dataValue.baseInfo.power) {
	if (1) {
		// 原本的战斗力区间
		pvpHandle.removePvpSng(dataValue.baseInfo, function(err) {
			if (err) {
				tiny.log.error("removePvpSng error", err, dataValue.baseInfo.area, dataValue.baseInfo.uuid);
			}
		});
		dataValue.baseInfo.power = outArgs.maxPower;
	}
	// 修改英雄战力匹配区间
	return outArgs;
};

// 报名参加日赛
var enrollPvpDay = function(dataValue) {
	var outArgs = {};
	outArgs.retCode = ErrCode.SUCCESS;
	// 检查是否到达报名时间
	if (dataValue.pvpInfo.myTime < dataValue.globalInfo.pvpDay[dataValue.area].updateTime) {
		//检查积分是否足够
		tiny.log.debug("enrollPvpDay before");
		if (dataValue.pvpInfo.ticketDay >= Const.PVP_ENROLL_DAY_TICKET_LIMIT
			&& dataValue.globalInfo.pvpDay[dataValue.area].nums < Const.PVP_ENROLL_DAY_NUMS_LIMIT) {
			tiny.log.debug("enrollPvpDay enough");
			// 参加比赛
			// 这里可能需要去重
			dataValue.pvpDay.uuids.push(dataValue.uuid);
			// 保存全局数据
			dataValue.globalInfo.pvpDay[dataValue.area].nums += 1;
			dataValue.globalInfo.pvpDay[dataValue.area].rewardPool += dataValue.pvpInfo.ticketDay;
			// 保存pvpInfo
			dataValue.pvpInfo.myTime = dataValue.globalInfo.pvpDay[dataValue.area].updateTime;
			dataValue.pvpInfo.dayMark = Const.PVP_DAY_START;
			outArgs.pvpDay = getReadPvpDay(dataValue);
		} else {
			outArgs.retCode = ErrCode.PVP_EROLL_DAY_ERROR;
		}
	} else {
		// 已经报名
		tiny.log.debug("enrollPvpDay INGING");
		outArgs.pvpDay = getReadPvpDay(dataValue);
		outArgs.retCode = Const.PVP_DAY_IS_ENROLL;
	}
	return outArgs;
};

// 获取日赛战斗结果
var getPvpDayResult = function(dataValue) {
	var outArgs = {};
	outArgs.retCode = ErrCode.SUCCESS;
	outArgs.fightInfoList = dataValue.pvpInfo.fightInfoListDay;
	outArgs.maxCount = dataValue.globalInfo.pvpDay[dataValue.area].maxCount;
	return outArgs;
};

// 获取8强赛战斗结果
var getPvpDayF8Result = function(dataValue) {
	var outArgs = {}, i, reward;
	outArgs.retCode = ErrCode.SUCCESS;
	outArgs.fightReward = getReadFightReward();
	outArgs.pvpF8Result = dataValue.pvpDay.pvpF8Result;
	for (i = 0; i < dataValue.pvpDay.finalSort.length; i++) {
		if (dataValue.baseInfo.uuid === dataValue.pvpDay.finalSort[i].uuid) {
			reward = Robot.getPvpDayRward(i, dataValue.pvpDay.finalSort.length);
			break;
		}
	}
	if (reward) {
		outArgs.pos = i + 1;
		outArgs.fightReward.diamand = reward.diamand;
		outArgs.fightReward.ticketWeek = reward.ticketWeek;
		// 保存数据
		if (dataValue.pvpInfo.dayMark !== Const.PVP_DAY_GET) {
			playerHandle.addPlayerDiamond(outArgs.fightReward.diamand, dataValue.baseInfo);
			dataValue.pvpInfo.dayMark = Const.PVP_DAY_GET;
			dataValue.pvpInfo.ticketWeek += outArgs.fightReward.ticketWeek;
		}
	}
	return outArgs;
};


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

var savePlayerInfo = function(playerInfo, playerInfoList) {
	var i;
	for (i = 0; i < playerInfoList.length; i++) {
		if (playerInfoList[i].area === playerInfo.area
			&& playerInfoList[i].uuid === playerInfo.uuid) {
			return;
		}
	}
	playerInfoList.push(playerInfo);
};

var calFightF8 = function(pvpDay, ua1, ua2, playerInfo1, playerInfo2, winner, seed, winUuid, failUuid, i) {
	var fightInfo = {};
	// 修改pvpDay
	fightInfo.player1 = ua1;
	fightInfo.player2 = ua2;
	fightInfo.winner = winner;
	fightInfo.seed = seed;
	fightInfo.fightReward = getReadFightReward();
	savePlayerInfo(playerInfo1, pvpDay.pvpF8Result.playerInfoList);
	savePlayerInfo(playerInfo2, pvpDay.pvpF8Result.playerInfoList);
	pvpDay.pvpF8Result["fightInfoList"+i].push(fightInfo);
	// 计算排名
	if (winner === 1) {
		winUuid.push(ua1);
		failUuid.push(ua2);
	} else {
		winUuid.push(ua2);
		failUuid.push(ua1);
	}
};

var fight1 = function(pvpDay, userArea1, userArea2, winUuid, failUuid, callback) {
	var ua1, ua2, f8 = [];
	if (userArea1.length === 0 || userArea2.length === 0) {
		// fight0
		tiny.log.debug("1", "winner", JSON.stringify(winUuid), "loser", JSON.stringify(failUuid));
		f8[0] = winUuid[0];
		f8[1] = failUuid[0];
		f8[2] = winUuid[1];
		f8[3] = failUuid[1];
		f8[4] = winUuid[2];
		f8[5] = failUuid[2];
		f8[6] = winUuid[3];
		f8[7] = failUuid[3];
		callback(null, f8);
	} else {
		ua1 = userArea1.pop();
		ua2 = userArea2.pop();
		pvpHandle.get1V1PlayerInfoS(ua1, ua2, function(err, playerInfo1, playerInfo2) {
			if (err) {
				callback(err);
			} else {
				// 战斗
				Fight.fightPvp(playerInfo1, playerInfo2, function(err, winner, seed) {
					if (err) {
						callback(err);
					} else {
						// 计算战斗结果
						calFightF8(pvpDay, ua1, ua2, playerInfo1, playerInfo2, winner, seed, winUuid, failUuid, 1);
						// 下一个
						fight1(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
					}
				});
			}
		});
	}
};

var fight2 = function(pvpDay, userArea1, userArea2, winUuid, failUuid, callback) {
	var ua1, ua2;
	if (userArea1.length === 0 || userArea2.length === 0) {
		// fight1
		tiny.log.debug("2", "winner", JSON.stringify(winUuid), "loser", JSON.stringify(failUuid));
		userArea1[0] = winUuid[0];
		userArea1[1] = failUuid[0];
		userArea1[2] = winUuid[2];
		userArea1[3] = failUuid[2];

		userArea2[0] = winUuid[1];
		userArea2[1] = failUuid[1];
		userArea2[2] = winUuid[3];
		userArea2[3] = failUuid[3];
		winUuid = [];
		failUuid = [];
		fight1(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
	} else {
		ua1 = userArea1.pop();
		ua2 = userArea2.pop();
		pvpHandle.get1V1PlayerInfoS(ua1, ua2, function(err, playerInfo1, playerInfo2) {
			if (err) {
				callback(err);
			} else {
				// 战斗
				Fight.fightPvp(playerInfo1, playerInfo2, function(err, winner, seed) {
					if (err) {
						callback(err);
					} else {
						// 计算战斗结果
						calFightF8(pvpDay, ua1, ua2, playerInfo1, playerInfo2, winner, seed, winUuid, failUuid, 2);
						// 下一个
						fight2(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
					}
				});
			}
		});
	}
};

var fight3 = function(pvpDay, userArea1, userArea2, winUuid, failUuid, callback) {
	var ua1, ua2;
	if (userArea1.length === 0 || userArea2.length === 0) {
		// fight2
		tiny.log.debug("4", "winner", JSON.stringify(winUuid), "loser", JSON.stringify(failUuid));
		userArea1[0] = winUuid[0];
		userArea1[1] = winUuid[1];
		userArea1[2] = failUuid[0];
		userArea1[3] = failUuid[1];

		userArea2[0] = winUuid[2];
		userArea2[1] = winUuid[3];
		userArea2[2] = failUuid[2];
		userArea2[3] = failUuid[3];
		winUuid = [];
		failUuid = [];
		fight2(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
	} else {
		ua1 = userArea1.pop();
		ua2 = userArea2.pop();
		pvpHandle.get1V1PlayerInfoS(ua1, ua2, function(err, playerInfo1, playerInfo2) {
			if (err) {
				callback(err);
			} else {
				// 战斗
				Fight.fightPvp(playerInfo1, playerInfo2, function(err, winner, seed) {
					if (err) {
						callback(err);
					} else {
						// 计算战斗结果
						calFightF8(pvpDay, ua1, ua2, playerInfo1, playerInfo2, winner, seed, winUuid, failUuid, 4);
						// 下一个
						fight3(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
					}
				});
			}
		});
	}
};

var fight4 = function(pvpDay, userArea1, userArea2, winUuid, failUuid, callback) {
	var ua1, ua2;
	if (userArea1.length === 0 || userArea2.length === 0) {
		// fight3
		tiny.log.debug("8", "winner", JSON.stringify(winUuid), "loser", JSON.stringify(failUuid));
		userArea1 = winUuid;
		userArea2 = failUuid;
		userArea2 = userArea2.reverse();
		winUuid = [];
		failUuid = [];
		fight3(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
	} else {
		ua1 = userArea1.pop();
		ua2 = userArea2.pop();
		pvpHandle.get1V1PlayerInfoS(ua1, ua2, function(err, playerInfo1, playerInfo2) {
			if (err) {
				callback(err);
			} else {
				// 战斗
				Fight.fightPvp(playerInfo1, playerInfo2, function(err, winner, seed) {
					if (err) {
						callback(err);
					} else {
						// 计算战斗结果
						calFightF8(pvpDay, ua1, ua2, playerInfo1, playerInfo2, winner, seed, winUuid, failUuid, 8);
						// 下一个
						fight4(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
					}
				});
			}
		});
	}
};

var fightF8 = function(pvpDay, userArea, callback) {
	var userArea1 = [], userArea2 = [], winUuid = [], failUuid = [], i;
	for (i = 0; i < 8; i++) {
		if ((i % 2) === 0) {
			userArea1.push(userArea[i]);
		} else {
			userArea2.push(userArea[i]);
		}
	}
	pvpDay.pvpF8Result.fightInfoList8 = [];
	pvpDay.pvpF8Result.fightInfoList4 = [];
	pvpDay.pvpF8Result.fightInfoList2 = [];
	pvpDay.pvpF8Result.fightInfoList1 = [];
	fight4(pvpDay, userArea1, userArea2, winUuid, failUuid, callback);
};

// 插入淘汰赛排名
var insertEltToSortResult = function(sortResult, ua) {
	var i, tag = false;
	if (sortResult.userArea.length === 0) {
		sortResult.userArea.push(ua);
		return sortResult;
	}
	for (i = 0; i < sortResult.userArea.length; i++) {
		if (sortResult.map[utils.userAreaKey(ua)] >= sortResult.map[utils.userAreaKey(sortResult.userArea[i])]) {
			tag = true;
			sortResult.userArea.splice(i, 0, ua);
			break;
		}
	}
	if (!tag) {
		sortResult.userArea.push(ua);
	}
	return sortResult;
};

// 计算战斗结果
var calFightResult = function(playerInfo1, pvpInfo1, playerInfo2, pvpInfo2, winner, seed, remainUserArea, sortResult, count) {
	var fightInfo = {};
	// 修改pvpInfo
	fightInfo.player1 = playerInfo1;
	fightInfo.player2 = playerInfo2;
	fightInfo.winner = winner;
	fightInfo.seed = seed;
	fightInfo.fightReward = getReadFightReward();
	if (count === 0) {
		pvpInfo1.fightInfoListDay = [];
		pvpInfo2.fightInfoListDay = [];
	}
	pvpInfo1.fightInfoListDay.push(fightInfo);
	pvpInfo2.fightInfoListDay.push(fightInfo);
	// 计算积分
	if (winner === 1) {
		tiny.log.debug("winner", playerInfo1.uuid, "loser", playerInfo2.uuid);
		if (pvpInfo1.ticketDay >= pvpInfo2.ticketDay) {
			// 1大于2 清空2
			fightInfo.fightReward.ticketDay = pvpInfo2.ticketDay;
			pvpInfo2.ticketDay = 0;
		} else {
			// 2只减去1
			fightInfo.fightReward.ticketDay = pvpInfo1.ticketDay;
			pvpInfo2.ticketDay -= fightInfo.fightReward.ticketDay;
		}
		// 1增加奖励
		pvpInfo1.ticketDay += fightInfo.fightReward.ticketDay;
	} else {
		tiny.log.debug("winner", playerInfo2.uuid, "loser", playerInfo1.uuid);
		if (pvpInfo2.ticketDay >= pvpInfo1.ticketDay) {
			// 2大于1 清空1
			fightInfo.fightReward.ticketDay = pvpInfo1.ticketDay;
			pvpInfo1.ticketDay = 0;
		} else {
			// 1只减去2
			fightInfo.fightReward.ticketDay = pvpInfo2.ticketDay;
			pvpInfo1.ticketDay -= fightInfo.fightReward.ticketDay;
		}
		// 2增加奖励
		pvpInfo2.ticketDay += fightInfo.fightReward.ticketDay;
	}
	tiny.log.debug("ticketDay", pvpInfo1.ticketDay, pvpInfo2.ticketDay, fightInfo.fightReward.ticketDay);
	// 计算排名
	if (pvpInfo1.ticketDay !== 0) {
		remainUserArea.push({area : playerInfo1.area, uuid : playerInfo1.uuid, ticketDay : pvpInfo1.ticketDay});
	} else {
		// 淘汰
		insertEltToSortResult(sortResult, {area : playerInfo1.area, uuid : playerInfo1.uuid});
	}
	if (pvpInfo2.ticketDay !== 0) {
		remainUserArea.push({area : playerInfo2.area, uuid : playerInfo2.uuid, ticketDay : pvpInfo2.ticketDay});
	} else {
		// 淘汰
		insertEltToSortResult(sortResult, {area : playerInfo2.area, uuid : playerInfo2.uuid});
	}
};

var fight2Array = function(userArea1, userArea2, remainUserArea, sortResult, count, callback) {
	var ua1, ua2, key1, key2;
	if (userArea1.length === 0 || userArea2.length === 0) {
		tiny.log.debug("fight2Array end");
		callback(null);
	} else {
		ua1 = userArea1.pop();
		ua2 = userArea2.pop();
		tiny.log.debug("Fight before", ua1.uuid, ua2.uuid);
		pvpHandle.get1V1PlayerInfo(ua1, ua2, function(err, playerInfo1, pvpInfo1, playerInfo2, pvpInfo2) {
			if (err) {
				callback(err);
			} else {
				// 保存大师积分map
				key1 = utils.userAreaKey(ua1);
				key2 = utils.userAreaKey(ua2);
				if (!sortResult.map.hasOwnProperty(key1)) {
					sortResult.map[key1] = pvpInfo1.ticketDay;
				}
				if (!sortResult.map.hasOwnProperty(key2)) {
					sortResult.map[key2] = pvpInfo2.ticketDay;
				}
				// 战斗
				Fight.fightPvp(playerInfo1, playerInfo2, function(err, winner, seed) {
					if (err) {
						callback(err);
					} else {
						// 计算战斗结果
						calFightResult(playerInfo1, pvpInfo1, playerInfo2, pvpInfo2, winner, seed, remainUserArea, sortResult, count);
						// 保存pvpInfo
						pvpHandle.set1V1PlayerInfo(ua1, ua2, pvpInfo1, pvpInfo2, function(err) {
							if (err) {
								tiny.log.error("set1V1PlayerInfo", JSON.stringify(ua1), JSON.stringify(ua2));
							} else {
								// 继续下一回合
								tiny.log.debug("fight2Array next fight", userArea1.length, userArea2.length);
								fight2Array(userArea1, userArea2, remainUserArea, sortResult, count, callback);
							}
						});
					}
				});
			}
		});
	}
};

// 每回合战斗
var fightOne = function(userArea, sortResult, count, callback) {
	var userArea1 = [], userArea2 = [], i, sOne, remainUserArea = [];
	if (count >= 10 || userArea.length <= 16) {
		// 最多10回合
		// 或者已经结束 人数少于16人
		callback(null, userArea, count);
		return;
	}
	// 奇数取其中一个出来
	if ((userArea.length % 2) !== 0) {
		sOne = userArea.shift();
	}
	for (i = 0; i < userArea.length; i++) {
		if ((i % 2) === 0) {
			userArea1.push(userArea[i]);
		} else {
			userArea2.push(userArea[i]);
		}
	}
	if (userArea1.length !== userArea2.length) {
		// ?两个数组不等
		callback(" don't equal " + userArea1.length + "|" + userArea2.length);
		return;
	}
	tiny.log.debug("Fight", count, JSON.stringify(userArea1), JSON.stringify(userArea2), JSON.stringify(sOne));
	fight2Array(userArea1, userArea2, remainUserArea, sortResult, count, function(err) {
		if (err) {
			callback(err);
		} else {
			if (sOne) {
				remainUserArea.push(sOne);
			}
			// 回合数+1
			count += 1;
			tiny.log.debug("fightOne next one", JSON.stringify(remainUserArea));
			fightOne(remainUserArea, sortResult, count, callback);
		}
	});
};

// 日赛战斗
var _fightPvpDay = function(dataValue, callback) {
	var sortResult = {
		userArea : [],
		map : {},
	}, count = 0, userArea = [], i, size;
	// 生成统一数据接口 uuid + area
	for (i = 0; i < dataValue.pvpDay.uuids.length; i++) {
		userArea.push({area : dataValue.pvpDay.area, uuid : dataValue.pvpDay.uuids[i]});
	}
	// 添加机器人
	if (userArea.length < 100) {
		size = 100 - userArea.length;
		tiny.log.debug("len", userArea.length, size);
		for (i = 0; i < size; i++)	{
			userArea.push({area : 0, uuid : i+1});
		}
	}
	tiny.log.debug("userArea", JSON.stringify(userArea));
	fightOne(userArea, sortResult, count, function(err, remainUserArea) {
		var f8 = [], printS = "";
		// 战斗完成
		if (err) {
			tiny.log.debug("fight err", err);
		} else {
			tiny.log.debug("fight finish");

			// 重新计算排名
			if (remainUserArea.length < 8) {
				//剩余人数不对
				tiny.log.debug(" fight num error", remainUserArea.length);
				return;
			}
			tiny.log.debug("userArea", JSON.stringify(sortResult.userArea));
			// 降序
			remainUserArea.sort(function cp(a, b) {
				return b.ticketDay - a.ticketDay;
			});
			// 剩余
			if (remainUserArea.length > 8) {
				for (i = 0; i < remainUserArea.length; i++) {
					if (i < 8) {
						f8.push(remainUserArea[i]);
					} else {
						sortResult.userArea.splice(0, 0, remainUserArea[i]);
					}
				}
			}
			for (i = 0; i < sortResult.userArea.length; i++) {
				printS = printS + "|{" + sortResult.userArea[i].area + "|" + sortResult.userArea[i].uuid + "|"
				+ sortResult.map[utils.userAreaKey(sortResult.userArea[i])] + "}|";
			}
			tiny.log.debug("fight finish sortResult", printS);

			tiny.log.debug("f8", JSON.stringify(f8));

			tiny.log.debug("fight f8 start");

			// 8强赛
			fightF8(dataValue.pvpDay, f8, function(err, final8) {
				if (err) {
					tiny.log.debug("f8 error", err);
				} else {
					tiny.log.debug("fight f8 finish", JSON.stringify(f8));
					sortResult.userArea = final8.concat(sortResult.userArea);
					// 计算不奖励
					dataValue.pvpDay.finalSort = sortResult.userArea;
					// 最终排序
					printS = "";
					for (i = 0; i < sortResult.userArea.length; i++) {
						printS = printS + "|{" + sortResult.userArea[i].area + "|" + sortResult.userArea[i].uuid + "|"
						+ (sortResult.userArea[i].ticketDay || sortResult.map[utils.userAreaKey(sortResult.userArea[i])]) + "}|";
					}
					tiny.log.debug("fight f8 final finish sortResult", printS);
					callback(null, dataValue.pvpDay);
				}
			});
			/*
			*/
		}
	});
};

// 日赛战斗
var fightPvpDay = function(area, callback) {
	pvpHandle.getPvpDay(area, function(err, pvpDay) {
		var dataValue = {};
		if (err) {
			tiny.log.error("getPvpDay error", err);
			callback(err);
		} else {
			dataValue.pvpDay = pvpDay;
			_fightPvpDay(dataValue, function(err, pvpDay) {
				if (err) {
					tiny.log.error("_fightPvpDay error", err);
					callback(err);
				} else {
					pvpHandle.setPvpDay(area, pvpDay, function(err) {
						if (err) {
							tiny.log.error("setPvpDay error", err);
							callback(err);
						} else {
							callback(null);
						}
					});
				}
			});
		}
	});
};

// 更新区服时间
var updateAreaTimeInGlobalInfo = function(area, callback) {
	pvpHandle.getGlobalInfo(function(err, globalInfo) {
		if (err) {
			callback(err);
		} else {
			tiny.log.debug("updateAreaTimeInGlobalInfo", area, JSON.stringify(globalInfo));
			globalInfo.pvpDay[area].updateTime = utils.getDate();
			pvpHandle.setGlobalInfo(globalInfo, function(err) {
				if (err) {
					callback(err);
				}
			});
		}
	});
};

var testData = function(dataValue) {
	var outArgs = {};
	tiny.log.debug("dataValue", JSON.stringify(dataValue));
	//tiny.log.debug("dataValue", JSON.stringify(dataValue.teamHeroList));
	//dataValue.pvpInfo.ticketN += 1;
	//dataValue.heroInfo.level +=1;
	outArgs.uuid = "123";
	return outArgs;
};

var test = {
"getPvpMainList" : getPvpMainList,
"enrollPvpSng" : enrollPvpSng,
"getSngBoxReward" : getSngBoxReward,
"getSngReward" : getSngReward,
"exitPvpSng" : exitPvpSng,
"setMaxPower" : setMaxPower,
"enrollPvpDay" : enrollPvpDay,
"getPvpDayResult" : getPvpDayResult,
"getPvpDayF8Result" : getPvpDayF8Result,
"fightPvpDay" : fightPvpDay,
"updateAreaTimeInGlobalInfo" : updateAreaTimeInGlobalInfo,
"testData" : testData,
};
exports.test = test;
//agentHandle.bindImp(exports, test);
