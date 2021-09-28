function ConfigureDefaultSettings()
	local settings = {};
	settings["General"] = {
		["Width"] = 312,
		["Position"] = {200, 200},
		["Debug"] = false,
		["ShowSkills"] = true,
	};
	if playerClass == Turbine.Gameplay.Class.Beorning then

	elseif playerClass == Turbine.Gameplay.Class.Brawler then

	elseif playerClass == Turbine.Gameplay.Class.Burglar then

	elseif playerClass == Turbine.Gameplay.Class.Captain then
		settings["Class"] = ConfigureCaptainSettings();
	elseif playerClass == Turbine.Gameplay.Class.Champion then

	elseif playerClass == Turbine.Gameplay.Class.Guardian then

	elseif playerClass == Turbine.Gameplay.Class.Hunter then

	elseif playerClass == Turbine.Gameplay.Class.LoreMaster then

	elseif playerClass == Turbine.Gameplay.Class.Minstrel then

	elseif playerClass == Turbine.Gameplay.Class.RuneKeeper then

	elseif playerClass == Turbine.Gameplay.Class.Warden then

	end
	
	return settings;
end

function ConfigureCaptainSettings()
	
	--Shared procs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	local SharedProcTable = {
		["Gallant Display Tier 1"] = {1091829784, 2, 1},
        ["Gallant Display Tier 2"] = {1091829784, 2, 2},
        ["Gallant Display Tier 3"] = {1091829784, 2, 3},
		["Enemy Defeat Response"] = {1090541069, 3, 0},
	};

	--Blue-only procs
	local BlueProcs = CopyTable(SharedProcTable);
	BlueProcs["Inspiriting Presence"] = {1091840414, 1, 0};
	BlueProcs["Valour"] = {1091916299, 4, 1};
	BlueProcs["Valour - Tier 1"] = {1091916299, 4, 2};
    BlueProcs["Valour - Tier 2"] = {1091916299, 4, 3};
    BlueProcs["Valour - Tier 3"] = {1091916299, 4, 4};
    BlueProcs["Valour - Tier 4"] = {1091916299, 4, 5};

	--Red-only procs
	local RedProcs = CopyTable(SharedProcTable);
	RedProcs["Cutting Edge"] = {1090553775, 5, 0};
	RedProcs["Master of War"] = {1091831459, 7, 0};

	--Yellow-only procs
	local YellowProcs = CopyTable(SharedProcTable);


	--This table basically just holds the icon size information for each row.
	--If you want to make a particular row of quickslots large just adjust the value for the given row index
	local SharedRowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 38,
	};

	--Blue row-info settings
	local BlueRowInfo = CopyTable(SharedRowInfo);
	--Red row-info settings
	local RedRowInfo = CopyTable(SharedRowInfo);
	--Yellow row-info settings
	local YellowRowInfo = CopyTable(SharedRowInfo);


	--Shared Skill List
	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	local SharedSkills = {
		["Battle-shout"] = {1090541075, 1, 1, false, true},
		["Improved Sure Strike"] = {1091659757, 2, 1, false, true},
		["Grave Wound"] = {1091659758, 3, 1, false, true},
		["Gallant Display"] = {1091829784, 6, 1, false, true},
		["Kick"] = {1091037684, 7, 1, false, true},
		["Words of Courage"] = {1090553779, 8, 1, false, true},

		["Devastating Blow"] = {1090541118, 1, 2, true, true},
        ["Pressing Attack"] = {1090553778, 2, 2, true, true},
        ["Improved Cutting Attack"] = {1091659767, 3, 2, false, true},
        ["Improved Blade of Elendil"] = {1091155262, 4, 2, true, true},
        ["Cleanse Corruption"] = {1091478590, 5, 2, false, true},
        ["Rallying Cry"] = {1090541065, 6, 2, false, true},
        ["Routing Cry"] = {1090541073, 7, 2, false, true},
        ["Muster Courage"] = {1090541084, 8, 2, false, true},
		
        ["Standard of Honour"] = {1091829788, 2, 3, false, false},
		["Standard of Valour"] = {1091829786, 2, 3, false, false},
		["Standard of War"] = {1091829787, 2, 3, false, false},
        ["Blade-brother's Call"] = {1091840431, 4, 3, false, false},
        ["Make Haste"] = {1090533151, 5, 3, false, false},
        ["Time of Need"] = {1091037688, 6, 3, false, false},
        ["Cry Vengeance"] = {1091787648, 7, 3, false, false},
        ["Fighting Withdrawal"] = {1091037686, 8, 3, false, false},
        
	};

	--Blue-only skils
	local BlueSkills = CopyTable(SharedSkills);
	BlueSkills["Valiant Strike"] = {1091463400, 4, 1, false, true};
	BlueSkills["Inspire (Shield-brother)"] = {1091659761, 5, 1, false, true};
	BlueSkills["To Arms (Shield-brother)"] = {1091659766, 3, 3, false, false};
	BlueSkills["Song-brother's Call"] = {1091831453, 4, 3, false, false};
	BlueSkills["Reform the Lines!"] = {1091829785, 1, 3, false, false};

	--Red-only skils
	local RedSkills = CopyTable(SharedSkills);
	RedSkills["Shadow's Lament"] = {1091476094, 4, 1, false, true};
	RedSkills["Oathbreaker's Shame"] = {1090533154, 12, 3, false, false};
	RedSkills["Inspire (Shield-brother)"] = {1091659762, 5, 1, false, true};
	RedSkills["To Arms (Shield-brother)"] = {1091037682, 3, 3, false, false};
	RedSkills["Blade-brother's Call"] = {1091840431, 4, 3, false, false};

	--Yellow-only skils
	local YellowSkills = CopyTable(SharedSkills);
	YellowSkills["Threatening Shout"] = {1091831472, 4, 1, false, true};
	YellowSkills["Elendil's Roar"] = {1090541120, 9, 2, false, true};
	YellowSkills["In Harm's Way"] = {1091926677, 11, 3, false, false};
	YellowSkills["Last Stand"] = {1090533270, 9, 3, false, false};
	YellowSkills["Shield of the Dúnedain"] = {1091926678, 10, 3, false, false};
	YellowSkills["Inspire (Shield-brother)"] = {1091037681, 5, 1, false, true};
	YellowSkills["To Arms (Shield-brother)"] = {1091659765, 3, 3, false, false};
	YellowSkills["Shield-brother's Call"] = {1091831458, 4, 3, false, false};


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end

function ConfigureChampionSettings()
	
	--Shared procs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	local SharedProcTable = {
		["Improved Wild Attack"] = {1090553751, 1, 0},
		["Emboldened Blades 1"] = {1090539704, 2, 1},
		["Emboldened Blades 2"] = {1090539704, 2, 2},
		["Emboldened Blades 3"] = {1090539704, 2, 3},
		["Emboldened Blades 4"] = {1090539704, 2, 4},
		["Emboldened Blades 5"] = {1090539704, 2, 5},
		["Champion's Advantage"] = {1091830092, 2, 0},
	};

	--Blue-only procs
	local BlueProcs = CopyTable(SharedProcTable);
	BlueProcs["Inspiriting Presence"] = {1091840414, 1, 0};
	BlueProcs["Valour"] = {1091916299, 4, 1};
	BlueProcs["Valour - Tier 1"] = {1091916299, 4, 2};
    BlueProcs["Valour - Tier 2"] = {1091916299, 4, 3};
    BlueProcs["Valour - Tier 3"] = {1091916299, 4, 4};
    BlueProcs["Valour - Tier 4"] = {1091916299, 4, 5};

	--Red-only procs
	local RedProcs = CopyTable(SharedProcTable);
	RedProcs["Cutting Edge"] = {1090553775, 5, 0};
	RedProcs["Master of War"] = {1091831459, 7, 0};

	--Yellow-only procs
	local YellowProcs = CopyTable(SharedProcTable);


	--This table basically just holds the icon size information for each row.
	--If you want to make a particular row of quickslots large just adjust the value for the given row index
	local SharedRowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 38,
	};

	--Blue row-info settings
	local BlueRowInfo = CopyTable(SharedRowInfo);
	--Red row-info settings
	local RedRowInfo = CopyTable(SharedRowInfo);
	--Yellow row-info settings
	local YellowRowInfo = CopyTable(SharedRowInfo);


	--Shared Skill List
	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	local SharedSkills = {
		["Rend"] = {1091459631, 1, 1, false, true},
		["Devastating Strike"] = {1091804923, 1, 1, false, true},
		["Wild Attack"] = {1090553751, 2, 1, false, true},
		["Swift Strike"] = {1090541125, 3, 1, false, true},
		["Blade Wall"] = {1090553752, 4, 1, false, true},
		["Brutal Strikes"] = {1090553754, 5, 1, true, true},
		["Feral Strikes"] = {1091515785, 6, 1, true, true},
		["Clobber"] = {1090553763, 7, 1, true, true},
		["Battle Frenzy"] = {1091804924, 8, 1, false, true},

		["Remorseless Strike"] = {1090553759, 1, 2, true, true},
		["Fury of Blades"] = {1091830071, 1, 2, true, true},
		["Ferocious Strikes"] = {1091804902, 2, 2, true, true},
		["Blade Storm"] = {1090553756, 3, 2, true, true},
		["Raging Blade"] = {1091804939, 4, 2, true, true},
		["Born For Combat"] = {1091830102, 5, 2, true, true},
		["Champion's Challenge"] = {1090553760, 6, 2, false, true},
		["Horn of Gondor"] = {1090553764, 7, 2, true, true},
		["Horn of Champions"] = {1091744499, 8 , 2, false, true},
		["Hamstring"] = {1090553765, 9, 2, true, true},
		["Fear Nothing!"] = {1091591835, 10, 2, false, true},

		["Great Cleave"] = {1091804930, 1, 3, false, false},
		["Controlled Burn"] = {1091804918, 2, 3, false, false},
		["Fight On"] = {1090539699, 3, 3, false, false},
		["Champion's Duel"] = {1091804891, 4, 3, false, false},
		["Blood Rage"] = {1091459632, 5, 3, false, false},
		["True Heroics"] = {1091585417, 6, 3, false, false},
		["Sprint"] = {1090553762, 7, 3, false, false},
	};

	--Blue-only skils
	local BlueSkills = CopyTable(SharedSkills);
	BlueSkills["Valiant Strike"] = {1091463400, 4, 1, false, true};
	BlueSkills["Inspire (Shield-brother)"] = {1091659761, 5, 1, false, true};
	BlueSkills["To Arms (Shield-brother)"] = {1091659766, 3, 3, false, false};
	BlueSkills["Song-brother's Call"] = {1091831453, 4, 3, false, false};
	BlueSkills["Reform the Lines!"] = {1091829785, 1, 3, false, false};

	--Red-only skils
	local RedSkills = CopyTable(SharedSkills);
	RedSkills["Shadow's Lament"] = {1091476094, 4, 1, false, true};
	RedSkills["Oathbreaker's Shame"] = {1090533154, 12, 3, false, false};
	RedSkills["Inspire (Shield-brother)"] = {1091659762, 5, 1, false, true};
	RedSkills["To Arms (Shield-brother)"] = {1091037682, 3, 3, false, false};
	RedSkills["Blade-brother's Call"] = {1091840431, 4, 3, false, false};

	--Yellow-only skils
	local YellowSkills = CopyTable(SharedSkills);
	YellowSkills["Threatening Shout"] = {1091831472, 4, 1, false, true};
	YellowSkills["Elendil's Roar"] = {1090541120, 9, 2, false, true};
	YellowSkills["In Harm's Way"] = {1091926677, 11, 3, false, false};
	YellowSkills["Last Stand"] = {1090533270, 9, 3, false, false};
	YellowSkills["Shield of the Dúnedain"] = {1091926678, 10, 3, false, false};
	YellowSkills["Inspire (Shield-brother)"] = {1091037681, 5, 1, false, true};
	YellowSkills["To Arms (Shield-brother)"] = {1091659765, 3, 3, false, false};
	YellowSkills["Shield-brother's Call"] = {1091831458, 4, 3, false, false};


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end