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
		["Word1"] = "一个闪闪发光的箱子",
	},
	[200] = {
		["DescID"] = 200,
		["Word1"] = "魔女掉落的一个宝袋",
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
		["Word2"] = "人类，你来的正好！我要把魔晶卖给老商人呢？还是卖给那只奇怪的花？它说会给我双倍价钱。",
		["Word3"] = "恩，你说得对，它长得太丑了我不能相信它，这点金币就当我送给你的谢礼。",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "太幸运了！它真的给我双倍价了，这份金币我就送给你吧。",
		["Word6"] = "我的魔晶被它骗走了！我再也不想理你了！你走吧。",
	},
	[203] = {
		["DescID"] = 203,
		["Word1"] = "一只抱着魔晶的小光灵",
		["Word2"] = "人类，你还有什么事吗？",
	},
	[204] = {
		["DescID"] = 204,
		["Word1"] = "供奉森林之神的聚宝盆",
		["Word2"] = "这个聚宝盆塞满了宝物，森林之神允许过路的旅人拿走其中一件，太贪婪的人也许什么也拿不走。",
		["Word3"] = "你是个踏实的人，森林之神慷慨地将礼物送给了你。",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "你是个有勇气的人，森林之神赞赏地将礼物送给了你。",
		["Word6"] = "你太贪婪了，森林之神不想给你任何东西。",
	},
	[205] = {
		["DescID"] = 205,
		["Word1"] = "供奉森林之神的聚宝盆",
		["Word2"] = "无法再次访问。",
	},
	[206] = {
		["DescID"] = 206,
		["Word1"] = "一个上锁的宝箱，没有钥匙打开不了。你可以在附近找找看。",
		["Word2"] = "找到钥匙后你只能开启其中一个格子，你选择开左边的还是右边的？",
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
		["Word1"] = "一个巨大的石头人站在那里，手足无措的站着。",
		["Word2"] = "我...我...问...你...金钥匙...匙是你的，还是铜...铜钥匙？",
		["Word3"] = "其...其实，我...也不知道那是什么钥匙，这个钥匙给你！",
		["Word4"] = "很抱歉，你什么都没得到。",
		["Word5"] = "其...其实，我...也不知道那是什么钥匙，这个钥匙给你！",
		["Word6"] = "很抱歉，你什么都没得到。",
	},
	[209] = {
		["DescID"] = 209,
		["Word1"] = "人类，再见！",
		["Word2"] = "人类，再见！",
	},
	[210] = {
		["DescID"] = 210,
		["Word1"] = "奇怪的鱼人",
		["Word2"] = "如果你见到我父亲，就帮我最喜欢的书带给它！让他知道我是安全的！",
		["Word3"] = "好像就是这一本，你那去吧。",
		["Word4"] = "好像就是这一本，你那去吧。",
		["Word5"] = "好像不是这一本，算了，你都拿去吧。",
		["Word6"] = "好像不是这一本，算了，你都拿去吧。",
	},
	[211] = {
		["DescID"] = 211,
		["Word1"] = "奇怪的鱼人",
		["Word2"] = "奇怪的鱼人",
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
		["Word1"] = "在洞穴的最深处，有一个神秘人，正在不断地呼唤着怪物从混沌中涌出。（击败boss可获得收益提升）",
		["Word2"] = "在洞穴的最深处，有一个神秘人，正在不断地呼唤着怪物从混沌中涌出。（击败boss可获得收益提升）",
		["Word3"] = "在洞穴的最深处，有一个神秘人，正在不断地呼唤着怪物从混沌中涌出。（击败boss可获得收益提升）",
		["Word4"] = "击败了这个神秘人，你控制了他的法阵，阻止了继续制造更多怪物的同时，使你的挂机收益提升了20%",
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
		["Word1"] = "大陆上的怪物死后埋葬的地方，充满了诡异的气息，因为怪物死去的正在复活！",
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
		["Word1"] = "大陆上的怪物死后埋葬的地方，充满了诡异的气息，因为怪物死去的正在复活！",
		["Word2"] = "你必须去阻止那些大量复活的怪物，否则他们将淹没世界！（击败怪物会有丰富的奖励）",
	},
	[311] = {
		["DescID"] = 311,
		["Word1"] = "大陆上的怪物死后埋葬的地方，充满了诡异的气息，因为怪物死去的正在复活！",
		["Word2"] = "大陆上的怪物死后埋葬的地方，充满了诡异的气息，因为怪物死去的正在复活！",
	},
	[312] = {
		["DescID"] = 312,
		["Word1"] = "一个神秘的建筑，里面充满了发狂的怪物",
		["Word2"] = "一群被邪恶的魔法操纵的生物，正在试图攻击你！（击败怪物会有丰富的奖励）",
	},
	[313] = {
		["DescID"] = 313,
		["Word1"] = "消灭操纵者魔物的邪恶法师，能够让你在此地获得更高的收益。（击败boos可获得收益提升）",
		["Word2"] = "消灭操纵者魔物的邪恶法师，能够让你在此地获得更高的收益。（击败boos可获得收益提升）",
		["Word3"] = "消灭操纵者魔物的邪恶法师，能够让你在此地获得更高的收益。（击败boos可获得收益提升）",
		["Word4"] = "你发现了魔王灭世魔法的气息让元凶渐渐明朗起来，随着对敌人的本质的理解，让你获得了20%挂机收益提升。",
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
		["Word1"] = "巨大的工厂里现在充满了各种怪物，但是也可以提供无比的财富。",
		["Word2"] = "被神秘的邪恶魔法感染的生物正在疯狂的想你发动攻击。（击败怪物会有丰富的奖励）",
	},
	[321] = {
		["DescID"] = 321,
		["Word1"] = "巨大的生物，控制者污染生物的水源，消灭它就可以恢复水车工作，为你提供更多资源。（击败boos可获得收益提升）",
		["Word2"] = "巨大的生物，控制者污染生物的水源，消灭它就可以恢复水车工作，为你提供更多资源。（击败boos可获得收益提升）",
		["Word3"] = "巨大的生物，控制者污染生物的水源，消灭它就可以恢复水车工作，为你提供更多资源。（击败boos可获得收益提升）",
		["Word4"] = "水车恢复了工作，你的战斗奖励提升20%",
	},
	[322] = {
		["DescID"] = 322,
		["Word1"] = "巨大的工厂里现在充满了各种怪物，但是也可以提供无比的财富。",
		["Word2"] = "被神秘的邪恶魔法感染的生物正在疯狂的想你发动攻击。（击败怪物会有丰富的奖励）",
	},
	[323] = {
		["DescID"] = 323,
		["Word1"] = "巨大的工厂里现在充满了各种怪物，但是也可以提供无比的财富。",
		["Word2"] = "巨大的工厂里现在充满了各种怪物，但是也可以提供无比的财富。",
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
		["Word1"] = "一座安静的城堡，看上去诗歌落脚的好地方",
		["Word2"] = "进入城堡里，没想到里面充满了正在发疯一样互相攻击的怪物，显然它们都疯了。只有你能赐予它们安息。（击败怪物会有丰厚的奖励）",
	},
	[329] = {
		["DescID"] = 329,
		["Word1"] = "四处寻找这些怪物发狂的原因的时候，你发现了一些魔法，那是来自于魔王末日之术。你必须找到施法者！（击败boss可获得收益提升）",
		["Word2"] = "四处寻找这些怪物发狂的原因的时候，你发现了一些魔法，那是来自于魔王末日之术。你必须找到施法者！（击败boss可获得收益提升）",
		["Word3"] = "四处寻找这些怪物发狂的原因的时候，你发现了一些魔法，那是来自于魔王末日之术。你必须找到施法者！（击败boss可获得收益提升）",
		["Word4"] = "你解除了使怪物发狂的法阵！这使你的挂机收益提升了20%",
	},
	[330] = {
		["DescID"] = 330,
		["Word1"] = "一座安静的城堡，看上去诗歌落脚的好地方",
		["Word2"] = "进入城堡里，没想到里面充满了正在发疯一样互相攻击的怪物，显然它们都疯了。只有你能赐予它们安息。（击败怪物会有丰厚的奖励）",
	},
	[331] = {
		["DescID"] = 331,
		["Word1"] = "一座安静的城堡，看上去诗歌落脚的好地方",
		["Word2"] = "一座安静的城堡，看上去诗歌落脚的好地方",
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
		["Word1"] = "好多烂泥挡在路中间，结成了许多灰色的土块",
		["Word2"] = "“泥丸子，你不能死啊！”一只史莱姆从烂泥里突然出现。“我跟你相依为命，同甘共苦了这么多年，一直把你当亲生骨肉一样教你养你，想不到今天，白发人送黑发人!我为了你和这些人拼啦！”",
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
		["Word2"] = "血魔花的大嘴滴着鲜血，发出令人不寒而栗的声音！",
	},
	[605] = {
		["DescID"] = 605,
		["Word1"] = "你是肉吗？你是肉吗？",
		["Word2"] = "是否要教训它？",
	},
	[606] = {
		["DescID"] = 606,
		["Word1"] = "谁来猜我的谜语？什么东西早上四条腿，中午两条腿，晚上三条腿？",
		["Word2"] = "你猜对了答案是人！斯芬克斯却像你发起了攻击！",
	},
	[607] = {
		["DescID"] = 607,
		["Word1"] = "嗬~难得有没发疯的对手！",
		["Word2"] = "石像鬼很有组织的向你们包围过来！",
	},
	[608] = {
		["DescID"] = 608,
		["Word1"] = "嗬~人类！活着的人类！",
		["Word2"] = "石像鬼大笑着，向你围了过来！",
	},
	[609] = {
		["DescID"] = 609,
		["Word1"] = "嗬~让我好好地疼爱你们！",
		["Word2"] = "石像鬼一脸淫笑的向你走了过来！",
	},
	[610] = {
		["DescID"] = 610,
		["Word1"] = "不，不要过来！",
		["Word2"] = "树精卫士不断地捶打自己，直到看到你，它转而开始攻击你！",
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
		["Word1"] = "不要靠近我！！！",
		["Word2"] = "树精卫士痛苦的呻吟着，你走过去看的瞬间，就愤怒的开始攻击你。",
	},
	[614] = {
		["DescID"] = 614,
		["Word1"] = "不要靠近我！！！",
		["Word2"] = "树精卫士不断地捶打自己，直到看到你，它转而开始攻击你！",
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
		["Word1"] = "通过这里，你就可以离开这片区域，前往其他区域。",
		["Word2"] = "渡口的守门人已经发狂，并阻止他发狂！",
	},
	[1001] = {
		["DescID"] = 1001,
		["Word1"] = "摆渡人：“谢谢你救了我，那个散播让我发狂的怪病的人似乎来自于血腥森林，你要去那里嘛？”",
		["Word2"] = "摆渡人：“谢谢你救了我，那个散播让我发狂的怪病的人似乎来自于血腥森林，你要去那里嘛？”",
	},
	[1002] = {
		["DescID"] = 1002,
		["Word1"] = "要前往新的区域必须经过这个传送门",
		["Word2"] = "一个发狂的人正在这里破坏，它必须被阻止！",
	},
	[1003] = {
		["DescID"] = 1003,
		["Word1"] = "现在可以继续前进了，到底是什么造成了怪物的狂暴？原因必须被查明。",
		["Word2"] = "现在可以继续前进了，到底是什么造成了怪物的狂暴？原因必须被查明。",
	},
	[1004] = {
		["DescID"] = 1004,
		["Word1"] = "离开森林的道路被封锁了！有人挡住了人们的去路！",
		["Word2"] = "一群士兵试图组织任何人通过，你是否要击败他们？",
	},
	[1005] = {
		["DescID"] = 1005,
		["Word1"] = "现在你可以前往亚历山大帝国的领土了！",
		["Word2"] = "现在你可以前往亚历山大帝国的领土了！",
	},
	[1006] = {
		["DescID"] = 1006,
		["Word1"] = "路口似乎有什么事情发生，聚集了很多人。",
		["Word2"] = "魔王的手下似乎正想要把这个地方上的生物也加以狂暴化，你必须阻止她！",
	},
	[1007] = {
		["DescID"] = 1007,
		["Word1"] = "魔王的手下逃跑了，你必须要追上她！调查清楚事件的真相！",
		["Word2"] = "魔王的手下逃跑了，你必须要追上她！调查清楚事件的真相！",
	},
	[1100] = {
		["DescID"] = 1100,
		["Word1"] = "我将会替你补给所有的魔晶，让你拥有足够的魔力继续作战。",
	},
	[1200] = {
		["DescID"] = 1200,
		["Word1"] = "一个充满神奇力量的泉眼",
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
		["Word1"] = "一个很高很高的塔，上去可以望到远方",
	},
	[1601] = {
		["DescID"] = 1601,
		["Word1"] = "视野已经打开",
		["Word2"] = "视野已经打开",
	},
	[1602] = {
		["DescID"] = 1602,
		["Word1"] = "我身后有一条秘密的路，很多人在那里找到了神兵利器，你可不要错过。",
		["Word2"] = "我身后有一条秘密的路，很多人在那里找到了神兵利器，你可不要错过。",
	},
	[1603] = {
		["DescID"] = 1603,
		["Word1"] = "咔哒~你在看什么？我完美的身材吗？算你有眼光，我北方一枝花告诉你，往北走有宝物可别错过了！",
		["Word2"] = "咔哒~你在看什么？我完美的身材吗？算你有眼光，我北方一枝花告诉你，往北走有宝物可别错过了！",
	},
	[1700] = {
		["DescID"] = 1700,
		["Word1"] = "可以传送到另一个地点",
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
		["Word2"] = "很不幸！你进入了一个蛇妖的巢穴，是否迎战？",
	},
	[9011] = {
		["DescID"] = 9011,
		["Word1"] = "神秘的时空之门。",
		["Word2"] = "真幸运！你来到了一个藏宝库，看守人员允许你带走一些宝物。",
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
		["Word1"] = "奇怪的鱼人，它似乎有什么要求。",
		["Word2"] = "现在所有人都发了疯，我妻子被杀死了，我儿子不知道哪里去了！你帮我找到我儿子，我就让你通过怎么样？他最喜欢的书是《皮克斯》。",
	},
	[9054] = {
		["DescID"] = 9054,
		["Word1"] = "奇怪的鱼人，它似乎有什么要求。",
		["Word2"] = "要跟我打一架吗？",
	},
	[9055] = {
		["DescID"] = 9055,
		["Word1"] = "奇怪的鱼人，它似乎有什么要求。",
		["Word2"] = "感谢你，这个礼物就送给你了。",
	},
	[9056] = {
		["DescID"] = 9056,
		["Word1"] = "奇怪的鱼人。",
		["Word2"] = "此门已经关闭。",
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
		["Word2"] = "此门已经关闭。",
	},
},
};

-- functions for xlstable read
local __getcell = function (t, a,b,c) return t[a][b][c] end
function GetCell(sheetx, rowx, colx)
	rst, v = pcall(__getcell, xlstable, sheetx, rowx, colx)
	if rst then return v
	else return nil
	end
end

function GetCellBySheetName(sheet, rowx, colx)
	return GetCell(sheetname[sheet], rowx, colx)
end

__XLS_END = true

local tbConfig = gf_CopyTable(elementdesc[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
