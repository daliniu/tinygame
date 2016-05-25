
function fun_removeTextureAndFrameCache(textureTable)
	for k,v in pairs(textureTable) do
		local textName = v;

		local pTextrue = cc.Director:getInstance():getTextureCache():getTextureForKey(textName);
		cc.SpriteFrameCache:getInstance():removeSpriteFramesFromTexture(pTextrue)
		cc.Director:getInstance():getTextureCache():removeTexture(pTextrue)
	end
end

function fun_removeAnimationCache(animationTable)
	
	for k,v in pairs(animationTable) do
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
		cc.AnimationCache:getInstance():removeAnimation(v)
	end

end