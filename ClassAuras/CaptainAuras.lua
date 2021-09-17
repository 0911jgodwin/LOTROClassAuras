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

	--This table basically just holds the icon size information for each row.
	--If you want to make a particular row of quickslots large just adjust the value for the given row index
	self.RowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 38,
	};

	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	self.Skills = {
		["Battle-shout"] = {1090541075, 1, 1, false, true},
		["Improved Sure Strike"] = {1091659757, 2, 1, false, true},
		["Grave Wound"] = {1091659758, 3, 1, false, true},
		["Valiant Strike"] = {1091463400, 4, 1, false, true},
		["Shadow's Lament"] = {1091476094, 4, 1, false, true},
        ["Threatening Shout"] = {1091831472, 4, 1, false, true},
		["Inspire (Shield-brother)"] = {1091037681, 5, 1, false, true},
		["Gallant Display"] = {1091829784, 6, 1, false, true},
		["Kick"] = {1091037684, 7, 1, false, true},
		["Words of Courage"] = {1090553779, 8, 1, false, true},

		["Devastating Blow"] = {1090541118, 1, 2, false, true},
        ["Pressing Attack"] = {1090553778, 2, 2, false, true},
        ["Improved Cutting Attack"] = {1091659767, 3, 2, false, true},
        ["Improved Blade of Elendil"] = {1091155262, 4, 2, false, true},
        ["Cleanse Corruption"] = {1091478590, 5, 2, false, true},
        ["Rallying Cry"] = {1090541065, 6, 2, false, true},
        ["Routing Cry"] = {1090541073, 7, 2, false, true},
        ["Muster Courage"] = {1090541084, 8, 2, false, true},
		["Elendil's Roar"] = {1090541120, 9, 2, false, true},

		["Reform the Lines!"] = {1091829785, 1, 3, false, false},
        ["Standard of Honour"] = {1091829788, 2, 3, false, false},
		["Standard of Valour"] = {1091829786, 2, 3, false, false},
		["Standard of War"] = {1091829787, 2, 3, false, false},
        ["To Arms (Shield-brother)"] = {1091659765, 3, 3, false, false},
        ["Song-brother's Call"] = {1091831453, 4, 3, false, false},
		["Shield-brother's Call"] = {1091831458, 4, 3, false, false},
        ["Blade-brother's Call"] = {1091840431, 4, 3, false, false},
        ["Make Haste"] = {1090533151, 5, 3, false, false},
        ["Time of Need"] = {1091037688, 6, 3, false, false},
        ["Cry Vengeance"] = {1091787648, 7, 3, false, false},
        ["Fighting Withdrawal"] = {1091037686, 8, 3, false, false},
		["Last Stand"] = {1090533270, 9, 3, false, false},
        ["Shield of the Dúnedain"] = {1091926678, 10, 3, false, false},
        ["In Harm's Way"] = {1091926677, 11, 3, false, false},
        ["Oathbreaker's Shame"] = {1090533154, 12, 3, false, false},
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
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, 3, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, 55);

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
		self.Skills["To Arms (Shield-brother)"][1] = 1091659766;
		self.Skills["Inspire (Shield-brother)"][1] = 1091659761;
	elseif self.role == 2 then
		self.BarTable["On Guard"] = nil;
		self.BarTable["Focus"] = nil;
		self.BarTable["Relentless Attack"] = self.StanceBar;
		self.Skills["To Arms (Shield-brother)"][1] = 1091037682;
		self.Skills["Inspire (Shield-brother)"][1] = 1091659762;
	elseif self.role == 3 then
		self.BarTable["Focus"] = nil;
		self.BarTable["Relentless Attack"] = nil;
		self.BarTable["On Guard"] = self.StanceBar;
		self.Skills["To Arms (Shield-brother)"][1] = 1091659765;
		self.Skills["Inspire (Shield-brother)"][1] = 1091037681;
	end

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	for i = 1, skillList:GetCount(), 1 do
        local name = skillList:GetItem(i):GetSkillInfo():GetName();

		if self.Skills[name] then
			self.SkillBar:AddSkill(name, Skill(self.SkillBar, self.RowInfo[self.Skills[name][3]], self.Skills[name][1], self.Skills[name][4] , self.Skills[name][5]), self.Skills[name][2], self.Skills[name][3] );
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

	self.ProcBar:Unload();
	self.SkillBar:Unload();
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