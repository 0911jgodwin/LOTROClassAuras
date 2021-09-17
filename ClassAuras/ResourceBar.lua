ResourceBar = class( Turbine.UI.Control );
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

    self.pipCount = pipCount;
    self.Pips = {};
    local pipWidth = width/pipCount;
    for i = 1, pipCount, 1 do
        self.Pips[i] = Pip(self, pipWidth, 6)
        self.Pips[i]:SetPosition((width/2) - ((pipWidth/2) * pipCount) + ((i-1)*pipWidth), 12);
    end

    self.image = Turbine.UI.Control();
    self.image:SetParent(self);
    self.image:SetSize(51, 51);
    
    self.image:SetBackground("ExoPlugins/ClassAuras/Resources/0.tga");
    self.image:SetStretchMode(1);
    self.image:SetSize(18, 18)
    self.image:SetPosition(width/2-10, 6);
    self.image:SetStretchMode(2);
    self.image:SetMouseVisible(false);
    


    self:SetTotal(5);
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
    self.image:SetBackground("ExoPlugins/ClassAuras/Resources/" .. total .. ".tga");
    self.image:SetStretchMode(1);
    self.image:SetSize(18, 18)
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