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
    self:SetSize(312, 300);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();
    
	self.role = nil;

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	self.ProcTable = {
		["Inspiriting Presence"] = {1091840414, 1, 0},
	};

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		["Elendil's Boon"] = "Shadow's Lament",
	};

	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image filepath>, <icon size>, <priority>}
	self.PrimarySkills = {
		["Battle-shout"] = {"Battle_Shout", 38, 1},
	};

	self.SecondarySkills = {
		["Devastating Blow"] = {"Devastating_Blow", 32, 1},
	};

	self.CooldownSkills = {
		["Reform the Lines!"] = {"Reform_the_Lines!", 32, 1},
	};

	self.Fortifications = {
		["Improved Fortification I"] = 1,
		["Improved Fortification II"] = 2,
		["Improved Fortification III"] = 3,
		["Improved Fortification IV"] = 4,
		["Improved Fortification V"] = 5,
	}

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

function GuardianAuras:ConfigureBars()
	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);
	self.PrimarySkillBar = SkillBar(self, width, 40, 38, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.PrimarySkillBar:SetPosition(0, 53+2);
	self.SecondarySkillBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.SecondarySkillBar:SetPosition(0, 85+2);
	self.CooldownBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, false);
	self.CooldownBar:SetPosition(0, 113+2);

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
			self.PrimarySkillBar:AddSkill(name, Skill(self.PrimarySkillBar, self.PrimarySkills[name][2], name, self.PrimarySkills[name][1]), self.PrimarySkills[name][3]);
		elseif self.SecondarySkills[name] then
			self.SecondarySkillBar:AddSkill(name, Skill(self.SecondarySkillBar, self.SecondarySkills[name][2], name, self.SecondarySkills[name][1]), self.SecondarySkills[name][3]);
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
		Turbine.Shell.WriteLine(effectName);

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

			if effectName == self.lastTier then
				self.fortBar:SetTotal(0);
			end

			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
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
                self.PrimarySkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
            end))
        end

		if self.SecondarySkills[name] then
            self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.SecondarySkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
            end))
        end

		if self.CooldownSkills[name] then
            self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.CooldownBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
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