Commands = Turbine.ShellCommand();
Turbine.Shell.AddCommand("auras", Commands);
Turbine.Shell.AddCommand("Auras", Commands);

function Commands:Execute(cmd, args)
	if string.len(args) > 0 then
		args = string.lower(args);

		if string.find(args, "options") == 1 then
			Options:SelectTab(1);
			Turbine.PluginManager.ShowOptions(Plugins["Auras"]);
		end

		if string.find(args, "reload") == 1 then
			Reload();
		end

		if string.find(args, "help") == 1 then
			Turbine.Shell.WriteLine("<rgb=#FF5555><Auras></rgb> Usage: /auras options | reload");
		end
	else
		Turbine.Shell.WriteLine("<rgb=#FF5555><Auras></rgb> Usage: /auras options | reload");
	end
end