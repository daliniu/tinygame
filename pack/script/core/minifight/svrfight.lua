if _SERVER then
require("script/core/minifight/minidef")
require("script/core/minifight/minifight")
require("script/core/minifight/fighter")
require("script/core/player/playerfactory")

if _INFO1 then
	_INFO1 = g_PlayerFactory:CreatePlayer(_INFO1)
	_INFO1 = _INFO1:GetHerosFightInfo()
	_INFO1 = fighter.createFromPlayer(_INFO1)
end

if _INFO2 then
	if _PVP then
		_INFO2 = g_PlayerFactory:CreatePlayer(_INFO2)
		_INFO2 = _INFO2:GetHerosFightInfo()
		_INFO2 = fighter.createFromPlayer(_INFO2)
	else
		_INFO2 = fighter.createFromMonsterBox(_INFO2)
	end
end

RESULT = 2	--_INFO1是否胜利
HPRATE = 0	--_INFO1剩余HP比例

if _INFO1 and _INFO2 and _SEED then
	_, RESULT, HPRATE = minifight.startFight(_INFO1, _INFO2, _SEED)
end

end

