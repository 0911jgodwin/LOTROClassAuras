import "ExoPlugins.Auras.AuraTools";
_G.GuardianAuras = class(Turbine.UI.Window)
function GuardianAuras:Constructor(parent, x, y)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);
    self:SetPosition(x, y);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 200);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();
    
	self.role = nil;

	self.parryResponse = false;
	self.blockResponse = false;
	self.retaliation = false
	self.shieldSwipe = false;


	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	--This table basically just holds the icon size information for each row.
	--If you want to make a particular row of quickslots large just adjust the value for the given row index
	self.RowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 32,
		[4] = 38,
	};
	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, 4, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, 51);

	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	self.ProcTable = {
		["Stoic"] = {1091668185, 1, 0},
	};

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		["Elendil's Boon"] = "Shadow's Lament",
	};


	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	self.Skills = {
		["Improved Sting"] = {1090541160, 1, 1, false, true},
		["Guardian's Ward"] = {1090540663, 2, 1, false, true},
		["Vexing Blow"] = {1090541171, 3, 1, false, true},
		["Sweeping Cut"] = {1090553893, 4, 1, false, true},
		["Shield-blow"] = {1090541166, 5, 1, false, true},
		["War-chant"] = {1091805310, 6, 1, false, true},
		["Stamp"] = {1090553906, 7, 1, false, true},
		["Stagger"] = {1091415788, 8, 1, false, true},

		["Fray the Edge"] = {1091415791, 1, 2, false, true},
		["Retaliation"] = {1090553896, 2, 2, true, true},
		["Whirling Retaliation"] = {1090553902, 3, 2, true, true},
		["Turn the Tables"] = {1090553907, 4, 2, false, true},
		["Ignore the Pain"] = {1091591836, 5, 2, false, true},
		["Shield-swipe"] = {1090541162, 6, 2, true, true},
		["Shield-taunt"] = {1090553905, 7, 2, true, true},
		["Bash"] = {1090553898, 8, 2, true, true},
		["Shield-smash"] = {1090540658, 9, 2, true, true},

		["Engage"] = {1091415793, 1, 3, false, true},
		["Redirect"] = {1091805300, 2, 3, true, true},
		["Catch a Breath"] = {1090541168, 3, 3, true, true},
		["Smashing Stab"] = {1091805247, 4, 3, true, true},
		["Challenge"] = {1090522264, 5, 3, false, true},

		["Guardian's Pledge"] = {1091805278, 1, 4, false, false},
		["Juggernaut"] = {1091805299, 2, 4, false, false},
		["Litany of Defiance"] = {1091444826, 3, 4, false, false},
		["Warrior's Heart"] = {1090541182, 4, 4, false, false},
		["Thrill of Danger"] = {1090541184, 5, 4, false, false},
		["Break Ranks"] = {1091805247, 6, 4, false, false},
	};

	self.Fortifications = {
		["Improved Fortification I"] = 1,
		["Improved Fortification II"] = 2,
		["Improved Fortification III"] = 3,
		["Improved Fortification IV"] = 4,
		["Improved Fortification V"] = 5,
	};

	self.ChainSkills = {
		["Retaliation"] = true,
		["Whirling Retaliation"] = true,
		["Shield-swipe"] = true,
		["Shield-taunt"] = true,
		["Bash"] = true,
		["Shield-smash"] = true,
		["Redirect"] = true,
		["Catch a Breath"] = true,
		["Smashing Stab"] = true,
	};

	self.ChainEffects = {
		["Block Response"] = true,
		["Parry Response"] = true,
		["Retaliation"] = true,
		["Shield Swipe"] = true,
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

	self.DragBar = Deusdictum.UI.DragBar( self, "Guardian Auras" );
end

function GuardianAuras:HandleResponseState( effect, bool )
	if effect == "Block Response" then
		self.blockResponse = bool;
		self.SkillBar:ToggleActive("Shield-swipe", bool);
	elseif effect == "Parry Response" then
		self.parryResponse = bool;
		self.SkillBar:ToggleActive("Retaliation", bool);
		self.SkillBar:ToggleActive("Whirling Retaliation", bool);
	elseif effect == "Retaliation" then
		self.retaliation = bool;
		self.SkillBar:ToggleActive("Redirect", bool);
	elseif effect == "Shield Swipe" then
		self.shieldSwipe = bool;
		self.SkillBar:ToggleActive("Shield-taunt", bool);
		self.SkillBar:ToggleActive("Bash", bool);
	end
	
	--Handle Catch a Breath
	if self.blockResponse or self.parryResponse then
		self.SkillBar:ToggleActive("Catch a Breath", true);
	else
		self.SkillBar:ToggleActive("Catch a Breath", false);
	end

	--Handle Smashing Stab
	if self.retaliation and self.shieldSwipe then
		self.SkillBar:ToggleActive("Smashing Stab", true);
		self.SkillBar:ToggleHighlight("Smashing Stab", true);
	elseif self.retaliation or self.shieldSwipe then
		self.SkillBar:ToggleActive("Smashing Stab", true);
		self.SkillBar:ToggleHighlight("Smashing Stab", false);
	else
		self.SkillBar:ToggleActive("Smashing Stab", false);
		self.SkillBar:ToggleHighlight("Smashing Stab", false);
	end
end

function GuardianAuras:ConfigureBars()

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	if self.role == 1 then
		self.colours = {
			[0] = Turbine.UI.Color(0.23, 0.12, 0.77),
			};
		self.fortBar = ResourceBar(self, width, 24, 5, self.colours);
		self.fortBar:SetPosition(0, 35);
		self.fortBar:SetTotal(0);
		self.lastTier = "";
	end

	for i = 1, skillList:GetCount(), 1 do
        local name = skillList:GetItem(i):GetSkillInfo():GetName();

		if self.Skills[name] then
			self.SkillBar:AddSkill(name, Skill(self.SkillBar, self.RowInfo[self.Skills[name][3]], self.Skills[name][1], self.Skills[name][4] , self.Skills[name][5]), self.Skills[name][2], self.Skills[name][3] );
		end
	end

	self.SkillBar:AddSkill("Break Ranks", Skill(self.SkillBar, self.RowInfo[self.Skills["Break Ranks"][3]], self.Skills["Break Ranks"][1], self.Skills["Break Ranks"][4] , self.Skills["Break Ranks"][5]), self.Skills["Break Ranks"][2], self.Skills["Break Ranks"][3] );
end

function GuardianAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();

		if self.ChainEffects[effectName] ~= nil then
			self:HandleResponseState(effectName, true);
		end

		if self.Fortifications[effectName] ~= nil then
			self.lastTier = effectName;
			self.fortBar:SetTotal(self.Fortifications[effectName]);
		end

		if self.ProcTable[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.ProcBar:SetActive(effectName, effect:GetDuration());
		end

		if effectName == "Break Ranks" then
			self.SkillBar:TriggerCooldown("Break Ranks", 60);
		end

		if effectName == "Guardian's Ward Tactics" then 
			self.SkillBar:ToggleHighlight("Guardian's Ward", false);
		end
	end);

	self.effectRemovedCallback = AddCallback(playerEffects, "EffectRemoved", function(sender, args)
		local effect = args.Effect;
		if effect ~= nil then 
			local effectName = effect:GetName();

			if self.ChainEffects[effectName] ~= nil and effect:GetID() == self.EffectIDs[effectName] then
				self:HandleResponseState(effectName, false);
			end

			if effectName == self.lastTier then
				self.fortBar:SetTotal(0);
			end

			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end

			if effectName == "Guardian's Ward Tactics" and effect:GetID() == self.EffectIDs[effectName] then 
				self.SkillBar:ToggleHighlight("Guardian's Ward", true);
			end
		end
	end);

	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();
		local ID = item:GetSkillInfo():GetIconImageID();

		Turbine.Shell.WriteLine(name .. " : " .. ID);
		
        self.Callbacks[name] = {}

		if self.Skills[name] then
			self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
            end));
		end
    end
end

function GuardianAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end

	self.ProcBar:Unload();
	self.PrimarySkillBar:Unload();
	self.SecondarySkillBar:Unload();
	self.TertiarySkillBar:Unload();
	self.CooldownBar:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function GuardianAuras:GetRole()
	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();
		if name == "Shield-taunt" then
			return 1;
		elseif name == "Overwhelm" then
			return 2;
		elseif name == "Take To Heart" then
			return 3;
		end
	end
	return 4;
end

function GuardianAuras:Unload()
	self:RemoveCallbacks();
	SaveData = {
		["aurasLeft"] = self:GetLeft(),
		["aurasTop"] = self:GetTop(),
	};
	Turbine.PluginData.Save(Turbine.DataScope.Character, "AuraSettings", SaveData)
end

function GuardianAuras:Reload()
	AddCallback(Updater, "Tick", self.ReloadHandler);
end