var Const = require("../const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var UseType = Const.ITEM.USE_TYPE;
var ItemMainType = Const.ITEM.MAIN_TYPE;
var tiny = require('../../tiny');
var playerHandle = require('../dataprocess/player_handle');
var equipHandle = require('../dataprocess/equip_handle');
var heroHandle = require('../dataprocess/hero_handle');
var Item = require('../config/pick/item');
var Compose = require('../config/equip/compose');
var bag = require('../bag/bag');
var async = require('async');
var utils = require('../utils');
var itemfunc = require('./item');

var sellItemGroup = function(dataValue, inArgs) {
	var sellgroup = inArgs.sellgroup,
		outArgs = {},
		itemID,
		num,
		index,
		cost = 0,
		price = 0,
		isEquip = false,
		itemNum;

	outArgs.cost = 0;
	// 遍历检查道具是否均可以卖
	for (index in sellgroup) {
		if (sellgroup.hasOwnProperty(index)) {
			num = Number.parseInt(sellgroup[index]);
			if (isNaN(num) || num < 0) {
				tiny.log.error("sellItemGroup", ErrCode.ITEM_SELL_NUM_ERROR, 'item num error ' + num);
				outArgs.retCode = ErrCode.ITEM_SELL_NUM_ERROR;
				break;
			}
			// 索引转id
			if (dataValue.bagList.equipList.hasOwnProperty(index)) {
				itemID = dataValue.bagList.equipList[index].id;
				isEquip = true;
			} else {
				itemID = index;
			}
			if (!Item.hasOwnProperty(itemID) || Item[itemID].sell !== 1) {
				tiny.log.error("sellItemGroup", ErrCode.ITEM_CANNOT_SELL, 'itemid error ' + itemID);
				outArgs.retCode = ErrCode.ITEM_CANNOT_SELL;
				break;
			}
			price = Number.parseInt(Item[itemID].price);
			if (isNaN(price) || price < 0) {
				tiny.log.error("sellItemGroup", ErrCode.ITEM_SELL_PRICE_WRONG, 'price error' + price);
				outArgs.retCode = ErrCode.ITEM_SELL_PRICE_WRONG;
				break;
			}
			// 检查背包内是否有这么多这种道具
			itemNum = bag.getItemNum(index, dataValue.bagList);
			if (itemNum < num) {
				tiny.log.error("sellItemGroup", ErrCode.ITEM_NUM_NOT_ENOUGH, itemNum + ' ' + num);
				tiny.log.trace('sellItemGroup', 'itemnum less', index, itemNum, num, JSON.stringify(dataValue.bagList));
				outArgs.retCode = ErrCode.ITEM_NUM_NOT_ENOUGH;
				break;
			}
			// 删除道具
			if (!bag.delItem(index, num, dataValue.bagList)) {
				tiny.log.error("sellItemGroup", ErrCode.ITEM_DEL_ERROR, index + ' ' + itemNum);
				tiny.log.trace('sellItemGroup', 'del item fail', index, num, JSON.stringify(dataValue.bagList));
				outArgs.retCode = ErrCode.ITEM_DEL_ERROR;
				break;
			}
			if (isEquip) {
				equipHandle.offEquip(dataValue.baseInfo, index);
			}
			cost = cost + price * num;
		}
	}

	outArgs.cost = cost;
	console.log(outArgs);
	return outArgs;
};

var compose = function(dataValue, inArgs) {
	var itemID = inArgs.item,
		num = inArgs.num,
		composeID = inArgs.composeid,
		outArgs = {},
		i,
		targetID = Compose[composeID].itemId,
		demand = Compose[composeID].demandItemId,
		targetNum = 0,
		costings = {},
		itemNum = 0,
		deItem,
		demandOK = false,
		room = 0,
		delOK = false;

	outArgs.target = 0;
	outArgs.num = 0;
	outArgs.costings = {};


	if (!Item.hasOwnProperty(itemID)) {
		tiny.log.error("compose", ErrCode.ITEM_NO_THIS_ITEM);
		outArgs.retCode = ErrCode.ITEM_NO_THIS_ITEM;
		return outArgs;
	}

	if (Item[itemID].compose !== composeID || !Compose.hasOwnProperty(composeID)) {
		tiny.log.error("compose", ErrCode.ITEM_COMPOSE_ID_ERROR, Item[itemID].compose + ' ' + composeID);
		outArgs.retCode = ErrCode.ITEM_COMPOSE_ID_ERROR;
		return outArgs;
	}

	// 合成道具
	for (i = 0; i < num; ++i) {
		// 检查背包内是否有此道具，并检查合成id是否正确
		itemNum = bag.getItemNum(itemID, dataValue.bagList);
		if (itemNum <= 0) {
			tiny.log.debug('compose', itemID, itemNum);
			outArgs.retCode = ErrCode.ITEM_COMPOSE_NOT_IN_BAG;
			break;
		}
		demandOK = true;
		// 检查背包内合成材料是否足够
		for (deItem in demand) {
			if (demand.hasOwnProperty(deItem)) {
				itemNum = bag.getItemNum(demand[deItem][1], dataValue.bagList);
				if (itemNum < demand[deItem][2]) {
					demandOK = false;
					outArgs.retCode = ErrCode.ITEM_COMPOSE_DEMAND_LESS;
					tiny.log.debug('compose', itemNum, demand[deItem][1], demand[deItem][2]);
					break;
				}
			}
		}
		if (!demandOK) {
			break;
		}
		// 检查背包空格够不够
		room = bag.getLeftRoom(dataValue.bagList);
		if (room < 1) {
			tiny.log.debug('compose', 'no enough room', room);
			outArgs.retCode = ErrCode.BAG_FREE_ROOM_LIMIT;
			break;
		}
		// 扣除合成材料并产生新道具添加进背包
		delOK = true;
		for (deItem in demand) {
			if (demand.hasOwnProperty(deItem)) {
				if (!bag.delItem(demand[deItem][1], demand[deItem][2], dataValue.bagList)) {
					tiny.log.error('compose', 'delItem fail', demand[deItem][1], demand[deItem][2]);
					delOK = false;
					outArgs.retCode = ErrCode.BAG_FREE_ROOM_LIMIT;
					break;
				}
				if (costings.hasOwnProperty(demand[deItem][1])) {
					costings[demand[deItem][1]] = costings[demand[deItem][1]] + demand[deItem][2];
				} else {
					costings[demand[deItem][1]] = demand[deItem][2];
				}
			}
		}
		if (delOK && bag.addItem(targetID, 1, dataValue.bagList)) {
			// 修改返回参数中的消耗和合成数量
			targetNum = targetNum + 1;
		} else {
			tiny.log.error('compose', 'addItem fail', targetID);
			outArgs.retCode = ErrCode.BAG_ADD_ERROR;
			break;
		}
	}

	outArgs.target = targetID;
	outArgs.num = targetNum;
	outArgs.costings = costings;
	return outArgs;
};

var useItem = function(dataValue, inArgs) {
	var itemID = inArgs.item,
		outArgs = {},
		useType,
		bagAdd = {},
		i,
		exp = 0,
		gold = 0,
		diamond = 0,
		action = 0,
		itemNum = 0,
		retPack;

	outArgs.item = itemID;
	outArgs.heroInfoList = {};

	// 检查合成ID是否正确
	if (!Item.hasOwnProperty(itemID)) {
		tiny.log.error("useItem", ErrCode.ITEM_NO_THIS_ITEM);
		outArgs.retCode = ErrCode.ITEM_NO_THIS_ITEM;
		return outArgs;
	}

	if (Item[itemID].hasOwnProperty('userTeyp')) {
		useType = Item[itemID].userTeyp;
	} else {
		tiny.log.error("useItem", ErrCode.ITEM_USE_NO_EFFECT, itemID + ' ' + 'have no effect userTeyp');
		outArgs.retCode = ErrCode.ITEM_USE_NO_EFFECT;
		return outArgs;
	}

	// 使用道具
	// 检查背包内是否有此道具，并检查合成id是否正确
	itemNum = bag.getItemNum(itemID, dataValue.bagList);
	if (itemNum <= 0) {
		tiny.log.error("useItem", ErrCode.ITEM_NUM_NOT_ENOUGH, 'bag have no this item ' + itemID);
		outArgs.retCode = ErrCode.ITEM_NUM_NOT_ENOUGH;
		return outArgs;
	}
	// 扣除道具并保存效果
	if (!bag.delItem(itemID, 1, dataValue.bagList)) {
		tiny.log.error("useItem", ErrCode.ITEM_DEL_ERROR, 'delItem fail ' + itemID);
		outArgs.retCode = ErrCode.ITEM_DEL_ERROR;
		return outArgs;
	}

	// 检查道具效果是否能产生
	for (i in useType) {
		if (useType.hasOwnProperty(i)) {
			tiny.log.debug("useType", useType[i][1]);
			if (useType[i][1] === UseType.ADD_ACTION) {
				action = utils.checkValue(useType[i][2]);
				dataValue.baseInfo.action = utils.addValue(dataValue.baseInfo.action + action);
			} else if (useType[i][1] === UseType.ADD_TEAM_EXP) {
				exp = utils.checkValue(useType[i][2]);
				playerHandle.addPlayerExp(exp, dataValue.baseInfo);
			} else if (useType[i][1] === UseType.ADD_GOLD) {
				gold = utils.checkValue(useType[i][2]);
				dataValue.baseInfo.gold = utils.addValue(dataValue.baseInfo.gold + gold);
			} else if (useType[i][1] === UseType.ADD_DIAMOND) {
				diamond = utils.checkValue(useType[i][2]);
				dataValue.baseInfo.diamond = utils.addValue(dataValue.baseInfo.diamond + diamond);
			} else if (useType[i][1] === UseType.OPEN_BOX) {
				retPack = itemfunc.dropPool(useType[i][2], dataValue.baseInfo, dataValue.bagList, dataValue.nodeInfo);
				if (retPack[0]) {
					tiny.log.error("useItem", ErrCode.DROP_POLL_ERROR, useType[i][2]);
					outArgs.retCode = ErrCode.DROP_POLL_ERROR;
					return outArgs;
				}
			} else if (useType[i][1] === UseType.ADD_HERO_EXP) {
				// 增加英雄经验
				exp = utils.checkValue(useType[i][2]);
				heroHandle.addHeroExp(exp, dataValue.heroInfo);
				outArgs.heroInfoList[inArgs.heroId] = dataValue.heroInfo;
			} else if (useType[i][1] === UseType.ADD_HERO) {
				// 临时创建英雄，道具爆英雄逻辑
				outArgs.heroInfoList = heroHandle.createHeroTmp(dataValue.area, dataValue.uuid, useType[i][2]);
			}
		}
	}

	outArgs.baseInfo = dataValue.baseInfo;
	if (retPack && retPack[1]) {
		outArgs.bagItem = retPack[1];
	} else {
		outArgs.bagItem = {};
	}

	return outArgs;
};

var test_addItem = function(dataValue, inArgs) {
	var itemID = inArgs.itemid,
		outArgs = {},
		equip,
		item,
		room, temp;
	outArgs.item = {};

	// 检查道具ID是否正确
	if (!Item.hasOwnProperty(itemID)) {
		tiny.log.error("test_addItem", ErrCode.ITEM_NO_THIS_ITEM);
		outArgs.retCode = ErrCode.ITEM_NO_THIS_ITEM;
		return outArgs;
	}

	// 增加道具
	// 检查背包空格够不够
	room = bag.getLeftRoom(dataValue.bagList);
	if (room < 1) {
		tiny.log.debug('test_addItem', 'no enough room', room);
		outArgs.retCode = ErrCode.BAG_FREE_ROOM_LIMIT;
		return outArgs;
	}
	if (parseInt(Item[itemID].itemTepy, 10) === ItemMainType.EQUIP) {
		temp = equipHandle.createEquip(itemID);
		if (!bag.addEquip(temp.index, temp.equipInfo, dataValue.bagList)) {
			tiny.log.error("test_addItem", ErrCode.BAG_ADD_ERROR);
			outArgs.retCode = ErrCode.BAG_ADD_ERROR;
			return outArgs;
		}
		equip = {};
		equip[temp.index] = temp.equipInfo;
		item = equip;
	} else {
		if (!bag.addItem(itemID, 1, dataValue.bagList)) {
			tiny.log.error("test_addItem", ErrCode.BAG_ADD_ERROR);
			outArgs.retCode = ErrCode.BAG_ADD_ERROR;
			return outArgs;
		}
		item = {};
		item[itemID] = {"num": 1};
	}

	outArgs.item = item;
	return outArgs;
};

var test_addValue = function(dataValue, inArgs) {
	var type = inArgs.type,
		value = inArgs.value,
		outArgs = {},
		action, gold, diamond;
	outArgs.type = type;
	outArgs.value = 0;

	// 增加数值
	if (type === UseType.ADD_ACTION) {
		action = utils.checkValue(value);
		dataValue.baseInfo.action = utils.addValue(dataValue.baseInfo.action + action);
		outArgs.value = dataValue.baseInfo.action;
	} else if (type === UseType.ADD_GOLD) {
		gold = utils.checkValue(value);
		dataValue.baseInfo.gold = utils.addValue(dataValue.baseInfo.gold + gold);
		outArgs.value = dataValue.baseInfo.gold;
	} else if (type=== UseType.ADD_DIAMOND) {
		diamond = utils.checkValue(value);
		dataValue.baseInfo.diamond = utils.addValue(dataValue.baseInfo.diamond + diamond);
		outArgs.value = dataValue.baseInfo.diamond;
	}

	return outArgs;
};

module.exports = {
	"sellItemGroup" : sellItemGroup,
	"compose" : compose,
	"useItem" : useItem,
	"test_addItem" : test_addItem,
	"test_addValue" : test_addValue,
};
