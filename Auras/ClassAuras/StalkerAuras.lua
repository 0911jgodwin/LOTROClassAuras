import "ExoPlugins.Auras.AuraTools";
_G.StalkerAuras = class(Turbine.UI.Window)
function StalkerAuras:Constructor(parent)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 200);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
	};

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	self.CriticalResponseSkills = {
		["Rend Flesh"] = true,
		["Frenzy"] = true,
	};

	self.DefeatResponseSkills = {
		["Rallying Howl"] = true,
	};

	self.criticalResponse = false;
	self.defeatResponse = false;

	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = DragBar( self, "Stalker Auras" );
end

function StalkerAuras:PowerManagement(PowerTotal)
	local powerPercentage = math.floor((PowerTotal / player:GetMaxPower()) * 100);
	self.Power:SetTotal(powerPercentage);
end

function StalkerAuras:ResponseSkillManagement()
	for key, value in pairs(self.CriticalResponseSkills) do
		self.SkillBar:ToggleActive(key, self.criticalResponse);
	end
end

function StalkerAuras:ManageSkills()
	for key, value in pairs(self.CriticalResponseSkills) do
		self.SkillBar:ToggleActive(key, self.criticalResponse);
	end
end

function StalkerAuras:ConfigureBars()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	self:SetPosition(Settings["General"]["Position"][1]*screenWidth, Settings["General"]["Position"][2]*screenHeight);
	
    self:SetSize(Settings["General"]["Width"], 200);
	width = self:GetWidth();

	self.RowInfo = Settings["Class"][playerRole]["Skills"]["RowInfo"];
	self.Skills = Settings["Class"][playerRole]["Skills"]["SkillData"];
	self.ProcTable = Settings["Class"][playerRole]["Procs"];
	self.BuffEffects = Settings["Class"][playerRole]["Buffs"];

	local rowCount = 0;
	for key, value in pairs(self.RowInfo) do
		rowCount = rowCount + 1;
	end

	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter, 38);
	self.ProcBar:SetPosition(0, 0);
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, rowCount, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, Settings["General"]["YPositions"]["SkillBar"]);

	self.BuffsBar = _G.EffectWindow( self:GetParent(), 256, 64, Turbine.UI.ContentAlignment.MiddleRight, Settings["General"]["BuffIconSize"]);
	self.BuffsBar:SetPosition(Settings["General"]["Buffs"]["Position"][1]*screenWidth, Settings["General"]["Buffs"]["Position"][2]*screenHeight);
	self.BuffDragBar = DragBar( self.BuffsBar, "Buffs" );

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, self.ProcBar:GetIconSize(), value[1], value[3]), value[2]);
	end

	for key, value in pairs(self.BuffEffects) do
		self.BuffsBar:AddEffect(key, Effect(self.BuffsBar, Settings["General"]["BuffIconSize"], value, 0));
	end

	self.colors = {
        [1] = {20, Turbine.UI.Color(1, 0.12, 0.12)},
        [2] = {35, Turbine.UI.Color(1, 0.96, 0.41)},
        [3] = {100, Turbine.UI.Color(0, 0.82, 1)},
    };

	self.Power = VitalBar(self, width, Settings["General"]["Resource"]["Height"], Settings["General"]["Resource"]["FontSize"], self.colors);
	self.Power:SetPosition(0, Settings["General"]["YPositions"]["Resource"]);
	self.Power:SetTotal(math.floor((player:GetPower()/player:GetMaxPower())*100));

	if Settings["General"]["ShowSkills"] then
		for i = 1, skillList:GetCount(), 1 do
			local name = skillList:GetItem(i):GetSkillInfo():GetName();

			if Settings["General"]["Debug"] then
				Debug("Skill Name: " .. name .. " | Skill Icon: " .. skillList:GetItem(i):GetSkillInfo():GetIconImageID());
			end

			if self.Skills[name] then
				self.SkillBar:AddSkill(name, Skill(self.SkillBar, self.RowInfo[self.Skills[name][3]], self.Skills[name][1], self.Skills[name][4] , self.Skills[name][5]), self.Skills[name][2], self.Skills[name][3] );				
			end
		end
	end
	if self.Skills["Brand"] ~= nil then
		self.SkillBar:AddSkill("Brand", Skill(self.SkillBar, self.RowInfo[self.Skills["Brand"][3]], self.Skills["Brand"][1], self.Skills["Brand"][4] , self.Skills["Brand"][5]), self.Skills["Brand"][2], self.Skills["Brand"][3] );	
	end
end

function StalkerAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if effectName == "Immunity" then
			self.SkillBar:TriggerCooldown("Brand", 60);
		end

		if effectName == "Critical Response" then
			if self.criticalResponse == false then
				self.criticalResponse = true;
				self:ResponseSkillManagement();
			end
		end

		if effectName == "Enemy Defeat Response" then
			self.SkillBar:ToggleActive("Rallying Howl", true);
		end

		if effectName == "March!" then
			self.SkillBar:ToggleActive("Stealth", false);
			self.SkillBar:ToggleActive("Disappear", false);
		end

		if self.BuffEffects[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.BuffsBar:SetActive(effectName, effect:GetDuration())
		end

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

			if effectName == "March!" and not player:IsInCombat() then
				self.SkillBar:ToggleActive("Stealth", true);
				self.SkillBar:ToggleActive("Disappear", true);
			end

			if effectName == "Critical Response" and effect:GetID() == self.EffectIDs[effectName] then
				self.criticalResponse = false;
				self:ResponseSkillManagement();
			end

			if effectName == "Enemy Defeat Response" and effect:GetID() == self.EffectIDs[effectName] then
				self.SkillBar:ToggleActive("Rallying Howl", false);
			end

			if self.BuffEffects[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BuffsBar:SetInactive(effectName);
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

	self.PowerCallback = AddCallback(player, "PowerChanged", function(sender, args)
		self:PowerManagement(player:GetPower());
	end);

	self.CombatCallback = AddCallback(player, "InCombatChanged", function(sender, args)
		self.SkillBar:ToggleActive("Stealth", not player:IsInCombat());
	end);

	self.SkillBar:ToggleActive("Stealth", not player:IsInCombat());
	self.SkillBar:ToggleActive("Disappear", true);
end

function StalkerAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	RemoveCallback(playerAttributes, "PowerChanged", self.PowerCallback);
	RemoveCallback(player, "InCombatChanged", self.CombatCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.Power:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function StalkerAuras:Unload()
	self:RemoveCallbacks();
end

function StalkerAuras:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};

	Settings["General"]["Position"] = Data;
end

function StalkerAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end