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


	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		--["Elendil's Boon"] = "Shadow's Lament",
	};



	self.Fortifications = {
		["Improved Fortification I"] = 1,
		["Improved Fortification II"] = 2,
		["Improved Fortification III"] = 3,
		["Improved Fortification IV"] = 4,
		["Improved Fortification V"] = 5,
	};

	self.ChainEffects = {
		["Block Response"] = true,
		["Parry Response"] = true,
		["Retaliation"] = true,
		["Shield Swipe"] = true,
	};

	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = DragBar( self, "Guardian Auras" );
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
		self.SkillBar:ToggleActive("Thrust", bool);
		self.SkillBar:ToggleActive("Overwhelm", bool);
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

	if playerRole == 1 then
		self.colours = {
			[0] = Turbine.UI.Color(0.23, 0.12, 0.77),
			};
		self.fortBar = ResourceBar(self, width, Settings["General"]["Resource"]["Height"], 5, self.colours, Settings["General"]["Resource"]["FontSize"]);
		self.fortBar:SetPosition(0, Settings["General"]["YPositions"]["Resource"]);
		self.fortBar:SetTotal(0);
		self.lastTier = "";
	end


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

		if playerRole == 1 then
			self.SkillBar:AddSkill("Break Ranks", 
				Skill(self.SkillBar, 
					self.RowInfo[self.Skills["Break Ranks"][3]], 
					self.Skills["Break Ranks"][1], 
					self.Skills["Break Ranks"][4], 
					self.Skills["Break Ranks"][5]), 
					self.Skills["Break Ranks"][2], 
					self.Skills["Break Ranks"][3]);
		end
	end
end

function GuardianAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if self.ChainEffects[effectName] ~= nil then
			self:HandleResponseState(effectName, true);
		end

		if self.Fortifications[effectName] ~= nil then
			self.lastTier = effectName;
			self.fortBar:SetTotal(self.Fortifications[effectName]);
		end

		if self.BuffEffects[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.BuffsBar:SetActive(effectName, effect:GetDuration())
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

			if self.BuffEffects[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BuffsBar:SetInactive(effectName);
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

		
		self.Callbacks[name] = {}

		if self.Skills[name] then
			self.SkillsTable[name] = item;

			if name == "Bash" or name == "Shield-taunt" then
				table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
					self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
					self.SkillBar:ToggleActive("Shield-smash", true, 5);
				end));
			elseif name == "Thrust" or name == "Overwhelm" then
				table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
					self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
					self.SkillBar:ToggleActive("To the King", true, 5);
				end));
			else
				table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
					self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
				end));
			end
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

	if self.fortBar ~= nil then
		self.fortBar:Unload();
		self.fortBar = nil;
	end

	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function GuardianAuras:Unload()
	self:RemoveCallbacks();
end

function GuardianAuras:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};

	Settings["General"]["Position"] = Data;
end

function GuardianAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end