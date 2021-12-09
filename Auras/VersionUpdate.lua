function UpdateToLatestVersion(version)
	if version == "V.0.6.5" or version == nil then
		screenWidth, screenHeight = Turbine.UI.Display:GetSize();

		--Need to convert the currently stored position from pixel position to % position
		local temp = Settings["General"]["Position"];
		temp[1] = Settings["General"]["Position"][1] / screenWidth;
		temp[2] = Settings["General"]["Position"][2] / screenHeight;
		Settings["General"]["Position"] = temp;

		Settings["General"]["Buffs"] = {
			["Position"] = {((screenWidth/2)-412)/screenWidth, (screenHeight/1.7)/screenHeight},
			["Width"] = 256,
		};
		Settings["Class"][1]["Buffs"] ={};
		Settings["Class"][2]["Buffs"] ={};
		if playerClass ~= Turbine.Gameplay.Class.Brawler then
			Settings["Class"][3]["Buffs"] ={};
		end
		--Update the version so future if statements can catch it and update it sequentially.
		version = "V.0.7.0.1";
	end
	
	if version == "V.7.0.1" or version == "V.0.7.0.1" or version == "V.7.0" then
		if playerClass ~= Turbine.Gameplay.Class.Captain then
			Settings["General"]["Resource"] = {
				["FontSize"] = 0.35,
				["Height"] = 6,
			};
			Settings["General"]["YPositions"] = {
				["Resource"] = 42,
				["SkillBar"] = 54,
			};
		else
			Settings["General"]["Resource"] = {
				["FontSize"] = 0.35,
				["Height"] = 8,
			};
			Settings["General"]["YPositions"] = {
				["Resource"] = 42,
				["SkillBar"] = 60,
			};
		end
		Settings["General"]["TimerFontSize"] = 0.3;
		Settings["General"]["BuffIconSize"] = 32;

		local rowInfo = {
		[1] = 38,
		[2] = 32,
		[3] = 32,
		[4] = 32,
		[5] = 32,
		[6] = 32,
		[7] = 32,
		[8] = 32,
		[9] = 32,
	};

		Settings["Class"][1]["Skills"]["RowInfo"] = rowInfo;
		Settings["Class"][2]["Skills"]["RowInfo"] = rowInfo;
		if playerClass ~= Turbine.Gameplay.Class.Brawler then
			Settings["Class"][3]["Skills"]["RowInfo"] = rowInfo;
		end
		version = "V.0.7.1";
	end

	Settings["General"]["Version"] = "V." .. plugin:GetVersion();
end