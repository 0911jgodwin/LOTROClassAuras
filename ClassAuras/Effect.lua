Effect = class(Turbine.UI.Control);
function Effect:Constructor(parent, size, icon, stack)
	Turbine.UI.Control.Constructor(self);

	self:SetParent(parent);
	self:SetSize(size, size + 4);
    self:SetVisible(true);

    self.duration = -1;
    self.currentTime = -1;


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

    self.Tint = Turbine.UI.Control();
    self.Tint:SetParent( self );
    self.Tint:SetBackColor( Turbine.UI.Color( 0.3, 0, 0, 0 ) );
    self.Tint:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
    self.Tint:SetPosition( 2, 4 );
    self.Tint:SetSize( (size - math.ceil(size/16)) - 2, (size - math.ceil((size/16)*3) - 2) );
    self.Tint:SetMouseVisible( false );

    self.IconLabel = Turbine.UI.Label();
    self.IconLabel:SetParent(self.IconFrame);
    self.IconLabel:SetBackground(icon);
    self.IconLabel:SetSize(size, size);
    self.IconLabel:SetPosition( -2, -4 );

    self.DurationLabel = Turbine.UI.Label();
    self.DurationLabel:SetParent(self);
    self.DurationLabel:SetSize(size, size);
    self.DurationLabel:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter);
    self.DurationLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    self.DurationLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.DurationLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.DurationLabel:SetPosition(0, 7);
    self.DurationLabel:SetMouseVisible(false);

    if stack > 0 then
        self.StackLabel = Turbine.UI.Label();
        self.StackLabel:SetParent(self);
        self.StackLabel:SetSize(size, size);
        self.StackLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
        self.StackLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
        self.StackLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
        self.StackLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
        self.StackLabel:SetPosition(0, -6);
        self.StackLabel:SetMouseVisible(false);
        self.StackLabel:SetText(stack);
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
    return false;
end

function Effect:StartTimer(timer)
    self.duration = timer;
end
