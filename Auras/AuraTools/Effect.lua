_G.Effect = class(Turbine.UI.Control);
function Effect:Constructor(parent, size, icon, stack)
	Turbine.UI.Control.Constructor(self);

	self:SetParent(parent);
	self:SetSize(size, size + 4);
    self:SetVisible(true);

    self.duration = -1;
    self.currentTime = -1;
    self.stack = stack;


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
    self.IconLabel:SetBackground(icon);
    self.IconLabel:SetSize(32, 32);
    self.IconLabel:SetPosition( -2, -4 );

    self.DurationLabel = Turbine.UI.Label();
    self.DurationLabel:SetParent(self);
    self.DurationLabel:SetSize(size, size);
    self.DurationLabel:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
    self.DurationLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
    self.DurationLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.DurationLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.DurationLabel:SetPosition(-1, 6);
    self.DurationLabel:SetMouseVisible(false);
    self.DurationLabel:SetStretchMode(1);
    self.DurationLabel:SetZOrder(1001);

    self.BlackBorder:SetStretchMode( 1 );
    self.BlackBorder:SetSize(size - math.ceil(size/16), size - math.ceil((size/16)*3) );

    if stack > 0 then
        self.StackLabel = Turbine.UI.Label();
        self.StackLabel:SetParent(self);
        self.StackLabel:SetSize(size, size);
        self.StackLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
        self.StackLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
        self.StackLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
        self.StackLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
        self.StackLabel:SetPosition(-1, -6);
        self.StackLabel:SetMouseVisible(false);
        self.StackLabel:SetText(stack);
        self.StackLabel:SetStretchMode(3);
        self.StackLabel:SetZOrder(1001);
    end

    self:SetVisible(false);
end

function  Effect:Update( delta )
	self.duration = self.duration - delta;
    if self.duration < 0 then
        self:SetVisible( false );
        return true;
    end

    local timeLeft = math.round(self.duration);
    if timeLeft == self.currentTime then
        return;
    end
    self.currentTime = timeLeft;
    self.DurationLabel:SetText(self.currentTime);
    if self.ShowDuration then
        self.DurationLabel:SetVisible(false);
        self.DurationLabel:SetVisible(true);
    end
    return false;
end

function Effect:StartTimer(timer)
    self.duration = timer;
    if self.duration > 100 then
        self.DurationLabel:SetVisible(false);
        self.ShowDuration = false;
    else 
        self.DurationLabel:SetVisible(true);
        self.ShowDuration = true;
    end
end

function Effect:GetDuration()
    return self.duration;
end

function Effect:Unload()
    self.BlackBorder:SetParent( nil );
    self.IconFrame:SetParent( nil );
    self.IconLabel:SetParent(nil);
    self.DurationLabel:SetParent(nil);
    if self.stack > 0 then
        self.StackLabel:SetParent(nil);
    end
    self:SetParent(nil);
    self = nil;
end