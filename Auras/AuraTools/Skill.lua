_G.Skill = class( Turbine.UI.Control )
function Skill:Constructor(parent, size, icon, responsive, display)
	Turbine.UI.Control.Constructor( self );

    self:SetParent(parent);
    self:SetSize(32);
    self:SetVisible(true);    

    self.background = icon;
    self.grayscaleBackground = icon;
    self.tempBackground = self.background;

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

    self.Cooldown = Turbine.UI.Window();
    self.Cooldown:SetParent(self);
    self.Cooldown:SetSize(32, 32);
    self.Cooldown:SetPosition(1, 3);


    self.RadialCooldown = Turbine.UI.Control();
    self.RadialCooldown:SetParent(self.Cooldown);
    self.RadialCooldown:SetSize(32, 32);
    self.RadialCooldown:SetBlendMode(4);
    self.RadialCooldown:SetBackColor(Turbine.UI.Color(1,0,0,0));
    self.RadialCooldown:SetBackColorBlendMode(3);
    self.RadialCooldown:SetVisible(true);
    self.RadialCooldown:SetMouseVisible(false);

    self.CooldownText = Turbine.UI.Label();
    self.CooldownText:SetParent(self);
    self.CooldownText:SetSize(size - math.ceil(size/16), size - math.ceil((size/16)*3));
    self.CooldownText:SetPosition(1, 3);
    self.CooldownText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.CooldownText:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.CooldownText:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
    self.CooldownText:SetOutlineColor(Turbine.UI.Color(1,0,0,0));
    self.CooldownText:SetBackColorBlendMode(2);
    self.CooldownText:SetMouseVisible(false);
    self.CooldownText:SetStretchMode(3);
    self.CooldownText:SetZOrder(1001);
    self.CooldownText:SetVisible(false);

    self.Cooldown:SetStretchMode(1);
    self.Cooldown:SetSize(size - math.ceil(size/16), size - math.ceil((size/16)*3));

    self.oldGameTime = Turbine.Engine.GetGameTime();
    self.steps = self.overlayEnd - self.overlayStart + 1;
    self.Update = function()
        self.duration =  self.duration - (Turbine.Engine.GetGameTime() - self.oldGameTime);
        if self.duration <= 0 then
            if self.active then
                self.IconLabel:SetBackColor(Turbine.UI.Color(0,1,1,1));
                self.Tint:SetVisible(false);
            end
            self.CooldownText:SetVisible(false);
            self.Cooldown:SetVisible(false);
            self.maxDuration = -1;
            self:SetWantsUpdates(false);
            if self.display == false then
                self:SetVisible(false);
                self:GetParent():Sort();
            end
        end
        local timeLeft = math.round(self.duration);
        if timeLeft < self.currentTime then
            self.currentTime = timeLeft;
            self.CooldownText:SetVisible(false);
            self.CooldownText:SetText(SecondsToMinutes(self.currentTime));
            self.CooldownText:SetVisible(true);
        end
        local progress = 1 - self.duration / self.maxDuration;
        
        self.RadialCooldown:SetBackground(self.overlayStart + math.floor(progress * self.steps));
        self.oldGameTime = Turbine.Engine.GetGameTime();
    end

    self.Highlight = Highlight(self, size - math.ceil(size/16), size - math.ceil((size/16)*3));


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
	self.duration = cooldown;
    if self.duration < 0 then
        self.IconLabel:SetBackColor(Turbine.UI.Color(0,1,1,1));
        self.CooldownText:SetVisible(false);
        self.Cooldown:SetVisible(false);
        self.maxDuration = -1;
        self:SetWantsUpdates(false);
        if self.display == false then
            Turbine.Shell.WriteLine(self.duration)
            self:SetVisible(false);
            self:GetParent():Sort();
        end
        return;
    end

    self.IconLabel:SetBackColor(Turbine.UI.Color(0.9,1,1,1));
    self.oldGameTime = Turbine.Engine.GetGameTime();
    self.currentTime = math.round(self.duration);
    self.CooldownText:SetVisible(true);
    self.CooldownText:SetText(SecondsToMinutes(self.currentTime));
    self.Cooldown:SetVisible(true);
    if self.display == false then
        self:SetVisible(true);
        self:GetParent():Sort();
    end
    if self.maxDuration < self.duration and self.duration > 0 then
        self.maxDuration = self.duration;
        self:SetWantsUpdates(true);
    end
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
    self.Highlight:Unload();
    self:SetParent(nil);
    self = nil;
end
