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

local intelligence = {
[1] = {
	[14001] = {
		["Id"] = 14001,
		["Name"] = "情报站",
		["ElementType"] = 14,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1400,
		["Pic1"] = 1400,
		["Pic2"] = 1400,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["InteACount"] = {{{1},{1,1}},{{2},{1,1}},{{3},{1,1}}},
	},
	[14002] = {
		["Id"] = 14002,
		["Name"] = "情报站",
		["ElementType"] = 14,
		["Genre"] = 4,
		["Area"] = {2,2},
		["Obstacle"] = 0,
		["GetInto"] = 1,
		["PickupLived"] = 1,
		["Desc1"] = 1400,
		["Pic1"] = 1401,
		["Pic2"] = 1401,
		["Resetting"] = 0,
		["RestrictStep"] = 0,
		["RestrictSuc"] = 0,
		["RestrictLose"] = 0,
		["Value"] = 0,
		["InteACount"] = {{{1},{1,1}},{{2},{1,1}},{{3},{1,1}}},
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

local tbConfig = gf_CopyTable(intelligence[1])

setmetatable(tbConfig, {__newindex = function(k, v)
		print("[Error]config is read only!")
	end})

return tbConfig;
