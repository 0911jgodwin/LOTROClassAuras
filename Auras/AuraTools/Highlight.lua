_G.Highlight = class(Turbine.UI.Window)
function Highlight:Constructor(parent, frameWidth, frameHeight)
    Turbine.UI.Window.Constructor(self);
    self:SetParent(parent);
    self:SetMouseVisible(false);

    --Highlighting is done via Marching Ants animation--


    self:SetPosition(0, 2)

    --Set the base size to whatever the dimensions are for the individual ant frames
    self:SetSize(49, 40);

    --Set the frameCount to however many frames your animation is
    self.frameCount = 60;
    self.antsTexture = "ExoPlugins/Auras/Resources/MarchingAnts.tga";

    self.ants = Turbine.UI.Control();
    self.ants:SetParent(self);
    self.ants:SetSize(253, 502);
    self.ants:SetBackground(self.antsTexture);
    self.ants:SetBlendMode(Turbine.UI.BlendMode.Normal);
    self.ants:SetVisible(true);
    self.ants:SetMouseVisible(false);

    self:SetStretchMode(1);
    self:SetSize(frameWidth + 2, frameHeight +2);

    self.currentFrame = 0;
    self.lastTick = Turbine.Engine.GetGameTime();
    self.Update = function()
        if Turbine.Engine.GetGameTime() - self.lastTick < 0.05 then return end
        self.lastTick = Turbine.Engine.GetGameTime();
        self.currentFrame = (self.currentFrame + 1) % self.frameCount;
        self.ants:SetPosition(-(self.currentFrame % 5) * 51, -(math.floor(self.currentFrame / 5) * 42));
    end
end

function Highlight:Toggle(bool)
    self:SetVisible(bool);
    self:SetWantsUpdates(bool);
end

function Highlight:Unload()

    self.ants:SetParent(nil);
    self:SetWantsUpdates(false);
    self:SetParent(nil);
    self = nil;
end