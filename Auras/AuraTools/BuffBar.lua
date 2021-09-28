_G.BuffBar = class( Turbine.UI.Control );
function BuffBar:Constructor(parent, width, height, barColour, alignment)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);

    self.Alignment = alignment;
    self.BarColour = barColour;
    
    self.oldWidth = -1;

    Background = "ExoPlugins/Auras/Resources/BarTexture.tga";

    --The border of the bar. Padding is built in to the size of the bar so we can easily align multiple bars.
    self.BorderBox = Turbine.UI.Control();
    self.BorderBox:SetParent(self);
    self.BorderBox:SetSize(width - 2, height);
    self.BorderBox:SetPosition(1, 0);
    self.BorderBox:SetBackColor(Turbine.UI.Color(1, 0, 0, 0));

    -- This bar serves as the background behind the filled section
    self.BackgroundBar = Turbine.UI.Control();
    self.BackgroundBar:SetParent(self.BorderBox);
    self.BackgroundBar:SetSize(width - 4, height - 2);
    self.BackgroundBar:SetPosition(1, 1);
    self.BackgroundBar:SetMouseVisible(false);
    self.BackgroundBar:SetBackColor(Turbine.UI.Color(0.75, 0.025, 0.025, 0.025));

    -- The current value of the display
    self.FillBar = Turbine.UI.Control();
    self.FillBar:SetParent(self.BorderBox);
    self.FillBar:SetSize(0, height - 2);
    self.FillBar:SetPosition(2, 1);
    self.FillBar:SetMouseVisible(false);
    self.FillBar:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
    self.FillBar:SetBackground(Background);
    self.FillBar:SetBackColor(barColour);
   

    self.active = false;

    self.UpdateHandler = function(delta)
		self.duration = self.duration - delta;
        if self.duration > 0 then
            self:AdjustBars();
        else
            self.FillBar:SetVisible(false);
            self.active = false;
            RemoveCallback(Updater, "Tick", self.UpdateHandler);
        end
	end
end

function BuffBar:SetTimer(timer)

    self.maxDuration = timer;
    self.duration = timer;
    self.startTime = Turbine.Engine.GetGameTime();
    self.FillBar:SetVisible(true);
    if self.active == false then
        AddCallback(Updater, "Tick", self.UpdateHandler);
    end
    self.active = true;
end

function BuffBar:EndTimer()

    if self.active then
        self.duration = 0;
    end
end

function BuffBar:AdjustBars()

    local totalWidth, currentHeight = self.BackgroundBar:GetSize();
    local currentWidth = totalWidth * (self.duration / self.maxDuration);
    
    if self.Alignment == Turbine.UI.ContentAlignment.MiddleRight then
        self.FillBar:SetWidth(math.ceil(currentWidth));
        self.FillBar:SetLeft( 1 + (totalWidth - currentWidth));
    elseif self.Alignment == Turbine.UI.ContentAlignment.MiddleCenter then
        local width = math.ceil(currentWidth);

        --To prevent jerky side-to-side movement we only shrink a center aligned bar 2 pixels at a time
        if width == 0 or self.oldWidth == -1 or math.abs(self.oldWidth - width) > 1 then
            self.FillBar:SetWidth(math.ceil(currentWidth));
            self.FillBar:SetLeft(1 + ((totalWidth - currentWidth) / 2));
            self.oldWidth = width;
        end
    else
        self.FillBar:SetWidth(math.ceil(currentWidth));
    end
end

function BuffBar:Unload()
    if self.active then
        RemoveCallback(Updater, "Tick", self.UpdateHandler);
    end
    self.BorderBox:SetParent(nil);
    self.BackgroundBar:SetParent(nil);
    self.FillBar:SetParent(nil);
    self:SetParent(nil);
    self = nil;
end