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

function FindSkill( name )
    for i=1 , skillList:GetCount() , 1 do
		if name == skillList:GetItem(i):GetSkillInfo():GetName() then
			return skillList:GetItem(i);
		end
	end
	return nil;
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
        timeString = minutes .. ":" .. seconds;
    end

    return timeString;
end
