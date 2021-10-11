_G.Skill = class( Turbine.UI.Control )
function Skill:Constructor(parent, size, icon, responsive, display)
	Turbine.UI.Control.Constructor( self );

    self:SetParent(parent);
    self:SetSize(32);
    self:SetVisible(true);    

    self.background = icon;
    self.grayscaleBackground = icon;

    self.display = display;


    --This section covers the general skill slot, from the frame to the icon itself

	self.BlackBorder = Turbine.UI.Control();
    self.BlackBorder:SetParent( self );
    self.BlackBorder:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
    self.BlackBorder:SetPosition( 1, 3 );
    self.BlackBorder:SetSize( 32 - math.ceil(32/16), 32 - math.ceil((32/16)*3) );
    self.BlackBorder:SetMouseVisible( false );

    self.IconFrame = Turbine.UI.Control();
    self.IconFrame:SetParent( self.BlackBorder );
    self.IconFrame:SetBackColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
    self.IconFrame:SetPosition( 1, 1 );
    self.IconFrame:SetSize( (32 - math.ceil(32/16)) - 2, (32 - math.ceil((32/16)*3) - 2) );
    self.IconFrame:SetMouseVisible( false );

    self.IconLabel = Turbine.UI.Label();
    self.IconLabel:SetParent(self.IconFrame);
    self.IconLabel:SetBackground(self.background);
    self.IconLabel:SetSize(32, 32);
    self.IconLabel:SetPosition( -math.floor(32/16), -math.floor((32/16)*3) );
    self.IconLabel:SetBackColor(Turbine.UI.Color(0,1,1,1));
    self.IconLabel:SetBlendMode(7);
    self.IconLabel:SetBackColorBlendMode(1);

    self.active = true;
    if responsive == true then
        self.active = false;
        self.IconLabel:SetBackColor(Turbine.UI.Color(0.9,1,1,1));
    end

    self.Tint = Turbine.UI.Control();
    self.Tint:SetParent( self.IconFrame );
    self.Tint:SetBackColor( Turbine.UI.Color(0.3, 0, 0, 0 ) );
    self.Tint:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
    self.Tint:SetBlendMode( Turbine.UI.BlendMode.Overlay );
    self.Tint:SetPosition( -2, -4 );
    self.Tint:SetSize( 32, 32 );
    self.Tint:SetMouseVisible( false );
    self.Tint:SetVisible(not self.active);


    self.BlackBorder:SetStretchMode( 1 );
    self.BlackBorder:SetSize(size - math.ceil(size/16), size - math.ceil((size/16)*3) );

    --This section handles everything to do with skill cooldown tracking

    self.overlayStart = 0x41007E70;
    self.overlayEnd = 0x41007E35;

    self.duration = -1;
    self.maxDuration = -1;

    self.CooldownText = NumericalDisplay(self, size - math.ceil(size/16), size - math.ceil((size/16)*3), 0.3);
    self.CooldownText:SetPosition(1, 3);
    self.CooldownText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.CooldownText:SetMouseVisible(false);
    self.CooldownText:SetZOrder(110);
    self.CooldownText:SetVisible(false);

    self.Highlight = Highlight(self, size - math.ceil(size/16), size - math.ceil((size/16)*3));
    self.Highlight:SetZOrder(120);
    self.RadialCooldown = RadialCooldown(self, size - math.ceil(size/16), size - math.ceil((size/16)*3));
    self.RadialCooldown:SetZOrder(101);
    self.RadialCooldown:SetPosition(1,3);

    --This updateHandler is for setting a responsive skill active

    self.UpdateHandler = function(delta)
		self.activeTime = self.activeTime - delta;

        if self.activeTime < 0 then
            self.activeTime = nil;
            self:ToggleActive(false);
            RemoveCallback(Updater, "Tick", self.UpdateHandler);
        end
	end
    self:SetVisible(self.display);
end

function Skill:ToggleHighlight( bool )
    self.Highlight:Toggle(bool);
end

function Skill:ToggleActive( bool, timer )
    self.active = bool;
    if self.active then
        if self.duration < 0 then
            self.IconLabel:SetBackColor(Turbine.UI.Color(0,1,1,1));
            self.Tint:SetVisible(not self.active);
        end
    else
        self.IconLabel:SetBackColor(Turbine.UI.Color(0.9,1,1,1));
        self.Tint:SetVisible(not self.active);
    end

    if timer ~= nil then
        self.activeTime = timer;
        AddCallback(Updater, "Tick", self.UpdateHandler);
    end
end

function  Skill:SetCooldown( cooldown )
    local active = self.duration > 0;
	self.duration = cooldown;
    self.RadialCooldown:Activate(self.duration);
    if self.duration < 0 then
        self:SetVisible( self.display );
        self.CooldownText:SetVisible(false);
        if self.active then
            self.IconLabel:SetBackColor(Turbine.UI.Color(0,1,1,1));
            self.Tint:SetVisible(false);
        end
        if self.display == false then
            self:GetParent():Sort();
        end
        return true;
    end

    self.CooldownText:SetText(self.duration);
    self.CooldownText:SetVisible(true);
    self.IconLabel:SetBackColor(Turbine.UI.Color(0.9,1,1,1));
    if self.display == false then
        self:SetVisible(true);
        self:GetParent():Sort();
    end
    if active then
        return true;
    else
        return false;
    end
end

function  Skill:Update( delta )
	self.duration = self.duration - delta;
    if self.duration < 0 then
        self:SetVisible( self.display );
        self.CooldownText:SetVisible(false);
        if self.active then
            self.IconLabel:SetBackColor(Turbine.UI.Color(0,1,1,1));
            self.Tint:SetVisible(false);
        end
        if self.display == false then
            self:GetParent():Sort();
        end
        return true;
    end

    local timeLeft = math.round(self.duration);
    if timeLeft == self.currentTime then
        return;
    end
    self.currentTime = timeLeft;
    self.CooldownText:SetText(self.currentTime);
    
    return false;
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
    self.CooldownText:SetParent(nil);
    self.Tint:SetParent(nil);
    self.CooldownText:Unload();
    self.Highlight:Unload();
    self.RadialCooldown:Unload();
    self:SetParent(nil);
    self = nil;
end
