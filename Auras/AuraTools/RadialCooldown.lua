_G.RadialCooldown = class(Turbine.UI.Window)
function RadialCooldown:Constructor(parent, frameWidth, frameHeight)
    Turbine.UI.Window.Constructor(self)

    self:SetParent(parent);
    self:SetSize(32, 32);
    self:SetOpacity(0.75);

	self.overlayStart = 0x41007E70;
    self.overlayEnd = 0x41007E35;

    self.duration = -1;
    self.maxDuration = -1;

    self.RadialCooldown = Turbine.UI.Control();
    self.RadialCooldown:SetParent(self);
    self.RadialCooldown:SetSize(32, 32);
    self.RadialCooldown:SetBlendMode(4);
    self.RadialCooldown:SetBackColor(Turbine.UI.Color(1,0,0,0));
    self.RadialCooldown:SetBackColorBlendMode(3);
    self.RadialCooldown:SetVisible(true);
    self.RadialCooldown:SetMouseVisible(false);
    self.RadialCooldown:SetBackground(self.overlayStart);

    self:SetStretchMode(1);
    self:SetSize(frameWidth, frameHeight);

    self.lastTick = Turbine.Engine.GetGameTime();
    self.steps = self.overlayEnd - self.overlayStart + 1;
    self.Update = function()
        self.duration =  self.duration - (Turbine.Engine.GetGameTime() - self.lastTick);
        if self.duration <= 0 then
            self:SetVisible(false);
            self.maxDuration = -1;
            self:SetWantsUpdates(false);
        end
        local progress = 1 - self.duration / self.maxDuration;
        self.RadialCooldown:SetBackground(math.max(self.overlayStart + math.floor(progress * self.steps), self.overlayEnd));
        self.lastTick = Turbine.Engine.GetGameTime();
    end
end

function RadialCooldown:Activate(duration)
    if duration > self.maxDuration then
        self.maxDuration = duration;
    end
    self.duration = duration;
    self.lastTick = Turbine.Engine.GetGameTime();
    self:SetVisible(true);
    self:SetWantsUpdates(true);
end

function RadialCooldown:Unload()
    self.RadialCooldown:SetParent(nil);
    self:SetWantsUpdates(false);
    self:SetParent(nil);
    self = nil;
end