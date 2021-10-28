function ConfigureDefaultSettings()
	screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	local settings = {};
	settings["General"] = {
		["Width"] = 312,
		["Position"] = {((screenWidth/2)-156)/screenWidth, (screenHeight/1.6)/screenHeight},
		["Version"] = "V." .. plugin:GetVersion(),
		["Buffs"] = {
			["Position"] = {((screenWidth/2)-412)/screenWidth, (screenHeight/1.7)/screenHeight},
			["Width"] = 256,
		},
		["Debug"] = false,
		["ShowSkills"] = true,
	};
	if playerClass == Turbine.Gameplay.Class.Beorning then
		settings["Class"] = ConfigureBeorningSettings();
	elseif playerClass == Turbine.Gameplay.Class.Brawler then
		settings["Class"] = ConfigureBrawlerSettings();
	elseif playerClass == Turbine.Gameplay.Class.Burglar then

	elseif playerClass == Turbine.Gameplay.Class.Captain then
		settings["Class"] = ConfigureCaptainSettings();
	elseif playerClass == Turbine.Gameplay.Class.Champion then
		settings["Class"] = ConfigureChampionSettings();
	elseif playerClass == Turbine.Gameplay.Class.Guardian then
		settings["Class"] = ConfigureGuardianSettings();
	elseif playerClass == Turbine.Gameplay.Class.Hunter then
		settings["Class"] = ConfigureHunterSettings();
	elseif playerClass == Turbine.Gameplay.Class.LoreMaster then

	elseif playerClass == Turbine.Gameplay.Class.Minstrel then

	elseif playerClass == Turbine.Gameplay.Class.RuneKeeper then
		settings["Class"] = ConfigureRunekeeperSettings();
	elseif playerClass == Turbine.Gameplay.Class.Warden then

	end
	
	return settings;
end

function ConfigureBeorningSettings()

	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Ferocious Roar"] = 1091940918,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);
	BlueBuffs["Thickened Hide"] = 1091940987;


	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);
	RedBuffs["Call To Wild"] = 1091940988;

	--Yellow-only buffs
	local YellowBuffs = CopyTable(SharedBuffTable);
	
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}

	--Blue-only procs
	local BlueProcs = {
		["Guarded - Tier 1"] = {1091945024, 1, 1},
		["Guarded - Tier 2"] = {1091945020, 1, 2},
		["Guarded - Tier 3"] = {1091945022, 1, 3},
		["Guarded - Tier 4"] = {1091945035, 1, 4},
		["Guarded - Tier 5"] = {1091945040, 1, 5},
		["Recuperate"] = {1091940911, 2, 0},
	};

	--Red-only procs
	local RedProcs = {
		["Lumber"] = {1091941775, 1, 1};
	};

	--Yellow-only procs
	local YellowProcs = {
		["Aiding Strike - Tier 1"] = {1091945028, 1, 3},
		["Aiding Strike - Tier 2"] = {1091945017, 1, 3},
		["Aiding Strike - Tier 3"] = {1091945029, 1, 3},
		["Recuperate"] = {1091940911, 2, 0},
	};


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


	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.

	--Blue-only skils
	local BlueSkills = {
		["Slash"] = {1091940897, 1, 1, false, true},
		["Slam"] = {1091940917, 2, 1, true, true},
		["Biting Edge"] = {1091940900, 3, 1, true, true},
		["Guarded Attack"] = {1091940907, 4, 1, true, true},
		["Thrash - Tier 1"] = {1091940889, 5, 1, false, true},
		["Claw Swipe"] = {1091940902, 6, 1, true, true},
		["Recuperate"] = {1091940911, 7, 1, true, true},
		["Vicious Claws"] = {1091940919, 8, 1, false, true},

		["Nature's Vengeance"] = {1091940914, 1, 2, false, true},
		["Hearten"] = {1091940912, 2, 2, true, true},
		["Ferocious Roar"] = {1091940918, 3, 2, true, true},
		["Relentless Maul"] = {1091940908, 4, 2, true, true},
		["Thunderous Roar"] = {1091952766, 5, 2, true, true},
		["Vigilant Roar"] = {1091940895, 6, 2, true, true},
		["Rending Blow"] = {1091940891, 7, 2, true, true},
		["Bee Swarm"] = {1091940896, 8, 2, true, true},
		["Counterattack"] = {1091945045, 9, 2, true, true},

		["Thickened Hide"] = {1091940987, 1, 3, false, false},
		["Sacrifice"] = {1091940913, 2, 3, false, false},
		["Rush"] = {1091940899, 3, 3, false, false},
		["Shake Free"] = {1091940916, 5, 3, false, false},
		["Grisly Cry"] = {1091940898, 6, 3, false, false},
		["Counter"] = {1091940905, 7, 3, false, false},

	};

	--Red-only skils
	local RedSkills = {
		["Slash"] = {1091940897, 1, 1, false, true},
		["Slam"] = {1091940917, 2, 1, true, true},
		["Biting Edge"] = {1091940900, 3, 1, true, true},
		["Expose (Man)"] = {1091940901, 4, 1, false, true},
		["Thrash - Tier 1"] = {1091940889, 5, 1, false, true},
		["Bee Swarm"] = {1091940896, 6, 1, true, true},
		["Vigilant Roar"] = {1091940895, 7, 1, true, true},
		["Vicious Claws"] = {1091940919, 8, 1, false, true},

		["Nature's Vengeance"] = {1091940914, 1, 2, false, true},
		["Hearten"] = {1091940912, 2, 2, true, true},
		["Ferocious Roar"] = {1091940918, 3, 2, true, true},
		["Relentless Maul"] = {1091940908, 4, 2, true, true},
		["Bash"] = {1091940909, 5, 2, true, true},
		["Rending Blow"] = {1091940891, 6, 2, true, true},

		["Call To Wild"] = {1091940988, 1, 3, false, false},
		["Sacrifice"] = {1091940913, 2, 3, false, false},
		["Rush"] = {1091940899, 3, 3, false, false},
		["Shake Free"] = {1091940916, 5, 3, false, false},
		["Grisly Cry"] = {1091940898, 6, 3, false, false},
	};

	--Yellow-only skils
	local YellowSkills = {
		["Slash"] = {1091940897, 1, 1, false, true},
		["Slam"] = {1091940917, 2, 1, true, true},
		["Biting Edge"] = {1091940900, 3, 1, true, true},
		["Nature's Mend"] = {1091940921, 4, 1, true, true},
		["Thrash - Tier 1"] = {1091940889, 5, 1, false, true},
		["Encouraging Roar"] = {1091940904, 6, 1, true, true},
		["Rejuvenating Bellow"] = {1091940990, 7, 1, true, true},
		["Bee Swarm"] = {1091940896, 8, 1, true, true},

		["Nature's Vengeance"] = {1091940914, 1, 2, false, true},
		["Hearten"] = {1091940912, 2, 2, true, true},
		["Ferocious Roar"] = {1091940918, 3, 2, true, true},
		["Relentless Maul"] = {1091940908, 4, 2, true, true},
		["Bash"] = {1091940909, 5, 2, true, true},
		["Rending Blow"] = {1091940891, 6, 2, true, true},
		["Vigilant Roar"] = {1091940895, 7, 2, true, true},
		["Vicious Claws"] = {1091940919, 8, 2, false, true},

		["Nature's Bond"] = {1091940986, 1, 3, false, false},
		["Sacrifice"] = {1091940913, 2, 3, false, false},
		["Rush"] = {1091940899, 3, 3, false, false},
		["Shake Free"] = {1091940916, 5, 3, false, false},
		["Grisly Cry"] = {1091940898, 6, 3, false, false},
		["Overbearing"] = {1091952763, 7, 3, false, false},
	};


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		},
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		},
		["Buffs"] = RedBuffs,
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		},
		["Buffs"] = YellowBuffs,
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end

function ConfigureBrawlerSettings()

	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Get Serious"] = 1092628691,
		["Feint"] = 1092693208,
		["Weather Blows"] = 1090541178,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);
	BlueBuffs["Iron Will"] = 1092598111;
	BlueBuffs["Song-brother's Call"] = 1091831453;
	BlueBuffs["Plant Feet - Tier 1"] = 1091916300;
	BlueBuffs["Plant Feet - Tier 2"] = 1091916300;
	BlueBuffs["Plant Feet - Tier 3"] = 1091916300;
	BlueBuffs["Plant Feet - Tier 4"] = 1091916300;
	BlueBuffs["Plant Feet - Tier 5"] = 1091916300;
	BlueBuffs["Bracing Guard Active"] = 1092693316;

	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);
	RedBuffs["Joy of Battle - Damage"] = 1091463400;
	RedBuffs["Battle Fury"] = 1091941793;
	
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	--Blue-only procs
	local BlueProcs = {
		["DNT - Mettle Shield"] = {1090552382, 0, 0},
		["Innate Strength: Inner Resilience - Tier 1"] = {1092687523, 1, 1},
		["Innate Strength: Inner Resilience - Tier 2"] = {1092687523, 1, 2},
		["Innate Strength: Inner Resilience - Tier 3"] = {1092687523, 1, 3},
		["Innate Strength: Inner Resilience - Tier 4"] = {1092687523, 1, 4},
		["Innate Strength: Intimidating Presence - Tier 1"] = {1092687522, 2, 1},
		["Innate Strength: Intimidating Presence - Tier 2"] = {1092687522, 2, 2},
		["Innate Strength: Intimidating Presence - Tier 3"] = {1092687522, 2, 3},
		["Innate Strength: Intimidating Presence - Tier 4"] = {1092687522, 2, 4},
		["Innate Strength: Deflecting Technique - Tier 1"] = {1092687524, 3, 1},
		["Innate Strength: Deflecting Technique - Tier 2"] = {1092687524, 3, 2},
		["Innate Strength: Deflecting Technique - Tier 3"] = {1092687524, 3, 3},
		["Innate Strength: Deflecting Technique - Tier 4"] = {1092687524, 3, 4},
	};

	--Red-only procs
	local RedProcs = {
		["Innate Strength: Precision - Tier 1"] = {1092687523, 1, 1},
		["Innate Strength: Precision - Tier 2"] = {1092687523, 1, 2},
		["Innate Strength: Precision - Tier 3"] = {1092687523, 1, 3},
		["Innate Strength: Precision - Tier 4"] = {1092687523, 1, 4},
		["Innate Strength: Raw Power - Tier 1"] = {1092687522, 2, 1},
		["Innate Strength: Raw Power - Tier 2"] = {1092687522, 2, 2},
		["Innate Strength: Raw Power - Tier 3"] = {1092687522, 2, 3},
		["Innate Strength: Raw Power - Tier 4"] = {1092687522, 2, 4},
		["Innate Strength: Finesse - Tier 1"] = {1092687524, 3, 1},
		["Innate Strength: Finesse - Tier 2"] = {1092687524, 3, 2},
		["Innate Strength: Finesse - Tier 3"] = {1092687524, 3, 3},
		["Innate Strength: Finesse - Tier 4"] = {1092687524, 3, 4},
	};


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


	--Shared Skill List
	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	local SharedSkills = {
		["Low Strike"] = {1092595470, 1, 1, false, true},
		["Sinister Cross"] = {1092595471, 2, 1, false, true},
		["Dextrous Hook"] = {1092595472, 3, 1, false, true},

		["Knee Strike"] = {1092598108 , 5, 1, true, true},
		["Hurl Object"] = {1092687520, 6, 1, false, true},
		["Helm-crusher"] = {1092685337, 7, 1, true, true},
		["Fulgurant Strike"] = {1091509864, 8, 1, false, true},
		
		["Backhand Clout"] = {1092598117, 1, 2, true, true},
		["Strike Towards the Sky"] = {1092686889, 2, 2, true, true},
		["Quick Feint"] = {1092598114, 3, 2, false, true},		

		["Get Serious"] = {1092628691, 5, 2, false, true},
		["Mighty Upheaval"] = {1092598109, 7, 2, true, true},
		["Helm's Hammer"] = {1092598113, 8, 2, false, true},		
		
		["Follow Me!"] = {1092686890, 1, 3, false, false},
		["Strike as One!"] = {1091831431, 2, 3, false, false},
		["Joy of Battle - Damage"] = {1091463400, 3, 3, false, false},
		["Share Innate Strength: Quickness"] = {1092687522, 5, 3, false, false},
		["Share Innate Strength: Heavy"] = {1092687523, 6, 3, false, false},
		["Share Innate Strength: Balance"] = {1092687524, 7, 3, false, false},
		["One for All"] = {1091805278, 8, 3, false, false},
		["Weather Blows"] = {1090541178, 9, 3, false, false},
		["Efficient Strikes"] = {1092693209, 10, 3, false, false},
		["Iron Will"] = {1092598111, 11, 3, false, false},
		["Bracing Guard"] = {1092693316, 12, 3, false, false},
	};

	--Blue-only skils
	local BlueSkills = CopyTable(SharedSkills);
	BlueSkills["Come At Me"] = {1092598121, 4, 2, false, true};
	BlueSkills["Brash Invitation"] = {1092598119, 4, 1, false, true};
	BlueSkills["Gut Punch"] = {1092692924, 6, 2, true, true};

	--Red-only skils
	local RedSkills = CopyTable(SharedSkills);
	RedSkills["Shattering Fist"] = {1092598120, 4, 1, true, true};
	RedSkills["First Strike"] = {1091805264, 4, 2, false, true};
	RedSkills["Fist of the Valar"] = {1092695530, 6, 2, true, true};
	RedSkills["Battle Fury"] = {1092695531, 4, 3, false, false};



	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
		["Buffs"] = RedBuffs,
	};


	local Data = {
		[1] = BlueData,
		[2] = RedData,
	};

	return Data;
end

function ConfigureCaptainSettings()
	
	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Time of Need"] = 1091037688,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);
	BlueBuffs["To Arms (Fellowship Shield-brother)"] = 1091659766;
	BlueBuffs["Song-brother's Call"] = 1091831453;

	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);
	RedBuffs["To Arms (Blade-brother)"] = 1091037682;
	RedBuffs["Blade-brother's Call"] = 1091840431;

	--Yellow-only buffs
	local YellowBuffs = CopyTable(SharedBuffTable);
	YellowBuffs["To Arms (Shield-brother)"] = 1091659765;
	YellowBuffs["Shield-brother's Call"] = 1091831458;


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
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
		["Buffs"] = RedBuffs,
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
		["Buffs"] = YellowBuffs,
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end

function ConfigureChampionSettings()

	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Fight On Critical Rating"] = 1090539699,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);

	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);

	--Yellow-only buffs
	local YellowBuffs = CopyTable(SharedBuffTable);
	
	--Shared procs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	local SharedProcTable = {
		["Improved Wild Attack"] = {1090553751, 1, 0},
		["Champion's Advantage"] = {1091830092, 3, 0},
	};

	--Blue-only procs
	local BlueProcs = CopyTable(SharedProcTable);

	--Red-only procs
	local RedProcs = CopyTable(SharedProcTable);
	RedProcs["Emboldened Blades 1"] = {1090539704, 2, 1};
	RedProcs["Emboldened Blades 2"] = {1090539704, 2, 2};
	RedProcs["Emboldened Blades 3"] = {1090539704, 2, 3};
	RedProcs["Emboldened Blades 4"] = {1090539704, 2, 4};
	RedProcs["Emboldened Blades 5"] = {1090539704, 2, 5};

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
		["Wild Attack"] = {1090553751, 2, 1, false, true},
		["Swift Strike"] = {1090541125, 3, 1, false, true},
		["Blade Wall"] = {1090553752, 4, 1, false, true},
		["Brutal Strikes"] = {1090553754, 5, 1, true, true},
		["Feral Strikes"] = {1091515785, 6, 1, true, true},
		["Clobber"] = {1090553763, 7, 1, true, true},
		["Battle Frenzy"] = {1091804924, 8, 1, false, true},

		["Ferocious Strikes"] = {1091804902, 2, 2, true, true},
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
		["Blood Rage"] = {1091459632, 5, 3, false, false},
		["True Heroics"] = {1091585417, 6, 3, false, false},
		["Sprint"] = {1090553762, 7, 3, false, false},
	};

	--Blue-only skils
	local BlueSkills = CopyTable(SharedSkills);
	BlueSkills["Sweeping Riposte"] = {1091830086, 1, 1, true, true};
	BlueSkills["Sudden Defence"] = {1090553758, 1, 2, true, true};
	BlueSkills["Second Wind"] = {1091425190, 3, 2, false, true};
	BlueSkills["Unbreakable"] = {1091804933, 4, 3, false, false};
	BlueSkills["Adamant"] = {1091459633, 8, 3, false, false};
	BlueSkills["Dire Need"] = {1090541139, 9, 3, false, false};

	--Red-only skils
	local RedSkills = CopyTable(SharedSkills);
	RedSkills["Devastating Strike"] = {1091804923, 1, 1, false, true};
	RedSkills["Remorseless Strike"] = {1090553759, 1, 2, true, true};
	RedSkills["Champion's Duel"] = {1091804891, 4, 3, false, false};

	--Yellow-only skils
	local YellowSkills = CopyTable(SharedSkills);
	YellowSkills["Rend"] = {1091459631, 1, 1, false, true};
	YellowSkills["Fury of Blades"] = {1091830071, 1, 2, true, true};
	YellowSkills["Blade Storm"] = {1090553756, 3, 2, true, true};


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
		["Buffs"] = RedBuffs,
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
		["Buffs"] = YellowBuffs,
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end

function ConfigureGuardianSettings()

	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Warrior's Heart"] = 1090541182,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);

	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);

	--Yellow-only buffs
	local YellowBuffs = CopyTable(SharedBuffTable);
	
	--Shared procs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	local SharedProcTable = {
	};

	--Blue-only procs
	local BlueProcs = CopyTable(SharedProcTable);

	--Red-only procs
	local RedProcs = CopyTable(SharedProcTable);

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
	local BlueRowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 32,
		[4] = 38,
	};
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
		["Improved Sting"] = {1090541160, 1, 1, false, true},
		["Guardian's Ward"] = {1090540663, 2, 1, false, true},
		["Vexing Blow"] = {1090541171, 3, 1, false, true},
		["Sweeping Cut"] = {1090553893, 4, 1, false, true},
		["Force Opening"] = {1091415790, 5, 1, false, true},
		["War-chant"] = {1091805310, 6, 1, false, true},
		["Stamp"] = {1090553906, 7, 1, false, true},
		["Stagger"] = {1091415788, 8, 1, false, true},

		["Retaliation"] = {1090553896, 1, 2, true, true},
		["Whirling Retaliation"] = {1090553902, 2, 2, true, true},
		["Thrust"] = {1090553903, 3, 2, true, true},
		["Overwhelm"] = {1091805314, 4, 2, true, true},
		["To the King"] = {1091805312, 5, 2, true, true},
		["Brutal Assault"] = {1091449586, 6, 2, false, true},
		["Hammer Down"] = {1091805297, 7, 2, false, true},
		["Smashing Stab"] = {1091805247, 8, 2, true, true},
		["Ignore the Pain"] = {1091591836, 9, 2, false, true},
		

		["Guardian's Pledge"] = {1091805278, 1, 3, false, false},
		["Juggernaut"] = {1091805299, 2, 3, false, false},
		["Litany of Defiance"] = {1091444826, 3, 3, false, false},
		["Warrior's Heart"] = {1090541182, 4, 3, false, false},
		["Thrill of Danger"] = {1090541184, 5, 3, false, false},
		["Break Ranks"] = {1091805247, 6, 3, false, false},
		["Catch a Breath"] = {1090541168, 7, 3, true, false},
		["Charge"] = {1091829797, 8, 3, false, false},
	};

	--Blue-only skils
	local BlueSkills = {
		["Improved Sting"] = {1090541160, 1, 1, false, true},
		["Guardian's Ward"] = {1090540663, 2, 1, false, true},
		["Vexing Blow"] = {1090541171, 3, 1, false, true},
		["Sweeping Cut"] = {1090553893, 4, 1, false, true},
		["Shield-blow"] = {1090541166, 5, 1, false, true},
		["War-chant"] = {1091805310, 6, 1, false, true},
		["Stamp"] = {1090553906, 7, 1, false, true},
		["Stagger"] = {1091415788, 8, 1, false, true},

		["Fray the Edge"] = {1091415791, 1, 2, false, true},
		["Retaliation"] = {1090553896, 2, 2, true, true},
		["Whirling Retaliation"] = {1090553902, 3, 2, true, true},
		["Turn the Tables"] = {1090553907, 4, 2, false, true},
		["Ignore the Pain"] = {1091591836, 5, 2, false, true},
		["Shield-swipe"] = {1090541162, 6, 2, true, true},
		["Shield-taunt"] = {1090553905, 7, 2, true, true},
		["Bash"] = {1090553898, 8, 2, true, true},
		["Shield-smash"] = {1090540658, 9, 2, true, true},

		["Engage"] = {1091415793, 1, 3, false, true},
		["Redirect"] = {1091805300, 2, 3, true, true},
		["Catch a Breath"] = {1090541168, 3, 3, true, true},
		["Smashing Stab"] = {1091805247, 4, 3, true, true},
		["Challenge"] = {1090522264, 5, 3, false, true},

		["Guardian's Pledge"] = {1091805278, 1, 4, false, false},
		["Juggernaut"] = {1091805299, 2, 4, false, false},
		["Litany of Defiance"] = {1091444826, 3, 4, false, false},
		["Warrior's Heart"] = {1090541182, 4, 4, false, false},
		["Thrill of Danger"] = {1090541184, 5, 4, false, false},
		["Break Ranks"] = {1091805247, 6, 4, false, false},
	};

	--Red-only skils
	local RedSkills = CopyTable(SharedSkills);

	--Yellow-only skils
	local YellowSkills = CopyTable(SharedSkills);


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
		["Buffs"] = RedBuffs,
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
		["Buffs"] = YellowBuffs,
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end


function ConfigureHunterSettings()

	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Burn Hot"] = 1091456474,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);

	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);

	--Yellow-only buffs
	local YellowBuffs = CopyTable(SharedBuffTable);
	
	--Shared procs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	local SharedProcTable = {
		["Fast Draw - Tier 1"] = {1090532013, 1, 1},
		["Fast Draw - Tier 2"] = {1090532013, 1, 2},
		["Fast Draw - Tier 3"] = {1090532013, 1, 3},
	};

	--Blue-only procs
	local BlueProcs = CopyTable(SharedProcTable);
	BlueProcs["Volley"] = {1090598919, 2, 0};

	--Red-only procs
	local RedProcs = CopyTable(SharedProcTable);

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
		["Improved Quick Shot"] = {1090553925, 1, 1, false, true},
		["Improved Penetrating Shot"] = {1090553933, 2, 1, false, true},
		["Improved Swift Bow"] = {1090553930, 3, 1, false, true},
		
		["Split Shot"] = {1090625142, 7, 1, true, true},
		["Blindside"] = {1090553942, 8, 1, false, true},
		
		["Barbed Arrow"] = {1090553904, 1, 2, false, true},
		["Heart Seeker"] = {1091388859, 2, 2, false, true},
		["Rain of Arrows"] = {1090553936, 6, 2, false, true},
		["Pinning Shot"] = {1091804877, 7, 2, true, true},
		["Set Trap"] = {1090524209, 8 , 2, false, true},
		["Bard's Arrow"] = {1090532133, 9, 2, false, true},
		["Improved Merciful Shot"] = {1090553939, 10, 2, false, true},

		["Burn Hot"] = {1091456474, 1, 3, false, false},
		["Intent Concentration"] = {1090541195, 2, 3, false, false},
		["Cry of the Hunter"] = {1091757776, 3, 3, false, false},
		["Distracting Shot"] = {1091459007, 4, 3, false, false},
	};
	--Blue-only skils
	local BlueSkills = CopyTable(SharedSkills);
	BlueSkills["Barrage"] = {1091829817, 4, 1, true, true};
	BlueSkills["Rapid Fire"] = {1091804881, 5, 3, false, false};
	BlueSkills["Blood Arrow"] = {1091591837, 5, 1, true, true};
	BlueSkills["Exsanguinate"] = {1091804879, 6, 1, true, true};

	--Red-only skils
	local RedSkills = CopyTable(SharedSkills);
	RedSkills["Upshot"] = {1091804886, 4, 1, true, true};
	RedSkills["Blood Arrow"] = {1091591837, 5, 1, true, true};
	RedSkills["Exsanguinate"] = {1091804879, 6, 1, true, true};

	--Yellow-only skils
	local YellowSkills = CopyTable(SharedSkills);
	YellowSkills["Lingering Wound"] = {1091804872, 4, 1, false, true};
	YellowSkills["Explosive Arrow"] = {1091459008, 5, 1, false, true};
	YellowSkills["Decoy"] = {1091829826, 6, 1, false, true};
	YellowSkills["Tripwire"] = {1091388957, 7, 1, false, true};
	YellowSkills["Rain of Thorns"] = {1090532137, 3, 2, false, true};
	YellowSkills["Piercing Trap"] = {1091829819, 4, 2, false, true};
	YellowSkills["The One Trap"] = {1091798545, 5, 2, false, true};


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
		["Buffs"] = RedBuffs,
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
		["Buffs"] = YellowBuffs,
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end

function ConfigureRunekeeperSettings()


	--Shared buffs that all lines are interested in
	--Data required for additional entries to this table:
	--[<Effect Name>] = <image ID>
	local SharedBuffTable = {
		["Armour of the Elements"] = 1091454154,
	};

	--Blue-only buffs
	local BlueBuffs = CopyTable(SharedBuffTable);

	--Red-only buffs
	local RedBuffs = CopyTable(SharedBuffTable);

	--Yellow-only buffs
	local YellowBuffs = CopyTable(SharedBuffTable);
	
	--Data required for additional entries to the proc tables:
	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}

	--Blue-only procs
	local BlueProcs = {};

	--Red-only procs
	local RedProcs = {
		["Closing Remarks"] = {1091502149, 1, 0},
		["Aftershock"] = {1092665247, 1, 0},
	};

	--Yellow-only procs
	local YellowProcs = {
		["Closing Remarks"] = {1091502149, 1, 0},
		["Aftershock"] = {1092665247, 1, 0},
		["Concession and Rebuttal - 1"] = {1091804893, 2, 1},
		["Concession and Rebuttal - 2"] = {1091804893, 2, 2},
		["Concession and Rebuttal - 3"] = {1091804893, 2, 3},
		["Concession and Rebuttal - 4"] = {1091804893, 2, 4},
		["Concession and Rebuttal - 5"] = {1091804893, 2, 5},
		["Flashing Images"] = {1091915737, 3, 0},
	};


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


	--Data required for additional entries to these tables:
	--[<Skill Name>] = {<image>, <x position>, <y position>, <responsive>, <visible off CD>}
	--Responsive skills are those that are not always available, they may require you to progress through a skill chain to unlock
	--for example in order to unlock Retaliation on Guardian you need a parry response effect to be active, therefore Retaliation is responsive.
	--Blue-only skils
	local BlueSkills = {
		["Mending Verse"] = {1091454164, 1, 1, false, true},
		["Writ of Health"] = {1091454166, 2, 1, false, true},
		["Bombastic Inspiration"] = {1091804917, 3, 1, false, true},
		["Prelude to Hope"] = {1091454167, 4, 1, false, true},
		["Rune-sign of Winter"] = {1091585423, 5, 1, false, true},
		["Essence of Storm"] = {1091454168, 6, 1, false, true},
		["Scribe's Spark"] = {1091454169, 7, 1, false, true},
		["Improved Final Word"] = {1091511267, 8, 1, false, true},
		
		["Rousing Words"] = {1091804932, 1, 2, false, true},
		["Epic for the Ages"] = {1091454160, 2, 2, false, true},
		["Word of Exaltation"] = {1091454161, 3, 2, false, true},
		["Essay of Exaltation"] = {1091829850, 4, 2, false, true},
		["Rune of Restoration"] = {1091829852, 5, 2, false, true},
		["Flurry of Words"] = {1091454144, 6, 2, false, true},
		["Volcanic Rune-stone"] = {1091804907, 7, 2, false, true},
		["Fulgurite Rune-stone"] = {1091829838, 8, 2, false, true},
		["Self-motivation"] = {1091454141, 9, 2, false, true},

		["Do Not Fall This Day"] = {1091454172, 1, 3, false, false},
		["Our Fates Entwined"] = {1091829845, 2, 3, false, false},
		["Armour of The Elements"] = {1091478065, 3, 3, false, false},
		["Steady Hands"] = {1091511268, 4, 3, false, false},
	};

	--Red-only skils
	local RedSkills = {
		["Fiery Ridicule"] = {1091440847, 1, 1, false, true},
		["Writ of Fire"] = {1091440848, 2, 1, false, true},
		["Distracting Flame"] = {1091511271, 3, 1, false, true},
		["Smouldering Wrath"] = {1091440849, 4, 1, false, true},
		["Ceaseless Argument"] = {1091454410, 5, 1, false, true},
		["Essence of Storm"] = {1091454168, 6, 1, false, true},
		["Scribe's Spark"] = {1091454169, 7, 1, false, true},
		["Improved Final Word"] = {1091511267, 8, 1, false, true},

		["Essay of Fire"] = {1091829841, 1, 2, false, true},
		["Essence of Flame"] = {1091829836, 2, 2, false, true},
		["Scathing Mockery"] = {1091804926, 3, 2, false, true},
		["Combustion"] = {1091804898, 4, 2, false, true},
		["Flurry of Words"] = {1091454144, 5, 2, false, true},
		["Vivid Imagery"] = {1091914259, 6, 2, false, true},
		["Epic Conclusion"] = {1091454171, 7, 2, false, true},
		["Volcanic Rune-stone"] = {1091804907, 8, 2, false, true},
		["Fulgurite Rune-stone"] = {1091829838, 9, 2, false, true},
		["Self-motivation"] = {1091454141, 10, 2, false, true},

		["Do Not Fall This Day"] = {1091454172, 1, 3, false, false},
		["Armour of The Elements"] = {1091478065, 2, 3, false, false},
		["Steady Hands"] = {1091511268, 3, 3, false, false},
	};

	--Yellow-only skils
	local YellowSkills = {
		["Ceaseless Argument"] = {1091454410, 1, 1, false, true},
		["Writ of Lightning"] = {1091829864, 2, 1, false, true},
		["Scribe's Spark"] = {1091454169, 3, 1, false, true},
		["Essence of Storm"] = {1091454168, 4, 1, false, true},
		["Shocking Words"] = {1091454170, 5, 1, false, true},
		["Static Surge"] = {1091804904, 6, 1, true, true},
		["Sustaining Bolt"] = {1091804937, 7, 1, false, true},
		["Improved Final Word"] = {1091511267, 8, 1, false, true},

		["Flurry of Words"] = {1091454144, 1, 2, false, true},
		["Vivid Imagery"] = {1091914259, 2, 2, false, true},
		["Epic Conclusion"] = {1091454171, 3, 2, false, true},
		["Volcanic Rune-stone"] = {1091804907, 4, 2, false, true},
		["Fulgurite Rune-stone"] = {1091829838, 5, 2, false, true},
		["Shocking Touch"] = {1091454163, 6, 2, false, true},
		["Self-motivation"] = {1091454141, 7, 2, false, true},

		["Do Not Fall This Day"] = {1091454172, 1, 3, false, false},
		["Concession and Rebuttal"] = {1091804893, 2, 3, false, false},
		["Armour of The Elements"] = {1091478065, 3, 3, false, false},
		["Steady Hands"] = {1091511268, 4, 3, false, false},
	};


	local BlueData = {
		["Procs"] = BlueProcs,
		["Skills"] = {
			["RowInfo"] = BlueRowInfo,
			["SkillData"] = BlueSkills,
		};
		["Buffs"] = BlueBuffs,
	};

	local RedData = {
		["Procs"] = RedProcs,
		["Skills"] = {
			["RowInfo"] = RedRowInfo,
			["SkillData"] = RedSkills,
		};
		["Buffs"] = RedBuffs,
	};

	local YellowData = {
		["Procs"] = YellowProcs,
		["Skills"] = {
			["RowInfo"] = YellowRowInfo,
			["SkillData"] = YellowSkills,
		};
		["Buffs"] = YellowBuffs,
	};

	local Data = {
		[1] = BlueData,
		[2] = RedData,
		[3] = YellowData,
	};

	return Data;
end