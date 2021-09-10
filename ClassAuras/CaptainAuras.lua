import "Deusdictum.UI";
import "ExoPlugins.ClassAuras.BuffBar";
import "ExoPlugins.ClassAuras.Skill";
import "ExoPlugins.ClassAuras.SkillBar";
CaptainAuras = class(Turbine.UI.Window)
function CaptainAuras:Constructor(parent)
    Turbine.UI.Window.Constructor(self)

	self:SetParent(parent);
    self:SetPosition(200, 200);

	--Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 300);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();
    self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);

	self.SkillsTable = {};
	self.Callbacks = {};

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
	};

	self.PrimarySkills = {
		["Battle-shout"] = {"Battle_Shout", 38, 1},
		["Improved Sure Strike"] = {"Improved_Sure_Strike", 38, 2},
		["Grave Wound"] = {"Grave_Wound", 38, 3},
		["Valiant Strike"] = {"Valiant_Strike", 38, 4},
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
	};

	self.CooldownSkills = {
		["Reform the Lines!"] = {"Reform_the_Lines!", 32, 1},
        ["Standard of Honour"] = {"Standard_of_Honour", 32, 2},
        ["To Arms (Shield-brother)"] = {"To_Arms_(Song-brother)", 32, 3},
        ["Song-brother's Call"] = {"Song-brother's_Call", 32, 4},
        ["Make Haste"] = {"Make_Haste", 32, 5},
        ["Time of Need"] = {"Time_of_Need", 32, 6},
        ["Cry Vengeance"] = {"Cry_of_Vengeance", 32, 7},
        ["Fighting Withdrawal"] = {"Fighting_Withdrawal", 32, 8},
	};

	self.PrimarySkillBar = SkillBar(self, width, 40, 38, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.PrimarySkillBar:SetPosition(0, 53+2);
	self.SecondarySkillBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, true);
	self.SecondarySkillBar:SetPosition(0, 85+2);
	self.CooldownBar = SkillBar(self, width, 40, 32, Turbine.Turbine.UI.ContentAlignment.MiddleCenter, false);
	self.CooldownBar:SetPosition(0, 113+2);

	--[[
	self.skill = Skill(self, 38, "Battle-shout", "Battle_Shout");
	self.skill:SetPosition(0+2, 53);
	self.skill = Skill(self, 38, "Improved Sure Strike", "Improved_Sure_Strike");
	self.skill:SetPosition(38+2, 53);
	self.skill = Skill(self, 38, "Grave Wound", "Grave_Wound");
	self.skill:SetPosition(76+2, 53);
	self.skill = Skill(self, 38, "Valiant Strike", "Valiant_Strike");
	self.skill:SetPosition(114+2, 53);
	self.skill = Skill(self, 38, "Inspire (Shield-brother)", "Inspire_(Song-brother)");
	self.skill:SetPosition(152+2, 53);
	self.skill = Skill(self, 38, "Gallant Display", "Gallant_Display");
	self.skill:SetPosition(190+2, 53);
	self.skill = Skill(self, 38, "Kick", "Kick");
	self.skill:SetPosition(228+2, 53);
	self.skill = Skill(self, 38, "Words of Courage", "Words_of_Courage");
	self.skill:SetPosition(266+2, 53);]]--

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	for key, value in pairs(self.PrimarySkills) do
		self.PrimarySkillBar:AddSkill(key, Skill(self.PrimarySkillBar, value[2], key, value[1]), value[3], true);
	end

	for key, value in pairs(self.SecondarySkills) do
		self.SecondarySkillBar:AddSkill(key, Skill(self.SecondarySkillBar, value[2], key, value[1]), value[3], true);
	end

	for key, value in pairs(self.CooldownSkills) do
		self.CooldownBar:AddSkill(key, Skill(self.CooldownBar, value[2], key, value[1]), value[3], false);
	end

	self.RallyBar=BuffBar(self, math.floor(width/3), 10, Turbine.UI.Color( 1.00, 0.96, 0.41 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.PenetratingBar=BuffBar(self, math.floor(width/3), 10, Turbine.UI.Color( 1.00, 0.96, 0.41 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.FocusBar=BuffBar(self, math.floor(width/3), 10, Turbine.UI.Color( 0.23, 0.77, 0.12 ), Turbine.UI.ContentAlignment.MiddleCenter);
	self.ReadiedBar=BuffBar(self, math.floor(width/2), 10, Turbine.UI.Color(0.23, 0.12, 0.77), Turbine.UI.ContentAlignment.MiddleRight);
	self.HardenedBar=BuffBar(self, math.floor(width/2), 10, Turbine.UI.Color(0.77, 0.12, 0.23), Turbine.UI.ContentAlignment.MiddleLeft);

	--[[self.FocusBar:SetPosition(((width-6)/2)-((width-6)/6) + 1, 35);
	self.PenetratingBar:SetPosition(((width-6)/2)+((width-6)/6) + 1, 35);
	self.RallyBar:SetPosition(0, 35);
	self.ReadiedBar:SetPosition(0, 44+2);
	self.HardenedBar:SetPosition((width-6)/2 + 1, 44+2);]]--


	self.RallyBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 , 35);
	self.FocusBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 + math.floor(self.RallyBar:GetWidth()), 35);
	self.PenetratingBar:SetPosition(width/2 - math.floor(self.RallyBar:GetWidth()/2) * 3 + math.floor(self.RallyBar:GetWidth() * 2), 35);
	self.ReadiedBar:SetPosition(width/2 - self.ReadiedBar:GetWidth(), 44+2);
	self.HardenedBar:SetPosition(width/2, 44+2);

	self.BarTable = {
		["Focus"] = self.FocusBar,
		["Battle-hardened"] = self.HardenedBar,
		["Battle-readied"] = self.ReadiedBar,
		["Rousing Cry Damage Buff"] = self.RallyBar,
		["Penetrating Cry Attack Speed Buff"] = self.PenetratingBar,	
	};

	self.EffectIDs = {};

	self:ConfigureCallbacks();
	self.DragBar = Deusdictum.UI.DragBar( self, "Captain Auras" );
end

function CaptainAuras:ConfigureCallbacks() 
	AddCallback(playerEffects, "EffectAdded", function(sender, args)
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
	end);

	AddCallback(playerEffects, "EffectRemoved", function(sender, args)
		local effect = args.Effect;
		if effect ~= nil then 
			local effectName = effect:GetName();

			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end

			if self.BarTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.BarTable[effectName]:EndTimer();
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

function CaptainAuras:DragEnd()
	Turbine.Shell.WriteLine("Drag event ended");
end