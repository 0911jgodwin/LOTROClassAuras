import "ExoPlugins.Auras.AuraTools";
_G.RunekeeperAuras = class(Turbine.UI.Window)
function RunekeeperAuras:Constructor(parent)
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
		["Master of Connotation - 5"] = "Writ of Fire",
		["Charged"] = "Sustaining Bolt",
	};

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

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
		["Sudden Defence"] = 1,
	};

	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = DragBar( self, "Runekeeper Auras" );
end

function RunekeeperAuras:AttunementManagement(fervorTotal)
	self.attunement:SetAttunementTotal(fervorTotal);
end

function RunekeeperAuras:StaticSurgeHandler(bool)

end

function RunekeeperAuras:ConfigureBars()

	self:SetPosition(Settings["General"]["Position"][1], Settings["General"]["Position"][2]);
	
    self:SetSize(Settings["General"]["Width"], 200);
	width = self:GetWidth();

	self.RowInfo = Settings["Class"][playerRole]["Skills"]["RowInfo"];
	self.Skills = Settings["Class"][playerRole]["Skills"]["SkillData"];
	self.ProcTable = Settings["Class"][playerRole]["Procs"];

	local rowCount = 0;
	for key, value in pairs(self.RowInfo) do
		rowCount = rowCount + 1;
	end

	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter, 38);
	self.ProcBar:SetPosition(0, 0);
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, rowCount, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, 51);

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, self.ProcBar:GetIconSize(), value[1], value[3]), value[2]);
	end

	self.colours = {
		[0] = Turbine.UI.Color(0.77, 0.12, 0.23),
		[11] = Turbine.UI.Color(0.12, 0.77, 0.23),
	};
	self.attunement = ResourceBar(self, width, 24, 9, self.colours);
	self.attunement:SetPosition(0, 35);
	self.attunement:SetAttunementTotal(playerAttributes:GetAttunement());

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
end

function RunekeeperAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if effectName == "Parry Response" then
			self.SkillBar:ToggleActive("Sweeping Riposte", true);
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

			if effectName == "Parry Response" and effect:GetID() == self.EffectIDs[effectName] then
				self.SkillBar:ToggleActive("Sweeping Riposte", false);
			end

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

	self.staticSurge = nil;
	self.staticSurgeUsable = nil;
	if playerRole == 3 then
		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
		
			if name == "Static Surge" then
				self.staticSurge = item;
			end
		end
	end

	if Settings["General"]["ShowSkills"] then
		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
		
			self.Callbacks[name] = {}

			if self.Skills[name] then
				self.SkillsTable[name] = item

				if self.staticSurge ~= nil then
					table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
						self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
						self.SkillBar:ToggleActive("Static Surge", self.staticSurge:IsUsable());
					end));
				else
					table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
						self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
					end));
				end
			end
		end
	end

	self.AttunementCallback = AddCallback(playerAttributes, "AttunementChanged", function(sender, args)
		self:AttunementManagement(playerAttributes:GetAttunement());
	end);
end

function RunekeeperAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	RemoveCallback(playerAttributes, "AttunementChanged", self.AttunementCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.staticSurge = nil;
	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.attunement:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function RunekeeperAuras:Unload()
	self:RemoveCallbacks();
end

function RunekeeperAuras:SavePosition()
	Data = {
		[1] = self:GetLeft(),
		[2] = self:GetTop(),
	};

	Settings["General"]["Position"] = Data;
end

function RunekeeperAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end