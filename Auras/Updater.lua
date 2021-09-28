Updater = class(Turbine.UI.Control)
function Updater:Constructor()
    Turbine.UI.Control.Constructor(self);
    self:SetWantsUpdates(true)

    self.Tick = nil;
    self.TickEvent = function (sender, event, args)
        if type(event)=="function" then
            event(args)
        else
            if type(event)=="table" then
                local size = table.getn(event);
                local i;
                for i=1,size do
                    if type(event[i])=="function" then
                        event[i](args);
                    end
                end
            end
        end
    end

    self.oldGameTime = Turbine.Engine.GetGameTime();
    self.TickRate = 0.1;
    self.Update = function()
        local currentGameTime = Turbine.Engine.GetGameTime();
        if currentGameTime == self.oldGameTime then
            return;
        end

        local delta = currentGameTime - self.oldGameTime;
    
        if delta < self.TickRate then
            return; 
        end
    
        self.TickEvent(self, self.Tick, delta);
    
        self.oldGameTime = currentGameTime;
    end   
end

function Updater:Unload()
    self:SetWantsUpdates(false)
end