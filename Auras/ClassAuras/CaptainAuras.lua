import "ExoPlugins.Auras.AuraTools";
_G.CaptainAuras = class(Turbine.UI.Window)
function CaptainAuras:Constructor(parent)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		["Elendil's Boon"] = "Shadow's Lament",
		["Elendil's Favour"] = "Valiant Strike",
	};

	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = DragBar( self, "Captain Auras" );
end

function CaptainAuras:ConfigureBars()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	self:SetPosition(Settings["General"]["Position"][1]*screenWidth, Settings["General"]["Position"][2]*screenHeight);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
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

	self.ProcBar= _G.EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter, 38);
	self.ProcBar:SetPosition(0, 0);
	self.SkillBar = _G.SkillBar(self, width, 200, self.RowInfo, rowCount, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, Settings["General"]["YPositions"]["SkillBar"]);

	self.BuffsBar = _G.EffectWindow( self:GetParent(), 256, 64, Turbine.UI.ContentAlignment.MiddleRight, Settings["General"]["BuffIconSize"]);
	self.BuffsBar:SetPosition(Settings["General"]["Buffs"]["Position"][1]*screenWidth, Settings["General"]["Buffs"]["Position"][2]*screenHeight);
	self.BuffDragBar = DragBar( self.BuffsBar, "Buffs" );

	self.RallyBar = _G.BuffBar(self, math.floor(width/3), Settings["General"]["Resource"]["Height"], Turbine.UI.Color( 1.00, 0.96, 0.41 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.PenetratingBar = _G.BuffBar(self, math.floor(width/3), Settings["General"]["Resource"]["Height"], Turbine.UI.Color( 1.00, 0.96, 0.41 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.StanceBar = _G.BuffBar(self, math.floor(width/3), Settings["General"]["Resource"]["Height"], Turbine.UI.Color( 0.23, 0.77, 0.12 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.ReadiedBar = _G.BuffBar(self, math.floor(width/2), Settings["General"]["Resource"]["Height"], Turbine.UI.Color(0.23, 0.12, 0.77), Turbine.UI.ContentAlignment.MiddleRight);
	self.HardenedBar = _G.BuffBar(self, math.floor(width/2), Settings["General"]["Resource"]["Height"], Turbine.UI.Color(0.77, 0.12, 0.23), Turbine.UI.ContentAlignment.MiddleLeft);


	self.RallyBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 , Settings["General"]["YPositions"]["Resource"]);
	self.StanceBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 + math.floor(self.RallyBar:GetWidth()), Settings["General"]["YPositions"]["Resource"]);
	self.PenetratingBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 + math.floor(self.RallyBar:GetWidth() * 2), Settings["General"]["YPositions"]["Resource"]);
	self.ReadiedBar:SetPosition(width/2 - self.ReadiedBar:GetWidth(), Settings["General"]["YPositions"]["Resource"] + Settings["General"]["Resource"]["Height"] + 2);
	self.HardenedBar:SetPosition(width/2, Settings["General"]["YPositions"]["Resource"] + Settings["General"]["Resource"]["Height"] + 2);

	self.BarTable = {
		["Battle-hardened"] = self.HardenedBar,
		["Battle-readied"] = self.ReadiedBar,
		["Rousing Cry Damage Buff"] = self.RallyBar,
		["Penetrating Cry Attack Speed Buff"] = self.PenetratingBar,	
	};

	

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, self.ProcBar:GetIconSize(), value[1], value[3]), value[2]);
	end

	for key, value in pairs(self.BuffEffects) do
		self.BuffsBar:AddEffect(key, Effect(self.BuffsBar, Settings["General"]["BuffIconSize"], value, 0));
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
	end

	if playerRole == 1 then
		self.BarTable["Focus"] = self.StanceBar;
		self.BarTable["Relentless Attack"] = nil;
		self.BarTable["On Guard"] = nil;
	elseif playerRole == 2 then
		self.BarTable["On Guard"] = nil;
		self.BarTable["Focus"] = nil;
		self.BarTable["Relentless Attack"] = self.StanceBar;
	elseif playerRole == 3 then
		self.BarTable["Focus"] = nil;
		self.BarTable["Relentless Attack"] = nil;
		self.BarTable["On Guard"] = self.StanceBar;
	end

end

function CaptainAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if effectName == "Battle-readied" then
			self.SkillBar:ToggleActive("Devastating Blow", true);
			self.SkillBar:ToggleActive("Pressing Attack", true);
		elseif effectName == "Battle-hardened" then
			self.SkillBar:ToggleActive("Improved Blade of Elendil", true);
		end

		if self.BuffEffects[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.BuffsBar:SetActive(effectName, effect:GetDuration())
		end

		if self.ProcTable[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.ProcBar:SetActive(effectName, effect:GetDuration());
		end

		if self.BarTable[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.BarTable[effectName]:SetTimer(effect:GetDuration());
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

			if effectName == "Battle-readied" and effect:GetID() == self.EffectIDs[effectName] then
				self.SkillBar:ToggleActive("Devastating Blow", false);
				self.SkillBar:ToggleActive("Pressing Attack", false);
			elseif effectName == "Battle-hardened" and effect:GetID() == self.EffectIDs[effectName] then
				self.SkillBar:ToggleActive("Improved Blade of Elendil", false);
			end

			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end

			if self.BuffEffects[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BuffsBar:SetInactive(effectName);
			end

			if self.BarTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BarTable[effectName]:EndTimer();
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
		local ID = item:GetSkillInfo():GetIconImageID();
	
		self.Callbacks[name] = {};

		if self.Skills[name] then
			self.SkillsTable[name] = item
			table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
				self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
			end))
		end
	end
end

function CaptainAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.RallyBar:Unload();
	self.StanceBar:Unload();
	self.PenetratingBar:Unload();
	self.ReadiedBar:Unload();
	self.HardenedBar:Unload();
	self.BuffsBar:Unload();

	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function CaptainAuras:Unload()
	self:RemoveCallbacks();
end

function CaptainAuras:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};

	Settings["General"]["Position"] = Data;
end

function CaptainAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end