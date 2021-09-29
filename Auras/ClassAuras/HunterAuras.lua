import "ExoPlugins.Auras.AuraTools";
_G.HunterAuras = class(Turbine.UI.Window)
function HunterAuras:Constructor(parent)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 200);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();

	self.swiftMercyStackCount = 0;
    

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		["Swift and True"] = "Improved Swift Bow",
	};

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	self.focusCosts = {
		["Improved Penetrating Shot"] = 3,
		["Blood Arrow"] = 3,
		["Improved Merciful Shot"] = 6,
		["Barrage"] = 3,
		["Split Shot"] = 2,
		["Pinning Shot"] = 3,
		["Rain of Arrows"] = 5,
		["Upshot"] = 1,
		["Explosive Arrow"] = 3,
	};

	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = DragBar( self, "Hunter Auras" );
end

function HunterAuras:FocusManagement(focusTotal)
	self.focus:SetTotal(focusTotal);

	for key, value in pairs(self.focusCosts) do
		if key == "Improved Merciful Shot" then
			if self.focusCosts[key] <= (focusTotal + self.swiftMercyStackCount) then
				self.SkillBar:ToggleActive(key, true);
			else
				self.SkillBar:ToggleActive(key, false);
			end
		else
			if self.focusCosts[key] <= (focusTotal) then
				self.SkillBar:ToggleActive(key, true);
			else
				self.SkillBar:ToggleActive(key, false);
			end
		end
	end
end

function HunterAuras:ConfigureBars()

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

	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, rowCount, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, 51);

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	self.colours = {
		[0] = Turbine.UI.Color(1.00, 0.96, 0.41),
		[9] = Turbine.UI.Color(0.77, 0.12, 0.23),
	};
	self.focus = ResourceBar(self, width, 24, 9, self.colours);
	self.focus:SetPosition(0, 35);
	self.focus:SetTotal(playerAttributes:GetFocus());

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

function HunterAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if effectName == "Swift Mercy" and self.swiftMercyStackCount == 0 then
			self.swiftMercyStackCount = 1;
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

			if effectName == "Swift Mercy" and effect:GetID() == self.EffectIDs[effectName] then
				Debug("reset");
				self.swiftMercyStackCount = 0;
			elseif effectName == "Swift Mercy" then
				Debug("Stack increase")
				self.swiftMercyStackCount = self.swiftMercyStackCount + 1;
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

	if Settings["General"]["ShowSkills"] then
		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
		
			self.Callbacks[name] = {}

			if self.Skills[name] then
				self.SkillsTable[name] = item

				if name == "Blood Arrow" then
					table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
						self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
						self.SkillBar:ToggleActive("Exsanguinate", true, 8);
					end));
				else
					table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
						self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
					end));
				end
			end
		end
	end

	self.FocusCallback = AddCallback(playerAttributes, "FocusChanged", function(sender, args)
		self:FocusManagement(playerAttributes:GetFocus());
	end);
end

function HunterAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	RemoveCallback(playerAttributes, "FocusChanged", self.FocusCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.focus:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function HunterAuras:Unload()
	self:RemoveCallbacks();
	Data = {
		[1] = self:GetLeft(),
		[2] = self:GetTop(),
	};

	Settings["General"]["Position"] = Data;
end

function HunterAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end