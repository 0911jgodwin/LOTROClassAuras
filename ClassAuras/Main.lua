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
if playerClass == Turbine.Gameplay.Class.Beorning then
	playerClass = "Beorning";
	Turbine.Shell.WriteLine("Beorning");
elseif playerClass == Turbine.Gameplay.Class.Burglar then
	Turbine.Shell.WriteLine("Burglar")
elseif playerClass == Turbine.Gameplay.Class.Brawler then
	import "ExoPlugins.ClassAuras.BrawlerAuras";
	Turbine.Shell.WriteLine("Brawler")
	Tools = BrawlerAuras(self);
elseif playerClass == Turbine.Gameplay.Class.Captain then
	Turbine.Shell.WriteLine("Captain")
	import "ExoPlugins.ClassAuras.CaptainAuras";
	playerClass = "Captain";
	--TestEffect=Effect(self, 32, 1090553787);
	Tools = CaptainAuras(self);
	
elseif playerClass == Turbine.Gameplay.Class.Champion then
	Turbine.Shell.WriteLine("Champion")
elseif playerClass == Turbine.Gameplay.Class.Guardian then
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
	Tools:Unload();
	Turbine.Shell.WriteLine("Unload Complete");
end