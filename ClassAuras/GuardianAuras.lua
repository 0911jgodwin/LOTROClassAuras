import "Deusdictum.UI";
import "ExoPlugins.ClassAuras.Skill";
import "ExoPlugins.ClassAuras.SkillBar";
import "ExoPlugins.ClassAuras.ResourceBar";
GuardianAuras = class(Turbine.UI.Window)
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
	--[<Skill Name>] = {<image filepath>, <icon size>, <priority>}
	self.PrimarySkills = {
		["Improved Sting"] = {"Sting", 38, 1},
		["Guardian's Ward"] = {"Guardian's_Ward", 38, 2},
		["Vexing Blow"] = {"Vexing_Blow", 38, 3},
		["Sweeping Cut"] = {"Sweeping_Cut", 38, 4},
		["Shield-blow"] = {"Shield-blow", 38, 5},
		["War-chant"] = {"War-chant", 38, 6},
		["Stamp"] = {"Stamp", 38, 7},
		["Stagger"] = {"Stagger", 38, 8},
	};

	self.SecondarySkills = {
		["Fray the Edge"] = {"Fray_the_Edge", 32, 1},
		["Retaliation"] = {"Retaliation", 32, 2},
		["Whirling Retaliation"] = {"Whirling_Retaliation", 32, 3},
		["Turn the Tables"] = {"Turn_the_Tables", 32, 4},
		["Ignore the Pain"] = {"Ignore_the_Pain", 32, 5},
		["Shield-swipe"] = {"Shield-swipe", 32, 6},
		["Shield-taunt"] = {"Shield-taunt", 32, 7},
		["Bash"] = {"Bash", 32, 8},
		["Shield-smash"] = {"Shield-smash", 32, 9},
	};

	self.TertiarySkills = {
		["Engage"] = {"Engage", 32, 1},
		["Redirect"] = {"Redirect", 32, 2},
		["Catch a Breath"] = {"Catch_a_Breath", 32, 3},
		["Smashing Stab"] = {"Smashing_Stab", 32, 4},
		["Challenge"] = {"Challenge", 32, 5},
	};

	self.CooldownSkills = {
		["Guardian's Pledge"] = {"Guardian's_Pledge", 32, 1},
		["Juggernaut"] = {"Juggernaut", 32, 2},
		["Litany of Defiance"] = {"Litany_of_Defiance", 32, 3},
		["Warrior's Heart"] = {"Warrior's_Heart", 32, 4},
		["Thrill of Danger"] = {"Thrill_of_Danger", 32, 5},
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
		self.SecondarySkillBar:ToggleActive("Shield-swipe", bool);
	elseif effect == "Parry Response" then
		self.parryResponse = bool;
		self.SecondarySkillBar:ToggleActive("Retaliation", bool);
		self.SecondarySkillBar:ToggleActive("Whirling Retaliation", bool);
	elseif effect == "Retaliation" then
		self.retaliation = bool;
		self.TertiarySkillBar:ToggleActive("Redirect", bool);
	elseif effect == "Shield Swipe" then
		self.shieldSwipe = bool;
		self.SecondarySkillBar:ToggleActive("Shield-taunt", bool);
		self.SecondarySkillBar:ToggleActive("Bash", bool);
	end
	
	--Handle Catch a Breath
	if self.blockResponse or self.parryResponse then
		self.TertiarySkillBar:ToggleActive("Catch a Breath", true);
	else
		self.TertiarySkillBar:ToggleActive("Catch a Breath", false);
	end

	--Handle Smashing Stab
	if self.retaliation and self.shieldSwipe then
		self.TertiarySkillBar:ToggleActive("Smashing Stab", true);
		self.TertiarySkillBar:ToggleHighlight("Smashing Stab", true);
	elseif self.retaliation or self.shieldSwipe then
		self.TertiarySkillBar:ToggleActive("Smashing Stab", true);
		self.TertiarySkillBar:ToggleHighlight("Smashing Stab", false);
	else
		self.TertiarySkillBar:ToggleActive("Smashing Stab", false);
		self.TertiarySkillBar:ToggleHighlight("Smashing Stab", false);
	end
end

function GuardianAuras:ConfigureBars()
	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);
	self.PrimarySkillBar = SkillBar(self, width, 40, 38, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.PrimarySkillBar:SetPosition(0, 55);
	self.SecondarySkillBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.SecondarySkillBar:SetPosition(0, 87);
	self.TertiarySkillBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.TertiarySkillBar:SetPosition(0, 115);
	self.CooldownBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, false);
	self.CooldownBar:SetPosition(0, 145);

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	if self.role == 1 then
		self.fortBar = ResourceBar(self, width, 24, 5);
		self.fortBar:SetPosition(0, 35);
		self.fortBar:SetTotal(0);
		self.lastTier = "";
	end

	for i = 1, skillList:GetCount(), 1 do
        local name = skillList:GetItem(i):GetSkillInfo():GetName();

		if self.PrimarySkills[name] then
			if self.ChainSkills[name] ~= nil then
				self.PrimarySkillBar:AddSkill(name, Skill(self.PrimarySkillBar, self.PrimarySkills[name][2], name, self.PrimarySkills[name][1], false), self.PrimarySkills[name][3]);
			else
				self.PrimarySkillBar:AddSkill(name, Skill(self.PrimarySkillBar, self.PrimarySkills[name][2], name, self.PrimarySkills[name][1]), self.PrimarySkills[name][3]);
			end
		elseif self.SecondarySkills[name] then
			if self.ChainSkills[name] ~= nil then
				self.SecondarySkillBar:AddSkill(name, Skill(self.SecondarySkillBar, self.SecondarySkills[name][2], name, self.SecondarySkills[name][1], false), self.SecondarySkills[name][3]);
			else
				self.SecondarySkillBar:AddSkill(name, Skill(self.SecondarySkillBar, self.SecondarySkills[name][2], name, self.SecondarySkills[name][1]), self.SecondarySkills[name][3]);
			end
		elseif self.TertiarySkills[name] then
			if self.ChainSkills[name] ~= nil then
				self.TertiarySkillBar:AddSkill(name, Skill(self.TertiarySkillBar, self.TertiarySkills[name][2], name, self.TertiarySkills[name][1], false), self.TertiarySkills[name][3]);
			else
				self.TertiarySkillBar:AddSkill(name, Skill(self.TertiarySkillBar, self.TertiarySkills[name][2], name, self.TertiarySkills[name][1]), self.TertiarySkills[name][3]);
			end
		elseif self.CooldownSkills[name] then
			self.CooldownBar:AddSkill(name, Skill(self.CooldownBar, self.CooldownSkills[name][2], name, self.CooldownSkills[name][1]), self.CooldownSkills[name][3]);
		end
	end

	self.CooldownBar:AddSkill("Break Ranks", Skill(self.CooldownBar, 32, "Break Ranks", "Break_Ranks"), 0);
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
			self.CooldownBar:TriggerCooldown("Break Ranks", 60);
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
				self.PrimarySkillBar:ToggleHighlight("Guardian's Ward", true);
			end
		end
	end);

	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();
		
        self.Callbacks[name] = {}

        if self.PrimarySkills[name] then
            self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.PrimarySkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown());
            end))
        end

		if self.SecondarySkills[name] then
            self.SkillsTable[name] = item
			if name == "Bash" or name == "Shield-taunt" then
				table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
					self.SecondarySkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown());
					self.SecondarySkillBar:ToggleActive("Shield-smash", true, 5);
				end))
			else
				table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
					self.SecondarySkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown());
				end))
			end
        end

		if self.TertiarySkills[name] then
            self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.TertiarySkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown());
            end))
        end

		if self.CooldownSkills[name] then
            self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.CooldownBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown());
            end))
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