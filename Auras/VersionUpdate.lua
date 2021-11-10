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
		version = "V.7.0.1";
	end

	Settings["General"]["Version"] = "V." .. plugin:GetVersion();
end