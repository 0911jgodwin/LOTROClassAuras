import "ExoPlugins.Auras.AuraTools";
_G.BeorningAuras = class(Turbine.UI.Window)
function BeorningAuras:Constructor(parent)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 200);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();
    
	self.form = nil;

	--Data required for additional entries to this table:
	--[<Effect Name>] = <Skill to Highlight>
	self.SkillHighlights = {
		["Sharpened Claws"] = "Relentless Maul",
	};

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	self.mountedSkills = {
		["Ferocious Roar"] = 1091787642,
		["Bee Swarm"] = 1091742016,
		["Biting Edge"] = 1091787649,
		["Slash"] = 1091742735,
		["Execute"] = 1091744017,
		["Recuperate"] = 1091787641,
		["Sacrifice"] = 1091747175,
	};

	self.BearWrathCosts = {
		["Bee Swarm"] = 10,
		["Rending Blow"] = 15,
		["Bash"] = 20,
		["Relentless Maul"] = 20,
		["Recuperate"] = 10,
		["Grisly Cry"] = 10,
		["Vigilant Roar"] = 0,
		["Vicious Claws"] = 15,
		["Claw Swipe"] = 10,
		["Thunderous Roar"] = 0,
		["Encouraging Roar"] = 10,
		["Rejuvenating Bellow"] = 20,
	};

	self.ManWrathCosts = {
		["Bee Swarm"] = 10,
		["Slam"] = 0,
		["Biting Edge"] = 0,
		["Guarded Attack"] = 0,
		["Hearten"] = 10,
		["Ferocious Roar"] = 0,
		["Nature's Mend"] = 0,
	};

	self:ConfigureBars();
	self:ConfigureCallbacks();

	self.DragBar = DragBar( self, "Beorning Auras" );
end

function BeorningAuras:WrathManagement(wrathTotal)
	self.Wrath:SetTotal(wrathTotal);
end

function BeorningAuras:SkillManagement(wrathTotal)
	if self.form == "Man-form" then
		for key, value in pairs(self.BearWrathCosts) do
			self.SkillBar:ToggleActive(key, false);
		end
		for key, value in pairs(self.ManWrathCosts) do
			if self.ManWrathCosts[key] <= wrathTotal then
				self.SkillBar:ToggleActive(key, true);
			else
				self.SkillBar:ToggleActive(key, false);
			end
		end
	elseif self.form == "Bear-form" then
		for key, value in pairs(self.ManWrathCosts) do
			self.SkillBar:ToggleActive(key, false);
		end
		for key, value in pairs(self.BearWrathCosts) do
			if self.BearWrathCosts[key] <= wrathTotal then
				self.SkillBar:ToggleActive(key, true);
			else
				self.SkillBar:ToggleActive(key, false);
			end
		end
	else
		
	end
end

function BeorningAuras:FormManagement(form)
	self.form = form;
	self:SkillManagement(playerAttributes:GetWrath());
end

function BeorningAuras:ConfigureBars()
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
		self.BuffsBar:AddEffect(key, Effect(self.BuffsBar, 32, value, 0));
	end

	self.colors = {
        [1] = {40, Turbine.UI.Color(1, 0.12, 0.12)},
        [2] = {100, Turbine.UI.Color(1, 0.4, 0)},
    };

	self.Wrath = VitalBar(self, width, Settings["General"]["Resource"]["Height"], Settings["General"]["Resource"]["FontSize"], self.colors);
	self.Wrath:SetPosition(0, Settings["General"]["YPositions"]["Resource"]);
	self.Wrath:SetTotal(playerAttributes:GetWrath());

	if Settings["General"]["ShowSkills"] then
		for i = 1, skillList:GetCount(), 1 do
			local name = skillList:GetItem(i):GetSkillInfo():GetName();

			if Settings["General"]["Debug"] then
				Debug("Skill Name: " .. name .. " | Skill Icon: " .. skillList:GetItem(i):GetSkillInfo():GetIconImageID());
			end

			if self.Skills[name] then
				--Beorning has a bunch of mounted combat skills sharing the names of non-mount skills so we need to make sure we're not tracking the non-mounted version.
				--Now, I'm sure you're wondering "Why not just check the skilltype to determine if it's mounted'" which is a genius solution that fails because these skills are not logged as mount skills.
				if skillList:GetItem(i):GetSkillInfo():GetIconImageID() == self.mountedSkills[name] then
					--Do nothing
				else
					self.SkillBar:AddSkill(name, Skill(self.SkillBar, self.RowInfo[self.Skills[name][3]], self.Skills[name][1], self.Skills[name][4] , self.Skills[name][5]), self.Skills[name][2], self.Skills[name][3] );
				end
				
			end
		end
	end

	-- Work out what form we started in
    for i = 1, playerEffects:GetCount(), 1 do
        local name = playerEffects:Get(i):GetName()

        if name == "Man-form" or name == "Bear-form" or name == "Wanderlust" then
			self:FormManagement(name);
		end
    end
end

function BeorningAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		self.EffectIDs[effectName] = effect:GetID();

		if Settings["General"]["Debug"] then
			Debug("Effect added: " .. effectName .. " | Effect Icon: " .. effect:GetIcon());
		end

		if effectName == "Man-form" or effectName == "Bear-form" or effectName == "Wanderlust" then
			self:FormManagement(effectName);
		end

		if effectName == "Counter" then
			self.EffectIDs[effectName] = effect:GetID();
			self.SkillBar:ToggleActive("Counterattack", true);
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

			if effectName == "Relentless Maul" and effect:GetID() == self.EffectIDs[effectName] and playerRole == 2 then
				self.SkillBar:TriggerCooldown("Relentless Maul", 30);
			end

			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end

			if effectName == "Counter" and effect:GetID() == self.EffectIDs[effectName] then
				self.SkillBar:ToggleActive("Counterattack", false);
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

		if self.Skills[name] and item:GetSkillInfo():GetIconImageID() ~= self.mountedSkills[name] then
			self.SkillsTable[name] = item
			table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
				self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
			end));
		end
	end

	self.WrathCallback = AddCallback(playerAttributes, "WrathChanged", function(sender, args)
		self:WrathManagement(playerAttributes:GetWrath());
	end);
end

function BeorningAuras:RemoveCallbacks()
	RemoveCallback(playerEffects, "EffectAdded", self.effectAddedCallback);
	RemoveCallback(playerEffects, "EffectRemoved", self.effectRemovedCallback);
	RemoveCallback(playerAttributes, "WrathChanged", self.WrathCallback);
	for key, value in pairs(self.Callbacks) do
        for _, callback in pairs(value) do
            RemoveCallback(self.SkillsTable[key], "ResetTimeChanged", callback);
        end
    end
	self.ProcBar:Unload();
	self.SkillBar:Unload();
	self.Wrath:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function BeorningAuras:Unload()
	self:RemoveCallbacks();
end

function BeorningAuras:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};

	Settings["General"]["Position"] = Data;
end

function BeorningAuras:Reload()
	skillList = player:GetTrainedSkills();
	self:RemoveCallbacks();
	self:ConfigureBars();
	self:ConfigureCallbacks();
end