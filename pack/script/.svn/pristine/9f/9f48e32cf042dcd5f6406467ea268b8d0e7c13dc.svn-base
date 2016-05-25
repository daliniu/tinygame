
local AUDIO_MANAGER_TB={
	lastBackground=nil,		--上一个背景音乐
}


AudioManager=class("AudioManager");

AudioManager.m_pLogic =nil;


function AudioManager:getInstance()
	if AudioManager.m_pLogic==nil then 
		AudioManager.m_pLogic = AudioManager.new();
	end

	return AudioManager.m_pLogic;
end


function AudioManager:playBackground(sPath)
	local isPlay = true;
	if isPlay == false then
		return;
	end
	
	sPath = sPath..".mp3"
	if cc.SimpleAudioEngine:getInstance():isMusicPlaying() == true then
		if self.lastBackground == sPath then 
			return;
		end
	end

	self.lastBackground = sPath;
	cc.SimpleAudioEngine:getInstance():playMusic(sPath, true)

end

function AudioManager:stopBackgroundMusic()
	cc.SimpleAudioEngine:getInstance():stopMusic()
end

function AudioManager:playEffect(sPath,layerID)
	local isPlay = true;
	if isPlay == false then
		return;
	end

	if GameSceneManager:getInstance():getCurrentLayerID() ~= layerID then 
		return;
	end


	sPath = sPath..".mp3"
	cc.SimpleAudioEngine:getInstance():playEffect(sPath,false)
end

function AudioManager:setBackgroundMusicVolume(fValue)
	cc.SimpleAudioEngine:getInstance():setMusicVolume(fValue);
end