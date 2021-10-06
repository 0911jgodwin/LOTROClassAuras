_G.ResourceBar = class( Turbine.UI.Control );
function ResourceBar:Constructor(parent, width, height, pipCount, colours)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, 24);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);

    self.colours = colours;

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
        self.Pips[i] = Pip(self, pipWidth, 6)
        self.Pips[i]:SetPosition((width/2) - ((pipWidth/2) * pipCount) + ((i-1)*pipWidth), 12);
        self.numbers[i] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/" .. i .. ".tga");
    end
    self.numbers[0] = Turbine.UI.Graphic("ExoPlugins/Auras/Resources/" .. 0 .. ".tga");
    self.image = Turbine.UI.Control();
    self.image:SetParent(self);
    self.image:SetSize(51, 51);
    
    self.image:SetBackground("ExoPlugins/Auras/Resources/0.tga");
    self.image:SetStretchMode(1);
    self.image:SetSize(18, 18)
    self.image:SetPosition(width/2-10, 6);
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
    self.image:SetSize(51, 51);
    self.image:SetBackground(self.numbers[total]);
    self.image:SetStretchMode(1);
    self.image:SetSize(18, 18)
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
function VitalBar:Constructor(parent, width, height, pipCount, colours)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, 24);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);

    self.colours = colours;

    --Example settings. Requires a value stored at 0 to be the default colour, other values are break points that tell it to switch to a new colour
    --In this example 0-2 pips are blue, 3-8 pips are yellow, and 9 pips display as red.

    --[[self.colours = {
    [0] = Turbine.UI.Color(0.23, 0.12, 0.77),
    [3] = Turbine.UI.Color( 1.00, 0.96, 0.41 ),
    [9] = Turbine.UI.Color(0.77, 0.12, 0.23),
    };]]--

    self.pipCount = 1;
    self.Pips = {};
    local pipWidth = width/1;
    for i = 1, 1, 1 do
        self.Pips[i] = Pip(self, pipWidth, 10)
        self.Pips[i]:SetPosition((width/2) - ((pipWidth/2) * 1) + ((i-1)*pipWidth), 12);
    end

    --Oh boy, it's Kerning time
    self.Kerning = {
        ["0"] = {1, 0},
        ["1"] = {2, 3},
        ["2"] = {1, 0},
        ["3"] = {1, 0},
        ["4"] = {1, -2},
        ["5"] = {1, 0},
        ["6"] = {0, 1},
        ["7"] = {1, -1},
        ["8"] = {1, 0},
        ["9"] = {1, 0},
    };

    self.threeDigitMid = Turbine.UI.Control();
    self.threeDigitMid:SetParent(self);
    self.threeDigitMid:SetSize(51, 51);
    self.threeDigitMid:SetBackground("ExoPlugins/Auras/Resources/0.tga");
    self.threeDigitMid:SetStretchMode(1);
    self.threeDigitMid:SetSize(18, 18)
    self.threeDigitMid:SetPosition(width/2-10, 8);
    self.threeDigitMid:SetStretchMode(2);
    self.threeDigitMid:SetMouseVisible(false);

    self.threeDigitLeft = Turbine.UI.Control();
    self.threeDigitLeft:SetParent(self);
    self.threeDigitLeft:SetSize(51, 51);
    self.threeDigitLeft:SetBackground("ExoPlugins/Auras/Resources/0.tga");
    self.threeDigitLeft:SetStretchMode(1);
    self.threeDigitLeft:SetSize(18, 18)
    self.threeDigitLeft:SetPosition(width/2-28, 8);
    self.threeDigitLeft:SetStretchMode(2);
    self.threeDigitLeft:SetMouseVisible(false);

    self.threeDigitRight = Turbine.UI.Control();
    self.threeDigitRight:SetParent(self);
    self.threeDigitRight:SetSize(51, 51);
    self.threeDigitRight:SetBackground("ExoPlugins/Auras/Resources/0.tga");
    self.threeDigitRight:SetStretchMode(1);
    self.threeDigitRight:SetSize(18, 18)
    self.threeDigitRight:SetPosition(width/2+8, 8);
    self.threeDigitRight:SetStretchMode(2);
    self.threeDigitRight:SetMouseVisible(false);

    self.twoDigitLeft = Turbine.UI.Control();
    self.twoDigitLeft:SetParent(self);
    self.twoDigitLeft:SetSize(51, 51);
    self.twoDigitLeft:SetBackground("ExoPlugins/Auras/Resources/0.tga");
    self.twoDigitLeft:SetStretchMode(1);
    self.twoDigitLeft:SetSize(18, 18)
    self.twoDigitLeft:SetPosition(width/2-16, 8);
    self.twoDigitLeft:SetStretchMode(2);
    self.twoDigitLeft:SetMouseVisible(false);

    self.twoDigitRight = Turbine.UI.Control();
    self.twoDigitRight:SetParent(self);
    self.twoDigitRight:SetSize(51, 51);
    self.twoDigitRight:SetBackground("ExoPlugins/Auras/Resources/0.tga");
    self.twoDigitRight:SetStretchMode(1);
    self.twoDigitRight:SetSize(18, 18)
    self.twoDigitRight:SetPosition(width/2, 8);
    self.twoDigitRight:SetStretchMode(2);
    self.twoDigitRight:SetMouseVisible(false);
end

function VitalBar:SetTotal(total)
    self:SetImage(total);
end

function VitalBar:SetImage(total)
    --Due to poor choice of fonts within the system and no capability to import fonts this plugin uses custom images for each number.
    local digits = {};
    local totalString = tostring(total);
    self.twoDigitRight:SetVisible(false);
    self.twoDigitLeft:SetVisible(false);
    self.threeDigitLeft:SetVisible(false);
    self.threeDigitMid:SetVisible(false);
    self.threeDigitRight:SetVisible(false);
    if total == 100 then
        self:DoNumbers(self.threeDigitLeft, "1", width/2-28 + self.Kerning["1"][2]);
        self:DoNumbers(self.threeDigitMid, "0", width/2-10);
        self:DoNumbers(self.threeDigitRight, "0", width/2+8);
    elseif total > 9 then
        digits[1], digits[2]=totalString:match('(%d)(%d)')
        self:DoNumbers(self.twoDigitLeft, digits[1], width/2-16 + self.Kerning[digits[1]][2]);
        self:DoNumbers(self.twoDigitRight, digits[2], width/2 - self.Kerning[digits[2]][1]);
    else
        self:DoNumbers(self.threeDigitMid, totalString, width/2-10);
    end
end

function VitalBar:DoNumbers(control, number, position)
    control:SetStretchMode(0);
    control:SetSize(51, 51);
    control:SetBackground("ExoPlugins/Auras/Resources/" .. number .. ".tga");
    control:SetStretchMode(1);
    control:SetSize(18, 18)
    control:SetVisible(true);
    control:SetLeft(position);
end