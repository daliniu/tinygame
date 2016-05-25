module('minidef')

--最大的回合数
BEGIN_TURN = 1
MAX_TURN = 10

--战斗双方
ME = 1
OBS = 2

--战斗阵营数量
CAMP_NUM = 2

--位置
P_NUM = 6
P_HEAD_LEFT  = 1
P_HEAD_MID   = 2
P_HEAD_RIGHT = 3
P_BACK_LEFT  = 4
P_BACK_MID   = 5
P_BACK_RIGHT = 6

--每回合技能费率概率表
SKILL_PRO = {
	[0] = { 16.6, 16.6, 16.6, 16.6, 16.6, 16.7 },
	[1] = {  100,    0,    0,    0,    0,    0 },
	[2] = {   25,   75,    0,    0,    0,    0 },
	[3] = {    5,   20,   75,    0,    0,    0 },
	[4] = {    0,    5,   20,   75,    0,    0 },
	[5] = {    0,    0,    5,   20,   75,    0 },
	[6] = {    0,    0,    0,    5,   20,   75 },
}

--技能费用
MIN_COST = 1
MAX_COST = 6

--条件队列类型
CONDITION_TYPE = {
	TURN_BEGIN = 9001,
	TURN_END = 9002,
	OUR_HERO_NORMAL_ATK = 9003,
	OUR_HERO_MAGIC = 9004,
	OUR_HERO_CALL = 9005,
	OUR_HERO_MUTIL = 9006,
	-- OUR_HERO_COMBO = 9007,
	OBS_CAST = 9008,
	OUR_CAST = 9009,
	CAST = 9010,
	BE_DAMAGE = 9011,
	HURT = 9012,
	OUR_CURL = 9013,
	SUMMON_ENTER = 9014,
	OUR_ENTER = 9015,
	OBS_ENTER = 9016,
	DEAD = 9017,
	OUR_DEAD = 9018,
}

--目标类型
TARGET_TYPE = {
	HERO = 1,	--英雄
	SUMMON = 2,	--生物
}

--寻找目标方式，如果找不到第一目标按照1寻找
SEARCH_TYPE = {
	DEFAULT = 1,	--默认方式（先对位生物，然后对位英雄，然后所有生物，然后所有英雄）
	POS = 2,	--位置
	SELF = 3,	--自身
	OBS_SUMMON = 4,	--对位生物
	MAX_SUMMON = 5,	--最高费生物
	MIN_SUMMON = 6,	--最低费生物
	COST_UP_SUMMON = 7,	--指定费用及以上生物
	COST_DOWN_SUMMON = 8,	--指定费用及以下生物
	RANDOM = 9,	--随机
	MIN_HP = 10,	--最少血量者
	OBS_HERO = 11,	--对位英雄
	SELF_HEAD = 12,	--身前
}

--默认目标范围
SEARCH_RANGE_ROW = 1	--横排
SEARCH_RANGE_LINE = 2	--竖排

--命中类型
BINGO = {
	MISS = 1,
	NO_MISS = 2,
	MUST = 3,
}

--技能效果
SKILL_EFFECT = {
	STATUS = 0,	--状态
	ATTACK = 1,	--攻击
	CURL = 2,	--治疗
	MUTIL = 3,	--多重施法
	KILL = 4, 	--杀生物
	ADD = 5,	--增加法力上限
	CALL = 6,	--召唤
	COPY = 7,	--复制
	COMMON = 8,	--普攻
}

--多重施法最大个数
MAX_SKILL_MUTIL_NU = 4

--召唤物队列上限
MAX_SUMMON_QUEUE_NUM = 4

--一轮触发技能上限
MAX_CAST_SKILL = 5

--状态等级如果是由技能引起的则为技能等级，如果不是由技能产生的则是状态所在生物或英雄的等级

--状态队列上限
MAX_STATUS_QUEUE_NUM = 5

--状态类型
STATUS_TYPE = {
	FLY = 1,	--飞行（我的普攻或攻击类技能直接攻击对位英雄）
	SHIELD = 2,	--护盾（减少一定伤害）
	RIDICULE = 3,	--嘲讽（敌方普攻和攻击类技能寻找目标强制为自身）
	ADD = 4,	--增加属性（增加指定属性）
	IMMUNITY = 5,	--免疫（免疫伤害）
	-- EXILE = 6,	--放逐，暂时不做
	DIZZ = 7,	--眩晕（行动时移除眩晕的技能和普攻）
	REDUCE = 8,	--减少属性（减少指定属性）
	SUSTAIN = 9,	--持续伤害（造成伤害，不触发暴击）
	SKILL = 10,	--释放技能（释放一个新技能）
}

--增加属性的类型
STATUS_ADD_PROPERTY = {
	ATK = 8001,	--攻击
	DEF = 8002,	--防御
	CRIT = 8003,	--暴击
	DOG = 8004,	--闪避
	MAX_HP = 8005,	--生命上限
}

--状态产生条件
STATUS_CREATE_COND = {
	BINGO = 0,	--命中即产生
	CRIT = 1,	--暴击产生
}

--状态性质
STATUS_NATURE = {
	POSITIVE = 1,	--正面状态
	NEGETIVE = 2,	--负面状态
}

--状态作用目标类型
STATUS_TARGET = {
	ALL = 0,
	HERO = 1,
	SUMMON = 2,
}

--状态驱散
STATUS_DIS = {
	OK = 1,	--可驱散
	NO = 0,	--不可驱散
}

--状态共存标记
STATUS_COEXIST = {
	NO = 0,	--无法共存，也不替换
	ALL = 1,	--共存
	UP = 2,	--高等级替换低等级
}

--=============================渲染=================================
OP_TYPE = {
	["buff"] = 1,
	["skill"] = 2,
	["queueskill"] = 3,
}
