import "ExoPlugins.ClassAuras.Highlight";
Skill = class( Turbine.UI.Control )
function Skill:Constructor(parent, size, name, icon, responsive)
	Turbine.UI.Control.Constructor( self );

    self:SetParent(parent);
    self:SetSize(size);
    self:SetVisible(true);

    self.duration = -1;
    self.currentTime = -1;
    
    if size == 38 then
        self.iconString = "ExoPlugins/ClassAuras/Resources/Class/" .. playerClass .. "/38px/";
    else
        self.iconString = "ExoPlugins/ClassAuras/Resources/Class/" .. playerClass .. "/32px/"
    end

    self.background = self.iconString .. icon .. ".tga";
    self.grayscaleBackground = self.iconString .. icon .. "_Grayscale.tga";
    self.tempBackground = self.background;

    self.active = true;
    if responsive ~= nil then
        self.active = false;
        self.background = self.grayscaleBackground;
    end

	self.BlackBorder = Turbine.UI.Control();
    self.BlackBorder:SetParent( self );
    self.BlackBorder:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
    self.BlackBorder:SetPosition( 1, 3 );
    self.BlackBorder:SetSize( size - math.ceil(size/16), size - math.ceil((size/16)*3) );
    self.BlackBorder:SetMouseVisible( false );

    self.IconFrame = Turbine.UI.Control();
    self.IconFrame:SetParent( self );
    self.IconFrame:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
    self.IconFrame:SetPosition( 2, 4 );
    self.IconFrame:SetSize( (size - math.ceil(size/16)) - 2, (size - math.ceil((size/16)*3) - 2) );
    self.IconFrame:SetMouseVisible( false );

    self.IconLabel = Turbine.UI.Label();
    self.IconLabel:SetParent(self.IconFrame);
    self.IconLabel:SetBackground(self.background);
    self.IconLabel:SetSize(size, size);
    self.IconLabel:SetPosition( -2, -4 );

    self.Tint = Turbine.UI.Control();
    self.Tint:SetParent( self );
    self.Tint:SetBackColor( Turbine.UI.Color( 0.3, 0, 0, 0 ) );
    self.Tint:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
    self.Tint:SetPosition( 2, 4 );
    self.Tint:SetSize( (size - math.ceil(size/16)) - 2, (size - math.ceil((size/16)*3) - 2) );
    self.Tint:SetMouseVisible( false );
    self.Tint:SetVisible(not self.active);

    self.CooldownLabel = Turbine.UI.Label();
    self.CooldownLabel:SetParent(self);
    self.CooldownLabel:SetSize(size, size);
    self.CooldownLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.CooldownLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    self.CooldownLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.CooldownLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.CooldownLabel:SetMouseVisible(false);


    self.Highlight = Highlight(self, self.BlackBorder:GetWidth()+2, self.BlackBorder:GetHeight() + 4);

    self.UpdateHandler = function(delta)
		self.activeTime = self.activeTime - delta;

        if self.activeTime < 0 then
            self.activeTime = nil;
            self:ToggleActive(false);
            RemoveCallback(Updater, "Tick", self.UpdateHandler);
        end
	end
end

function Skill:ToggleHighlight( bool )
    self.Highlight:Toggle(bool);
end

function Skill:ToggleActive( bool, timer )
    self.active = bool;
    if self.active then
        self.background = self.tempBackground;
        if self.duration < 0 then
            self.IconLabel:SetBackground(self.background);
            self.Tint:SetVisible(not self.active);
        end
    else
        self.background = self.grayscaleBackground;
        self.IconLabel:SetBackground(self.background);
        self.Tint:SetVisible(not self.active);
    end

    if timer ~= nil then
        self.activeTime = timer;
        AddCallback(Updater, "Tick", self.UpdateHandler);
    end
end

function  Skill:Update( delta )
	self.duration = self.duration - delta;
    if self.duration < 0 then
        self.CooldownLabel:SetVisible(false);
        self.IconLabel:SetBackground(self.background);
        self.Tint:SetVisible(not self.active);
        return true;
    end

    local timeLeft = math.round(self.duration);
    if timeLeft == self.currentTime then
        return false;
    end
    self.currentTime = timeLeft;
    if self.currentTime > 60 then
        self.CooldownLabel:SetText(SecondsToMinutes(self.currentTime));
    else
        self.CooldownLabel:SetText(self.currentTime);
    end
    return false;
end

function  Skill:SetCooldown( cooldown )
	self.duration = cooldown;
    if self.duration < 0 then
        self.CooldownLabel:SetVisible(false);
        self.IconLabel:SetBackground(self.background);
        return false;
    end

    local timeLeft = math.round(self.duration);
    if timeLeft == self.currentTime then
        return;
    end
    self.currentTime = timeLeft;
    self.CooldownLabel:SetVisible(true);
    if self.currentTime > 60 then
        self.CooldownLabel:SetText(SecondsToMinutes(self.currentTime));
    else
        self.CooldownLabel:SetText(self.currentTime);
    end
    self.IconLabel:SetBackground(self.grayscaleBackground);
    self.Tint:SetVisible(true);
    return true;
end

function Skill:Unload()
    self.background = nil;
    self.grayscaleBackground = nil;

    if self.active ~= nil then
        RemoveCallback(Updater, "Tick", self.UpdateHandler);
    end

    self.BlackBorder:SetParent( nil );
    self.IconFrame:SetParent( nil );
    self.IconLabel:SetParent(nil);
    self.Tint:SetParent(nil);
    self.CooldownLabel:SetParent(nil);
    self.Highlight:Unload();
    self:SetParent(nil);
    self = nil;
end
