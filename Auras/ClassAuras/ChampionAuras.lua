import "ExoPlugins.Auras.AuraTools";
_G.ChampionAuras = class(Turbine.UI.Window)
function ChampionAuras:Constructor(parent, x, y)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);
    self:SetPosition(x, y);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 200);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();
    
	self.role = nil;


	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	--This table basically just holds the icon size information for each row.
	--If you want to make a particular row of quickslots large just adjust the value for the given row index
	self.RowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 38,
	};

	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	self.ProcTable = {
		["Improved Wild Attack"] = {1090553751, 1, 0},
		["Emboldened Blades 1"] = {1090539704, 2, 1},
		["Emboldened Blades 2"] = {1090539704, 2, 2},
		["Emboldened Blades 3"] = {1090539704, 2, 3},
		["Emboldened Blades 4"] = {1090539704, 2, 4},
		["Emboldened Blades 5"] = {1090539704, 2, 5},
		["Champion's Advantage"] = {1091830092, 2, 0},
	};

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		["Emboldened Blades 5"] = "Remorseless Strike",
	};


	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	self.Skills = {
		["Rend"] = {1091459631, 1, 1, false, true},
		["Devastating Strike"] = {1091804923, 1, 1, false, true},
		["Wild Attack"] = {1090553751, 2, 1, false, true},
		["Swift Strike"] = {1090541125, 3, 1, false, true},
		["Blade Wall"] = {1090553752, 4, 1, false, true},
		["Brutal Strikes"] = {1090553754, 5, 1, true, true},
		["Feral Strikes"] = {1091515785, 6, 1, true, true},
		["Clobber"] = {1090553763, 7, 1, true, true},
		["Battle Frenzy"] = {1091804924, 8, 1, false, true},

		["Remorseless Strike"] = {1090553759, 1, 2, true, true},
		["Fury of Blades"] = {1091830071, 1, 2, true, true},
		["Ferocious Strikes"] = {1091804902, 2, 2, true, true},
		["Blade Storm"] = {1090553756, 3, 2, true, true},
		["Raging Blade"] = {1091804939, 4, 2, true, true},
		["Born For Combat"] = {1091830102, 5, 2, true, true},
		["Champion's Challenge"] = {1090553760, 6, 2, false, true},
		["Horn of Gondor"] = {1090553764, 7, 2, true, true},
		["Horn of Champions"] = {1091744499, 8 , 2, false, true},
		["Hamstring"] = {1090553765, 9, 2, true, true},
		["Fear Nothing!"] = {1091591835, 10, 2, false, true},

		["Great Cleave"] = {1091804930, 1, 3, false, false},
		["Controlled Burn"] = {1091804918, 2, 3, false, false},
		["Fight On"] = {1090539699, 3, 3, false, false},
		["Champion's Duel"] = {1091804891, 4, 3, false, false},
		["Blood Rage"] = {1091459632, 5, 3, false, false},
		["True Heroics"] = {1091585417, 6, 3, false, false},
		["Sprint"] = {1090553762, 7, 3, false, false},
	};

	self.FervorCosts = {
		["Clobber"] = 1,
		["Brutal Strikes"] = 3,
		["Feral Strikes"] = 2,
		["Fury of Blades"] = 1,
		["Ferocious Strikes"] = 5,
		["Remorseless Strike"] = 4,
		["Blade Storm"] = 4,
		["Raging Blade"] = 3,
		["Horn of Gondor"] = 5,
		["Hamstring"] = 1,
	};

	self.resetTime = nil;
	self.ReloadHandler = function(delta)
			if self.resetTime ~= nil then
				if self.resetTime < Turbine.Engine.GetGameTime() then
					skillList = player:GetTrainedSkills();
					self:RemoveCallbacks();
					self.role = self:GetRole();
					self:ConfigureBars();
					self:ConfigureCallbacks();
					self.resetTime = nil;
					RemoveCallback(Updater, "Tick", self.ReloadHandler);
				end
			else
				self.resetTime = Turbine.Engine.GetGameTime()+3;
			end
	end

	self.role = self:GetRole();
	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = Deusdictum.UI.DragBar( self, "Champion Auras" );
end

function ChampionAuras:FervorManagement(fervorTotal)
	self.fervour:SetTotal(fervorTotal);

	for key, value in pairs(self.FervorCosts) do
		if self.FervorCosts[key] <= fervorTotal then
			self.SkillBar:ToggleActive(key, true);
		else
			self.SkillBar:ToggleActive(key, false);
		end
	end
end

function ChampionAuras:ConfigureBars()

	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, 3, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, 51);

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	self.colours = {
		[0] = Turbine.UI.Color(0.77, 0.12, 0.23),
	};
	self.fervour = ResourceBar(self, width, 24, 5, self.colours);
	self.fervour:SetPosition(0, 35);
	self.fervour:SetTotal(playerAttributes:GetFervor());

	for i = 1, skillList:GetCount(), 1 do
        local name = skillList:GetItem(i):GetSkillInfo():GetName();
		if self.Skills[name] then
			self.SkillBar:AddSkill(name, Skill(self.SkillBar, self.RowInfo[self.Skills[name][3]], self.Skills[name][1], self.Skills[name][4] , self.Skills[name][5]), self.Skills[name][2], self.Skills[name][3] );
		end
	end
end

function ChampionAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();


		if self.ProcTable[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.ProcBar:SetActive(effectName, effect:GetDuration());
		end

		if self.SkillHighlights[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			if self.Skills[self.SkillHighlights[effectName]] then
				self.SkillBar:ToggleHighlight(self.SkillHighlights[effectName], true);
			end
		end

	end);

	self.effectRemovedCallback = AddCallback(playerEffects, "EffectRemoved", function(sender, args)
		local effect = args.Effect;
		if effect ~= nil then 
			local effectName = effect:GetName();

			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end

			if self.SkillHighlights[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				if self.Skills[self.SkillHighlights[effectName]] then
					self.SkillBar:ToggleHighlight(self.SkillHighlights[effectName], false);
				end
			end
		end
	end);

	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();
		
        self.Callbacks[name] = {}

		if self.Skills[name] then
			self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
            end));
		end
    end

	self.FervorCallback = AddCallback(playerAttributes, "FervorChanged", function(sender, args)
		self:FervorManagement(playerAttributes:GetFervor());
	end);
end

function ChampionAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	RemoveCallback(playerAttributes, "FervorChanged", self.FervorCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.fervour:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function ChampionAuras:GetRole()
	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();
		if name == "Sudden Defence" then
			return 1;
		elseif name == "Devastating Strike" then
			return 2;
		elseif name == "Exchange of Blows" then
			return 3;
		end
	end
	return 4;
end

function ChampionAuras:Unload()
	self:RemoveCallbacks();
	SaveData = {
		["aurasLeft"] = self:GetLeft(),
		["aurasTop"] = self:GetTop(),
	};
	Turbine.PluginData.Save(Turbine.DataScope.Character, "AuraSettings", SaveData)
end

function ChampionAuras:Reload()
	AddCallback(Updater, "Tick", self.ReloadHandler);
end