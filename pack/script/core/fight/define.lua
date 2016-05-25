----------------------------------------------------------
-- file:	__init__.lua
-- Author:	page
-- Time:	2015/01/31	14:13
-- Desc:	��������()
----------------------------------------------------------

--ս��״̬��������
TB_ENUM_FIGHT_STATE_ARR_INDEX_DEF = {
	ERROR				= 0,
	ATTACKABLE 			= 1,	--�Ƿ�ɹ���
	LIFE				= 2,	--����״̬(���ţ�����)
	JOIN				= 3,	--�Ƿ��ϳ�
	SUM					= 100
}

--ս��״̬
TB_ENUM_FIGHT_STATE_DEF = {
	[TB_ENUM_FIGHT_STATE_ARR_INDEX_DEF.LIFE] = {
		ERROR  			= 0,		--����״̬
		ALIVE 			= 1,		--����״̬
		DEAD 			= 2,		--����
	},
}
	
TB_ENUM_FIGHT_CAMP_DEF = {
	MINE 					= 1, 		--�ҷ�
	ENEMY					= 2,		--�з�
}

--λ�ö���
TB_ENUM_POSITION_DEF = {
	POS_1					= 1,
	POS_2					= 2,
	POS_3					= 3,
	POS_4					= 4,
	POS_5					= 5,
	POS_6					= 6,
}
TB_ENUM_POSITION_DEF.POS_MIN = TB_ENUM_POSITION_DEF.POS_1;
TB_ENUM_POSITION_DEF.POS_MAX = TB_ENUM_POSITION_DEF.POS_6;

--�������ȼ�����
TB_ENUM_CONDITION_LEVEL_DEF = {
	ENEMY_HERO				= 1,		--�з�Ӣ��
	MINE_HERO				= 2,		--�ҷ�Ӣ��
	ENEMY_NPC				= 3,		--�ط�����
	MINE_NPC				= 4,		--�ҷ�����
}

MAX_COST = 6 		--������