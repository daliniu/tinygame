var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var heroHandle = require('../dataprocess/hero_handle');
var playerHandle = require('../dataprocess/player_handle');
var equipHandle = require('../dataprocess/equip_handle');
var bag = require('../bag/bag');
var async = require('async');
var utils = require('../utils');
var eqStar = require("../config/equip/eqStar");
var async = require('async');

// 换装备
var changeEquip = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, sign, seq, ids = {};

	// 获取输入参数
	sign = inArgs.sign;
	seq  = inArgs.seq;

	ids[1] = inArgs.id1;
	ids[2] = inArgs.id2;
	ids[3] = inArgs.id3;
	ids[4] = inArgs.id4;
	ids[5] = inArgs.id5;
	ids[6] = inArgs.id6;

	outArgs = {};
	// 更换具体位置装备
	dataValue.baseInfo.posList = equipHandle.changeEquipInPosition(dataValue.baseInfo.posList, seq, sign, ids, dataValue.bagList);
	// 生成装备列表
	outArgs.equipList = playerHandle.transPosListToEquipList(dataValue.baseInfo.posList, dataValue.bagList.equipList);

	return outArgs;
};

// 装备升星
var upgradeEquipStar = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, ids = {}, equipId, i, gold, equipReult, equip;

	// 获取输入参数
	equipId = inArgs.equipId;
	ids[1] = inArgs.id1;
	ids[2] = inArgs.id2;
	ids[3] = inArgs.id3;
	ids[4] = inArgs.id4;
	ids[5] = inArgs.id5;

	outArgs = {};

	// 检查强化石是否在背包中并且删除强化石
	for (i in ids) {
		if (ids.hasOwnProperty(i)) {
			if (ids[i] && !bag.delItem(ids[i], 1, dataValue.bagList)) {
				tiny.log.error("upgradeEquipStar", dataValue.area, dataValue.uuid, ErrCode.EQUIP_UPGRADE_STAR_ERROR, "ids:" + ids[i] + " is not in bagList");
				outArgs.retCode = ErrCode.EQUIP_UPGRADE_STAR_ERROR;
				return outArgs;
			}
			if (ids[i] && !bag.isStone(ids[i])) {
				tiny.log.error("upgradeEquipStar", dataValue.area, dataValue.uuid, ErrCode.EQUIP_UPGRADE_STAR_ERROR, "ids:" + ids[i] + " is not stone");
				outArgs.retCode = ErrCode.EQUIP_UPGRADE_STAR_ERROR;
				return outArgs;
			}
		}
	}
	// 检查装备是否在背包中
	if (bag.getItemNum(equipId, dataValue.bagList) === 0) {
		tiny.log.error("upgradeEquipStar", dataValue.area, dataValue.uuid, ErrCode.EQUIP_UPGRADE_STAR_ERROR, "equipId:" + equipId + " is not in bagList");
		outArgs.retCode = ErrCode.EQUIP_UPGRADE_STAR_ERROR;
		return outArgs;
	}
	// 取装备信息
	equip = dataValue.bagList.equipList[equipId];
	// 判断装备星级
	if (equip.star >= Const.EQUIP_STAR_LEVEL_LIMIT) {
		tiny.log.error("upgradeEquipStar", dataValue.area, dataValue.uuid, ErrCode.EQUIP_UPGRADE_STAR_ERROR, "equipId:" + equipId + " is level limit");
		outArgs.retCode = ErrCode.EQUIP_UPGRADE_STAR_ERROR;
		return outArgs;
	}
	// 取配置表信息
	if (!eqStar[equip.star + 1] || !eqStar[equip.star + 1].cost) {
		tiny.log.error("upgradeEquipStar", dataValue.area, dataValue.uuid, ErrCode.EQUIP_UPGRADE_STAR_ERROR, "equipId:" + equipId + " config is error");
		outArgs.retCode = ErrCode.EQUIP_UPGRADE_STAR_ERROR;
		return outArgs;
	}
	// 取扣费金钱
	gold = eqStar[equip.star + 1].cost;
	gold = Number.parseInt(gold, 10) * -1;
	// 扣费
	if (!playerHandle.addPlayerGold(gold, dataValue.baseInfo)) {
		tiny.log.error("upgradeEquipStar", dataValue.area, dataValue.uuid, ErrCode.EQUIP_UPGRADE_STAR_ERROR, "equipId:" + equipId + " no gold");
		outArgs.retCode = ErrCode.EQUIP_UPGRADE_STAR_ERROR;
		return outArgs;
	}

	// 获取升星后的装备
	if (ids) {
		dataValue.bagList.equipList[equipId].star++;
		equipReult = {};
		equipReult = dataValue.bagList.equipList[equipId];
		equipReult.index = equipId;
	}
	
	outArgs.equip = equipReult;
	return outArgs;	
};

// 装备拆分
var splitEquip = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, equipIdList, result, gold, equip, i, equipId;

	// 获取输入参数
	equipIdList = JSON.parse(inArgs.equipIdList);

	outArgs = {};
	gold = 0;
	result = {};
	result.itemList = {};
	for (i = 0; i < equipIdList.length; i++) {
		equipId = equipIdList[i];
		// 检查装备是否在背包中
		if (bag.getItemNum(equipId, dataValue.bagList) === 0) {
			tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "equipId:" + equipId + " is not in bagList");
			outArgs.retCode = ErrCode.FAILURE;
			break;
		}
		// 取装备信息
		equip = dataValue.bagList.equipList[equipId];
		// 取拆分结构
		if (equip.star !== 0) {
			// 取配置表信息
			if (!eqStar[equip.star] || !eqStar[equip.star].splitReturn) {
				tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "equipId:" + equipId + " config is error");
				outArgs.retCode = ErrCode.FAILURE;
				break;
			}
			// 取金钱
			gold += equipHandle.getGoldFromSplitConfig(eqStar[equip.star].splitReturn);
			// 获取拆分道具,删除装备
			equipHandle.dealSplitEquipInBagList(dataValue.bagList, eqStar[equip.star].splitReturn, equipId, result);
			if (!result) {
				tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "equipId:" + equipId + " is not in bagList");
				outArgs.retCode = ErrCode.FAILURE;
				break;
			}
		} else {
			equipHandle.dealSplitEquipInBagList(dataValue.bagList, null, equipId, result);
			if (!result) {
				tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "equipId:" + equipId + " is not in bagList");
				outArgs.retCode = ErrCode.FAILURE;
				break;
			}
			gold += 100;
		}
	}
	// 增加金钱
	if (!playerHandle.addPlayerGold(gold, dataValue.baseInfo)) {
		tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "add gold fail!" + gold);
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}


	outArgs.splitList = result.itemList;
	outArgs.gold = gold;
	return outArgs;

};

// 装备淬炼
var meltingEquip = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, lequipId, requipId, attr, result, splitReturn, gold, equip;

	// 获取输入参数
	lequipId = inArgs.lequipId;
	requipId = inArgs.requipId;
	attr = inArgs.attr;
	outArgs = {};

	result = {};
	result.itemList = {};
	// 检查装备是否在背包中
	if (bag.getItemNum(lequipId, dataValue.bagList) === 0) {
		tiny.log.error("meltingEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "lequipId:" + ErrCode.FAILURE + " is not in bagList");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}
	if (bag.getItemNum(requipId, dataValue.bagList) === 0) {
		tiny.log.error("meltingEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "requipId:" + requipId + " is not in bagList");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}
	// 取拆分结构
	if (dataValue.bagList.equipList[requipId].star === 0) {
		splitReturn = {};
		gold = 100;
	} else {
		splitReturn = eqStar[dataValue.bagList.equipList[requipId].star].splitReturn;
		// 取金钱
		gold = equipHandle.getGoldFromSplitConfig(splitReturn);
	}
	// 增加金钱
	if (!playerHandle.addPlayerGold(gold, dataValue.baseInfo)) {
		tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "add gold fail!" + gold);
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	// 淬炼装备属性
	equip = equipHandle.dealAttrInEquip(dataValue.bagList, lequipId, requipId, attr);
	if (!equip) {
		tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "get equip attr fail");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}
	equip.index = lequipId;
	// 获取拆分道具,删除装备
	equipHandle.dealSplitEquipInBagList(dataValue.bagList, splitReturn, requipId, result);
	if (!result) {
		tiny.log.error("splitEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "requipId:" + requipId + " is not in bagList");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}

	outArgs.splitList = result.itemList;
	outArgs.equip = equip;
	outArgs.gold = gold;
	return outArgs;
};

// 反装备淬炼
var rvmeltingEquip = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, equipId, equip;

	// 获取输入参数
	equipId = inArgs.equipId;

	outArgs = {};

	// 检查装备是否在背包中
	if (bag.getItemNum(equipId, dataValue.bagList) === 0) {
		tiny.log.error("rvmeltingEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, "equipId:" + equipId + " is not in bagList");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}
	// 为装备反转属性
	equip = equipHandle.rvdealAttrInEquip(dataValue.bagList, equipId);
	if (!equip) {
		tiny.log.error("rvmeltingEquip", dataValue.area, dataValue.uuid, ErrCode.FAILURE, equipId + " rvmelting fail!");
		outArgs.retCode = ErrCode.FAILURE;
		return outArgs;
	}
	equip.index = equipId;
	outArgs.equip = equip;

	return outArgs;
};

// 打造装备
var makeEquip = function(dataValue, inArgs) {
	// 定义变量
	var outArgs, scrollList, equipData, itemId, i, equipList = {};
	// 获取输入参数
	scrollList = inArgs.scrollList;
	outArgs = {};

	for (i = 0; i < scrollList.length; i++) {
		if (scrollList.hasOwnProperty(i)) {
			// 检查背包空间是否足够
			if (bag.getLeftRoom(dataValue.bagList) === 0) {
				tiny.log.info("makeEquip", dataValue.area, dataValue.uuid, ErrCode.EQUIP_CREATE_ERROR, "check bag space error");
				outArgs.retCode = ErrCode.EQUIP_CREATE_ERROR;
				break;
			}
			// 检查配置背包
			itemId = equipHandle.checkMakeConfig(dataValue.bagList, scrollList[i]);
			if (!itemId) {
				tiny.log.error("makeEquip", dataValue.area, dataValue.uuid, ErrCode.EQUIP_CREATE_ERROR, "checkMakeConfig error");
				outArgs.retCode = ErrCode.EQUIP_CREATE_ERROR;
				break;
			}
			// 创建装备
			equipData = equipHandle.createEquip(itemId);
			// 添加到背包
			if (!bag.addEquip(equipData.index, equipData.equipInfo, dataValue.bagList)) {
				tiny.log.error("makeEquip", dataValue.area, dataValue.uuid, ErrCode.EQUIP_CREATE_ERROR, "addEquip error");
				outArgs.retCode = ErrCode.EQUIP_CREATE_ERROR;
				break;
			}
			equipList[equipData.index] = equipData.equipInfo;
		}
	}
	outArgs.equipList = equipList;
	return outArgs;
};

// 开启背包格子
var unlockBag = function(dataValue) {
	// 定义变量
	var outArgs, diamond;

	outArgs = {};
	// 开启背包格子
	diamond = equipHandle.unlockBag(dataValue.bagList);
	if (diamond === null) {
		tiny.log.error("unlockBag", dataValue.area, dataValue.uuid, ErrCode.BAG_UNLOCK_ERROR, "unlockBag fail!");
		outArgs.retCode = ErrCode.BAG_UNLOCK_ERROR;
		return outArgs;
	}

	if (!playerHandle.addPlayerDiamond(diamond, dataValue.baseInfo)) {
		tiny.log.error("unlockBag", dataValue.area, dataValue.uuid, ErrCode.BAG_UNLOCK_ERROR, "Diamond error");
		outArgs.retCode = ErrCode.BAG_UNLOCK_ERROR;
		return outArgs;
	}

	outArgs.max = dataValue.bagList.max;
	return outArgs;
};


module.exports = {
	"changeEquip" : changeEquip,
	"upgradeEquipStar" : upgradeEquipStar,
	"splitEquip" : splitEquip,
	"makeEquip" : makeEquip,
	"unlockBag" : unlockBag,
	"meltingEquip" : meltingEquip,
	"rvmeltingEquip" : rvmeltingEquip,
};

