--https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--https://www.lotro.com/forums/showthread.php?428196-Writing-LoTRO-Lua-Plugins-for-Noobs&p=5784203#post5784203
function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

function ConfigureFont()
	local numbers = {};
    for i = 0, 9, 1 do
        numbers[i] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/AG" .. i .. ".tga");
    end
    numbers[10] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/AGColon.tga");
	return numbers;
end

function SecondsToMinutes(time)
    local timeString = "";
    local seconds = 0;
    local minutes = 0;
    if time <= 60 then
        timeString = time;
    else
        seconds = (time % 60);
        minutes = math.floor(time / 60);
        if seconds < 10 then
            seconds = "0" .. seconds;
        end
        timeString = minutes .. seconds;
    end

    return tonumber(timeString);
end

function GetMidpointPosition(width, parentWidth)
    return (parentWidth / 2) - (width / 2);
end

function SortEffects(a, b)
    if a[2] == b[2] then
        return a[3] < b[3];
    else
        return a[2] < b[2];
    end
end

function SortSkills(a, b)
    if a[3] == b[3] then
        return a[2] < b[2];
    else
        return a[3] < b[3];
    end
end

function SortEffects(a, b)
    if a[2] == b[2] then
        return a[3] < b[3];
    else
        return a[2] < b[2];
    end
end

function LoadData(Scope, FileName)
	return LoadTable(Turbine.PluginData.Load(Scope, FileName));
end

function SaveData(Scope, FileName, Data)
	Turbine.PluginData.Save(Scope, FileName, SaveTable(Data));
end

function LoadTable(Table)
	if Table == nil then
		return nil;
	end
	local Data = {};
	for key, value in pairs(Table) do
		Data[LoadField(key)] = LoadField(value);
	end
	return Data;
end

function LoadField(Field)
	if type(Field) == "table" then
		return LoadTable(Field);
	elseif type(Field) == "string" then
		if string.find(Field, "<num>") then
			return tonumber(string.sub(Field, string.find(Field, ">") + 1, string.len(Field)));
		else
			return Field;
		end
	elseif type(Field) == "boolean" then
		return Field;
	end
end

function SaveTable(Table)
	if Table == nil then
		return nil;
	end
	local Data = {};
	for key, value in pairs(Table) do
		Data[SaveField(key)] = SaveField(value);
	end
	return Data;
end

function SaveField(Field)
	if type(Field) == "number" then 
		return ("<num>" .. tostring(Field));
	elseif type(Field) == "table" then
		return SaveTable(Field);
	elseif type(Field) == "string" then
		return Field;
	elseif type(Field) == "boolean" then
		return Field;
	end
end

function Debug(STRING)
    if STRING == nil or STRING == "" then return end;
    Turbine.Shell.WriteLine("<rgb=#FF5555>" .. STRING .. "</rgb>");
end

function dump(o)
    if type(o) == 'table' then
        local s = '{\n'
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. '\n'
        end
        return s .. '}\n'
    else
        return tostring(o)
    end
end

function CopyTable(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[CopyTable(k, s)] = CopyTable(v, s) end
  return res
end

function GetRole()
	if playerClass == Turbine.Gameplay.Class.Beorning then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Counter" then
				return 1;
			elseif name == "Bash" then
				return 2;
			elseif name == "Encouraging Roar" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.Brawler then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Come At Me" then
				return 1;
			elseif name == "Shattering Fist" then
				return 2;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.Burglar then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Lucky Strike" then
				return 1;
			elseif name == "Knives Out" then
				return 2;
			elseif name == "Mischievous Glee" then
				return 3;
			end
		end		

	elseif playerClass == Turbine.Gameplay.Class.Captain then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Valiant Strike" then
				return 1;
			elseif name == "Shadow's Lament" then
				return 2;
			elseif name == "Elendil's Roar" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.Champion then
	
		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Sudden Defence" then
				return 1;
			elseif name == "Devastating Strike" then
				return 2;
			elseif name == "Exchange of Blows" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.Guardian then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Shield-taunt" then
				return 1;
			elseif name == "Overwhelm" then
				return 2;
			elseif name == "Take To Heart" then
				return 3;
			end
		end
	
	elseif playerClass == Turbine.Gameplay.Class.Hunter then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Barrage" then
				return 1;
			elseif name == "Pinning Shot" then
				return 2;
			elseif name == "Decoy" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.LoreMaster then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Sic 'em" then
				return 1;
			elseif name == "Ents go to War" then
				return 2;
			elseif name == "Test of Will" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.Minstrel then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Soliloquy of Spirit" then
				return 1;
			elseif name == "Call to Fate" then
				return 2;
			elseif name == "Anthem of Prowess" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.RuneKeeper then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Writ of Health" then
				return 1;
			elseif name == "Writ of Fire" then
				return 2;
			elseif name == "Writ of Lightning" then
				return 3;
			end
		end

	elseif playerClass == Turbine.Gameplay.Class.Warden then

		for i = 1, skillList:GetCount(), 1 do
			local item = skillList:GetItem(i);
			local name = item:GetSkillInfo():GetName();
			if name == "Warning Shot" then
				return 1;
			elseif name == "Shield Piercer" then
				return 2;
			elseif name == "Improved Hampering Javelin" then
				return 3;
			end
		end

	end
	--If it doesn't figure it out, just return 1 to prevent errors
	return 1;
end