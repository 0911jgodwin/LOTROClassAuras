Skill = class( Turbine.UI.Control )
function Skill:Constructor(parent, size, name, icon)
	Turbine.UI.Control.Constructor( self );

	self.name = name;
	self.skill = FindSkill( name );

    self:SetParent(parent);
    self:SetSize(size);
    self:SetVisible(true);

    self.duration = -1;
    self.currentTime = -1;


    --Is this section still needed?
    if self.skill ~= nil then
        self.resetTime = self.skill:GetResetTime();
        self.duration = self.resetTime - Turbine.Engine.GetGameTime();
    end
    
    if size == 38 then
        self.iconString = "ExoPlugins/ClassAuras/Resources/Class/" .. playerClass .. "/38px/";
    else
        self.iconString = "ExoPlugins/ClassAuras/Resources/Class/" .. playerClass .. "/32px/"
    end

    self.background = self.iconString .. icon .. ".tga";
    self.grayscaleBackground = self.iconString .. icon .. "_Grayscale.tga";

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
    --self.IconLabel:SetBackground(self.skill:GetSkillInfo():GetIconImageID());
    self.IconLabel:SetBackground(self.background);
    self.IconLabel:SetSize(size, size);
    self.IconLabel:SetPosition( -2, -4 );

    self.CooldownLabel = Turbine.UI.Label();
    self.CooldownLabel:SetParent(self);
    self.CooldownLabel:SetSize(size, size);
    self.CooldownLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.CooldownLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    self.CooldownLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.CooldownLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.CooldownLabel:SetMouseVisible(false);
end

function  Skill:Update( delta )
	self.duration = self.duration - delta;
    if self.duration < 0 then
        self.CooldownLabel:SetVisible(false);
        self.IconLabel:SetBackground(self.background);
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
    return true;
end
