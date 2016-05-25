var Const = require("../../module/const");
var ErrCode = Const.CLIENT_ERROR_CODE;
var tiny = require('../../tiny');
var playerHandle = require('../../module/dataprocess/player_handle');
var heroHandle = require('../../module/dataprocess/hero_handle');
var skillHandle = require('../../module/dataprocess/skill_handle');
var agentHandle = require('../../module/dataprocess/agent_handle');
var mapImp = require('../../module/map/map_imp');
var playerImp = require('../../module/player/player_imp');
var heroImp = require('../../module/hero/hero_imp');
var equipImp = require('../../module/equip/equip_imp');
var itemImp = require('../../module/item/item_imp');
var hangImp = require('../../module/fight/hangup_imp');
var pvpImp = require('../../module/pvp/pvp_imp');
var mailImp = require('../../module/mail/mail_imp');
var async = require('async');
var utils = require('../../module/utils');

agentHandle.bindImp(exports, mapImp);
utils.bindImp(exports, playerImp);
utils.bindImp(exports, mailImp);
agentHandle.bindImp(exports, hangImp);
agentHandle.bindImp(exports, pvpImp.test);
agentHandle.bindImp(exports, heroImp);
agentHandle.bindImp(exports, itemImp);
agentHandle.bindImp(exports, equipImp);


/*
// 获取技能槽列表信息
exports.getSkillSlotList = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid, area;

	// 获取输入参数
	uuid = inArgs.uuid;
	area = inArgs.area;

	// 处理逻辑
	tiny.log.debug("|getSkillSlotList|uuid:" + uuid + "|" + area);

	outArgs = {};

	skillHandle.getSkillSlotList(area, uuid, function(err, skillSlotList) {
		if (err) {
			tiny.log.error("|getSkillSlotList|uuid:" + uuid + "|" + area + "|" + err);
			retCode = ErrCode.FAILURE;
		} else {
			if (skillSlotList !== undefined) {
				outArgs.skillSlotList = skillSlotList;
				retCode = ErrCode.SUCCESS;
			} else {
				retCode = ErrCode.FAILURE;
			}
		}
		onResponse(retCode, current, inArgs, outArgs);
	});
};

// 升级技能槽
exports.upgradeSkillSlot = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid, area, slotId;

	// 获取输入参数
	uuid = inArgs.uuid;
	area = inArgs.area;
	slotId = inArgs.slotId;

	// 处理逻辑
	tiny.log.debug("|upgradeSkillSlot|uuid:" + uuid + "|" + area);

	outArgs = {};

	skillHandle.upgradeSkillSlot(area, uuid, slotId, function(err, skillSlotList) {
		if (err) {
			tiny.log.error("|upgradeSkillSlot|uuid:" + uuid + "|" + area + "|" + err);
			retCode = ErrCode.FAILURE;
		} else {
			if (skillSlotList !== undefined) {
				outArgs.skillSlotList = skillSlotList;
				retCode = ErrCode.SUCCESS;
			} else {
				retCode = ErrCode.FAILURE;
			}
		}
		onResponse(retCode, current, inArgs, outArgs);
	});
};


// 修改技能槽配置
exports.adapterSkillSlotList = function(inArgs, onResponse, current) {
	// 定义变量
	var retCode, outArgs, uuid, area, adpapter;

	// 获取输入参数
	uuid = inArgs.uuid;
	area = inArgs.area;
	adpapter = inArgs.adpapter;


	// 处理逻辑
	tiny.log.debug("|adapterSkillSlotList|uuid:" + uuid + "|" + area);

	outArgs = {};

	skillHandle.adapterSkillSlotList(area, uuid, adpapter, function(err, skillSlotList) {
		if (err) {
			tiny.log.error("|adapterSkillSlotList|uuid:" + uuid + "|" + area + "|" + err);
			retCode = ErrCode.FAILURE;
		} else {
			if (skillSlotList !== undefined) {
				outArgs.skillSlotList = skillSlotList;
				retCode = ErrCode.SUCCESS;
			} else {
				retCode = ErrCode.FAILURE;
			}
		}
		onResponse(retCode, current, inArgs, outArgs);
	});
};
*/
