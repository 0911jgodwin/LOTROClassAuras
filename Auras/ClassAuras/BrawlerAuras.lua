import "ExoPlugins.Auras.AuraTools";
_G.BrawlerAuras = class(Turbine.UI.Window)
function BrawlerAuras:Constructor(parent, x, y)
    Turbine.UI.Window.Constructor(self)
    self:SetParent(parent);
    self:SetPosition(x, y);

    --Due to the design of the bars, keep the width of this window as a multiple of 6 to avoid weird alignment issues.
    self:SetSize(312, 150);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	width = self:GetWidth();

	self.SkillsTable = {};
	self.Callbacks = {};
	self.EffectIDs = {};

    self.ProcBar=EffectBar(self, width, 50, Turbine.UI.ContentAlignment.MiddleCenter);
	self.ProcBar:SetPosition(0, 0);

	self.colours = {
    [0] = Turbine.UI.Color(1.00, 0.96, 0.41),
	[1] = Turbine.UI.Color(0.97, 0.87, 0.39),
	[2] = Turbine.UI.Color(0.95, 0.77, 0.37),
	[3] = Turbine.UI.Color(0.92, 0.68, 0.35),
	[4] = Turbine.UI.Color(0.90, 0.59, 0.33),
	[5] = Turbine.UI.Color(0.87, 0.49, 0.31),
	[6] = Turbine.UI.Color(0.85, 0.40, 0.29),
	[7] = Turbine.UI.Color(0.82, 0.31, 0.27),
    [8] = Turbine.UI.Color(0.80, 0.21, 0.25),
    [9] = Turbine.UI.Color(0.77, 0.12, 0.23),
    };

	self.test = ResourceBar(self, width, 24, 9, self.colours);
	self.test:SetPosition(0, 35);
	self.test:SetZOrder(101);

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
		--["Feint"] = {1092693208, 4, 0},
		--["Get Serious"] = {1092628691, 5, 0},
	};

	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	self.Skills = {
		["Low Strike"] = {1092595470, 1, 1, false, true},
		["Sinister Cross"] = {1092595471, 2, 1, false, true},
		["Dextrous Hook"] = {1092595472, 3, 1, false, true},
		["Shattering Fist"] = {1092598120, 4, 1, false, true},
		["Backhand Clout"] = {1092598117, 5, 1, false, true},
		["Strike Towards the Sky"] = {1092686889, 6, 1, false, true},
		["Hurl Object"] = {1092687520, 7, 1, false, true},
		["Fulgurant Strike"] = {1091509864, 8, 1, false, true},
		
		["Quick Feint"] = {1092598114, 1, 2, false, true},
		["First Strike"] = {1091805264, 2, 2, false, true},
		["Overhand Smash"] = {1092598116, 3, 2, false, true},
		["Pummel"] = {1092598112, 4, 2, false, true},
		["Knee Strike"] = {1092598108 , 5, 2, false, true},
		["Helm-crusher"] = {1092685337, 6, 2, false, true},
		["Helm's Hammer"] = {1092598113, 7, 2, false, true},
		["Mighty Upheaval"] = {1092598109, 8, 2, false, true},
		["Fist of the Valar"] = {1092695530, 9, 2, false, true},
		["Get Serious"] = {1092628691, 10, 2, false, true},
		
		["Follow Me!"] = {1092686890, 1, 3, false, false},
		["Strike as One!"] = {1091831431, 2, 3, false, false},
		["Joy of Battle - Damage"] = {1091463400, 3, 3, false, false},
		["Battle Fury"] = {1092638683, 4, 3, false, false},
		["Share Innate Strength: Quickness"] = {1092687522, 5, 3, false, false},
		["Share Innate Strength: Heavy"] = {1092687523, 6, 3, false, false},
		["Share Innate Strength: Balance"] = {1092687524, 7, 3, false, false},
		["One for All"] = {1091805278, 8, 3, false, false},
		["Weather Blows"] = {1090541178, 9, 3, false, false},
	};

	--This table basically just holds the icon size information for each row.
	--If you want to make a particular row of quickslots large just adjust the value for the given row index
	self.RowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 38,
	};
	self.SkillBar = SkillBar(self, width, 200, self.RowInfo, 3, Turbine.Turbine.UI.ContentAlignment.MiddleCenter);
	self.SkillBar:SetPosition(0, 51);

	for key, value in pairs(self.ProcTable) do
		self.ProcBar:AddEffect(key, Effect(self.ProcBar, 32, value[1], value[3]), value[2]);
	end

	for i = 1, skillList:GetCount(), 1 do
        local name = skillList:GetItem(i):GetSkillInfo():GetName();

		if self.Skills[name] then
			self.SkillBar:AddSkill(name, Skill(self.SkillBar, self.RowInfo[self.Skills[name][3]], self.Skills[name][1], self.Skills[name][4] , self.Skills[name][5]), self.Skills[name][2], self.Skills[name][3] );
		end
	end

	--self.ProcBar:AddEffect("Shattering Fist", Effect(self.ProcBar, 32, 1091940901, 1), 0);

	self.test:SetTotal(1);
	self.lastTier = "Battle Flow 1";

	self.resetTime = nil;

    self:ConfigureCallbacks();
    self.DragBar = Deusdictum.UI.DragBar( self, "Brawler Auras" );
end

function BrawlerAuras:ConfigureCallbacks() 
	self.effectAddedCallback = AddCallback(playerEffects, "EffectAdded", function(sender, args)
		local effect = playerEffects:Get(args.Index);
		local effectName = effect:GetName();

		if self.BattleFlow[effectName] ~= nil then
			self.lastTier = effectName;
			self.test:SetTotal(self.BattleFlow[effectName]);
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
		local ID = item:GetSkillInfo():GetIconImageID();
		Turbine.Shell.WriteLine(name .. " : " .. ID);


        self.Callbacks[name] = {}

		if self.Skills[name] then
			self.SkillsTable[name] = item
            table.insert(self.Callbacks[name], AddCallback(item, "ResetTimeChanged", function(sender, args) 
                self.SkillBar:TriggerCooldown(name, item:GetResetTime() - Turbine.Engine.GetGameTime(), item:GetCooldown())
            end));
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
end

function BrawlerAuras:Unload()
	self:RemoveCallbacks();
	SaveData = {
		["aurasLeft"] = self:GetLeft(),
		["aurasTop"] = self:GetTop(),
	};
	Turbine.PluginData.Save(Turbine.DataScope.Character, "AuraSettings", SaveData);
end