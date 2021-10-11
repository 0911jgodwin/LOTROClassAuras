_G.NumericalDisplay = class(Turbine.UI.Control);
function NumericalDisplay:Constructor(parent, x, y, textScale)
    Turbine.UI.Control.Constructor(self);
	self:SetParent(parent);
	self:SetSize(x, y);
    width = x;

    self.textScale = textScale;

    
    self.threeDigitMidPos = width/2 - (33*self.textScale / 2);
    self.threeDigitLeftPos = self.threeDigitMidPos - (33*self.textScale);
    self.threeDigitRightPos = self.threeDigitMidPos + (33*self.textScale);

    self.twoDigitLeftPos = width/2 - (33*self.textScale);
    self.twoDigitRightPos = width/2;

    self.colonOffset = 20*self.textScale/2;

	self.firstDigit = Turbine.UI.Control();
    self.firstDigit:SetParent(self);
    self.firstDigit:SetSize(33, 47);
    self.firstDigit:SetBackground(AGFont[0]);
    self.firstDigit:SetStretchMode(1);
    self.firstDigit:SetSize(33*self.textScale, 47*self.textScale)
    self.firstDigit:SetPosition(width/2-10, -(47*self.textScale/2));
    self.firstDigit:SetStretchMode(2);
    self.firstDigit:SetMouseVisible(false);

    self.secondDigit = Turbine.UI.Control();
    self.secondDigit:SetParent(self);
    self.secondDigit:SetSize(33, 47);
    self.secondDigit:SetBackground(AGFont[0]);
    self.secondDigit:SetStretchMode(1);
    self.secondDigit:SetSize(33*self.textScale, 47*self.textScale)
    self.secondDigit:SetPosition(0, -(47*self.textScale/2));
    self.secondDigit:SetStretchMode(2);
    self.secondDigit:SetMouseVisible(false);

    self.thirdDigit = Turbine.UI.Control();
    self.thirdDigit:SetParent(self);
    self.thirdDigit:SetSize(33, 47);
    self.thirdDigit:SetBackground(AGFont[0]);
    self.thirdDigit:SetStretchMode(1);
    self.thirdDigit:SetSize(33*self.textScale, 47*self.textScale)
    self.thirdDigit:SetPosition((width/3)*2, -(47*self.textScale/2));
    self.thirdDigit:SetStretchMode(2);
    self.thirdDigit:SetMouseVisible(false);

    self.colonContainer = Turbine.UI.Control();
    self.colonContainer:SetParent(self);
    self.colonContainer:SetSize(33, 47);
    self.colonContainer:SetStretchMode(1);
    self.colonContainer:SetSize(20*self.textScale, 47*self.textScale);
    self.colonContainer:SetTop(-(47*self.textScale/2));
    self.colonContainer:SetLeft(self.threeDigitLeftPos + 33*self.textScale - self.colonOffset);
    self.colonContainer:SetStretchMode(2);
    self.colonContainer:SetMouseVisible(false);

    self.colon = Turbine.UI.Control();
    self.colon:SetParent(self.colonContainer);
    self.colon:SetSize(16, 36);
    self.colon:SetStretchMode(1);
    self.colon:SetBackground(AGFont[10]);
    self.colon:SetSize(16*self.textScale, 36*self.textScale);
    self.colon:SetLeft(4*self.textScale);
    self.colon:SetTop((47*self.textScale/2) - ((33*self.textScale)/2));
    self.colon:SetStretchMode(2);
    self.colon:SetMouseVisible(false);
end

function NumericalDisplay:SetText(number)
    local digits = {};
    local totalString = tostring(number);
    self.firstDigit:SetVisible(false);
    self.secondDigit:SetVisible(false);
    self.thirdDigit:SetVisible(false);
    self.colonContainer:SetVisible(false);
    
    if number > 60 then
        totalString = tostring(SecondsToMinutes(number));
        digits[1], digits[2], digits[3]=totalString:match('(%d)(%d)(%d)')
        self:ScaleImage(self.firstDigit, digits[1], self.threeDigitLeftPos - self.colonOffset);
        self.colonContainer:SetVisible(true);
        self:ScaleImage(self.secondDigit, digits[2], self.threeDigitMidPos + self.colonOffset);
        self:ScaleImage(self.thirdDigit, digits[3], self.threeDigitRightPos + self.colonOffset);
    elseif number > 9 then
        digits[1], digits[2]=totalString:match('(%d)(%d)')
        self:ScaleImage(self.firstDigit, digits[1], self.twoDigitLeftPos);
        self:ScaleImage(self.secondDigit, digits[2], self.twoDigitRightPos);
    else
        self:ScaleImage(self.secondDigit, totalString, self.threeDigitMidPos);
    end
end

function NumericalDisplay:SetTextAlignment(alignment)
    if alignment == Turbine.UI.ContentAlignment.MiddleCenter then 
        self.firstDigit:SetTop((self:GetHeight()/2) - ((47*self.textScale)/2));
        self.secondDigit:SetTop((self:GetHeight()/2) - ((47*self.textScale)/2));
        self.thirdDigit:SetTop((self:GetHeight()/2) - ((47*self.textScale)/2));
        self.colonContainer:SetTop((self:GetHeight()/2) - ((47*self.textScale)/2));
    elseif alignment == Turbine.UI.ContentAlignment.BottomCenter then 
        self.firstDigit:SetTop(self:GetHeight() - ((47*self.textScale)/2));
        self.secondDigit:SetTop(self:GetHeight() - ((47*self.textScale)/2));
        self.thirdDigit:SetTop(self:GetHeight() - ((47*self.textScale)/2));
        self.colonContainer:SetTop(self:GetHeight() - ((47*self.textScale)/2));
    end
end

function NumericalDisplay:ScaleImage(control, number, position)
    control:SetStretchMode(0);
    control:SetSize(33, 47);
    control:SetBackground(AGFont[tonumber(number)]);
    control:SetStretchMode(1);
    control:SetSize(33*self.textScale, 47*self.textScale)
    control:SetVisible(true);
    control:SetLeft(position);
end

function NumericalDisplay:Unload()
    self.firstDigit:SetParent(nil);
    self.secondDigit:SetParent(nil);
    self.thirdDigit:SetParent(nil);
    self.colonContainer:SetParent(nil);
    self.colon:SetParent(nil);
    self.firstDigit = nil;
    self.secondDigit = nil;
    self.thirdDigit = nil;
    self.colonContainer = nil;
    self.colon = nil;
end