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

local portal = {
[1] = {
	[17001] = {
		["Id"] = 17001,
		["Name"] = "1号传送门",
		["ElementType"] = 17,
		["Genre"] = 5,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1700,
		["Pic1"] = 1700,
		["Pic2"] = 1700,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Portal"] = 0,
		["Map"] = 0,
		["Scale"] = 100,
	},
	[17002] = {
		["Id"] = 17002,
		["Name"] = "1号传送门",
		["ElementType"] = 17,
		["Genre"] = 5,
		["Area"] = {1,1},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1700,
		["Pic1"] = 1701,
		["Pic2"] = 1701,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Portal"] = 0,
		["Map"] = 0,
		["Scale"] = 100,
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

local tbConfig = gf_CopyTable(portal[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
