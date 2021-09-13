import "Deusdictum.UI";
import "ExoPlugins.ClassAuras.BuffBar";
import "ExoPlugins.ClassAuras.Skill";
import "ExoPlugins.ClassAuras.SkillBar";
CaptainAuras = class(Turbine.UI.Window)
function CaptainAuras:Constructor(parent, x, y)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);
    self:SetPosition(x, y);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 200);
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
		["Gallant Display Tier 1"] = {1091829784, 2, 1},
        ["Gallant Display Tier 2"] = {1091829784, 2, 2},
        ["Gallant Display Tier 3"] = {1091829784, 2, 3},
		["Enemy Defeat Response"] = {1090541069, 3, 0},
		["Valour"] = {1091916299, 4, 1},
		["Valour - Tier 1"] = {1091916299, 4, 2},
        ["Valour - Tier 2"] = {1091916299, 4, 3},
        ["Valour - Tier 3"] = {1091916299, 4, 4},
        ["Valour - Tier 4"] = {1091916299, 4, 5},
		["Cutting Edge"] = {1090553775, 5, 0},
		["Master of War"] = {1091831459, 7, 0},
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
		["Improved Sure Strike"] = {"Improved_Sure_Strike", 38, 2},
		["Grave Wound"] = {"Grave_Wound", 38, 3},
		["Valiant Strike"] = {"Valiant_Strike", 38, 4},
		["Shadow's Lament"] = {"Shadow's_Lament", 38, 4},
        ["Threatening Shout"] = {"Threatening_Shout", 38, 4},
		["Inspire (Shield-brother)"] = {"Inspire_(Song-brother)", 38, 5},
		["Gallant Display"] = {"Gallant_Display", 38, 6},
		["Kick"] = {"Kick", 38, 7},
		["Words of Courage"] = {"Words_of_Courage", 38, 8},
	};

	self.SecondarySkills = {
		["Devastating Blow"] = {"Devastating_Blow", 32, 1},
        ["Pressing Attack"] = {"Pressing_Attack", 32, 2},
        ["Improved Cutting Attack"] = {"Improved_Cutting_Attack", 32, 3},
        ["Improved Blade of Elendil"] = {"Blade_of_Elendil", 32, 4},
        ["Cleanse Corruption"] = {"Cleanse_Corruption", 32, 5},
        ["Rallying Cry"] = {"Rallying_Cry", 32, 6},
        ["Routing Cry"] = {"Routing_Cry", 32, 7},
        ["Muster Courage"] = {"Muster_Courage", 32, 8},
		["Elendil's Roar"] = {"Elendil's_Roar", 32, 9},
	};

	self.CooldownSkills = {
		["Reform the Lines!"] = {"Reform_the_Lines!", 32, 1},
        ["Standard of Honour"] = {"Standard_of_Honour", 32, 2},
		["Standard of Valour"] = {"Standard_of_Valour", 32, 2},
		["Standard of War"] = {"Standard_of_War", 32, 2},
        ["To Arms (Shield-brother)"] = {"To_Arms_(Song-brother)", 32, 3},
        ["Song-brother's Call"] = {"Song-brother's_Call", 32, 4},
		["Shield-brother's Call"] = {"Shield-brother's_Call", 32, 4},
        ["Blade-brother's Call"] = {"Blade-brother's_Call", 32, 4},
        ["Make Haste"] = {"Make_Haste", 32, 5},
        ["Time of Need"] = {"Time_of_Need", 32, 6},
        ["Cry Vengeance"] = {"Cry_of_Vengeance", 32, 7},
        ["Fighting Withdrawal"] = {"Fighting_Withdrawal", 32, 8},
		["Last Stand"] = {"Last_Stand", 32, 9},
        ["Shield of the Dúnedain"] = {"Shield_of_the_Dunedain", 32, 10},
        ["In Harm's Way"] = {"In_Harm's_Way", 32, 11},
        ["Oathbreaker's Shame"] = {"Oathbreaker's_Shame", 32, 12},
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

	self.DragBar = Deusdictum.UI.DragBar( self, "Captain Auras" );
end

function CaptainAuras:ConfigureBars()
	self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);
	self.PrimarySkillBar = SkillBar(self, width, 40, 38, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.PrimarySkillBar:SetPosition(0, 53+2);
	self.SecondarySkillBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.SecondarySkillBar:SetPosition(0, 85+2);
	self.CooldownBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, false);
	self.CooldownBar:SetPosition(0, 113+2);

	self.RallyBar=BuffBar(self, math.floor(width/3), 10, Turbine.UI.Color( 1.00, 0.96, 0.41 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.PenetratingBar=BuffBar(self, math.floor(width/3), 10, Turbine.UI.Color( 1.00, 0.96, 0.41 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.StanceBar=BuffBar(self, math.floor(width/3), 10, Turbine.UI.Color( 0.23, 0.77, 0.12 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.ReadiedBar=BuffBar(self, math.floor(width/2), 10, Turbine.UI.Color(0.23, 0.12, 0.77), Turbine.UI.ContentAlignment.MiddleRight);
	self.HardenedBar=BuffBar(self, math.floor(width/2), 10, Turbine.UI.Color(0.77, 0.12, 0.23), Turbine.UI.ContentAlignment.MiddleLeft);


	self.RallyBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 , 35);
	self.StanceBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 + math.floor(self.RallyBar:GetWidth()), 35);
	self.PenetratingBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 + math.floor(self.RallyBar:GetWidth() * 2), 35);
	self.ReadiedBar:SetPosition(width/2 - self.ReadiedBar:GetWidth(), 44+2);
	self.HardenedBar:SetPosition(width/2, 44+2);

	self.BarTable = {
		["Battle-hardened"] = self.HardenedBar,
		["Battle-readied"] = self.ReadiedBar,
		["Rousing Cry Damage Buff"] = self.RallyBar,
		["Penetrating Cry Attack Speed Buff"] = self.PenetratingBar,	
	};

	if self.role == 1 then
		self.BarTable["Focus"] = self.StanceBar;
		self.BarTable["Relentless Attack"] = nil;
		self.BarTable["On Guard"] = nil;
		self.CooldownSkills["To Arms (Shield-brother)"] = {"To_Arms_(Song-brother)", 32, 3};
		self.PrimarySkills["Inspire (Shield-brother)"] = {"Inspire_(Song-brother)", 38, 5};
	elseif self.role == 2 then
		self.BarTable["On Guard"] = nil;
		self.BarTable["Focus"] = nil;
		self.BarTable["Relentless Attack"] = self.StanceBar;
		self.CooldownSkills["To Arms (Shield-brother)"] = {"To_Arms_(Blade-brother)", 32, 3};
		self.PrimarySkills["Inspire (Shield-brother)"] = {"Inspire_(Blade-brother)", 38, 5};
	elseif self.role == 3 then
		self.BarTable["Focus"] = nil;
		self.BarTable["Relentless Attack"] = nil;
		self.BarTable["On Guard"] = self.StanceBar;
		self.CooldownSkills["To Arms (Shield-brother)"] = {"To_Arms", 32, 3};
		self.PrimarySkills["Inspire (Shield-brother)"] = {"Inspire", 38, 5};
	end

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
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
end

function CaptainAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

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
			if self.PrimarySkills[self.SkillHighlights[effectName]] then
				self.PrimarySkillBar:ToggleHighlight(self.SkillHighlights[effectName], true);
			elseif self.SecondarySkills[self.SkillHighlights[effectName]] then
				self.SecondarySkillBar:ToggleHighlight(self.SkillHighlights[effectName], true);
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

			if self.BarTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BarTable[effectName]:EndTimer();
			end

			if self.SkillHighlights[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				if self.PrimarySkills[self.SkillHighlights[effectName]] then
					self.PrimarySkillBar:ToggleHighlight(self.SkillHighlights[effectName], false);
				elseif self.SecondarySkills[self.SkillHighlights[effectName]] then
					self.SecondarySkillBar:ToggleHighlight(self.SkillHighlights[effectName], false);
				end
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

	self.ProcBar:Unload();
	self.PrimarySkillBar:Unload();
	self.SecondarySkillBar:Unload();
	self.CooldownBar:Unload();
	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

	collectgarbage()
end

function CaptainAuras:GetRole()
	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();
		if name == "Valiant Strike" then
			return 1;
		elseif name == "Shadow's Lament" then
			return 2;
		elseif name == "Threatening Shout" then
			return 3;
		end
	end
	return 4;
end

function CaptainAuras:Unload()
	self:RemoveCallbacks();
	SaveData = {
		["aurasLeft"] = self:GetLeft(),
		["aurasTop"] = self:GetTop(),
	};
	Turbine.PluginData.Save(Turbine.DataScope.Character, "AuraSettings", SaveData)
end

function CaptainAuras:Reload()
	AddCallback(Updater, "Tick", self.ReloadHandler);
end