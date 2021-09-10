import "Turbine.Gameplay";
import "Turbine.UI"; -- this will expose the label control that we will implement
import "Turbine.UI.Lotro"; -- this will expose the standard window that we will implement
import "ExoPlugins.ClassAuras.Effect";
import "ExoPlugins.ClassAuras.EffectBar";
import "ExoPlugins.ClassAuras.Updater";
import "ExoPlugins.ClassAuras.Utils";
import "ExoPlugins.ClassAuras.CaptainAuras";
import "ExoPlugins.ClassAuras.BrawlerAuras";

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
	Turbine.Shell.WriteLine("Brawler")
	BrawlerTools = BrawlerAuras(self);
elseif playerClass == Turbine.Gameplay.Class.Captain then
	Turbine.Shell.WriteLine("Captain")
	playerClass = "Captain";
	--TestEffect=Effect(self, 32, 1090553787);
	CaptainTools = CaptainAuras(self);
	
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

