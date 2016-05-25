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

local shop = {
[1] = {
	[15001] = {
		["Id"] = 15001,
		["Name"] = "黑心商店",
		["ElementType"] = 15,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1500,
		["Pic1"] = 1500,
		["Pic2"] = 1500,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["SellGroup"] = {1,2,3},
		["Effect1"] = {60048,100,-17,109},
	},
	[15002] = {
		["Id"] = 15002,
		["Name"] = "黑心商店",
		["ElementType"] = 15,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1500,
		["Pic1"] = 1501,
		["Pic2"] = 1501,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["SellGroup"] = {1,2,3},
		["Effect1"] = {60048,100,-17,109},
	},
	[15003] = {
		["Id"] = 15003,
		["Name"] = "4黑心商店",
		["ElementType"] = 15,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1500,
		["Pic1"] = 908,
		["Pic2"] = 908,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["SellGroup"] = {4,5,6},
		["Effect1"] = {60056,100,0,104},
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

local tbConfig = gf_CopyTable(shop[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
