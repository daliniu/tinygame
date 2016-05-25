var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var async = require('async');
var utils = require('../utils');
var moment = require('moment');
var eqStar = require("../config/equip/eqStar");
var hangHandle = require('../dataprocess/hangup_handle');
var equipHandle = require('../dataprocess/equip_handle');
var playerHandle = require('../dataprocess/player_handle');
var heroHandle = require('../dataprocess/hero_handle');
var mapHandle = require('../dataprocess/map_handle');
var afkHandle = require('../dataprocess/afk_handle');
var bag = require('../bag/bag');
var afk = require('../afk/afk');
var item = require('../item/item');
var WorldMap = require('../config/map/worldmap');
var maxScoreTime = function(_afkReward) {
	var i, j, max = 0, afkReward = {};
	for (i in _afkReward) {
		if (_afkReward.hasOwnProperty(i)) {
			for (j in _afkReward[i].Score) {
				if (_afkReward[i].Score.hasOwnProperty(j)) {
					if (parseInt(j, 10) >= max) {
						max = parseInt(j, 10);
					}
				}
			}
			afkReward[i] = _afkReward[i];
			afkReward[i].MaxScoreTime = max;
			max = 0;
		}
	}
	return afkReward;
};
var Afkreward = maxScoreTime(require('../config/map/afkreward'));
var itemfunc = require('../item/item');
// 离线获取挂机收益
var offlineProfit = function(dataValue) {
	// 定义变量
	var outArgs, result, isEnough = true, itemId, isSet = false, bagItem = {}, heroId,
	mapInfo = dataValue.mapInfo, nodeInfo = dataValue.nodeInfo;
	outArgs = {};

	// 获取离线收益
	// 运行逻辑
	// tiny.log.debug("guajiid", dataValue.afkInfo.curAfker.guajiid);

	result = afk.calProfit(true, nodeInfo, mapInfo);
	// tiny.log.debug("guajiid", JSON.stringify(dataValue.afkInfo), JSON.stringify(dataValue.mapInfo), JSON.stringify(dataValue.result));
	// if (!result) {
	// 	tiny.log.error("offlineProfit", dataValue.uuid, dataValue.area, ErrCode.NO_NEED_TIPS, "cal offline afk fail");
	// 	outArgs.retCode = ErrCode.NO_NEED_TIPS;
	// 	return outArgs;
	// }

	// 把道具添加到背包里面
	// for (itemId in result.splitList) {
	// 	if (result.splitList.hasOwnProperty(itemId)) {
	// 		if (result.splitList[itemId].num !== 0 && !bag.tryAddItem(result.splitList[itemId].id, result.splitList[itemId].num, dataValue.bagList)) {
	// 			// 背包空间不足 删除道具
	// 			delete result.splitList[itemId];
	// 			isEnough = false;
	// 			tiny.log.debug("itemId", itemId, ' tryAddItem to BagList fail');
	// 		} else {
	// 			if (result.splitList[itemId].num !== 0 && !item.getItemAward(result.splitList[itemId].id, result.splitList[itemId].num, dataValue.bagList, bagItem)) {
	// 				tiny.log.debug("itemId", itemId, ' save item to BagList fail');
	// 				isEnough = false;
	// 			} else {
	// 				isSet = true;
	// 			}
	// 		}
	// 	}
	// }

	// if (!isSet) {
	// 	bagItem.itemList = {};
	// 	bagItem.equipList = {};
	// }

	// 修改玩家金钱
	playerHandle.addPlayerGold(result.gold, dataValue.baseInfo);
	// 增加经验值
	playerHandle.addPlayerExp(result.exp, dataValue.baseInfo);
	// 增加行动力
	// playerHandle.addPlayerAction(result.action, dataValue.baseInfo);

	for (heroId in dataValue.teamHeroList) {
		if (dataValue.teamHeroList.hasOwnProperty(heroId)) {
			heroHandle.addHeroExp(result.exp,dataValue.teamHeroList[heroId]);
		}
	}

	outArgs.bagitem = bagItem;
	outArgs.playerInfo = dataValue.baseInfo;
	outArgs.playerInfo.teamList = dataValue.teamHeroList;
	outArgs.gold = result.gold;
	outArgs.exp = result.exp;
	outArgs.action = 0;
	outArgs.offTime = result.offTime;
	// if (isEnough) {
	// 	outArgs.retCode = ErrCode.SUCCESS;
	// } else {
	// 	outArgs.retCode = ErrCode.FIGHT_BAG_FREE_ROOM_LIMIT;
	// }

	return outArgs;
};

// 在线实时获取挂机收益
var onlineProfit = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, result = {}, heroId, win = inArgs.isWin,
	mapInfo = dataValue.mapInfo, nodeInfo = dataValue.nodeInfo;

	outArgs = {};
	// 获取在线收益
	// 运行逻辑
	result = afk.calProfit(false, nodeInfo, mapInfo, win);
	// tiny.log.debug("guajiid", JSON.stringify(dataValue.afkInfo), JSON.stringify(dataValue.mapInfo), JSON.stringify(dataValue.result));
	// if (!result) {
	// 	tiny.log.error("offlineProfit", dataValue.uuid, dataValue.area, ErrCode.NOT_BEGIN_AFK_ERROR, "cal online afk fail");
	// 	outArgs.retCode = ErrCode.NOT_BEGIN_AFK_ERROR;
	// 	return outArgs;
	// }

	// 把道具添加到背包里面
	// for (itemId in result.splitList) {
	// 	if (result.splitList.hasOwnProperty(itemId)) {
	// 		if (result.splitList[itemId].num !== 0 && !bag.tryAddItem(result.splitList[itemId].id, result.splitList[itemId].num, dataValue.bagList)) {
	// 			// 背包空间不足 删除道具
	// 			delete result.splitList[itemId];
	// 			isEnough = false;
	// 			tiny.log.debug("itemId", itemId, ' tryAddItem to BagList fail');
	// 		} else {
	// 			if (result.splitList[itemId].num !== 0 && !item.getItemAward(result.splitList[itemId].id, result.splitList[itemId].num, dataValue.bagList, bagItem)) {
	// 				tiny.log.debug("itemId", itemId, ' save item to BagList fail');
	// 				isEnough = false;
	// 			} else {
	// 				isSet = true;
	// 			}
	// 		}
	// 	}
	// }

	// if (!isSet) {
	// 	bagItem.itemList = {};
	// 	bagItem.equipList = {};
	// }

	// 修改玩家金钱
	playerHandle.addPlayerGold(result.gold, dataValue.baseInfo);
	// 增加经验值
	playerHandle.addPlayerExp(result.exp, dataValue.baseInfo);
	// 增加行动力
	// playerHandle.addPlayerAction(result.action, dataValue.baseInfo);

	for (heroId in dataValue.teamHeroList) {
		if (dataValue.teamHeroList.hasOwnProperty(heroId)) {
			heroHandle.addHeroExp(result.exp,dataValue.teamHeroList[heroId]);
		}
	}

	outArgs.bagitem = {};
	outArgs.playerInfo = dataValue.baseInfo;
	outArgs.playerInfo.teamList = dataValue.teamHeroList;
	outArgs.gold = result.gold;
	outArgs.exp = result.exp;
	outArgs.action = 0;
	// outArgs.rewardCount = result.rewardCount;
	// if (isEnough) {
	// 	outArgs.retCode = ErrCode.SUCCESS;
	// } else {
	// 	outArgs.retCode = ErrCode.FIGHT_BAG_FREE_ROOM_LIMIT;
	// }

	return outArgs;
};

var setProAfkTime = function(area, uuid, callback) {
	// afkHandle.getAfkInfo(area, uuid, function(err, afkInfo) {
	// 	if (err) {
	// 		callback(err);
	// 	} else {
	// 		afk.proAfkTimeChange(afkInfo, Date.now());
	// 		afkHandle.setAfkInfo(area, uuid, afkInfo, function(err) {
	// 			if (err) {
	// 				callback(err);
	// 			} else {
	// 				callback(null);
	// 			}
	// 		});
	// 	}
	// });
	var nodeid;
	tiny.redis.get(utils.redisKeyGen(area, uuid, 'map'), function(e, r) {
		if (e) {
			callback(e);
		} else {
			nodeid = r.curAfkNode;
			mapHandle.getNodeInfo(area, uuid, nodeid, function(e, node) {
				if (e) {
					callback(e);
				} else {
					if (node) {
						node.proAfkTime = moment().format();
						mapHandle.saveNodeInfo(area, uuid, nodeid, node, callback);
					}
				}
			});
		}
	});
};

// 获取宝箱
//var getPresent = function(dataValue, inArgs, dataKey) {
var getPresent = function(dataValue) {
	//tiny.log.debug("doing", JSON.stringify(inArgs), JSON.stringify(dataKey), JSON.stringify(dataValue));

	var outArgs = {}, victoryTime, count = 0, i, rewardTime = 0, rewardPack,
	nodeInfo = dataValue.nodeInfo, afkid = WorldMap[dataValue.mapInfo.curAfkNode].ResourceID;
	outArgs.bagitem = {};

	// guajiId = dataValue.afkInfo.curAfker.guajiid;
	// uid = dataValue.afkInfo.curAfker.uid;
	// if (guajiId === 0 || !dataValue.hasOwnProperty("mapInfo")) {
	// 	victoryTime = dataValue.afkInfo.afkVictoryTime;
	// 	guajiId = Const.DEFAULT_AFK_POINT;
	// } else {
	// 	tiny.log.debug("doing", uid, dataValue.mapInfo.uidList[uid].afkVictoryTime);
	// 	if (!dataValue.mapInfo.uidList[uid].afkVictoryTime) {
	// 		dataValue.mapInfo.uidList[uid].afkVictoryTime = { rewardCount : 0, scoreTime : 1};
	// 	}
	// 	victoryTime = dataValue.mapInfo.uidList[uid].afkVictoryTime;
	// }
	victoryTime = nodeInfo.victoryTime;
	rewardTime = nodeInfo.rewardTime;
	for (i in Afkreward[afkid].Score) {
		if (Afkreward[afkid].Score.hasOwnProperty(i)) {
			count++;
		}
	}
	if (rewardTime >= count) {
		rewardTime = count - 1;
	}
	if (victoryTime >= Afkreward[afkid].Score[rewardTime + 1]) {
		rewardPack = itemfunc.dropPool(Afkreward[afkid].ScoreReward, dataValue.baseInfo, dataValue.bagList, nodeInfo);
		if (rewardPack[0]) {
			tiny.log.error('getPresent', '挂机进度奖励获取失败', rewardPack[0]);
			outArgs.retCode = ErrCode.AFK_GET_REWARD_ERROR;
			return outArgs;
		}
		rewardTime++;
		nodeInfo.victoryTime = 0;
		nodeInfo.rewardTime = rewardTime;

		outArgs.playerInfo = dataValue.baseInfo;
		if (rewardPack[1].gold) {
			outArgs.gold = rewardPack[1].gold;
		} else {
			outArgs.gold = 0;
		}
		if (rewardPack[1].exp) {
			outArgs.exp = rewardPack[1].exp;
		} else {
			outArgs.exp = 0;
		}
		outArgs.action = 0;  //result.action;
		outArgs.rewardCount = 0;
		if (rewardTime + 1 > count) {
			outArgs.step = count;
		} else {
			outArgs.step = rewardTime + 1;
		}
		return outArgs;
	} else {
		tiny.log.error('getPresent', '次数未到，无法领取');
		outArgs.retCode = ErrCode.AFK_GET_REWARD_ERROR;
		return outArgs;
	}
	// if (victoryTime >= Afkreward[afkid].Score) {
	// 	// 获取礼物
	// 	count = Afkreward[guajiId].Score[Afkreward[guajiId].MaxScoreTime];
	// } else {
	// 	// 连胜次数在配置范围内
	// 	count = Afkreward[guajiId].Score[victoryTime.scoreTime];
	// }

	// tiny.log.debug("get ScoreReward", guajiId, Afkreward[guajiId].ScoreReward, victoryTime.rewardCount, victoryTime.scoreTime, Afkreward[guajiId].MaxScoreTime, count);

	// if (victoryTime.rewardCount >= count) {
	// 	// 给礼物
	// 	if (!itemfunc.dropPool(Afkreward[guajiId].ScoreReward, dataValue.baseInfo, dataValue.bagList, outArgs.bagitem)) {
	// 		outArgs.retCode = ErrCode.AFK_GET_REWARD_ERROR;
	// 	} else {
	// 		victoryTime.scoreTime += 1;
	// 		outArgs.playerInfo = dataValue.baseInfo;
	// 		outArgs.gold = dataValue.baseInfo.gold - bGold;    //result.gold;
	// 		outArgs.exp = 0;     //result.exp;
	// 		outArgs.action = 0;  //result.action;
	// 		outArgs.rewardCount = 0;
	// 		outArgs.step = victoryTime.scoreTime;
	// 		outArgs.retCode = ErrCode.SUCCESS;
	// 		// 重新设置为0;
	// 		victoryTime.rewardCount = 0;
	// 	}
	// } else {
	// 	tiny.log.error("count not enough", victoryTime.rewardCount, count);
	// 	outArgs.retCode = ErrCode.AFK_GET_REWARD_ERROR;
	// }
};

// 获取奖励次数
//var getRewardTime = function(dataValue, inArgs, dataKey) {
var getRewardTime = function(dataValue) {
	//tiny.log.debug("doing", JSON.stringify(inArgs), JSON.stringify(dataKey), JSON.stringify(dataValue));

	var outArgs = {}, nodeInfo = dataValue.nodeInfo, i, count = 0,
	afkid = WorldMap[dataValue.mapInfo.curAfkNode].ResourceID;

	// 设置宝箱次数
	// if (guajiId === 0 || !dataValue.hasOwnProperty("mapInfo")) {
	// 	outArgs.rewardCount = dataValue.afkInfo.afkVictoryTime.rewardCount;
	// 	outArgs.step = dataValue.afkInfo.afkVictoryTime.scoreTime;
	// } else {
	// 	if (!dataValue.mapInfo.uidList[uid].hasOwnProperty("afkVictoryTime")) {
	// 		dataValue.mapInfo.uidList[uid].afkVictoryTime = { rewardCount : 0, scoreTime : 1};
	// 	}
	// 	outArgs.rewardCount = dataValue.mapInfo.uidList[uid].afkVictoryTime.rewardCount;
	// 	outArgs.step = dataValue.mapInfo.uidList[uid].afkVictoryTime.scoreTime;
	// }
	for (i in Afkreward[afkid].Score) {
		if (Afkreward[afkid].Score.hasOwnProperty(i)) {
			count++;
		}
	}

	outArgs.rewardCount = nodeInfo.victoryTime;
	if (nodeInfo.rewardTime + 1 >= count) {
		outArgs.step = count;
	} else {
		outArgs.step = nodeInfo.rewardTime + 1;
	}
	return outArgs;
};

module.exports = {
	"setProAfkTime" : setProAfkTime, //该函数客户端退出游戏时服务器自己调用
	"getPresent" : getPresent,
	"getRewardTime" : getRewardTime,
	"offlineProfit" : offlineProfit,
	"onlineProfit" : onlineProfit,
};

