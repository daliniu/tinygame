require("script/core/player/player")

HeroControl =class("HeroControl")


HeroControl.pHeroControl=nil


--单例
function HeroControl:getInstance()
    if HeroControl.pHeroControl==nil then
    	HeroControl.pHeroControl=HeroControl:new()
    end
    
    return HeroControl.pHeroControl
    
end


--获取指定英雄的动态信息
function HeroControl:getHeroInfo(id)
    local childArray=self:getAllHeroes()
    local _childeCount = table.getn(childArray)
    for i =0,_childeCount-1,1 do
        local _hero=childArray[i+1]
        if _hero:GetID() == id then
            return _hero
        end
    end
    
    return nil
end


--获取玩家所有英雄信息
function HeroControl:getAllHeroes()
	return me:GetAllHeros();
end

--获取玩家所有未上阵的英雄
function HeroControl:getAllNotFightHero()
    local heroTable = {}
    for i,hero in pairs(self:getAllHeroes()) do
        if hero:IsHero() and hero:IsOff() then
            table.insert(heroTable,hero)
        end
    end

    return heroTable
end

--获取上阵的英雄
function HeroControl:getAllFightHero()
    local heroTable = {}
    for i,hero in pairs(self:getAllHeroes()) do
        if hero:IsHero() and hero:IsOn() then
            table.insert(heroTable,hero)
    	end
    end
    
    return heroTable
    
end

--为指定英雄增加一个携带技能
function HeroControl:equipSkill(heroID,skillID)

    local _pHeroInfo=self:getHeroInfo(heroID);
    local _currentSkillInfo = SkillConfigure:getInstance():getSkillInfo(skillID);

    --检测当前已经有当前费率的 技能
    local bIsHave = false;
    -- for i,var in pairs(_pHeroInfo.currentSkill) do
    for i,var in pairs(_pHeroInfo:GetSlot()) do
    	if SkillConfigure:getInstance():getSkillInfo(var).expend == _currentSkillInfo.expend then
            -- table.remove(_pHeroInfo.currentSkill,i)
            table.remove(_pHeroInfo:GetSlot(),i)
            break;
         end
    end

    -- table.insert(_pHeroInfo.currentSkill,skillID)
    table.insert(_pHeroInfo:GetSlot(),skillID)

end


--为指定英雄替换一个携带技能
function HeroControl:replaceSkill(heroID,oldID,newID)

    local _pHeroInfo=self:getHeroInfo(heroID)
   
    local iPos = 1
    -- for i,_var in pairs(_pHeroInfo.currentSkill) do
    for i,_var in pairs(_pHeroInfo:GetSlot()) do
    	if _var==oldID then
            -- table.remove(_pHeroInfo.currentSkill,iPos)
            table.remove(_pHeroInfo:GetSlot(),iPos)
            break
    	end   	
    	iPos=iPos+1
    end
    
    -- table.insert(_pHeroInfo.currentSkill,iPos,newID)
    table.insert(_pHeroInfo:GetSlot(),iPos,newID)
    
    
end

--取消玩家某一技能的装备
function HeroControl:cancleSkill(heroID,skillid)
    local pHero = self:getHeroInfo(heroID)
    if pHero~=nil then
        -- for i,var in pairs(pHero.currentSkill) do
        for i,var in pairs(pHero:GetSlot()) do
            if var == skillid then
                -- table.remove(pHero.currentSkill,i)
                table.remove(pHero:GetSlot(),i)
            end
        end
        
    end

end



--获取指定英雄已经装备的指定费率的技能
function HeroControl:getHeroCurrentSkillWithExpend(heroID,resNum)
    local pHero = self:getHeroInfo(heroID)
    if pHero~=nil then
        -- for i,var in pairs(pHero.currentSkill) do
        for i,var in pairs(pHero:GetSlot()) do
        	if SkillConfigure:getInstance():getSkillInfo(var).expend == resNum then
        		return var
        	end
        end
    	
    end
    return 0
end

--获取指定英雄指定阶段的所有技能
function HeroControl:getHeroAllSkillWithStage(heroID,stageID)
    local pTable={}
    local pHero = self:getHeroInfo(heroID)
    -- for i,var in pairs(pHero.allSkill) do
    for i,var in pairs(pHero:GetAllSkills()) do
        -- if SkillConfigure:getInstance():getSkillInfo(var).stage==stageID  then
        	table.insert(pTable,var)
        -- end
    end
    
    return pTable;
end

--获取英雄所有技能
function HeroControl:getHeroAllSkill(heroID)
    local pHero = self:getHeroInfo(heroID)
    return pHero:GetAllSkills();
end


--出战英雄换人
function HeroControl:FightHeroChange(newHeroID,oldHeroID)
    
    self:setHeroNotFight(oldHeroID)
    self:setHeroFight(newHeroID)
    
end


--设置英雄出战
function HeroControl:setHeroFight(heroID)
    for i,var in pairs(PlayerDate:getInstance().heroes) do
        if var.id == heroID then
        	var.state = 1
        	break;
        end
    	
    end
    
end

--设置英雄未出战
function HeroControl:setHeroNotFight(heroID)
    for i,var in pairs(PlayerDate:getInstance().heroes) do
        if var.id == heroID then
            var.state = 0
            break;
        end

    end

end




