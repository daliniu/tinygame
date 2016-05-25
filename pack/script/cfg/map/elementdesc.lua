-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["Sheet1"] = 1,
};

sheetindex = {
[1] = "Sheet1",
};

local elementdesc = {
[1] = {
	[1] = {
		["DescID"] = 1,
		["Word1"] = "一个普通的宝箱，打开可以获得好东西！",
	},
	[200] = {
		["DescID"] = 200,
		["Word1"] = "魔女的宝箱",
		["Word2"] = "被施了魔法的宝袋里有无数的宝贝，但是你无法同时取走多个，你只能做出选择。",
		["Word3"] = "恭喜你获得以下道具！",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "你真幸运，顺利地拿到以下宝贝！",
		["Word6"] = "真不好意思，什么都没得到。",
	},
	[201] = {
		["DescID"] = 201,
		["Word1"] = "魔女掉落的一个宝袋",
		["Word2"] = "宝贝你已经取过，无法再取。",
	},
	[202] = {
		["DescID"] = 202,
		["Word1"] = "一只光灵正在树下不断地转圈，时不时地用头撞树。",
		["Word2"] = "头好痛头好痛，给我的头来一脚吧！我的头不痛了就给你一些金币好不好！",
		["Word3"] = "哎呀呀，只是缓解了一点，这点作为报酬给你好了~",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "哎呀呀，头不痛啦，头不痛啦~来这是谢礼~",
		["Word6"] = "光灵被你一脚踢死了，于是你什么也没得到。",
	},
	[203] = {
		["DescID"] = 203,
		["Word1"] = "一只抱着魔晶的小光灵",
		["Word2"] = "人类，你还有什么事吗？",
	},
	[204] = {
		["DescID"] = 204,
		["Word1"] = "精灵的宝箱，你只能从中获得一个道具！",
		["Word2"] = "你可以选择两件宝物中的一件，不同道具有不同的获得概率！",
		["Word3"] = "你成功的得到了道具！",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "你成功的得到了道具！",
		["Word6"] = "很抱歉，你什么都没得到。",
	},
	[205] = {
		["DescID"] = 205,
		["Word1"] = "精灵的宝箱，你只能从中获得一个道具！",
		["Word2"] = "无法再次访问。",
	},
	[206] = {
		["DescID"] = 206,
		["Word1"] = "一个上锁的宝箱，没有钥匙打开不了。你可以在附近找找看。",
		["Word2"] = "你只能获得宝箱中的一个道具！",
		["Word3"] = "恭喜你获得以下道具！",
		["Word4"] = "这个格子里面是空的。",
		["Word5"] = "你真幸运，顺利地拿到以下宝贝！",
		["Word6"] = "这个格子里面是空的。",
	},
	[207] = {
		["DescID"] = 207,
		["Word1"] = "一个上锁的宝箱",
		["Word2"] = "已空",
	},
	[208] = {
		["DescID"] = 208,
		["Word1"] = "一个漂浮在空中的光灵似乎正在寻找什么人",
		["Word2"] = "少年的英雄啊！这里有两把钥匙，一把金钥匙，一把铜钥匙。哪一把是你的呢？",
		["Word3"] = "其实两把钥匙都一样，你拿去吧！",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "其实两把钥匙都一样，你拿去吧！",
		["Word6"] = "很抱歉，你什么都没得到。",
	},
	[209] = {
		["DescID"] = 209,
		["Word1"] = "人类，再见！",
		["Word2"] = "人类，再见！",
	},
	[210] = {
		["DescID"] = 210,
		["Word1"] = "一只对世界充满好奇的鱼人",
		["Word2"] = "如果你见到我父亲，就帮我最喜欢的书带给它！让他知道我是安全的！",
		["Word3"] = "好像就是这一本，你那去吧。",
		["Word4"] = "好像就是这一本，你那去吧。",
		["Word5"] = "好像不是这一本，算了，你都拿去吧。",
		["Word6"] = "好像不是这一本，算了，你都拿去吧。",
	},
	[211] = {
		["DescID"] = 211,
		["Word1"] = "一只对世界充满好奇的鱼人",
		["Word2"] = "一只对世界充满好奇的鱼人",
	},
	[300] = {
		["DescID"] = 300,
		["Word1"] = "一群发疯的怪物正在乱窜，他们拼命地袭击一切会动的东西",
		["Word2"] = "现在只有你能阻止这些发疯的怪物。（击败怪物会有丰厚的奖励）",
	},
	[301] = {
		["DescID"] = 301,
		["Word1"] = "怪物们都躲避着一个神秘的帐篷，里面似乎有什么强大的东西。（击败boss可获得收益提升）",
		["Word2"] = "怪物们都躲避着一个神秘的帐篷，里面似乎有什么强大的东西。（击败boss可获得收益提升）",
		["Word3"] = "怪物们都躲避着一个神秘的帐篷，里面似乎有什么强大的东西。（击败boss可获得收益提升）",
		["Word4"] = "你从怪兽的帐篷里找到了一份记录，让你可以把中了疯狂魔法的怪物治愈，前提是你击败它们！这使你的挂机收益提升了20%",
	},
	[302] = {
		["DescID"] = 302,
		["Word1"] = "一群发疯的怪物正在乱窜，他们拼命地袭击一切会动的东西",
		["Word2"] = "现在只有你能阻止这些发疯的怪物。（击败怪物会有丰厚的奖励）",
	},
	[303] = {
		["DescID"] = 303,
		["Word1"] = "一群发疯的怪物正在乱窜，他们拼命地袭击一切会动的东西",
		["Word2"] = "一群发疯的怪物正在乱窜，他们拼命地袭击一切会动的东西",
	},
	[304] = {
		["DescID"] = 304,
		["Word1"] = "一个巨大的洞穴，里面不断的发出令人毛骨悚然的凄厉叫声。",
		["Word2"] = "只有你阻止疯狂的怪物从洞窟里冲出来。（击败怪物会有丰厚的奖励）",
	},
	[305] = {
		["DescID"] = 305,
		["Word1"] = "在洞穴的最深处，有一个怪物，正在不断地呼唤着怪物从混沌中涌出。（击败boss可获得收益提升）",
		["Word2"] = "在洞穴的最深处，有一个怪物，正在不断地呼唤着怪物从混沌中涌出。（击败boss可获得收益提升）",
		["Word3"] = "在洞穴的最深处，有一个怪物，正在不断地呼唤着怪物从混沌中涌出。（击败boss可获得收益提升）",
		["Word4"] = "击败了这个怪物，你控制了他的法阵，阻止了继续制造更多怪物的同时，使你的挂机收益提升了20%",
	},
	[306] = {
		["DescID"] = 306,
		["Word1"] = "一个巨大的洞穴，里面不断的发出令人毛骨悚然的凄厉叫声。",
		["Word2"] = "只有你阻止疯狂的怪物从洞窟里冲出来。（击败怪物会有丰厚的奖励）",
	},
	[307] = {
		["DescID"] = 307,
		["Word1"] = "一个巨大的洞穴，里面不断的发出令人毛骨悚然的凄厉叫声。",
		["Word2"] = "一个巨大的洞穴，里面不断的发出令人毛骨悚然的凄厉叫声。",
	},
	[308] = {
		["DescID"] = 308,
		["Word1"] = "大陆上的怪物的墓地，充满了诡异的气息，因为怪物死去的正在复活！",
		["Word2"] = "你必须去阻止那些大量复活的怪物，否则他们将淹没世界！（击败怪物会有丰富的奖励）",
	},
	[309] = {
		["DescID"] = 309,
		["Word1"] = "在墓地的深处，一个巨大的怪兽正在醒来。（击败boos可获得收益提升）",
		["Word2"] = "在墓地的深处，一个巨大的怪兽正在醒来。（击败boos可获得收益提升）",
		["Word3"] = "在墓地的深处，一个巨大的怪兽正在醒来。（击败boos可获得收益提升）",
		["Word4"] = "死亡的怪兽上了巨大能量，让你的战斗可以得到更多奖励，使你的挂机收益提升了20%。",
	},
	[310] = {
		["DescID"] = 310,
		["Word1"] = "大陆上的怪物的墓地，充满了诡异的气息，因为怪物死去的正在复活！",
		["Word2"] = "你必须去阻止那些大量复活的怪物，否则他们将淹没世界！（击败怪物会有丰富的奖励）",
	},
	[311] = {
		["DescID"] = 311,
		["Word1"] = "大陆上的怪物的墓地，充满了诡异的气息，因为怪物死去的正在复活！",
		["Word2"] = "大陆上的怪物的墓地，充满了诡异的气息，因为怪物死去的正在复活！",
	},
	[312] = {
		["DescID"] = 312,
		["Word1"] = "一个神秘的建筑，里面充满了发狂的怪物",
		["Word2"] = "一群被邪恶的魔法操纵的生物，正在试图攻击你！（击败怪物会有丰富的奖励）",
	},
	[313] = {
		["DescID"] = 313,
		["Word1"] = "消灭操纵者魔物的邪恶怪物，能够让你在此地获得更高的收益。（击败boos可获得收益提升）",
		["Word2"] = "消灭操纵者魔物的邪恶怪物，能够让你在此地获得更高的收益。（击败boos可获得收益提升）",
		["Word3"] = "消灭操纵者魔物的邪恶法师，能够让你在此地获得更高的收益。（击败boos可获得收益提升）",
		["Word4"] = "你发现了操纵魔物的技巧，让你获得了20%挂机收益提升。",
	},
	[314] = {
		["DescID"] = 314,
		["Word1"] = "一个神秘的建筑，里面充满了发狂的怪物",
		["Word2"] = "一群被邪恶的魔法操纵的生物，正在试图攻击你！（击败怪物会有丰富的奖励）",
	},
	[315] = {
		["DescID"] = 315,
		["Word1"] = "一个神秘的建筑，里面充满了发狂的怪物",
		["Word2"] = "一个神秘的建筑，里面充满了发狂的怪物",
	},
	[316] = {
		["DescID"] = 316,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味！",
		["Word2"] = "营地里的怪物正在向周围扩散，你如果不阻止他们整个区域都会被毁灭。（击败怪物会有丰富的奖励）",
	},
	[317] = {
		["DescID"] = 317,
		["Word1"] = "消灭营地里不断感染那些幸存者的感染源，可以让你更好的控制怪物们。（击败boss可以获得收益提升）",
		["Word2"] = "消灭营地里不断感染那些幸存者的感染源，可以让你更好的控制怪物们。（击败boss可以获得收益提升）",
		["Word3"] = "消灭营地里不断感染那些幸存者的感染源，可以让你更好的控制怪物们。（击败boss可以获得收益提升）",
		["Word4"] = "感染源被消灭了，你可以确认这是一场魔法造成的灾害！理解疫情本质让你获得了20%挂机收益提升。",
	},
	[318] = {
		["DescID"] = 318,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味！",
		["Word2"] = "营地里的怪物正在向周围扩散，你如果不阻止他们整个区域都会被毁灭。（击败怪物会有丰富的奖励）",
	},
	[319] = {
		["DescID"] = 319,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味！",
		["Word2"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味！",
	},
	[320] = {
		["DescID"] = 320,
		["Word1"] = "巨大的工厂不断地生产着各种各样的怪物。",
		["Word2"] = "这些被魔法制造出来的怪物看到你就像你发动了攻击。（击败怪物会有丰富的奖励）",
	},
	[321] = {
		["DescID"] = 321,
		["Word1"] = "巨大的生物，控制着工厂的生产，消灭它就可以控制工厂生产，为你提供更多资源。（击败boos可获得收益提升）",
		["Word2"] = "巨大的生物，控制着工厂的生产，消灭它就可以控制工厂生产，为你提供更多资源。（击败boos可获得收益提升）",
		["Word3"] = "巨大的生物，控制者污染生物的水源，消灭它就可以控制工厂的生产，为你提供更多资源。（击败boos可获得收益提升）",
		["Word4"] = "水车恢复了工作，你的战斗奖励提升20%",
	},
	[322] = {
		["DescID"] = 322,
		["Word1"] = "巨大的工厂不断地生产着各种各样的怪物。",
		["Word2"] = "这些被魔法制造出来的怪物看到你就像你发动了攻击。（击败怪物会有丰富的奖励）",
	},
	[323] = {
		["DescID"] = 323,
		["Word1"] = "巨大的工厂不断地生产着各种各样的怪物。",
		["Word2"] = "巨大的工厂不断地生产着各种各样的怪物。",
	},
	[324] = {
		["DescID"] = 324,
		["Word1"] = "一座荒废的祭坛里，似乎有什么邪恶力量在蠢蠢欲动！",
		["Word2"] = "一群怪物似乎守护者什么邪恶的秘密！不一探究竟是不会知道其中的秘密！（击败怪物会有丰富的奖励）",
	},
	[325] = {
		["DescID"] = 325,
		["Word1"] = "一个强大的怪物正在保护着某个设施，这到底是什么？（击败boos可获得收益提升）",
		["Word2"] = "一个强大的怪物正在保护着某个设施，这到底是什么？（击败boos可获得收益提升）",
		["Word3"] = "一个强大的怪物正在保护着某个设施，这到底是什么？（击败boos可获得收益提升）",
		["Word4"] = "这个设施就是研究如何让怪物疯狂的设施，发现秘密给予你20%挂机收益提升。",
	},
	[326] = {
		["DescID"] = 326,
		["Word1"] = "一座荒废的祭坛里，似乎有什么邪恶力量在蠢蠢欲动！",
		["Word2"] = "一群怪物似乎守护者什么邪恶的秘密！不一探究竟是不会知道其中的秘密！（击败怪物会有丰富的奖励）",
	},
	[327] = {
		["DescID"] = 327,
		["Word1"] = "一座荒废的祭坛里，似乎有什么邪恶力量在蠢蠢欲动！",
		["Word2"] = "一座荒废的祭坛里，似乎有什么邪恶力量在蠢蠢欲动！",
	},
	[328] = {
		["DescID"] = 328,
		["Word1"] = " 这是测试用的挂机点，不相关的人员请绕道",
		["Word2"] = " 这是测试用的挂机点，不相关的人员请绕道。（击败怪物会有丰厚的奖励）",
	},
	[329] = {
		["DescID"] = 329,
		["Word1"] = " 这是测试用的挂机点，不相关的人员请绕道",
		["Word2"] = " 这是测试用的挂机点，攻击守怪能增加挂机收益。",
		["Word3"] = " 这是测试用的挂机点，攻击守怪能增加挂机收益。",
		["Word4"] = "你解除了使怪物发狂的法阵！这使你的挂机收益提升了20%",
	},
	[330] = {
		["DescID"] = 330,
		["Word1"] = " 这是测试用的挂机点，不相关的人员请绕道",
		["Word2"] = " 这是测试用的挂机点，不相关的人员请绕道。（击败怪物会有丰厚的奖励）",
	},
	[331] = {
		["DescID"] = 331,
		["Word1"] = " 这是测试用的挂机点，不相关的人员请绕道",
		["Word2"] = " 这是测试用的挂机点，不相关的人员请绕道。",
	},
	[332] = {
		["DescID"] = 332,
		["Word1"] = "被废弃的神庙里，怪物在乱跑！",
		["Word2"] = "神殿里的怪物，见到你就开始发动攻击，持续不断的！（击败怪物会有丰厚的奖励）",
	},
	[333] = {
		["DescID"] = 333,
		["Word1"] = "神殿的深处，一个巨大的邪灵正在复活！（击败boss可获得收益提升）",
		["Word2"] = "神殿的深处，一个巨大的邪灵正在复活！（击败boss可获得收益提升）",
		["Word3"] = "神殿的深处，一个巨大的邪灵正在复活！（击败boss可获得收益提升）",
		["Word4"] = "你消灭了巨大的邪灵！这使你的挂机收益提升了20%",
	},
	[334] = {
		["DescID"] = 334,
		["Word1"] = "被废弃的神庙里，怪物在乱跑！",
		["Word2"] = "神殿里的怪物，见到你就开始发动攻击，持续不断的！（击败怪物会有丰厚的奖励）",
	},
	[335] = {
		["DescID"] = 335,
		["Word1"] = "被废弃的神庙里，怪物在乱跑！",
		["Word2"] = "神殿里的怪物，见到你就开始发动攻击，持续不断的！（击败怪物会有丰厚的奖励）",
	},
	[336] = {
		["DescID"] = 336,
		["Word1"] = "一个幽深的洞窟，里面不断地传出可怕的哀嚎！",
		["Word2"] = "进入洞穴，马上你就被一群嗜血的怪物攻击！（击败怪物会有丰厚的奖励）",
	},
	[337] = {
		["DescID"] = 337,
		["Word1"] = "很快你发现这些怪物都怕光，而只有一只完全无惧阳光！（击败boss可获得收益提升）",
		["Word2"] = "很快你发现这些怪物都怕光，而只有一只完全无惧阳光！（击败boss可获得收益提升）",
		["Word3"] = "很快你发现这些怪物都怕光，而只有一只完全无惧阳光！（击败boss可获得收益提升）",
		["Word4"] = "你消灭了洞窟里最强大的怪物！这使你的挂机收益提升了20%",
	},
	[338] = {
		["DescID"] = 338,
		["Word1"] = "一个幽深的洞窟，里面不断地传出可怕的哀嚎！",
		["Word2"] = "进入洞穴，马上你就被一群嗜血的怪物攻击！（击败怪物会有丰厚的奖励）",
	},
	[339] = {
		["DescID"] = 339,
		["Word1"] = "一个幽深的洞窟，里面不断地传出可怕的哀嚎！",
		["Word2"] = "进入洞穴，马上你就被一群嗜血的怪物攻击！（击败怪物会有丰厚的奖励）",
	},
	[340] = {
		["DescID"] = 340,
		["Word1"] = "一座巨大的兵营，里面不时的传出咔哒的声音！",
		["Word2"] = "这里是魔王的兵营，你不得不击败这些魔王的士兵！（击败怪物会有丰厚的奖励）",
	},
	[341] = {
		["DescID"] = 341,
		["Word1"] = "你在战斗中，发现了敌人的指挥官，正在指挥着敌人！（击败boss可获得收益提升）",
		["Word2"] = "你在战斗中，发现了敌人的指挥官，正在指挥着敌人！（击败boss可获得收益提升）",
		["Word3"] = "你在战斗中，发现了敌人的指挥官，正在指挥着敌人！（击败boss可获得收益提升）",
		["Word4"] = "你消灭了敌军的指挥官！这使你的挂机收益提升了20%",
	},
	[342] = {
		["DescID"] = 342,
		["Word1"] = "一座安静的城堡，看上去是个落脚的好地方",
		["Word2"] = "城堡里面充满了正在发疯一样互相攻击的怪物，显然它们都疯了。只有你能赐予它们安息。（击败怪物会有丰厚的奖励）",
	},
	[343] = {
		["DescID"] = 343,
		["Word1"] = "一座安静的城堡，看上去是个落脚的好地方",
		["Word2"] = "一座安静的城堡，看上去是个落脚的好地方",
	},
	[344] = {
		["DescID"] = 344,
		["Word1"] = "巨大的树屋里，根本看不到里面发生了什么！",
		["Word2"] = "进入到树屋里面，到处都是正在想要袭击你的怪物！（击败怪物会有丰厚的奖励）",
	},
	[345] = {
		["DescID"] = 345,
		["Word1"] = "树屋的深处，一只巨大的怪物仿佛从树屋里生长出来一样！（击败boss可获得收益提升）",
		["Word2"] = "树屋的深处，一只巨大的怪物仿佛从树屋里生长出来一样！（击败boss可获得收益提升）",
		["Word3"] = "树屋的深处，一只巨大的怪物仿佛从树屋里生长出来一样！（击败boss可获得收益提升）",
		["Word4"] = "你消灭了树屋的活体，削弱了大量的敌人！这使你的挂机收益提升了20%",
	},
	[346] = {
		["DescID"] = 346,
		["Word1"] = "巨大的树屋里，根本看不到里面发生了什么！",
		["Word2"] = "进入到树屋里面，到处都是正在想要袭击你的怪物！（击败怪物会有丰厚的奖励）",
	},
	[347] = {
		["DescID"] = 347,
		["Word1"] = "巨大的树屋里，根本看不到里面发生了什么！",
		["Word2"] = "进入到树屋里面，到处都是正在想要袭击你的怪物！（击败怪物会有丰厚的奖励）",
	},
	[400] = {
		["DescID"] = 400,
		["Word1"] = "一座神秘的树屋，孤零零的矗立在荒废的空地上。里面发出了不断地地狱般的恐怖声音！",
		["Word2"] = "大量发狂的人和怪物正在疯狂的向一切看得到的活物发动攻击！（击败怪物会有丰富的奖励）",
	},
	[401] = {
		["DescID"] = 401,
		["Word1"] = "一座神秘的树屋，孤零零的矗立在荒废的空地上。里面发出了不断地地狱般的恐怖声音！",
		["Word2"] = "一座神秘的树屋，孤零零的矗立在荒废的空地上。里面发出了不断地地狱般的恐怖声音！",
	},
	[402] = {
		["DescID"] = 402,
		["Word1"] = "一座神秘的树屋，里面已经空荡荡的。",
		["Word2"] = "一座神秘的树屋，里面已经空荡荡的。",
	},
	[500] = {
		["DescID"] = 500,
		["Word1"] = "此据点资源有限，火速来抢，可迁移到这里挂机。",
		["Word2"] = "此据点资源有限，火速来抢，可迁移到这里挂机。是否要迁移到此限时挂机点？",
	},
	[501] = {
		["DescID"] = 501,
		["Word1"] = "你可以选择挑战守怪来立即收获剩余的挂机收益",
		["Word2"] = "你可以选择挑战守怪来立即收获剩余的挂机收益",
	},
	[502] = {
		["DescID"] = 502,
		["Word1"] = "这里是限时挂机点。挂机点已空。",
		["Word2"] = "这里是限时挂机点。挂机点已空。",
	},
	[600] = {
		["DescID"] = 600,
		["Word1"] = "一群拦路的火龙，看起来十分凶猛。",
		["Word2"] = "是否要挑战这些怪物？",
	},
	[601] = {
		["DescID"] = 601,
		["Word1"] = "一大堆蘑菇长在路边",
		["Word2"] = "你不小心踩碎了一个蘑菇，结果一群蘑菇跳了出来！“我们的兄弟就这样被你们踩死了！我们跟你没完！”",
	},
	[602] = {
		["DescID"] = 602,
		["Word1"] = "我要吃肉，我要吃肉！",
		["Word2"] = "看到你走过来，血魔花向你包围了过来。",
	},
	[603] = {
		["DescID"] = 603,
		["Word1"] = "肉！肉！新鲜的肉！",
		["Word2"] = "血魔花发出“肉”的叫声，要攻击你！",
	},
	[604] = {
		["DescID"] = 604,
		["Word1"] = "肉！肉！肉！",
		["Word2"] = "食尸鬼的爪子上滴着鲜血，发出令人不寒而栗的声音！",
	},
	[605] = {
		["DescID"] = 605,
		["Word1"] = "你是肉吗？你是肉吗？",
		["Word2"] = "血魔花像你扑了过来~",
	},
	[606] = {
		["DescID"] = 606,
		["Word1"] = "美杜莎站在路中间，不知道在做什么！",
		["Word2"] = "“不准通过！”美杜莎一边说着，一边开始攻击你！",
	},
	[607] = {
		["DescID"] = 607,
		["Word1"] = "消灭~消灭~消灭~",
		["Word2"] = "骷髅兵很有组织的向你们包围过来！",
	},
	[608] = {
		["DescID"] = 608,
		["Word1"] = "嗬~人类！活着的人类！",
		["Word2"] = "石像鬼大笑着，向你围了过来！",
	},
	[609] = {
		["DescID"] = 609,
		["Word1"] = "所有人都将臣服于主人！",
		["Word2"] = "血腥魔女就在你面前，正在释放她的邪恶魔法！",
	},
	[610] = {
		["DescID"] = 610,
		["Word1"] = "噗嗤~噗嗤~噗嗤~",
		["Word2"] = "冒泡的史莱姆，像你攻了过来！",
	},
	[611] = {
		["DescID"] = 611,
		["Word1"] = "水的力量是无敌的！",
		["Word2"] = "水元素们看到你，就逼近过来发动攻击！",
	},
	[612] = {
		["DescID"] = 612,
		["Word1"] = "你们身上的火必须被扑灭！",
		["Word2"] = "水元素们看到你不由分说开始向你身上喷水，中间还夹杂着冰雹！",
	},
	[613] = {
		["DescID"] = 613,
		["Word1"] = "噗嗤~噗嗤~噗嗤~",
		["Word2"] = "冒泡的史莱姆，像你攻了过来！",
	},
	[614] = {
		["DescID"] = 614,
		["Word1"] = "噗嗤~噗嗤~噗嗤~",
		["Word2"] = "冒泡的史莱姆，像你攻了过来！",
	},
	[700] = {
		["DescID"] = 700,
		["Word1"] = "这个怪物似乎要跟你说什么",
		["Word2"] = "你可以支付一定的步数收买这个怪物，或者战胜它来让它让路，你想怎么选择？",
	},
	[800] = {
		["DescID"] = 800,
		["Word1"] = "一座阴森高塔。看起来有一场持久战，如果扛不住了，可以下次中途退出，下次继续。",
		["Word2"] = "你是否要进去？",
		["Word3"] = "1层怪物描述，是否挑战？",
		["Word4"] = "2层怪物描述，是否挑战？",
		["Word5"] = "3层怪物描述，是否挑战？",
		["Word6"] = "4层怪物描述，是否挑战？",
		["Word7"] = "5层怪物描述，是否挑战？",
		["Word8"] = "6层怪物描述，是否挑战？",
		["Word9"] = "7层怪物描述，是否挑战？",
		["Word10"] = "8层怪物描述，是否挑战？",
		["Word11"] = "你已扫荡了这里。",
	},
	[801] = {
		["DescID"] = 801,
		["Word1"] = "一座阴森高塔。里面已经什么都没有了。",
		["Word2"] = "里面已经什么都没有了。",
	},
	[900] = {
		["DescID"] = 900,
		["Word1"] = "神秘洞窟里隐藏着什么？是宝藏还是怪物？",
		["Word2"] = "神秘洞窟里隐藏着什么？是宝藏还是怪物？\n是否要一探究竟？",
	},
	[901] = {
		["DescID"] = 901,
		["Word1"] = "此神秘洞窟已空。",
	},
	[902] = {
		["DescID"] = 902,
		["Word1"] = "散发着邪恶气息的房子里，似乎隐藏着什么。",
		["Word2"] = "散发着邪恶气息的房子里，似乎隐藏着什么。\n是否要一探究竟？",
	},
	[903] = {
		["DescID"] = 903,
		["Word1"] = "此房子已空。",
	},
	[904] = {
		["DescID"] = 904,
		["Word1"] = "荒野上的修道院，里面到底有着什么东西？让人感觉如此的恐怖。",
		["Word2"] = "荒野上的修道院，里面到底有着什么东西？让人感觉如此的恐怖。\n是否要一探究竟？",
	},
	[905] = {
		["DescID"] = 905,
		["Word1"] = "此修道院已空。",
	},
	[906] = {
		["DescID"] = 906,
		["Word1"] = "曾经守卫着这片土地的哨塔，里面是旧时代的宝物，还是横行的怪物？",
		["Word2"] = "曾经守卫着这片土地的哨塔，里面是旧时代的宝物，还是横行的怪物？\n是否要一探究竟？",
	},
	[907] = {
		["DescID"] = 907,
		["Word1"] = "此哨塔已空。",
	},
	[908] = {
		["DescID"] = 908,
		["Word1"] = "侏儒性格阴晴不定，他们有时慷慨无比，有时则会袭击一切来访者。",
		["Word2"] = "侏儒性格阴晴不定，他们有时慷慨无比，有时则会袭击一切来访者。\n是否要继续访问？",
	},
	[909] = {
		["DescID"] = 909,
		["Word1"] = "你已访问过侏儒要塞。",
	},
	[910] = {
		["DescID"] = 910,
		["Word1"] = "巨龙巢穴里藏满宝藏，还有——强大的巨龙！",
		["Word2"] = "巨龙巢穴里藏满宝藏，还有——强大的巨龙！\n是否要前往冒险？",
	},
	[911] = {
		["DescID"] = 911,
		["Word1"] = "龙巢已空。",
	},
	[912] = {
		["DescID"] = 912,
		["Word1"] = "战争的遗迹里面藏着大量的物资和神秘的战争机器！",
		["Word2"] = "战争的遗迹里面藏着大量的物资和神秘的战争机器！\n是否要进去？",
	},
	[913] = {
		["DescID"] = 913,
		["Word1"] = "此遗迹里已空。",
	},
	[1000] = {
		["DescID"] = 1000,
		["Word1"] = "通过这里，你就可以前往血色森林，追击血腥魔女！",
		["Word2"] = "血腥魔女留下来的巨大怪物挡在渡口前，你必须击败它才能继续前进。",
	},
	[1001] = {
		["DescID"] = 1001,
		["Word1"] = "管理员：“通过这里你就可以前往血色森林，点击确认即可进入下一张地图！”",
		["Word2"] = "管理员：“通过这里你就可以前往血色森林，点击确认即可进入下一张地图！”",
	},
	[1002] = {
		["DescID"] = 1002,
		["Word1"] = "要前往新的区域必须经过这个传送门",
		["Word2"] = "一个发狂的人正在这里破坏，它必须被阻止！",
	},
	[1003] = {
		["DescID"] = 1003,
		["Word1"] = "现在可以继续前进了，显然怪物的狂暴是血腥魔女的原因，她必须被阻止。",
		["Word2"] = "现在可以继续前进了，显然怪物的狂暴是血腥魔女的原因，她必须被阻止。",
	},
	[1004] = {
		["DescID"] = 1004,
		["Word1"] = "离开森林的道路被封锁了！有人挡住了人们的去路！",
		["Word2"] = "一群士兵试图阻止任何人通过，你是否要击败他们？",
	},
	[1005] = {
		["DescID"] = 1005,
		["Word1"] = "现在你可以前往卓尔湖畔！",
		["Word2"] = "现在你可以前往卓尔湖畔！",
	},
	[1006] = {
		["DescID"] = 1006,
		["Word1"] = "路口被一群怪物封锁了。",
		["Word2"] = "德古拉伯爵的手下封锁了路口，必须击败它们才能前往德古拉的城堡！",
	},
	[1007] = {
		["DescID"] = 1007,
		["Word1"] = "现在，通向德古拉伯爵城堡的道路已经被打通了！",
		["Word2"] = "现在，通向德古拉伯爵城堡的道路已经被打通了！",
	},
	[1100] = {
		["DescID"] = 1100,
		["Word1"] = "我将会替你补给所有的魔晶，让你拥有足够的魔力继续作战。",
	},
	[1200] = {
		["DescID"] = 1200,
		["Word1"] = "拥有神奇力量的泉水会减少行动力消耗",
	},
	[1201] = {
		["DescID"] = 1201,
		["Word1"] = "此处已空",
		["Word2"] = "此处已空",
	},
	[1300] = {
		["DescID"] = 1300,
		["Word1"] = "此处可以购买利于行走的交通工具",
	},
	[1400] = {
		["DescID"] = 1400,
		["Word1"] = "此处可以获得地图的情报信息",
	},
	[1500] = {
		["DescID"] = 1500,
		["Word1"] = "商店。快来看看有什么需要的。",
	},
	[1600] = {
		["DescID"] = 1600,
		["Word1"] = "很高的塔，可以打开5视野",
	},
	[1601] = {
		["DescID"] = 1601,
		["Word1"] = "视野已经打开",
		["Word2"] = "视野已经打开",
	},
	[1602] = {
		["DescID"] = 1602,
		["Word1"] = "什么？你说我下方有装备？我不知道啊~我说过这话？我不记得了！",
		["Word2"] = "什么？你说我下方有装备？我不知道啊~我说过这话？我不记得了！",
	},
	[1603] = {
		["DescID"] = 1603,
		["Word1"] = "你在看什么？我们完美的身材吗？算你有眼光，我塞希师诉你，往北走有宝物可别错过了！",
		["Word2"] = "你在看什么？我们完美的身材吗？算你有眼光，我塞希师诉你，往北走有宝物可别错过了！",
	},
	[1700] = {
		["DescID"] = 1700,
		["Word1"] = "可以传送到下一张地图！",
	},
	[1800] = {
		["DescID"] = 1800,
		["Word1"] = "这是一个邮筒，看看有没有你的信件",
	},
	[9009] = {
		["DescID"] = 9009,
		["Word1"] = "神秘的时空之门，它将要通往何方？那里会有一番怎样的洞天？",
		["Word2"] = "是否要一探究竟？",
	},
	[9010] = {
		["DescID"] = 9010,
		["Word1"] = "神秘的时空之门。",
	},
	[9011] = {
		["DescID"] = 9011,
		["Word1"] = "神秘的时空之门。",
	},
	[9012] = {
		["DescID"] = 9012,
		["Word1"] = "神秘的时空之门。",
		["Word2"] = "此门已经关闭。",
	},
	[9013] = {
		["DescID"] = 9013,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声",
		["Word2"] = "阴森的洞穴里不断地发出骇人的惨叫声，是否要一探究竟？",
	},
	[9014] = {
		["DescID"] = 9014,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声",
		["Word2"] = "一直巨大的怪物从里面冲了出来……",
	},
	[9015] = {
		["DescID"] = 9015,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声",
		["Word2"] = "你发现了一具腐烂的尸体，上面有一些宝物。",
	},
	[9016] = {
		["DescID"] = 9016,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声",
		["Word2"] = "此门已经关闭。",
	},
	[9017] = {
		["DescID"] = 9017,
		["Word1"] = "消失于时间尽头的遗迹，富丽堂皇的建筑散发着神秘的幽光。",
		["Word2"] = "消失于时间尽头的遗迹，富丽堂皇的建筑散发着神秘的幽光。，是否要一探究竟？",
	},
	[9018] = {
		["DescID"] = 9018,
		["Word1"] = "消失于时间尽头的遗迹，富丽堂皇的建筑散发着神秘的幽光。",
		["Word2"] = "遗迹的守卫者出现了！",
	},
	[9019] = {
		["DescID"] = 9019,
		["Word1"] = "消失于时间尽头的遗迹，富丽堂皇的建筑散发着神秘的幽光。",
		["Word2"] = "遗迹里面发现了上古的宝藏",
	},
	[9020] = {
		["DescID"] = 9020,
		["Word1"] = "消失于时间尽头的遗迹，富丽堂皇的建筑散发着神秘的幽光。",
		["Word2"] = "此门已经关闭。",
	},
	[9021] = {
		["DescID"] = 9021,
		["Word1"] = "被封闭的大门仅仅的关上，除非你有魔法钥匙，否则绝不可能进入",
		["Word2"] = "被封闭的大门仅仅的关上，除非你有魔法钥匙，否则绝不可能进入，是否要一探究竟？",
	},
	[9022] = {
		["DescID"] = 9022,
		["Word1"] = "被封闭的大门仅仅的关上，除非你有魔法钥匙，否则绝不可能进入",
		["Word2"] = "被封印千年的怪物出现在了房间之中！",
	},
	[9023] = {
		["DescID"] = 9023,
		["Word1"] = "被封闭的大门仅仅的关上，除非你有魔法钥匙，否则绝不可能进入",
		["Word2"] = "神秘的房间里发现了宝藏",
	},
	[9024] = {
		["DescID"] = 9024,
		["Word1"] = "被封闭的大门仅仅的关上，除非你有魔法钥匙，否则绝不可能进入",
		["Word2"] = "此门已经关闭。",
	},
	[9025] = {
		["DescID"] = 9025,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。，是否要一探究竟？",
	},
	[9026] = {
		["DescID"] = 9026,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "你的到来惊醒了沉睡的怪物，它们像你发动了攻击！",
	},
	[9027] = {
		["DescID"] = 9027,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "里面有许多已经死去的尸体，他们安详的躺着，把宝物留给了你！",
	},
	[9028] = {
		["DescID"] = 9028,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "此门已经关闭。",
	},
	[9029] = {
		["DescID"] = 9029,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味。",
		["Word2"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味，是否要探索这个营地？",
	},
	[9030] = {
		["DescID"] = 9030,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味。",
		["Word2"] = "疯狂的怪物开始拼命像你发动攻击！",
	},
	[9031] = {
		["DescID"] = 9031,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味。",
		["Word2"] = "你在死去的怪物身上找到了不少宝物！",
	},
	[9032] = {
		["DescID"] = 9032,
		["Word1"] = "发疯的怪物四处奔跑，身上散发着腐烂的气味。",
		["Word2"] = "此门已经关闭。",
	},
	[9033] = {
		["DescID"] = 9033,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "黑暗的洞口里，传出细不可闻的呜咽声。是否要一探究竟？",
	},
	[9034] = {
		["DescID"] = 9034,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "受伤的人已经彻底发狂了，他们开始攻击你们。",
	},
	[9035] = {
		["DescID"] = 9035,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "你拯救了洞中的伤者，他们给了你许多谢礼。",
	},
	[9036] = {
		["DescID"] = 9036,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "此门已经关闭。",
	},
	[9037] = {
		["DescID"] = 9037,
		["Word1"] = "水井里似乎隐藏着什么东西，要不要打捞上来？",
		["Word2"] = "水井里似乎隐藏着什么东西，要不要打捞上来？",
	},
	[9038] = {
		["DescID"] = 9038,
		["Word1"] = "水井里似乎隐藏着什么东西，要不要打捞上来？",
		["Word2"] = "井里冒出了巨大的怪物，要把你吞噬！",
	},
	[9039] = {
		["DescID"] = 9039,
		["Word1"] = "水井里似乎隐藏着什么东西，要不要打捞上来？",
		["Word2"] = "井下居然有一个宝箱，你开心的打开了它！",
	},
	[9040] = {
		["DescID"] = 9040,
		["Word1"] = "水井里似乎隐藏着什么东西，要不要打捞上来？",
		["Word2"] = "此门已经关闭。",
	},
	[9041] = {
		["DescID"] = 9041,
		["Word1"] = "瀑布的后面漏出了一个洞穴，上面有神秘的三个方型标志。",
		["Word2"] = "瀑布的后面漏出了一个洞穴，上面有神秘的三个方型标志，是否要一探究竟？",
	},
	[9042] = {
		["DescID"] = 9042,
		["Word1"] = "瀑布的后面漏出了一个洞穴，上面有神秘的三个方型标志。",
		["Word2"] = "洞里冲出了许多无人知晓的怪物，你不得不对抗他们！",
	},
	[9043] = {
		["DescID"] = 9043,
		["Word1"] = "瀑布的后面漏出了一个洞穴，上面有神秘的三个方型标志。",
		["Word2"] = "洞穴里有一个巨大的金属柱子，你没法带走它，但还是挂了点金属带走。",
	},
	[9044] = {
		["DescID"] = 9044,
		["Word1"] = "瀑布的后面漏出了一个洞穴，上面有神秘的三个方型标志。",
		["Word2"] = "此门已经关闭。",
	},
	[9045] = {
		["DescID"] = 9045,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所空洞的小屋上嚎叫着。",
		["Word2"] = "嘎~嘎~嘎~乌鸦在一所空洞的小屋上嚎叫着。你要进入这房子么？",
	},
	[9046] = {
		["DescID"] = 9046,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所空洞的小屋上嚎叫着。",
		["Word2"] = "房子里有一个已经彻底变异的怪物，像你发动了强大攻击。",
	},
	[9047] = {
		["DescID"] = 9047,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所空洞的小屋上嚎叫着。",
		["Word2"] = "房子里留下了原来主人的宝物，你小心的替它们的主人保管它们。",
	},
	[9048] = {
		["DescID"] = 9048,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所空洞的小屋上嚎叫着。",
		["Word2"] = "此门已经关闭。",
	},
	[9049] = {
		["DescID"] = 9049,
		["Word1"] = "在水井旁边发现了一个深深的洞穴，里面似乎有什么。",
		["Word2"] = "在水井旁边发现了一个深深的洞穴，里面似乎有什么。",
	},
	[9050] = {
		["DescID"] = 9050,
		["Word1"] = "在水井旁边发现了一个深深的洞穴，里面似乎有什么。",
		["Word2"] = "洞穴里充满了被邪恶魔法影响的疯狂生物，你只能消灭他们。",
	},
	[9051] = {
		["DescID"] = 9051,
		["Word1"] = "在水井旁边发现了一个深深的洞穴，里面似乎有什么。",
		["Word2"] = "巨大的洞穴里堆满了各种宝物，你很开心的接收了所有的宝物。",
	},
	[9052] = {
		["DescID"] = 9052,
		["Word1"] = "在水井旁边发现了一个深深的洞穴，里面似乎有什么。",
		["Word2"] = "此门已经关闭。",
	},
	[9053] = {
		["DescID"] = 9053,
		["Word1"] = "正在四处寻找儿子的鱼人",
		["Word2"] = "现在所有人都发了疯，我妻子被杀死了，我儿子不知道哪里去了！你帮我找到我儿子，我就让你通过怎么样？他最喜欢的书是《皮克斯》。",
	},
	[9054] = {
		["DescID"] = 9054,
		["Word1"] = "正在四处寻找儿子的鱼人",
		["Word2"] = "要跟我打一架吗？",
	},
	[9055] = {
		["DescID"] = 9055,
		["Word1"] = "正在四处寻找儿子的鱼人",
		["Word2"] = "感谢你，这个礼物就送给你了。",
	},
	[9056] = {
		["DescID"] = 9056,
		["Word1"] = "正在四处寻找儿子的鱼人",
		["Word2"] = "谢谢你，我的朋友",
	},
	[9057] = {
		["DescID"] = 9057,
		["Word1"] = "美丽的少女啊你在哪里？如果你给我一瓶少女的黄金水，我就让你通过！",
		["Word2"] = "美丽的少女啊你在哪里？如果你给我一瓶少女的黄金水，我就让你通过！",
	},
	[9058] = {
		["DescID"] = 9058,
		["Word1"] = "美丽的少女啊你在哪里？如果你给我一瓶少女的黄金水，我就让你通过！",
		["Word2"] = "啊~这颜色多么漂亮~~听说它能够增强灵力，我喝完你跟我打一架。",
	},
	[9059] = {
		["DescID"] = 9059,
		["Word1"] = "美丽的少女啊你在哪里？如果你给我一瓶少女的黄金水，我就让你通过！",
		["Word2"] = "感谢你，这个礼物就送给你了。",
	},
	[9060] = {
		["DescID"] = 9060,
		["Word1"] = "美丽的少女啊你在哪里？",
		["Word2"] = "谢谢你，我的朋友",
	},
	[19011] = {
		["DescID"] = 19011,
		["Word1"] = "逃出林间营地的蘑菇一家",
	},
	[19012] = {
		["DescID"] = 19012,
		["Word1"] = "去采蘑菇路上的蘑菇们",
	},
	[19021] = {
		["DescID"] = 19021,
		["Word1"] = "飘在空中的光灵，一副受惊的样子",
	},
	[19022] = {
		["DescID"] = 19022,
		["Word1"] = "陷入了迷乱状态的美杜莎",
	},
	[19031] = {
		["DescID"] = 19031,
		["Word1"] = "一个逃离了魔王军队的骷髅兵",
	},
	[19032] = {
		["DescID"] = 19032,
		["Word1"] = "起义对抗魔王暴行的骷髅兵",
	},
	[512001011] = {
		["DescID"] = 512001011,
		["Word1"] = "拥有神奇力量的泉水会消除步数消耗",
	},
	[512001012] = {
		["DescID"] = 512001012,
		["Word1"] = "此处已空",
		["Word2"] = "此处已空",
	},
	[101001011] = {
		["DescID"] = 101001011,
		["Word1"] = "拾取可以获得好东西",
	},
	[101001012] = {
		["DescID"] = 101001012,
		["Word1"] = "开盖有惊喜！",
	},
	[101001013] = {
		["DescID"] = 101001013,
		["Word1"] = "不知道谁在路边丢了一堆钱",
	},
	[101001014] = {
		["DescID"] = 101001014,
		["Word1"] = "打造装备的材料",
	},
	[501005011] = {
		["DescID"] = 501005011,
		["Word1"] = "这个宝箱太大了，留着最后开。",
	},
	[402001011] = {
		["DescID"] = 402001011,
		["Word1"] = "魔女的宝袋",
		["Word2"] = "被施了魔法的宝袋里有无数的宝贝，但是你无法同时取走多个，你只能做出选择。",
		["Word3"] = "恭喜你获得以下道具！",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "你真幸运，顺利地拿到以下宝贝！",
		["Word6"] = "真不好意思，什么都没得到。",
	},
	[402001012] = {
		["DescID"] = 402001012,
		["Word1"] = "魔女掉落的一个宝袋",
		["Word2"] = "宝贝你已经取过，无法再取。",
	},
	[402002011] = {
		["DescID"] = 402002011,
		["Word1"] = "国王的宝藏",
		["Word2"] = "你只能获得宝箱中的一个道具！",
		["Word3"] = "恭喜你获得以下道具！",
		["Word4"] = "这个格子里面是空的。",
		["Word5"] = "你真幸运，顺利地拿到以下宝贝！",
		["Word6"] = "这个格子里面是空的。",
	},
	[402002012] = {
		["DescID"] = 402002012,
		["Word1"] = "国王的宝藏",
		["Word2"] = "宝贝你已经取过，无法再取。",
	},
	[502001011] = {
		["DescID"] = 502001011,
		["Word1"] = "一个憨厚老实的石头人正在悬崖边愁眉苦脸，不会是想不开吧？",
		["Word2"] = "我捡到一把秘境的开启钥匙，传说如果看不懂这钥匙的材质，就不是命运选中的勇者，不配拿到秘境里的宝藏。你来看看它是金钥匙还是铜钥匙？",
		["Word3"] = "恭喜你获得以下道具！",
		["Word4"] = "什么？你就是那个命运选中的人？不，我不甘心！我要把钥匙扔落悬崖，让你做不了勇者。",
		["Word5"] = "恭喜你获得以下道具！",
		["Word6"] = "太遗憾，你猜错了，看来你不是勇者，勇者是会先从远处查看洞穴信息再来回答我的。",
	},
	[502001012] = {
		["DescID"] = 502001012,
		["Word1"] = "人类，再见！",
		["Word2"] = "人类，再见！",
	},
	[502002011] = {
		["DescID"] = 502002011,
		["Word1"] = "一只捧着魔晶的光灵，正在草丛中转圈。",
		["Word2"] = "我为森林之王献上魔晶，它给我两个袋子，一个袋子能拿到一件普通宝器，另一个袋子有概率拿到稀有宝器，你说我选哪个好？",
		["Word3"] = "相信你准没错。",
		["Word4"] = "你害了我。",
		["Word5"] = "哎呀！太幸运了，拿到稀有宝器了。",
		["Word6"] = "哎呀，你害苦了我，我什么也得不到了！",
	},
	[502002012] = {
		["DescID"] = 502002012,
		["Word1"] = "一只抱着魔晶的小光灵。",
		["Word2"] = "人类，再见。",
	},
	[602001011] = {
		["DescID"] = 602001011,
		["Word1"] = "魔女的宝袋",
		["Word2"] = "被施了魔法的宝袋里有无数的宝贝，但是你无法同时取走多个，你只能做出选择。",
		["Word3"] = "恭喜你获得以下道具！",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "你真幸运，顺利地拿到以下宝贝！",
		["Word6"] = "真不好意思，什么都没得到。",
	},
	[602001012] = {
		["DescID"] = 602001012,
		["Word1"] = "魔女掉落的一个宝袋",
		["Word2"] = "宝贝你已经取过，无法再取。",
	},
	[106001011] = {
		["DescID"] = 106001011,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "不要问我从哪里来，你是打不过我的。",
	},
	[106001012] = {
		["DescID"] = 106001012,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "好想找人打架啊……",
	},
	[106001013] = {
		["DescID"] = 106001013,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "你为什么要蹂躏我这个娇小的身躯？",
	},
	[106001014] = {
		["DescID"] = 106001014,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "你为什么不蹂躏旁边那个娇小的身躯？",
	},
	[106001015] = {
		["DescID"] = 106001015,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "他背后似乎有不少宝贝",
	},
	[106001016] = {
		["DescID"] = 106001016,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "他背后有很多钱，钱可以买东西",
	},
	[106001017] = {
		["DescID"] = 106001017,
		["Word1"] = "一个怪物挡在路上",
		["Word2"] = "他背后有箱子，总不会让你空手而归",
	},
	[106001018] = {
		["DescID"] = 106001018,
		["Word1"] = "好像是你的王叔带领军团堵住了你前进的路",
		["Word2"] = "俺的侄儿啊！乖乖放下你的武器，跟叔叔，还是舅舅？不管了，回家去吧！老子给你取个媳妇。",
	},
	[119001011] = {
		["DescID"] = 119001011,
		["Word1"] = "它似乎有话对你说",
	},
	[116001011] = {
		["DescID"] = 116001011,
		["Word1"] = "很高的塔，可以打开视野",
		["Word2"] = "视野已经打开",
	},
	[309001011] = {
		["DescID"] = 309001011,
		["Word1"] = "看似祥和的森林营地，但是静得可怕。",
		["Word2"] = "看似祥和的森林营地，但是静得可怕。是否要进去看看？",
	},
	[309001012] = {
		["DescID"] = 309001012,
		["Word1"] = "看似祥和的森林营地，但是静得可怕。",
		["Word2"] = "很不幸！一群蘑菇疯狂地冲了出来，是否迎战？",
	},
	[309001013] = {
		["DescID"] = 309001013,
		["Word1"] = "看似祥和的森林营地，但是静得可怕。",
		["Word2"] = "这里似乎经过了一场激斗，只剩下满地破败，你在帐篷里捡到了旅人遗落的丰厚财宝。",
	},
	[309001014] = {
		["DescID"] = 309001014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
	[409001011] = {
		["DescID"] = 409001011,
		["Word1"] = "一座巨大的兵营，里面不时的传出咔哒的声音！",
		["Word2"] = "一座巨大的兵营，里面不时的传出咔哒的声音！是否要进去一探究竟？",
	},
	[409001012] = {
		["DescID"] = 409001012,
		["Word1"] = "一座巨大的兵营，里面不时的传出咔哒的声音！",
		["Word2"] = "这里是魔王的兵营，你很不幸地遇到了魔兵，不得不展开战斗。",
	},
	[409001013] = {
		["DescID"] = 409001013,
		["Word1"] = "一座巨大的兵营，里面不时的传出咔哒的声音！",
		["Word2"] = "这里是魔王的兵营，人去楼空，像是经历了一场浩劫。但是很幸运地挖出了几箱宝物",
	},
	[409001014] = {
		["DescID"] = 409001014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
	[409002011] = {
		["DescID"] = 409002011,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所诡异的树洞上空嚎叫着。",
		["Word2"] = "嘎~嘎~嘎~乌鸦在一所诡异的树洞上空嚎叫着。你是否要进去查探？",
	},
	[409002012] = {
		["DescID"] = 409002012,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所诡异的树洞上空嚎叫着。",
		["Word2"] = "树洞里有一个已经彻底变异的怪物，像你发动了强大攻击。",
	},
	[409002013] = {
		["DescID"] = 409002013,
		["Word1"] = "嘎~嘎~嘎~乌鸦在一所诡异的树洞上空嚎叫着。",
		["Word2"] = "树洞里留下了不知何人的宝物，你小心的以保管之名拿走了它。",
	},
	[409002014] = {
		["DescID"] = 409002014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
	[509001011] = {
		["DescID"] = 509001011,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声，没有金钥匙，将打不开洞口的大门。",
		["Word2"] = "阴森的洞穴里不断地发出骇人的惨叫声，是否要一探究竟？",
	},
	[509001012] = {
		["DescID"] = 509001012,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声，没有金钥匙，将打不开洞口的大门。",
		["Word2"] = "一直巨大的怪物从里面冲了出来……",
	},
	[509001013] = {
		["DescID"] = 509001013,
		["Word1"] = "阴森的洞穴里不断地发出骇人的惨叫声，没有金钥匙，将打不开洞口的大门。",
		["Word2"] = "你发现了一具腐烂的尸体，上面有一些宝物。",
	},
	[509001014] = {
		["DescID"] = 509001014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
	[509002011] = {
		["DescID"] = 509002011,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "黑暗的洞口里，传出细不可闻的呜咽声。是否要一探究竟？",
	},
	[509002012] = {
		["DescID"] = 509002012,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "受伤的人已经彻底发狂了，他们开始攻击你们。",
	},
	[509002013] = {
		["DescID"] = 509002013,
		["Word1"] = "黑暗的洞口里，传出细不可闻的呜咽声。",
		["Word2"] = "你拯救了洞中的伤者，他们给了你许多谢礼。",
	},
	[509002014] = {
		["DescID"] = 509002014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
	[509003011] = {
		["DescID"] = 509003011,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。，是否要一探究竟？",
	},
	[509003012] = {
		["DescID"] = 509003012,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "你的到来惊醒了沉睡的怪物，它们像你发动了攻击！",
	},
	[509003013] = {
		["DescID"] = 509003013,
		["Word1"] = "巨大的光芒笼罩着神秘建筑的入口，看着它就让人昏昏欲睡。",
		["Word2"] = "里面有许多已经死去的尸体，他们安详的躺着，把宝物留给了你！",
	},
	[509003014] = {
		["DescID"] = 509003014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
	[309002011] = {
		["DescID"] = 309002011,
		["Word1"] = "王国英雄的石像。",
		["Word2"] = "传说中英雄石像手里的蓝宝石是个机关，可以被命运之子取下来。命运之子将携带英雄石像的宝藏，去战胜黑暗，释放光明。你是否想尝试取下宝石？",
	},
	[309002012] = {
		["DescID"] = 309002012,
		["Word1"] = "王国英雄的石像。",
		["Word2"] = "你的行为惊醒了沉睡的怪物，它们像你发动了攻击！",
	},
	[309002013] = {
		["DescID"] = 309002013,
		["Word1"] = "王国英雄的石像。",
		["Word2"] = "你获得了巨大的宝藏",
	},
	[309002014] = {
		["DescID"] = 309002014,
		["Word1"] = "此处已经探索过。",
		["Word2"] = "此处已经探索过。",
	},
},
};


return elementdesc[1]
