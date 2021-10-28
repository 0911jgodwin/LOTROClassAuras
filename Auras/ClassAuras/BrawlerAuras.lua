import "ExoPlugins.Auras.AuraTools";
_G.BrawlerAuras = class(Turbine.UI.Window)
function BrawlerAuras:Constructor(parent, x, y)
    Turbine.UI.Window.Constructor(self)
    self:SetParent(parent);

    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	self.BattleFlow = {
		["Battle Flow 1"] = 1,
		["Battle Flow 2"] = 2,
		["Battle Flow 3"] = 3,
		["Battle Flow 4"] = 4,
		["Battle Flow 5"] = 5,
		["Battle Flow 6"] = 6,
		["Battle Flow 7"] = 7,
		["Battle Flow 8"] = 8,
		["Battle Flow 9"] = 9,
	}

	self.mettleCosts = {
		["Shattering Fist"] = 3,
		["Backhand Clout"] = 3,
		["Strike Towards the Sky"] = 3,
		["Overhand Smash"] = 3,
		["Pummel"] = 3,
		["Helm-crusher"] = 3,
		["Mighty Upheaval"] = 3,
		["Fist of the Valar"] = 3,
		["Gut Punch"] = 3,
		["Knee Strike"] = 3,
	};

	self:ConfigureBars();
    self:ConfigureCallbacks();
    self.DragBar = DragBar( self, "Brawler Auras" );
end

function BrawlerAuras:MettleMangement(mettleTotal)
	self.mettle:SetTotal(mettleTotal);

	for key, value in pairs(self.mettleCosts) do
		if self.mettleCosts[key] <= mettleTotal then
			self.SkillBar:ToggleActive(key, true);
		else
			self.SkillBar:ToggleActive(key, false);
		end
	end
end

function BrawlerAuras:ConfigureBars()
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
	self.SkillBar:SetPosition(0, 51);

	self.BuffsBar = _G.EffectWindow( self:GetParent(), 256, 64, Turbine.UI.ContentAlignment.MiddleRight, 32);
	self.BuffsBar:SetPosition(Settings["General"]["Buffs"]["Position"][1]*screenWidth, Settings["General"]["Buffs"]["Position"][2]*screenHeight);
	self.BuffDragBar = DragBar( self.BuffsBar, "Buffs" );

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, self.ProcBar:GetIconSize(), value[1], value[3]), value[2]);
	end

	for key, value in pairs(self.BuffEffects) do
		self.BuffsBar:AddEffect(key, Effect(self.BuffsBar, 32, value, 0));
	end

	self.colours = {
		[0] = Turbine.UI.Color(1.00, 0.96, 0.41),
		[4] = Turbine.UI.Color(0.87, 0.55, 0.1),
		[7] = Turbine.UI.Color(0.77, 0.12, 0.23),
    };
	self.mettle = ResourceBar(self, width, 24, 9, self.colours);
	self.mettle:SetPosition(0, 35);
	self.mettle:SetTotal(0);

	self.lastTier = "Battle Flow 1";

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

function BrawlerAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if self.BattleFlow[effectName] ~= nil then
			self.lastTier = effectName;
			self:MettleMangement(self.BattleFlow[effectName]);
		end

		if self.BuffEffects[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.BuffsBar:SetActive(effectName, effect:GetDuration())
		end

		if self.ProcTable[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.ProcBar:SetActive(effectName, effect:GetDuration());
		end
	end);

	self.effectRemovedCallback = AddCallback(playerEffects, "EffectRemoved", function(sender, args)
		local effect = args.Effect;
		if effect ~= nil then 
			local effectName = effect:GetName();

			if effectName == self.lastTier then
				self:MettleMangement(0);
			end
			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end

			if self.BuffEffects[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BuffsBar:SetInactive(effectName);
			end
		end
	end);

	if Settings["General"]["ShowSkills"] then
		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			local ID = item:GetSkillInfo():GetIconImageID();

			self.Callbacks[name] = {}

			if self.Skills[name] then
				self.SkillsTable[name] = item
				table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
					self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
				end));
			end
		end
	end
end

function BrawlerAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.mettle:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function BrawlerAuras:Unload()
	self:RemoveCallbacks();
end

function BrawlerAuras:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};

	Settings["General"]["Position"] = Data;
end

function BrawlerAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end