import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "ExoPlugins.Auras.Updater";
import "ExoPlugins.Auras.Utils";
import "ExoPlugins.Auras.Options";
import "ExoPlugins.Auras.Commands";

--Setup all the global objects we need reference to
player = Turbine.Gameplay.LocalPlayer.GetInstance();
skillList = player:GetTrainedSkills();
playerClass = player:GetClass();
playerRole = GetRole();
playerAttributes = player:GetClassAttributes();
playerEffects = player:GetEffects();
Updater = Updater();
Settings = nil;


if Turbine.PluginData.Load(Turbine.DataScope.Character, "AurasSettings") ~= nil then
	Settings = LoadData(Turbine.DataScope.Character, "AurasSettings");
else
	import "ExoPlugins.Auras.DefaultSettings";
	Settings = ConfigureDefaultSettings();
end

Options = _G.OptionsMaster();
plugin.GetOptionsPanel = function(self) return Options; end	

ChatHandler = Turbine.Chat;

ReloadHandler = function(delta)
	if resetTime ~= nil then
		if resetTime < Turbine.Engine.GetGameTime() then
			resetTime = nil;
			playerRole = GetRole();
			Reload();
			RemoveCallback(Updater, "Tick", ReloadHandler);
		end
	else
		resetTime = Turbine.Engine.GetGameTime()+3;
	end
end

RefreshTools = function(f, args)
	if args ~= nil then
		if args.ChatType == Turbine.ChatType.Advancement then
			local msg = string.find(args.Message, "You have acquired the Class Specialization Bonus Trait:");
			if msg ~= nil then
				AddCallback(Updater, "Tick", ReloadHandler);
			end
		end
	end
end
AddCallback(ChatHandler, "Received", RefreshTools);

function Reload()
	Tools:Reload();
	Options:Reload();
end

if playerClass == Turbine.Gameplay.Class.Beorning then

	Turbine.Shell.WriteLine("Beorning");

elseif playerClass == Turbine.Gameplay.Class.Brawler then

	import "ExoPlugins.Auras.ClassAuras.BrawlerAuras";
	Tools = _G.BrawlerAuras(self);

elseif playerClass == Turbine.Gameplay.Class.Burglar then

	Turbine.Shell.WriteLine("Burglar")

elseif playerClass == Turbine.Gameplay.Class.Captain then

	import "ExoPlugins.Auras.ClassAuras.CaptainAuras";
	Tools = _G.CaptainAuras(self);

elseif playerClass == Turbine.Gameplay.Class.Champion then
	
	import "ExoPlugins.Auras.ClassAuras.ChampionAuras";
	Tools = _G.ChampionAuras(self);

elseif playerClass == Turbine.Gameplay.Class.Guardian then

	import "ExoPlugins.Auras.ClassAuras.GuardianAuras";
	Tools = _G.GuardianAuras(self);

elseif playerClass == Turbine.Gameplay.Class.Hunter then

	import "ExoPlugins.Auras.ClassAuras.HunterAuras";
	Tools = _G.HunterAuras(self);

elseif playerClass == Turbine.Gameplay.Class.LoreMaster then

	Turbine.Shell.WriteLine("Lore-Master")

elseif playerClass == Turbine.Gameplay.Class.Minstrel then

	Turbine.Shell.WriteLine("Minstrel")

elseif playerClass == Turbine.Gameplay.Class.RuneKeeper then

	Turbine.Shell.WriteLine("Runekeeper")

elseif playerClass == Turbine.Gameplay.Class.Warden then

	Turbine.Shell.WriteLine("Warden")

end

plugin.Load=function(sender, args)
	Turbine.Shell.WriteLine("<rgb=#FF5555><" .. plugin:GetName() .. "></rgb> V." .. plugin:GetVersion() .. " loaded.");
end

plugin.Unload=function()
	RemoveCallback(ChatHandler, "Received", RefreshTools);
	Tools:Unload();
	Options:Unload();
	SaveData(Turbine.DataScope.Character, "AurasSettings", Settings);
	Turbine.Shell.RemoveCommand("auras");
	Turbine.Shell.RemoveCommand("Auras");
	Turbine.Shell.WriteLine("<rgb=#FF5555><Auras></rgb> Unload Complete");
end