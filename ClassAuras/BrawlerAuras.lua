import "Deusdictum.UI";
import "ExoPlugins.ClassAuras.BuffBar";
import "ExoPlugins.ClassAuras.Skill";
import "ExoPlugins.ClassAuras.SkillBar";
import "ExoPlugins.ClassAuras.ResourceBar";
BrawlerAuras = class(Turbine.UI.Window)
function BrawlerAuras:Constructor(parent)
    Turbine.UI.Window.Constructor(self)
    self:SetParent(parent);
    self:SetPosition(200, 200);

    --Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 150);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();

	self.SkillsTable = {};
	self.Callbacks = {};

    self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);

	self.test = ResourceBar(self, width, 24, 9);
	self.test:SetPosition(0, 35);

	self.Endurance = {
		["Endurance 1"] = 1,
		["Endurance 2"] = 2,
		["Endurance 3"] = 3,
		["Endurance 4"] = 4,
		["Endurance 5"] = 5,
		["Endurance 6"] = 6,
		["Endurance 7"] = 7,
		["Endurance 8"] = 8,
		["Endurance 9"] = 9,
	}

	self.ProcTable = {
		["Innate Strength: Precision - Tier 1"] = {1092693258, 1, 1},
		["Innate Strength: Precision - Tier 2"] = {1092693258, 1, 2},
		["Innate Strength: Precision - Tier 3"] = {1092693258, 1, 3},
		["Innate Strength: Precision - Tier 4"] = {1092693258, 1, 4},
		["Innate Strength: Raw Power - Tier 1"] = {1092693259, 2, 1},
		["Innate Strength: Raw Power - Tier 2"] = {1092693259, 2, 2},
		["Innate Strength: Raw Power - Tier 3"] = {1092693259, 2, 3},
		["Innate Strength: Raw Power - Tier 4"] = {1092693259, 2, 4},
		["Innate Strength: Finesse - Tier 1"] = {1090539704, 3, 1},
		["Innate Strength: Finesse - Tier 2"] = {1090539704, 3, 2},
		["Innate Strength: Finesse - Tier 3"] = {1090539704, 3, 3},
		["Innate Strength: Finesse - Tier 4"] = {1090539704, 3, 4},
		["Feint"] = {1092693208, 4, 0},
		["Get Serious"] = {1092628691, 5, 0},
	};

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	--self.ProcBar:AddEffect("Shattering Fist", Effect(self.ProcBar, 32, 1091940901, 1), 0);

	self.test:SetTotal(1);
	self.lastTier = "Endurance 1";

	self.EffectIDs = {};

    self:ConfigureCallbacks();
    self.DragBar = Deusdictum.UI.DragBar( self, "Brawler Auras" );
end

function BrawlerAuras:ConfigureCallbacks() 
	AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		if self.Endurance[effectName] ~= nil then
			self.lastTier = effectName;
			self.test:SetTotal(self.Endurance[effectName]);
		end

		if self.ProcTable[effectName] then
			self.EffectIDs[effectName] = effect:GetID();
			self.ProcBar:SetActive(effectName, effect:GetDuration());
		end
	end);

	AddCallback(playerEffects, "EffectRemoved", function(sender, args)
		local effect = args.Effect;
		if effect ~= nil then 
			local effectName = effect:GetName();

			if effectName == self.lastTier then
				self.test:SetTotal(0);
			end
			if self.ProcTable[effectName] and effect:GetID() == self.EffectIDs[effectName] then
				self.ProcBar:SetInactive(effectName);
			end
		end
	end);

	for i = 1, skillList:GetCount(), 1 do
        local item = skillList:GetItem(i);
        local name = item:GetSkillInfo():GetName();

        self.Callbacks[name] = {}

    end
end

function BrawlerAuras:DragEnd()
	Turbine.Shell.WriteLine("Drag event ended");
end