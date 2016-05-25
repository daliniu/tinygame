var util = require('util');
var EventEmitter = require('events').EventEmitter;
var nodeUUID = require('node-uuid');
var async = require('async');

var tiny = require('../../tiny');
var utils = require('../utils');
var Const = require('../const');
var playerHandle = require('./player_handle');
var equipHandle = require('./equip_handle');
var bag = require('../bag/bag');
var item = require('../item/item');
/*
// 英雄信息列表
key : heroId                //英雄id
value : HeroInfo
{
	curExp	              //当前经验
	level                 //等级
	star                  //星级
	quality               //品质
	skillList           //技能列表
	{
		skillId,
	}
	//技能槽列表
	SkillSlotList
	{
		1 : {level : 1},
		2 : {level : 1},
		3 : {level : 1},
		4 : {level : 1},
		5 : {level : 1},
		6 : {level : 1}
	}
}
*/
var convertGainskill = function(gainSkill) {
	var i, g = {};
	for (i in gainSkill) {
		if (gainSkill.hasOwnProperty(i)) {
			g[gainSkill[i][2]] = gainSkill[i][1];
		}
	}
	return g;
};
var guideHero = {};
var convertCharacter = function(character) {
	var i;
	for (i in character) {
		if (character.hasOwnProperty(i)) {
			character[i].skillid = utils.jsonToArray(character[i].skillid);
			character[i].gainskill = convertGainskill(character[i].gainskill);
			if (character[i].freehero !== 0) {
				guideHero[character[i].freehero[2]] = i;
			}
		}

	}
	return character;
};
var convertHeroShop = function(_heroShop) {
	var i, heroShop = {};
	heroShop[1] = [];
	heroShop[2] = [];
	heroShop[3] = [];
	heroShop[4] = [];
	heroShop[5] = [];
	for (i in _heroShop) {
		if (_heroShop.hasOwnProperty(i)) {
			if (_heroShop[i].hasOwnProperty("1st")) {
				heroShop[1].push(_heroShop[i]["1st"]);
			}
			if (_heroShop[i].hasOwnProperty("2st")) {
				heroShop[2].push(_heroShop[i]["2st"]);
			}
			if (_heroShop[i].hasOwnProperty("3st")) {
				heroShop[3].push(_heroShop[i]["3st"]);
			}
			if (_heroShop[i].hasOwnProperty("4st")) {
				heroShop[4].push(_heroShop[i]["4st"]);
			}
			if (_heroShop[i].hasOwnProperty("5st")) {
				heroShop[5].push(_heroShop[i]["5st"]);
			}
		}
	}
	return heroShop;
};
var convertCompose = function(_compose) {
	var i, compose = {};
	for (i in _compose) {
		if (_compose.hasOwnProperty(i)) {
			compose[_compose[i].itemId] = _compose[i];
		}
	}
	return compose;
};
var Character = convertCharacter(require('../config/character/character'));
var Heroquality = require('../config/hero/heroquality');
var HeroStar = require('../config/hero/herostar');
var HeroQualityConsume = require('../config/hero/heroqualityconsume');
var HeroShop = convertHeroShop(require('../config/hero/heroshop'));
var Compose = convertCompose(require('../config/equip/compose'));
var convertSuitAu = function(_suitAu) {
	var i, j, key, suitAu = {};
	for (i in _suitAu) {
		if (_suitAu.hasOwnProperty(i)) {
			if (!suitAu[_suitAu[i].heroId]) {
				suitAu[_suitAu[i].heroId] = {};
			}
			for (j = 1; j <= 5; ++j) {
				key = 'chance' + j;
				if (!suitAu[_suitAu[i].heroId][key]) {
					suitAu[_suitAu[i].heroId][key] = {};
					suitAu[_suitAu[i].heroId][key].weight = [];
					suitAu[_suitAu[i].heroId][key].index = [];
				}
				suitAu[_suitAu[i].heroId][key].weight.push(_suitAu[i][key]);
				suitAu[_suitAu[i].heroId][key].index.push(_suitAu[i].Bid);
			}
		}
	}
	return suitAu;
};
var SuitAu = convertSuitAu(require('../config/character/suitAu'));
var Exprience = require('../config/player/experience');

// 随机英雄碎片
var randomHeroShop = function(pos) {
	var i;
	if (HeroShop[pos].length <= 0) {
		tiny.log.error("HeroShop config error");
		return 0;
	}
	i = utils.randomInt(0, HeroShop[pos].length - 1);
	tiny.log.debug("random i:" + i + " " +HeroShop[pos].length);
	return HeroShop[pos][i];
};

// 计算英雄升级经验
var getExpForUpgradeLevel = function(curLevel) {
	//return Math.pow((curLevel + 8), 3) * 2;
	if (Exprience.hasOwnProperty(curLevel) && Exprience[curLevel].experience) {
		return parseInt(Exprience[curLevel].experience, 10);
	}
	return parseInt(Const.EXP_LEVEL_LIMIT, 10);
};

// 创建新英雄
var createHero = function(heroId, pos) {
	tiny.log.debug("createHero", heroId);
	var heroInfo = {};
	if (Character[heroId] && Character[heroId].skillid) {
		heroInfo.skillList = Character[heroId].skillid;
	}
	heroInfo.heroId = heroId;
	heroInfo.curExp = 0;
	heroInfo.level = 1;
	heroInfo.star = 1;
	heroInfo.quality = 0;
	heroInfo.skillSlotList = {
		1 : {skillId : 0, level : 1},
		2 : {skillId : 0, level : 1},
		3 : {skillId : 0, level : 1},
		4 : {skillId : 0, level : 1},
		5 : {skillId : 0, level : 1},
		6 : {skillId : 0, level : 1}
	};
	heroInfo.pos = pos;
	heroInfo.suitId1 = utils.randomScope(SuitAu[heroId].chance1.index, SuitAu[heroId].chance1.weight);
	heroInfo.suitId2 = utils.randomScope(SuitAu[heroId].chance2.index, SuitAu[heroId].chance2.weight);
	heroInfo.suitId3 = utils.randomScope(SuitAu[heroId].chance3.index, SuitAu[heroId].chance3.weight);
	heroInfo.suitId4 = utils.randomScope(SuitAu[heroId].chance4.index, SuitAu[heroId].chance4.weight);
	heroInfo.suitId5 = utils.randomScope(SuitAu[heroId].chance5.index, SuitAu[heroId].chance5.weight);

	return heroInfo;
};
// 导出createHero接口
exports.createHero = createHero;

// 计算英雄战斗力
/*
exports.getHeroPower = function(heroInfo) {
	if (!Character.hasOwnProperty(heroInfo.heroId)) {
		tiny.log.error(" Character don't the heroId", heroInfo.heroId);
		return 0;
	}
	// atk    critrate    increasehurt   hits   hp    reducehurt     dodgerate
	// 战斗力=（（攻击力*（1+暴击率）*（1+穿透率）*命中率）*（生命值/（1-减伤比）/闪避率））/100
	// 品质 + 等级 + 星级   hp   atk    defense
	var hp, atk, defense, power,  reducehurt, heroConfig = Character[heroInfo.heroId];

	// 初始成长
	hp      = heroConfig.levelgrowing[1];
	atk     = heroConfig.levelgrowing[2];
	defense = heroConfig.levelgrowing[3];

	// 星级成长
	if (heroInfo.star !== 0 && heroConfig.stargrowing[heroInfo.star]) {
		hp      += heroConfig.stargrowing[heroInfo.star][1];
		atk     += heroConfig.stargrowing[heroInfo.star][2];
		defense += heroConfig.stargrowing[heroInfo.star][3];
	}

	// 等级成长
	hp      *= heroInfo.level;
	atk     *= heroInfo.level;
	defense *= heroInfo.level;

	// 品质成长
	if (heroInfo.quality !== 0 && Heroquality[heroInfo.quality]) {
		hp += Heroquality[heroInfo.quality].hp;
		atk += Heroquality[heroInfo.quality].ap;
		defense += Heroquality[heroInfo.quality].def;
	}

	// 计算减伤比
	reducehurt = heroConfig.reducehurt + defense / (atk / 4 + defense);

	// 计算战斗力
	power = (atk * (heroConfig.critrate / 100 + 1)  * (1 + heroConfig.increasehurt) * heroConfig.hits) *
			(hp / (1 - reducehurt / 100) / heroConfig.dodgerate) / 100;

	return power;
};
*/
exports.getHeroPower = function(heroInfo) {
	if (!heroInfo) {
		tiny.log.error(" getHeroPower don't hava a hero");
		return 0;
	}
	if (!Character.hasOwnProperty(heroInfo.heroId)) {
		tiny.log.error(" Character don't the heroId", heroInfo.heroId);
		return 0;
	}
	var x, hp, atk, def, hpRate = 0, atkRate = 0, defRate = 0, power, heroConfig = Character[heroInfo.heroId];

	// 初始成长
	x       = heroConfig.grow_base[1];
	hp      = heroConfig.grow_base[2];
	atk     = heroConfig.grow_base[3];
	def     = heroConfig.grow_base[3];

	// 星级成长
	if (heroInfo.star !== 0 && heroConfig.stargrowing[heroInfo.star]) {
		hpRate  += heroConfig.grow_rate[heroInfo.star][1];
		atkRate += heroConfig.grow_rate[heroInfo.star][2];
		defRate += heroConfig.grow_rate[heroInfo.star][3];
	}

	// 等级成长
	hp  = hpRate * hp * heroInfo.level + x * hp;
	atk = atkRate * atk * heroInfo.level + x * atk;
	def = defRate * def * heroInfo.level + x * def;

	// 品质成长
	if (heroInfo.quality !== 0 && Heroquality[heroInfo.quality]) {
		hp += Heroquality[heroInfo.quality].hp;
		atk += Heroquality[heroInfo.quality].ap;
		def += Heroquality[heroInfo.quality].def;
	}

	// 计算战斗力
	power = hp + atk + def;

	tiny.log.debug("power", hp, atk, def, power);
	return Math.floor(power);
};

// 创建英雄图鉴信息
var createHeroBookInfo = function() {
	var n = parseInt(Date.now() / 1000, 10);
	return {
		heroId1    : 10001,
		heroId2    : guideHero[2],
		heroId3    : guideHero[3],
		summomNums : 10,
		countSummomNums : 0,
		shop1      : randomHeroShop(1),
		shop2      : randomHeroShop(2),
		shop3      : randomHeroShop(3),
		shop4      : randomHeroShop(4),
		shop5      : randomHeroShop(5),
		refreshNums: 3,
		time       : n,
	};
};

// 创建英雄列表
exports.createHeroList = function(area, uuid, callback) {
	var heroInfoList = {};
	// 创建默认英雄
	heroInfoList[Const.HERO_BOOK_INFO_INDEX] = utils.setObject(createHeroBookInfo());
	heroInfoList[guideHero[1]] = utils.setObject(createHero(guideHero[1], 0));
	heroInfoList[10013] = utils.setObject(createHero(10013, 0));
	heroInfoList[10004] = utils.setObject(createHero(10004, 0));
	exports.setHeroInfoList(area, uuid, heroInfoList, callback);
};

// 计算经验和等级
exports.calExpAndLevel = function(object) {
	var upgradeExp = 0,
		func = function(err, heroBookInfo) {
			if (!err) {
				if (object.level !== 10) {
					heroBookInfo.summomNums += 1;
				}
				exports.setHeroInfo(object.area, object.uuid, Const.HERO_BOOK_INFO_INDEX, heroBookInfo);
			}
		};
	if (object.level) {
		// 升级需要经验
		upgradeExp = getExpForUpgradeLevel(object.level);
		// 计算升级级数
		while (parseInt(object.curExp,10) >= upgradeExp) {
			object.level = parseInt(object.level,10) + 1;
			object.curExp = parseInt(object.curExp,10) - upgradeExp;
			upgradeExp = getExpForUpgradeLevel(object.level);
			// 玩家升级每5级增加召唤次数
			if (parseInt(object.level, 10) !== 0 && parseInt(object.level, 10) % 5 === 0) {
				exports.getHeroInfo(object.area, object.uuid, Const.HERO_BOOK_INFO_INDEX, func);
			}
		}
		//返回
		return object.level;
	}
	return -1;
};

exports.calHeroExpAndLevel = function(heroInfo) {
	var upgradeExp = 0;
	if (heroInfo.level) {
		// 升级需要经验
		upgradeExp = getExpForUpgradeLevel(heroInfo.level);
		// 计算升级级数
		while (parseInt(heroInfo.curExp,10) >= upgradeExp) {
			heroInfo.level = parseInt(heroInfo.level,10) + 1;
			heroInfo.curExp = parseInt(heroInfo.curExp,10) - upgradeExp;
			upgradeExp = getExpForUpgradeLevel(heroInfo.level);
		}
		//返回
		return heroInfo.level;
	}
	return -1;
};

// 计算超过等级上限情况
exports.limitLevel  = function(level) {
	var limit = parseInt(level,10);
	if (limit > parseInt(Const.PLAYER_LEVEL_LIMIT,10)) {
		return parseInt(Const.PLAYER_LEVEL_LIMIT,10);
	}
	return limit;
};

// 增加英雄经验值
exports.addHeroExp = function(exp, heroInfo) {
	var upgradeLevel = 0;
	if (exp > parseInt(Const.EXP_LEVEL_LIMIT, 10)) {
		exp = parseInt(Const.EXP_LEVEL_LIMIT, 10);
	}
	// 增加经验
	heroInfo.curExp = parseInt(heroInfo.curExp,10) + exp;

	// 计算是否升级以及升级等级
	upgradeLevel = exports.calHeroExpAndLevel(heroInfo);
	// 计算超过等级上限情况
	heroInfo.level = exports.limitLevel(upgradeLevel);

	return true;
};

// 获取英雄列表
exports.getHeroInfoList = function(area, uuid, callback) {
	var heroInfoList ={};
	tiny.redis.hgetall(utils.redisKeyGen(area, uuid, 'hero'), function(err, data) {
		var heroId, heroBookInfo;
		if (err) {
			callback(err);
		} else {
			if (data) {
				for (heroId in data) {
					if (data.hasOwnProperty(heroId)) {
						heroInfoList[heroId] = utils.getObject(data[heroId]);
					}
				}
				// 设置英雄图鉴信息
				heroBookInfo = heroInfoList[Const.HERO_BOOK_INFO_INDEX];
				if (heroBookInfo) {
					delete heroInfoList[Const.HERO_BOOK_INFO_INDEX];
				}
				// 成功回调
				callback(null, heroInfoList, heroBookInfo);
			} else {
				callback("heroInfoList is null fail");
			}
		}
	});
};

// 获取团队列表
exports.getTeamHeroList = function(area, uuid, heroIds, callback) {
	var heroId, teamHeroList ={}, i;
	tiny.redis.hmget(utils.redisKeyGen(area, uuid, 'hero'), heroIds, function(err, data) {
		if (err) {
			callback(err);
		} else {
			if (data) {
				for (i = 0; i < heroIds.length; i++) {
					if (data[i]) {
						heroId = heroIds[i];
						teamHeroList[heroId] = utils.getObject(data[i]);
					}
				}
				callback(null, teamHeroList);
			} else {
				callback("teamHeroList is null fail");
			}
		}
	});
};

// 设置英雄列表
exports.setHeroInfoList = function(area, uuid, heroList, callback) {
	var heroInfoList ={};
	tiny.redis.hmset(utils.redisKeyGen(area, uuid, 'hero'), heroList, function(err, data) {
		var heroId;
		if (err) {
			callback(err);
		} else {
			for (heroId in data) {
				if (data.hasOwnProperty(heroId)) {
					heroInfoList[heroId] = utils.getObject(data[heroId]);
				}
			}
			callback(null, heroInfoList);
		}
	});
};

// 保存英雄信息到英雄列表中
exports.setHeroToHeroList = function(area, uuid, heroId, heroInfo, callback) {
	// 获取英雄列表信息
	tiny.redis.hset(utils.redisKeyGen(area, uuid, 'hero'),
		heroId, utils.setObject(heroInfo), function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, heroInfo);
		}
	});
};

// 提升英雄经验，等级
exports.updateHeroExpInHeroList = function(area, uuid, heroId, exp, callback) {
	var heroInfo;
	// 获取英雄列表信息
	tiny.redis.hget(utils.redisKeyGen(area, uuid, 'hero'), heroId, function(err, data) {
		if (err) {
			// 取数据失败或者没有英雄列表数据
			callback(err);
		} else {
			// 找到英雄信息
			if (data) {
				heroInfo = utils.getObject(data);
				// 检查经验值
				if (!exp) {
					tiny.log.debug("updateHeroExpInHeroList don't get exp");
					callback(null, heroInfo);
					return;
				}
				// 增加经验值
				exports.addHeroExp(exp, heroInfo);
				//将英雄列表保存回数据库
				tiny.redis.hset(utils.redisKeyGen(area, uuid, 'hero'), heroId, utils.setObject(heroInfo), function(err, data) {
					if (err) {
						callback(err);
					} else {
						if (data) {
							// 成功处理完流程回调
							callback(null, heroInfo);
						} else {
							callback('set heroList data fail');
						}
					}
				});
			} else {
				callback('cant find the heroId');
			}
		}
	});
};

// 提升英雄经验，等级，数组版本
exports.updateHerosExpInHeroList = function(area, uuid, heroIds, exp, callback) {
	var heroInfo, heroId, i, setHeroInfoList = {}, teamHeroList = {};
	// 获取英雄列表信息
	tiny.redis.hmget(utils.redisKeyGen(area, uuid, 'hero'), heroIds, function(err, heroInfoList) {
		if (err) {
			// 取数据失败或者没有英雄列表数据
			callback(err);
		} else {
			if (heroInfoList) {
				// 找到英雄信息
				for (i = 0; i < heroIds.length; i++) {
					if (heroInfoList[i]) {
						heroId = heroIds[i];
						heroInfo = utils.getObject(heroInfoList[i]);
						// 增加经验值
						exports.addHeroExp(exp, heroInfo);
						// 返回数据
						teamHeroList[heroId] = heroInfo;
						setHeroInfoList[heroId] = utils.setObject(heroInfo);
					}
				}
				// 检查经验值
				if (!exp) {
					tiny.log.debug("updateHerosExpInHeroList don't get exp");
					callback(null, teamHeroList);
					return;
				}
				// 保存英雄信息
				tiny.redis.hmset(utils.redisKeyGen(area, uuid, 'hero'), setHeroInfoList, function(err) {
					if (err) {
						callback(err);
					} else {
						if (teamHeroList) {
							// 成功处理完流程回调
							callback(null, teamHeroList);
						} else {
							callback('set heroList data fail');
						}
					}
				});
			}
		}
	});
};

// 提升技能槽等级
exports.upgradeSkillSlot = function(area, uuid, heroId, slotId, callback) {
	var heroInfo, gold;
	// 获取英雄列表信息
	tiny.redis.hget(utils.redisKeyGen(area, uuid, 'hero'), heroId, function(err, data) {
		if (err) {
			callback(err);
		} else {
			// 英雄信息
			if (data) {
				heroInfo = utils.getObject(data);
				// 计算技能槽升级参数
				if (heroInfo.skillSlotList.hasOwnProperty(slotId)) {
					gold = (100 + 800 * (heroInfo.skillSlotList[slotId].level - 1)) * -1;
					if (heroInfo.skillSlotList[slotId].level < Const.SKILL_SLOT_LEVEL_LIMIT) {
						heroInfo.skillSlotList[slotId].level = heroInfo.skillSlotList[slotId].level + 1;
					} else {
						callback(slotId + 'slot level limit');
						return;
					}
					// 修改金钱
					playerHandle.modPlayerGold(area, uuid, gold, function(err) {
						if (err) {
							callback(err);
						} else {
							//将英雄列表保存回数据库
							tiny.redis.hset(utils.redisKeyGen(area, uuid, 'hero'), heroId, utils.setObject(heroInfo), function(err, data) {
								if (err) {
									callback(err);
								} else {
									if (data) {
										// 成功处理完流程回调
										callback(null, heroInfo);
									} else {
										callback('set hero data fail');
									}
								}
							});
						}
					});
				} else {
					callback(slotId + "don't have the slot");
				}
			} else {
				callback(heroId + 'cant find the heroId');
			}
		}
	});
};

// 升星修改金钱
exports.upgradeHeroStarBaseInfo = function(heroInfo, baseInfo) {
	var gold;
	if (heroInfo.star < 0 || heroInfo.star > Const.HERO_STAR_LEVEL_LIMIT) {
		tiny.log.debug("1");
		return false;
	}
	if (HeroStar.hasOwnProperty(heroInfo.star + 1)) {
		gold = Number.parseInt(HeroStar[heroInfo.star + 1].gold, 10) * -1;
		if (!playerHandle.addPlayerGold(gold, baseInfo)) {
		tiny.log.debug("2");
			return false;
		}
		return true;
	}
		tiny.log.debug("3");
	return false;
};

// 升星修改背包
exports.upgradeHeroStarBagList = function(heroInfo, bagList) {
	var itemNum, itemId;
	if (heroInfo.star < 0 || heroInfo.star > Const.HERO_STAR_LEVEL_LIMIT) {
		tiny.log.debug("4");
		return false;
	}
	if (HeroStar.hasOwnProperty(heroInfo.star + 1)) {
		itemNum = HeroStar[heroInfo.star + 1].itemNum;
		itemId = HeroStar[heroInfo.star + 1].itemId;
		if (!bag.delItem(itemId, itemNum, bagList)) {
		tiny.log.debug("5");
			return false;
		}
		return true;
	}
		tiny.log.debug("6");
	return false;
};

// 提升星级
exports.upgradeHeroStarLevel = function(heroInfo) {
	// 提升英雄星级
	if (heroInfo.star < Const.HERO_STAR_LEVEL_LIMIT) {
		heroInfo.star = heroInfo.star + 1;
		return true;
	}
	return false;
};

// 提升品质
exports.upgradeHeroQualityLevel = function(heroInfo) {
	// 提升英雄星级
	if (heroInfo.quality < Const.HERO_QUALITY_LEVEL_LIMIT) {
		heroInfo.quality = heroInfo.quality + 1;
		return true;
	}
	return false;
};

// 升品修改背包
exports.upgradeHeroQualityBagList = function(heroInfo, bagList) {
	var itemNum, itemId, i;
	if (heroInfo.quality < 0 || heroInfo.quality > Const.HERO_QUALITY_LEVEL_LIMIT) {
		tiny.log.debug("4");
		return false;
	}
	if (HeroQualityConsume.hasOwnProperty(heroInfo.heroId)) {
		for (i in HeroQualityConsume[heroInfo.heroId][heroInfo.quality+1]) {
			if (HeroQualityConsume[heroInfo.heroId][heroInfo.quality+1].hasOwnProperty(i)) {
				itemId = HeroQualityConsume[heroInfo.heroId][heroInfo.quality+1][i][1];
				itemNum = HeroQualityConsume[heroInfo.heroId][heroInfo.quality+1][i][2];
				if (!bag.delItem(itemId, itemNum, bagList)) {
					tiny.log.debug("5");
					return false;
				}
			}
		}
		return true;
	}
		tiny.log.debug("6");
	return false;
};

// 根据英雄ID获取英雄信息
exports.getHeroInfo = function(area, uuid, heroId, callback) {
	var heroInfo;
	tiny.redis.hget(utils.redisKeyGen(area, uuid, 'hero'), heroId, function(err, data) {
		if (err) {
			// 取数据失败或者没有英雄列表数据
			callback(err);
		} else {
			// 找到英雄信息
			if (data) {
				heroInfo = utils.getObject(data);
				callback(null, heroInfo);
			} else {
				callback("heroInfo not exist " + heroId);
			}
		}
	});
};

// 根据英雄ID获取英雄信息
exports.setHeroInfo = function(area, uuid, heroId, heroInfo, callback) {
	tiny.redis.hset(utils.redisKeyGen(area, uuid, 'hero'), heroId, utils.setObject(heroInfo), callback);
};

var delArrayElt = function(_array, _id) {
	var i, newArray = [];
	for (i = 0; i < _array.length; i++) {
		if (parseInt(_array[i],10) !== parseInt(_id, 10)) {
			newArray.push(_array[i]);
		}
	}
	return newArray;
};

// 随机英雄槽
exports.rollheroBookInfo = function(heroBookInfo, heroInfoList, thisHeroId) {
	var i, heroId, heroIds = {}, heroIdA = [], heroIdB = [], heroIdC =[];


	for (heroId in Character) {
		if (Character.hasOwnProperty(heroId)) {
			if (!heroInfoList.hasOwnProperty(heroId)
				&& parseInt(heroId,10) !== parseInt(thisHeroId,10)) {
				heroIdA.push(heroId);
			} else {
				if (!heroIds.hasOwnProperty(Character[heroId].teamId)) {
					heroIds[Character[heroId].teamId] = [];
				}
				heroIds[Character[heroId].teamId].push(heroId);
			}
		}
	}

	// 召唤次数大于8次则全随机
	if (parseInt(heroBookInfo.countSummomNums, 10) >= 5) {
		if (heroIdA.length !== 0) {
			heroBookInfo.heroId1 = utils.randomArray(heroIdA);
		}
		heroIdA = delArrayElt(heroIdA, heroBookInfo.heroId1);
		if (heroIdA.length !== 0) {
			heroBookInfo.heroId2 = utils.randomArray(heroIdA);
		}
		heroIdA = delArrayElt(heroIdA, heroBookInfo.heroId2);
		if (heroIdA.length !== 0) {
			heroBookInfo.heroId3 = utils.randomArray(heroIdA);
		}
		return heroBookInfo;
	}

	for (i = 0; i < heroIdA.length; i++) {
		if (!heroIds.hasOwnProperty(Character[heroIdA[i]].teamId)
			|| heroIds[Character[heroIdA[i]].teamId].length < 2) {
			heroIdB.push(heroIdA[i]);
		} else {
			heroIdC.push(heroIdA[i]);
		}
	}

	if (heroIdB.length !== 0) {
		heroBookInfo.heroId1 = utils.randomArray(heroIdB);
	} else {
		tiny.log.debug("heroListB end");
		heroIdB = heroIdC;
		if (heroIdB.length !== 0) {
			heroBookInfo.heroId1 = utils.randomArray(heroIdB);
		} else {
			tiny.log.debug("heroListC end");
		}
	}
	heroIdB = delArrayElt(heroIdB, heroBookInfo.heroId1);
	if (heroIdB.length !== 0) {
		heroBookInfo.heroId2 = utils.randomArray(heroIdB);
	} else {
		tiny.log.debug("heroList end");
	}
	heroIdB = delArrayElt(heroIdB, heroBookInfo.heroId2);
	if (heroIdB.length !== 0) {
		heroBookInfo.heroId3 = utils.randomArray(heroIdB);
	} else {
		tiny.log.debug("heroList end");
	}

	return heroBookInfo;
};

// 随机英雄ID
exports.getHeroId = function(heroInfoList, thisHeroId) {
	var heroId, heroIds = [];
	for (heroId in Character) {
		if (Character.hasOwnProperty(heroId)
			&& !heroInfoList.hasOwnProperty(heroId)
			&& parseInt(heroId,10) !== parseInt(thisHeroId, 10)) {
			heroIds.push(heroId);
		}
	}
	if (heroIds.length !== 0) {
		return utils.randomArray(heroIds);
	}

	return null;
};

// 创建英雄信息到英雄列表中
exports.createHeroInHeroInfoList = function(area, uuid, heroId, callback) {
	var heroInfo;
	heroInfo = createHero(heroId, 0);
	// 获取英雄列表信息
	tiny.redis.hset(utils.redisKeyGen(area, uuid, 'hero'),
		heroId, utils.setObject(heroInfo), function(err) {
		if (err) {
			callback(err);
		} else {
			callback(null, heroInfo);
		}
	});
};

// 检查是否为新手引导英雄
exports.checkGuideHero = function(heroId) {
	var i;
	for (i in guideHero) {
		if (guideHero.hasOwnProperty(i)) {
			if (parseInt(heroId, 10) === parseInt(guideHero[i], 10)) {
				return true;
			}
		}
	}
	return false;
};

// 随机召唤英雄
exports.rollHero = function(area, uuid, heroId, callback) {
	var rtHeroBookInfo, rollHeroId;
	// 取出已有英雄信息
	exports.getHeroInfoList(area, uuid, function(err, heroInfoList, heroBookInfo) {
		if (err) {
			callback(err);
		} else {
			if (heroInfoList.hasOwnProperty(heroId)) {
				callback("heroId no exist " + heroId);
				return;
			}

			if (heroBookInfo.summomNums <= 0) {
				callback("summomNums is " + heroBookInfo.summomNums);
				return;
			}

			if (!heroBookInfo) {
				callback("heroBookInfo no exist");
				return;
			}

			// 设置召唤次数
			if (parseInt(heroBookInfo.summomNums,0) >= 0) {
				heroBookInfo.summomNums -= 1;
				heroBookInfo.countSummomNums += 1;
			} else {
				callback("summomNums is error " + heroBookInfo.summomNums);
				return;
			}

			// 3选1随机
			if (heroId !== 0) {
				// 检查该英雄是否已经召唤了
				if (heroInfoList.hasOwnProperty(heroId)) {
					callback("heroId has been roll " + heroId);
					return;
				}
				// 检查是否为新手引导英雄
				if (exports.checkGuideHero(heroId)) {
					rollHeroId = heroId;
				} else {
					if (heroId === parseInt(heroBookInfo.heroId1,10) ||
						heroId === parseInt(heroBookInfo.heroId2,10) ||
						heroId === parseInt(heroBookInfo.heroId3,10)) {
						rollHeroId = heroId;
					} else {
						callback("heroId don't match " + heroId);
						return;
					}
				}
			} else {
				// 完全随机
				rollHeroId = exports.getHeroId(heroInfoList, heroId);
				if (!rollHeroId){
					callback("heroId end");
					return;
				}
			}
			// 创建新英雄
			exports.createHeroInHeroInfoList(area, uuid, rollHeroId, function(err, heroInfo) {
				if (err) {
					callback("create HeroInfo fail " + heroId);
				} else {
					// 随机英雄槽
					rtHeroBookInfo = exports.rollheroBookInfo(heroBookInfo, heroInfoList, heroId);
					// 保存英雄图鉴信息
					exports.setHeroToHeroList(area, uuid, Const.HERO_BOOK_INFO_INDEX, rtHeroBookInfo, function(err) {
						if (err) {
							callback("save heroBookInfo fail");
						} else {
							callback(null, heroInfo, heroBookInfo);
						}
					});
				}
			});
		}
	});
};

// 检查商店槽和英雄等级的匹配
var checkHeroShopLevel = function(shopId, baseInfo) {
	if (shopId === 1) {
		return true;
	}

	if (shopId === 2 && baseInfo.level >= 10) {
		return true;
	}

	if (shopId === 3 && baseInfo.level >= 20) {
		return true;
	}

	if (shopId === 4 && baseInfo.level >= 30) {
		return true;
	}

	if (shopId === 5 && baseInfo.level >= 40) {
		return true;
	}

	return false;
};

// 合成英雄碎片
exports.shopHero = function(shopId, bagList, heroBookInfo, baseInfo, bagItem) {
	var i, delToItem, itemId, itemNum;

	// 检查商店槽和英雄等级的匹配
	if (!checkHeroShopLevel(shopId, baseInfo)) {
		tiny.log.debug("checkHeroShopLevel");
		return false;
	}
	if (!heroBookInfo.hasOwnProperty("shop" + shopId)) {
		tiny.log.debug("heroBookInfo shop" + shopId);
		return false;
	}
	if (!Compose.hasOwnProperty(heroBookInfo["shop" + shopId])) {
		tiny.log.debug("Compose shop " + shopId + " " + heroBookInfo["shop" + shopId]);
		return false;
	}

	// 删除材料
	delToItem = Compose[heroBookInfo["shop" + shopId]];
	for (i in delToItem.demandItemId) {
		if (delToItem.demandItemId.hasOwnProperty(i)) {
			itemId = delToItem.demandItemId[i][1];
			itemNum = delToItem.demandItemId[i][2];
			if (!bag.delItem(itemId, itemNum, bagList)) {
				return false;
			}
		}
	}

	// 添加英雄碎片
	if (!item.getItemAward(heroBookInfo["shop" + shopId], 1, bagList, bagItem)) {
		tiny.log.debug("getItemAward " + heroBookInfo["shop" + shopId]);
		return false;
	}

	// 置为已经召唤
	heroBookInfo["shop" + shopId] = heroBookInfo["shop" + shopId] * -1;

	return true;
};

// 计算刷新次数
var calRefreshHeroShopTime = function(now, heroBookInfo) {
	while (now - heroBookInfo.time > Const.HERO_REFRESH_TIME_INTERVAL) {
		heroBookInfo.time += Const.HERO_REFRESH_TIME_INTERVAL;
		if (heroBookInfo.refreshNums < Const.HERO_REFRESH_TIME_DAILY_LIMIT) {
			heroBookInfo.refreshNums += 1;
		}
	}
};

// 随机英雄碎片
var rollHeroShop = function(heroBookInfo) {
	var shopId;
	heroBookInfo.refreshNums = parseInt(heroBookInfo.refreshNums,10) - 1;

	shopId = randomHeroShop(1);
	if (shopId === 0) {
		return false;
	}
	heroBookInfo.shop1 = shopId;

	heroBookInfo.shop2 = randomHeroShop(2);

	heroBookInfo.shop3 = randomHeroShop(3);

	heroBookInfo.shop4 = randomHeroShop(4);

	heroBookInfo.shop5 = randomHeroShop(5);

	return true;
};

// 刷新英雄商店
exports.refreshHeroShop = function(isRefresh, heroBookInfo, baseInfo) {
	// 检查时间
	// 计算时间
	// 随机碎片ID
	var now = parseInt(Date.now() / 1000, 10), dTime, durTime;
	dTime = now - parseInt(heroBookInfo.time, 10);
	if (dTime > Const.HERO_REFRESH_TIME_INTERVAL) {
		calRefreshHeroShopTime(now, heroBookInfo);
	}
	dTime = now - parseInt(heroBookInfo.time, 10);
	durTime = Const.HERO_REFRESH_TIME_INTERVAL - dTime;
	//heroBookInfo.time = now;

	tiny.log.debug("refreshHeroShop durTime", durTime, isRefresh);

	// 刷新商店
	if (parseInt(heroBookInfo.refreshNums,10) > 0 && parseInt(isRefresh, 10) !== 0) {
		tiny.log.debug("refreshHeroShop refresh ", durTime, isRefresh);
		if (!rollHeroShop(heroBookInfo, baseInfo)) {
			return -1;
		}
	}
	return durTime;
};

// 洗练英雄
exports.washHeroInfo = function(heroInfo, bagList, baseInfo, locks) {
	var pos = [],
	itemID = 15501,
	itemNum,
	i,
	diamond = -250;
	if (parseInt(locks.lock1, 0) === 0) {
		diamond += 50;
		pos.push(1);
	}
	if (parseInt(locks.lock2, 0) === 0) {
		diamond += 50;
		pos.push(2);
	}
	if (parseInt(locks.lock3, 0) === 0) {
		diamond += 50;
		pos.push(3);
	}
	if (parseInt(locks.lock4, 0) === 0) {
		diamond += 50;
		pos.push(4);
	}
	if (parseInt(locks.lock5, 0) === 0) {
		diamond += 50;
		pos.push(5);
	}
	if (pos.length === 0) {
		return null;
	}
	// 扣除钻石币
	playerHandle.addPlayerDiamond(diamond, baseInfo);
	i = utils.randomArray(pos);
	heroInfo["suitId" + i] = utils.randomScope(SuitAu[heroInfo.heroId]["chance" + i].index,
											   SuitAu[heroInfo.heroId]["chance" + i].weight);
	// 检查背包内是否有此道具，并检查合成id是否正确
	itemNum = bag.getItemNum(itemID, bagList);
	if (itemNum <= 0) {
		return null;
	}
	// 扣除道具并保存效果
	if (!bag.delItem(itemID, 1, bagList)) {
		return null;
	}
	return heroInfo;
};

// 临时创建英雄，道具爆英雄逻辑
exports.createHeroTmp = function(area, uuid, heroIds) {
	var i, cb = function(err) {
		if (err) {
			tiny.log.debug("createHeroTmp fail",area, uuid);
		}
	}, heroInfoList = {};
	for (i in heroIds) {
		if (heroIds.hasOwnProperty(i)) {
			tiny.log.debug("createHeroTmp",area, uuid, heroIds[i]);
			heroInfoList[heroIds[i]] = createHero(heroIds[i], 0);
			exports.setHeroToHeroList(area, uuid, heroIds[i], heroInfoList[heroIds[i]], cb);
		}
	}

	return heroInfoList;
};
