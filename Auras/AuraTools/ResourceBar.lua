_G.ResourceBar = class( Turbine.UI.Control );
function ResourceBar:Constructor(parent, width, height, pipCount, colours, textScale)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, (53*textScale));
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);

    self.colours = colours;
    self.textScale = textScale;

    --Example settings. Requires a value stored at 0 to be the default colour, other values are break points that tell it to switch to a new colour
    --In this example 0-2 pips are blue, 3-8 pips are yellow, and 9 pips display as red.

    --[[self.colours = {
    [0] = Turbine.UI.Color(0.23, 0.12, 0.77),
    [3] = Turbine.UI.Color( 1.00, 0.96, 0.41 ),
    [9] = Turbine.UI.Color(0.77, 0.12, 0.23),
    };]]--
    self.numbers = {};
    self.pipCount = pipCount;
    self.Pips = {};
    local pipWidth = width/pipCount;
    for i = 1, pipCount, 1 do
        self.Pips[i] = Pip(self, pipWidth, height)
        self.Pips[i]:SetPosition((width/2) - ((pipWidth/2) * pipCount) + ((i-1)*pipWidth), (53*self.textScale)/2- height/2);
        self.numbers[i] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/GU" .. i .. ".tga");
    end
    self.numbers[0] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/GU" .. 0 .. ".tga");
    self.image = Turbine.UI.Control();
    self.image:SetParent(self);
    self.image:SetSize(51, 53);
    
    self.image:SetBackground(self.numbers[0]);
    self.image:SetStretchMode(1);
    self.image:SetSize((51*textScale), (53*textScale))
    self.image:SetPosition(width/2-10, 0);
    self.image:SetStretchMode(2);
    self.image:SetMouseVisible(false);

end

function ResourceBar:SetTotal(total)
    self:SetImage(total);
    local colour;
    for i = total, 0, -1 do
        if self.colours[i] ~= nil then
            colour = self.colours[i];
            break;
        end
    end

    for i = 1, self.pipCount, 1 do
        if i <= total then
            self.Pips[i]:SetActive(colour);
        else
            self.Pips[i]:SetInactive();
        end
    end
end

function ResourceBar:SetImage(total)
    --Due to poor choice of fonts within the system and no capability to import fonts this plugin uses custom images for each number.
    self.image:SetStretchMode(0);
    self.image:SetSize(51, 53);
    self.image:SetBackground(self.numbers[total]);
    self.image:SetStretchMode(1);
    self.image:SetSize((51*self.textScale), (53*self.textScale))
end

function ResourceBar:SetAttunementTotal(total)
    
    local colour;
    for i = total, -9, -1 do
        if self.colours[i] ~= nil then
            colour = self.colours[i];
            break;
        end
    end

    local currentTotal = (total - 10);
    if currentTotal < 0 then
        currentTotal = currentTotal * -1;
    end
    self:SetImage(currentTotal);

    for i = 1, self.pipCount, 1 do
        if i <= currentTotal then
            self.Pips[i]:SetActive(colour);
        else
            self.Pips[i]:SetInactive();
        end
    end
end

function ResourceBar:Unload()
    for i = 1, self.pipCount, 1 do
        self.Pips[i]:Unload();
    end
    self.image:SetSize(0,0);
    self.Pips = {};
    self:SetParent(nil);
	self = nil;
end

Pip = class( Turbine.UI.Control );
function Pip:Constructor(parent, width, height)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);

    self.BorderBox = Turbine.UI.Control();
    self.BorderBox:SetParent(self);
    self.BorderBox:SetSize(width - 2, height);
    self.BorderBox:SetPosition(1, 0);
    self.BorderBox:SetBackColor(Turbine.UI.Color(1, 0, 0, 0));

    self.BackgroundBar = Turbine.UI.Control();
    self.BackgroundBar:SetParent(self.BorderBox);
    self.BackgroundBar:SetSize(width - 4, height - 2);
    self.BackgroundBar:SetPosition(1, 1);
    self.BackgroundBar:SetMouseVisible(false);
    self.BackgroundBar:SetBackColor(Turbine.UI.Color(0.75, 0.025, 0.025, 0.025));
end

function Pip:SetActive(color)
    self.BackgroundBar:SetBackColor(color);
end

function Pip:SetInactive()
    self.BackgroundBar:SetBackColor(Turbine.UI.Color(0.75, 0.025, 0.025, 0.025));
end

function Pip:Unload()
    self:SetParent(nil);
	self = nil;
end

_G.VitalBar = class( Turbine.UI.Control );
function VitalBar:Constructor(parent, width, height, textScale, colours)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, (53*textScale));
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);
    self.textScale = textScale;

    self.numbers = {};
    for i = 0, 9, 1 do
        self.numbers[i] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/GU" .. i .. ".tga");
    end

    --Example settings. Requires a value stored at 0 to be the default colour, other values are break points that tell it to switch to a new colour
    --In this example 0-2 pips are blue, 3-8 pips are yellow, and 9 pips display as red.

    --[[self.colours = {
    [0] = Turbine.UI.Color(0.23, 0.12, 0.77),
    [3] = Turbine.UI.Color( 1.00, 0.96, 0.41 ),
    [9] = Turbine.UI.Color(0.77, 0.12, 0.23),
    };]]--

    --[[self.colors = {
        [1] = {40, Turbine.UI.Color(1, 0.12, 0.12)},
        [2] = {100, Turbine.UI.Color(1, 0.4, 0)},

    };]]--

    --Oh boy, it's Kerning time
    self.Kerning = {
        ["0"] = {1, 1},
        ["1"] = {8*self.textScale, 10*self.textScale},
        ["2"] = {3*self.textScale, 3*self.textScale},
        ["3"] = {2*self.textScale, 3*self.textScale},
        ["4"] = {1, 1},
        ["5"] = {2*self.textScale, 3*self.textScale},
        ["6"] = {2*self.textScale, 3*self.textScale},
        ["7"] = {4*self.textScale, 3*self.textScale},
        ["8"] = {2*self.textScale, 3*self.textScale},
        ["9"] = {3*self.textScale, 3*self.textScale},
    };
    self.threeDigitMidPos = width/2 - (51*self.textScale / 2);
    self.threeDigitLeftPos = self.threeDigitMidPos - (51*self.textScale);
    self.threeDigitRightPos = self.threeDigitMidPos + (51*self.textScale);

    self.twoDigitLeftPos = width/2 - (51*self.textScale);
    self.twoDigitRightPos = width/2;

    self.bar = VitalDisplay(self, width, height, colours);
    self.bar:SetTop(((53*self.textScale)/2)-(self.bar:GetHeight()/2));

    self.firstDigit = Turbine.UI.Control();
    self.firstDigit:SetParent(self);
    self.firstDigit:SetSize(51, 53);
    self.firstDigit:SetBackground(self.numbers[0]);
    self.firstDigit:SetStretchMode(1);
    self.firstDigit:SetSize(51*self.textScale, 53*self.textScale);
    self.firstDigit:SetPosition(width/2-10, 0);
    self.firstDigit:SetStretchMode(2);
    self.firstDigit:SetMouseVisible(false);

    self.secondDigit = Turbine.UI.Control();
    self.secondDigit:SetParent(self);
    self.secondDigit:SetSize(51, 53);
    self.secondDigit:SetBackground(self.numbers[0]);
    self.secondDigit:SetStretchMode(1);
    self.secondDigit:SetSize(51*self.textScale, 53*self.textScale);
    self.secondDigit:SetPosition(0, 0);
    self.secondDigit:SetStretchMode(2);
    self.secondDigit:SetMouseVisible(false);

    self.thirdDigit = Turbine.UI.Control();
    self.thirdDigit:SetParent(self);
    self.thirdDigit:SetSize(51, 53);
    self.thirdDigit:SetBackground(self.numbers[0]);
    self.thirdDigit:SetStretchMode(1);
    self.thirdDigit:SetSize(51*self.textScale, 53*self.textScale);
    self.thirdDigit:SetPosition((width/3)*2, 0);
    self.thirdDigit:SetStretchMode(2);
    self.thirdDigit:SetMouseVisible(false);
end

function VitalBar:SetTotal(total)
    self:SetImage(total);
    self.bar:SetValue(total);
end

function VitalBar:SetImage(number)
    --Due to poor choice of fonts within the system and no capability to import fonts this plugin uses custom images for each number.
    local digits = {};
    local totalString = tostring(number);
    self.firstDigit:SetVisible(false);
    self.secondDigit:SetVisible(false);
    self.thirdDigit:SetVisible(false);
    
    if number > 99 then
        digits[1], digits[2], digits[3]=totalString:match('(%d)(%d)(%d)')
        self:ScaleImage(self.firstDigit, digits[1], self.threeDigitLeftPos + (self.Kerning[digits[1]][2] + self.Kerning[digits[2]][1]));
        self:ScaleImage(self.secondDigit, digits[2], self.threeDigitMidPos);
        self:ScaleImage(self.thirdDigit, digits[3], self.threeDigitRightPos -(self.Kerning[digits[3]][1] + self.Kerning[digits[2]][2]));
    elseif number > 9 then
        digits[1], digits[2]=totalString:match('(%d)(%d)')
        self:ScaleImage(self.firstDigit, digits[1], self.twoDigitLeftPos + (self.Kerning[digits[1]][2]));
        self:ScaleImage(self.secondDigit, digits[2], self.twoDigitRightPos - (self.Kerning[digits[2]][1]));
    else
        self:ScaleImage(self.secondDigit, totalString, self.threeDigitMidPos);
    end
end

function VitalBar:ScaleImage(control, number, position)
    control:SetStretchMode(0);
    control:SetSize(51, 53);
    control:SetBackground(self.numbers[tonumber(number)]);
    control:SetStretchMode(1);
    control:SetSize(51*self.textScale, 53*self.textScale)
    control:SetVisible(true);
    control:SetLeft(position);
end

function VitalBar:Unload()
    self.firstDigit:SetVisible(false);
    self.secondDigit:SetVisible(false);
    self.thirdDigit:SetVisible(false);
    self.firstDigit:SetParent(nil);
    self.secondDigit:SetParent(nil);
    self.thirdDigit:SetParent(nil);
    self.numbers = {};
    self.Kerning = {};
    self:SetParent(nil);
	self = nil;
end

VitalDisplay = class( Turbine.UI.Control );
function VitalDisplay:Constructor(parent, width, height, colors)
    Turbine.UI.Control.Constructor( self );

    self.colours = colors;
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetBackColor(Turbine.UI.Color(1, 0, 0, 0));
    self:SetVisible(true);

    self.BackgroundBar = Turbine.UI.Control();
    self.BackgroundBar:SetParent(self);
    self.BackgroundBar:SetSize(width - 2, height - 2);
    self.BackgroundBar:SetPosition(1, 1);
    self.BackgroundBar:SetMouseVisible(false);
    self.BackgroundBar:SetBackColor(Turbine.UI.Color(0.75, 0.025, 0.025, 0.025));

    self.CurrentBar = Turbine.UI.Control();
    self.CurrentBar:SetParent(self);
    self.CurrentBar:SetSize(width - 2, height - 2);
    self.CurrentBar:SetPosition(1, 1);
    self.CurrentBar:SetMouseVisible(false);
    self.CurrentBar:SetBackColor(self.color);
end

function VitalDisplay:SetValue(number)
    local currentWidth = number/100 * self.BackgroundBar:GetWidth();

    local colourSet = false;
    local i = 1;
    while(colourSet == false)
    do
        if self.colours[i] ~= nil then
            if number <= self.colours[i][1] then
                self.CurrentBar:SetBackColor(self.colours[i][2]);
                colourSet = true;
            end
        else
            --If we get here just throw it a default colour to use
            self.CurrentBar:SetBackColor(Turbine.UI.Color(0, 0.82, 1));
            colourSet = true;
        end
        i = i + 1;
    end

    self.CurrentBar:SetWidth(math.ceil(currentWidth));
    --[[if number <= 40 then
        self.CurrentBar:SetBackColor(Turbine.UI.Color(1, 0.12, 0.12));
    else
        self.CurrentBar:SetBackColor(Turbine.UI.Color(1, 0.4, 0));
    end]]--
end