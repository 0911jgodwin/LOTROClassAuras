import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "ExoPlugins.ClassAuras.Effect";
import "ExoPlugins.ClassAuras.EffectBar";
import "ExoPlugins.ClassAuras.Updater";
import "ExoPlugins.ClassAuras.Utils";

player = Turbine.Gameplay.LocalPlayer.GetInstance();
skillList = player:GetTrainedSkills();
playerClass = player:GetClass();
playerEffects = player:GetEffects();
Updater = Updater();
ChatHandler = Turbine.Chat;

RefreshTools = function(f, args)
	if args ~= nil then
		if args.ChatType == Turbine.ChatType.Advancement then
			local msg = string.find(args.Message, "You have acquired the Class Specialization Bonus Trait:");
			if msg ~= nil then
				Tools:Reload();
			end
		end
	end
end
AddCallback(ChatHandler, "Received", RefreshTools);

if Turbine.PluginData.Load(Turbine.DataScope.Character, "AuraSettings") ~= nil then

	AuraSettings = Turbine.PluginData.Load(Turbine.DataScope.Character, "AuraSettings")
else
	AuraSettings = {}
	AuraSettings["aurasLeft"] = 200;
	AuraSettings["aurasTop"] = 200;
end

if playerClass == Turbine.Gameplay.Class.Beorning then
	playerClass = "Beorning";
	Turbine.Shell.WriteLine("Beorning");
elseif playerClass == Turbine.Gameplay.Class.Burglar then
	Turbine.Shell.WriteLine("Burglar")
elseif playerClass == Turbine.Gameplay.Class.Brawler then
	import "ExoPlugins.ClassAuras.BrawlerAuras";
	Tools = BrawlerAuras(self);
elseif playerClass == Turbine.Gameplay.Class.Captain then
	import "ExoPlugins.ClassAuras.CaptainAuras";
	playerClass = "Captain";
	Tools = CaptainAuras(self, AuraSettings["aurasLeft"], AuraSettings["aurasTop"]);
elseif playerClass == Turbine.Gameplay.Class.Champion then
	Turbine.Shell.WriteLine("Champion")
elseif playerClass == Turbine.Gameplay.Class.Guardian then
	import "ExoPlugins.ClassAuras.GuardianAuras";
	playerClass = "Guardian";
	Tools = GuardianAuras(self, AuraSettings["aurasLeft"], AuraSettings["aurasTop"]);
	Turbine.Shell.WriteLine("Guardian")
elseif playerClass == Turbine.Gameplay.Class.Hunter then
	Turbine.Shell.WriteLine("Hunter")
elseif playerClass == Turbine.Gameplay.Class.LoreMaster then
	Turbine.Shell.WriteLine("Lore-Master")
elseif playerClass == Turbine.Gameplay.Class.Minstrel then
	Turbine.Shell.WriteLine("Minstrel")
elseif playerClass == Turbine.Gameplay.Class.RuneKeeper then
	Turbine.Shell.WriteLine("Runekeeper")
elseif playerClass == Turbine.Gameplay.Class.Warden then
	Turbine.Shell.WriteLine("Warden")
end

plugin.Unload=function()
	RemoveCallback(ChatHandler, "Received", RefreshTools);
	Tools:Unload();
	Turbine.Shell.WriteLine("Unload Complete");
end