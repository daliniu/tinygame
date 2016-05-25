-- excel xlstable format (sparse 3d matrix)
--{	[sheet1] = { [row1] = { [col1] = value, [col2] = value, ...},
--					 [row5] = { [col3] = value, }, },
--	[sheet2] = { [row9] = { [col9] = value, }},
--}
-- nameindex table
--{ [sheet,row,col name] = index, .. }
sheetname = {
["guide"] = 1,
};

sheetindex = {
[1] = "guide",
};

local guide = {
[1] = {
	[1] = {
		["GuideId"] = 1,
		["IfStart"] = 1,
		["TriggerType"] = 1,
		["TriggerPara1"] = 1,
		["TriggerPara2"] = {{16,10},{16,11},{17,10},{18,10},{18,11}},
		["Text"] = "恭喜你找到新的挂机点！在这里将获得更大的挂机效益。请走过去点击迁移。",
		["WindowPos"] = {258,1138},
		["ClickType"] = 1,
		["ClickPos"] = {17,8},
		["CleanType"] = 3,
		["Next"] = 2,
		["Remarks"] = "挂机点引导",
	},
	[2] = {
		["GuideId"] = 2,
		["IfStart"] = 0,
		["ClickType"] = 2,
		["ClickPos"] = {379,77},
		["CleanType"] = 3,
		["Next"] = 3,
	},
	[3] = {
		["GuideId"] = 3,
		["IfStart"] = 1,
		["TriggerType"] = 1,
		["TriggerPara1"] = 3,
		["TriggerPara2"] = {{6,16},{7,16},{8,16},{6,15},{7,15},{6,14},{7,14}},
		["Text"] = "你知道 加成 挂机点收益的方法吗？快来挑战挂机守怪BOSS！",
		["WindowPos"] = {258,1138},
		["ClickType"] = 1,
		["ClickPos"] = {5,16},
		["CleanType"] = 3,
		["Next"] = 4,
		["Remarks"] = "挂机点守怪引导",
	},
	[4] = {
		["GuideId"] = 4,
		["IfStart"] = 0,
		["CleanType"] = 3,
		["ClickPos"] = {379,77},
		["ClickType"] = 2,
	},
	[5] = {
		["GuideId"] = 5,
		["IfStart"] = 1,
		["TriggerType"] = 1,
		["TriggerPara1"] = 3,
		["TriggerPara2"] = {{5,10},{6,10},{7,10},{6,9},{7,9},{8,9},{7,8},{8,8}},
		["Text"] = "此处的沼泽地形，将会加重每格的步数消耗",
		["WindowPos"] = {258,1138},
		["CleanType"] = 3,
		["Remarks"] = "沼泽引导",
	},
	[6] = {
		["GuideId"] = 6,
		["IfStart"] = 1,
		["TriggerType"] = 1,
		["TriggerPara1"] = 4,
		["TriggerPara2"] = {{2,7},{3,7},{3,6},{4,7},{4,8}},
		["Text"] = "补给会随着战斗损耗，补给为零将会被传回上一个挂机点，记得补充",
		["WindowPos"] = {258,1138},
		["ClickType"] = 1,
		["ClickPos"] = {4,6},
		["CleanType"] = 3,
		["Remarks"] = "补给站引导",
	},
},
};


return guide[1]
