var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var heroHandle = require('../dataprocess/hero_handle');
var playerHandle = require('../dataprocess/player_handle');
var equipHandle = require('../dataprocess/equip_handle');
var async = require('async');
var utils = require('../utils');
var async = require('async');

// 获取英雄图鉴信息
var getHeroInfoList = function(dataValue) {
	// 定义变量
	var outArgs, heroInfoList = {};

	outArgs = {};
	// 获取英雄图鉴信息
	// 获取英雄列表

	heroInfoList = dataValue.heroInfoList;
	outArgs.heroBookInfo = dataValue.heroInfoList[Const.HERO_BOOK_INFO_INDEX];
	if (outArgs.heroBookInfo) {
		delete heroInfoList[Const.HERO_BOOK_INFO_INDEX];
	}
	outArgs.heroInfoList = heroInfoList;

	//返回
	return outArgs;
};

// 创建新英雄
var createHero = function(dataValue) {
	// 定义变量
	var outArgs;
	// 获取输入参数
	outArgs = {};

	outArgs.heroInfo = dataValue.heroInfo;
	//返回
	return outArgs;
};

// 提升英雄经验，等级
var upgradeHeroLevel = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, heroId, expPlayer, exp, i;

	// 获取输入参数
	heroId    = inArgs.heroId;
	expPlayer = inArgs.expPlayer;
	exp       = inArgs.exp;

	outArgs = {};

	if (heroId) {
		// 升级单个英雄
		heroHandle.addHeroExp(exp, dataValue.heroInfo);
	}
	else {
		// 升级玩家经验
		playerHandle.addPlayerExp(expPlayer, dataValue.baseInfo);
	}

	// 升级团队英雄经验
	for (i in dataValue.teamHeroList) {
		if (dataValue.teamHeroList.hasOwnProperty(i)) {
			heroHandle.addHeroExp(exp,dataValue.teamHeroList[i]);
		}
	}

	outArgs.playerInfo = dataValue.baseInfo;
	outArgs.playerInfo.teamList = dataValue.teamHeroList;

	return outArgs;
};

/*
*/
// 提升技能槽等级
var upgradeSkillSlot = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, slotId, gold;

	// 获取输入参数
	slotId = inArgs.slotId;

	outArgs = {};

	// 计算技能槽升级参数
	if (dataValue.heroInfo.skillSlotList.hasOwnProperty(slotId)) {
		gold = (100 + 800 * (dataValue.heroInfo.skillSlotList[slotId].level - 1)) * -1;
		if (dataValue.heroInfo.skillSlotList[slotId].level >= Const.SKILL_SLOT_LEVEL_LIMIT) {
			tiny.log.error("upgradeSkillSlot", dataValue.area, dataValue.uuid, ErrCode.FAILURE, slotId + 'slot level limit');
			outArgs.retCode = ErrCode.FAILURE;
			return outArgs;
		}
		// 修改金钱
		if (!playerHandle.addPlayerGold(gold, dataValue.baseInfo)) {
			tiny.log.error("upgradeSkillSlot", dataValue.area, dataValue.uuid, ErrCode.FAILURE, slotId + 'mode gold error');
			outArgs.retCode = ErrCode.FAILURE;
			return outArgs;
		}

		dataValue.heroInfo.skillSlotList[slotId].level++;
	} else {
		tiny.log.error("upgradeSkillSlot", dataValue.area, dataValue.uuid, ErrCode.FAILURE, slotId + 'property error');
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	outArgs.heroInfo = dataValue.heroInfo;
	return outArgs;
};

// 英雄升星
var upgradeHeroStar = function(dataValue) {
	// 定义变量
	var outArgs;

	// 获取输入参数

	outArgs = {};
	// 逻辑计算
	tiny.log.debug("upgradeHeroStar", JSON.stringify(dataValue.heroInfo), JSON.stringify(dataValue.baseInfo), JSON.stringify(dataValue.bagList));
	if (!heroHandle.upgradeHeroStarBaseInfo(dataValue.heroInfo, dataValue.baseInfo)) {
		tiny.log.error("upgradeHeroStar", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "upgradeHeroStarBaseInfo error");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	} 
	if (!heroHandle.upgradeHeroStarBagList(dataValue.heroInfo, dataValue.bagList)) {
		tiny.log.error("upgradeHeroStar", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "upgradeHeroStarBagList error");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	} 
	if (!heroHandle.upgradeHeroStarLevel(dataValue.heroInfo)) {
		tiny.log.error("upgradeHeroStar", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "upgradeHeroStarLevel error");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	outArgs.heroInfo = dataValue.heroInfo;
	return outArgs;
};

// 英雄布阵
var makeHeroLineup = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, posDst, tmp, checkHero = true, i;

	// 获取输入参数

	outArgs = {};
	posDst = inArgs.posDst;

	tiny.log.debug("before lineup", JSON.stringify(dataValue.baseInfo));
	posDst = parseInt(posDst, 10) - Const.LINEUP_MAX_POS;
	if (posDst < Const.LINEUP_MIN_POS
		|| posDst > Const.LINEUP_MAX_POS) {
		outArgs.isOk = ErrCode.NOT_OK;
		tiny.log.error("makeHeroLineup", dataValue.area, dataValue.uuid, ErrCode.NOT_OK, "dst pos don't match " + posDst);
		return outArgs;
	}
	// 布阵
	for (i in dataValue.baseInfo.posList) {
		if (dataValue.baseInfo.posList.hasOwnProperty(i)) {
			if (dataValue.baseInfo.posList[i].heroId === inArgs.heroId) {
				tmp = dataValue.baseInfo.posList[posDst];
				dataValue.baseInfo.posList[posDst] = dataValue.baseInfo.posList[i];
				dataValue.baseInfo.posList[i] = tmp;
				dataValue.baseInfo.posList[posDst].pos = parseInt(posDst, 10) + Const.LINEUP_MAX_POS;
				dataValue.baseInfo.posList[i].pos = parseInt(i, 10) + Const.LINEUP_MAX_POS;
				checkHero = false;
				break;
			}
		}
	}

	// 换将
	if (checkHero) {
		if (dataValue.heroInfo) {
			dataValue.baseInfo.posList[posDst].heroId = inArgs.heroId;
		} else {
			outArgs.isOk = ErrCode.NOT_OK;
			tiny.log.info("makeHeroLineup", dataValue.area, dataValue.uuid, ErrCode.NOT_OK, "heroInfo error :"+checkHero);
			return outArgs;
		}
	}

	outArgs.isOk = ErrCode.OK;
	return outArgs;
};

// 召唤英雄
var rollHero = function(dataValue, inArgs, dataKey) {
	// 定义变量
	var outArgs, rtHeroBookInfo, rollHeroId, heroId, heroBookInfo, heroInfo;

	outArgs = {};
	heroId = parseInt(inArgs.heroId, 10);

	if (dataValue.heroInfoList.hasOwnProperty(heroId) && heroId !== 0) {
		tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "heroId no exist " + heroId);
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	if (!dataValue.heroInfoList.hasOwnProperty(Const.HERO_BOOK_INFO_INDEX)) {
		tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "heroBookInfo no exist");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}
	heroBookInfo = dataValue.heroInfoList[Const.HERO_BOOK_INFO_INDEX];
	if (heroBookInfo.summomNums <= 0) {
		tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "summomNums is " + heroBookInfo.summomNums);
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	// 设置召唤次数
	if (parseInt(heroBookInfo.summomNums,0) >= 0) {
		heroBookInfo.summomNums -= 1;
		heroBookInfo.countSummomNums += 1;
	} else {
		tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "summomNums is error " + heroBookInfo.summomNums);
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	// 3选1随机
	if (heroId !== 0) {
		// 检查该英雄是否已经召唤了
		if (dataValue.heroInfoList.hasOwnProperty(heroId)) {
			tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "heroId has been roll " + heroId);
			outArgs.retCode = ErrCode.FAILURE;
			return outArgs;
		}
		// 检查是否为新手引导英雄
		if (heroHandle.checkGuideHero(heroId)) {
			rollHeroId = heroId;
		} else {
			if (heroId === parseInt(heroBookInfo.heroId1,10) ||
				heroId === parseInt(heroBookInfo.heroId2,10) ||
				heroId === parseInt(heroBookInfo.heroId3,10)) {
				rollHeroId = heroId;
			} else {
				tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "heroId don't match " + heroId);
				outArgs.retCode = ErrCode.FAILURE;
				return outArgs;
			}
		}
	} else {
		// 完全随机
		rollHeroId = heroHandle.getHeroId(dataValue.heroInfoList, heroId);
		if (!rollHeroId){
			tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "heroId end");
			outArgs.retCode = ErrCode.FAILURE;
			return outArgs;
		}
	}

	// 创建新英雄
	heroInfo = heroHandle.createHero(rollHeroId, 0);
	rtHeroBookInfo = heroHandle.rollheroBookInfo(heroBookInfo, dataValue.heroInfoList, heroId);
	//存新英雄数据
	dataValue.heroInfo = heroInfo;
	dataKey.heroId = heroInfo.heroId;
	//存BookInfo数据
	heroHandle.setHeroToHeroList(dataValue.area, dataValue.uuid, Const.HERO_BOOK_INFO_INDEX, rtHeroBookInfo, function(err) {
		if (err) {
			tiny.log.error("rollHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "save heroBookInfo fail");
			outArgs.retCode = ErrCode.FAILURE;
		}
	});

	outArgs.heroInfo = heroInfo;
	outArgs.heroBookInfo = heroBookInfo;
	return outArgs;
};

// 英雄升品
var upgradeHeroQuality = function(dataValue) {
	// 定义变量
	var outArgs;

	outArgs = {};
	// 逻辑计算
	tiny.log.debug("upgradeHeroQuality", JSON.stringify(dataValue.heroInfo), JSON.stringify(dataValue.bagList));
	if (!heroHandle.upgradeHeroQualityBagList(dataValue.heroInfo, dataValue.bagList)) {
		tiny.log.error("upgradeHeroQuality", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "upgradeHeroQualityBagList error");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	} 

	if (!heroHandle.upgradeHeroQualityLevel(dataValue.heroInfo)) {
		tiny.log.error("upgradeHeroQuality", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "upgradeHeroQuality error");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	outArgs.heroInfo = dataValue.heroInfo;
	return outArgs;
};

// 英雄碎片购买
var shopHero = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, bagItem ={};

	//console.log(dataValue);
	outArgs = {};
	// 逻辑计算
	if (!heroHandle.shopHero(inArgs.shopId, dataValue.bagList, dataValue.heroBookInfo, dataValue.baseInfo, bagItem)) {
		tiny.log.error("shopHero", dataValue.area, dataValue.uuid, ErrCode.SHOP_HERO_ERROR, "shopHero error");
		outArgs.retCode = ErrCode.SHOP_HERO_ERROR;
		return outArgs;
	} 

	outArgs.bagItem = bagItem;

	return outArgs;
};

// 刷新英雄商店
var refreshHeroShop = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, time;

	outArgs = {};
	// 逻辑计算
	time = heroHandle.refreshHeroShop(inArgs.isRefresh, dataValue.heroBookInfo, dataValue.baseInfo);
	if (time < 0) {
		tiny.log.error("shopHero", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "refreshHeroShop error");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	outArgs.shop1 = dataValue.heroBookInfo.shop1;
	outArgs.shop2 = dataValue.heroBookInfo.shop2;
	outArgs.shop3 = dataValue.heroBookInfo.shop3;
	outArgs.shop4 = dataValue.heroBookInfo.shop4;
	outArgs.shop5 = dataValue.heroBookInfo.shop5;
	outArgs.refreshNums = dataValue.heroBookInfo.refreshNums;
	outArgs.time = time;
	return outArgs;
};

//洗练英雄
var washHero = function(dataValue, inArgs) {
	// 定义变量
	var outArgs;

	outArgs = {};

	// 洗练英雄
	if (!heroHandle.washHeroInfo(dataValue.heroInfo, dataValue.bagList, dataValue.baseInfo, inArgs)) {
		tiny.log.error("washHero", dataValue.area, dataValue.uuid, ErrCode.WASH_HERO_ERROR, "washHeroInfo error");
		outArgs.retCode = ErrCode.WASH_HERO_ERROR;
		return outArgs;
	}

	outArgs.heroInfo = dataValue.heroInfo;
	return outArgs;
};


// 配置技能槽
var adapterSkillSlot = function(dataValue, inArgs) {
	var outArgs = {}, i;
	outArgs.retCode = ErrCode.SUCCESS;
	for (i = 1; i < 7; i++) {
		if (inArgs["skillId" + i] !== 0) {
			dataValue.heroInfo.skillSlotList[i].skillId = inArgs["skillId" + i];
		}
	}
	outArgs.heroInfo = dataValue.heroInfo;
	return outArgs;
};

module.exports = {
	"adapterSkillSlot" : adapterSkillSlot,
	"getHeroInfoList" : getHeroInfoList,
	"createHero" : createHero,
	"upgradeHeroLevel" : upgradeHeroLevel,
	"upgradeSkillSlot" : upgradeSkillSlot,
	"upgradeHeroStar" : upgradeHeroStar,
	"makeHeroLineup" : makeHeroLineup,
	"rollHero" : rollHero,
	"upgradeHeroQuality" : upgradeHeroQuality,
	"shopHero" : shopHero,
	"washHero" : washHero,
	"refreshHeroShop" : refreshHeroShop,
};
