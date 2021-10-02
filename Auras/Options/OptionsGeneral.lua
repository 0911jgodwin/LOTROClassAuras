OptionsGeneral = class(Turbine.UI.Control)
function OptionsGeneral:Constructor()
	Turbine.UI.Control.Constructor(self);
	self.width = 200;
	self.height = 200;

	self.fontColor = Turbine.UI.Color(225/255,197/255,110/255);
	
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
	self:SetWidth(self.width);

	self.auraSettings = Turbine.UI.ListBox();
	self.auraSettings:SetParent(self);
	self.auraSettings:SetSize(250, 200);
	self.auraSettings:SetTop(30);
	self.auraSettings:SetMouseVisible(false);
	self.auraSettings:SetVisible(true);

	self.auraHeader = Header("Aura Settings", 250);
	self.auraSettings:AddItem(self.auraHeader);

	self.showSkillBars = Turbine.UI.Lotro.CheckBox();
	self.showSkillBars:SetSize(250, 25);
	self.showSkillBars:SetText("Display Skill Bars: ");
	self.showSkillBars:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.showSkillBars:SetForeColor(self.fontColor);
	self.showSkillBars:SetChecked(true);
	self.showSkillBars:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.showSkillBars:SetTop(10);

	self.auraSettings:AddItem(self.showSkillBars);

	self.aurasWidthControl = Turbine.UI.Control();
	self.aurasWidthControl:SetSize(250, 25);

	self.aurasWidthLabel = Turbine.UI.Label();
	self.aurasWidthLabel:SetParent(self.aurasWidthControl);
	self.aurasWidthLabel:SetSize(200, 25);
	self.aurasWidthLabel:SetText("Aura Width: ");
	self.aurasWidthLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.aurasWidthLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasWidthLabel:SetForeColor(self.fontColor);

	self.aurasWidthValue = Turbine.UI.Lotro.TextBox();
	self.aurasWidthValue:SetParent(self.aurasWidthControl);
	self.aurasWidthValue:SetSize(50, 18);
	self.aurasWidthValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasWidthValue:SetForeColor(self.fontColor);
	self.aurasWidthValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.aurasWidthValue:SetLeft(200);
	self.aurasWidthValue:SetTop(3);

	self.auraSettings:AddItem(self.aurasWidthControl);

	self.toggleDebugMode = Turbine.UI.Lotro.CheckBox();
	self.toggleDebugMode:SetSize(250, 25);
	self.toggleDebugMode:SetText("Debug Mode Enabled: ");
	self.toggleDebugMode:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.toggleDebugMode:SetForeColor(self.fontColor);
	self.toggleDebugMode:SetChecked(false);
	self.toggleDebugMode:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);

	self.auraSettings:AddItem(self.toggleDebugMode);

	self:LoadData();

	self.acceptButton = Turbine.UI.Lotro.Button();
	self.acceptButton:SetParent(self);
	self.acceptButton:SetTop(self.height - 25);
	self.acceptButton:SetText("Save Changes");
	self.acceptButton:SetSize(120, 20);

	self.acceptButton.MouseClick = function(sender, args)
		self:SaveData();
		Reload();
	end

	self.loaded = true;
end

function OptionsGeneral:SizeChanged(args)
	if self.loaded then
		self.auraSettings:SetLeft(GetMidpointPosition(self.auraSettings:GetWidth(), self:GetWidth()));
		self.acceptButton:SetLeft(GetMidpointPosition(self.acceptButton:GetWidth(), self:GetWidth()));
	end
end


function OptionsGeneral:LoadData()
	self.showSkillBars:SetChecked(Settings["General"]["ShowSkills"]);
	self.toggleDebugMode:SetChecked(Settings["General"]["Debug"]);
	self.aurasWidthValue:SetText(Settings["General"]["Width"]);
end

function OptionsGeneral:SaveData()
	Settings["General"]["ShowSkills"] = self.showSkillBars:IsChecked();
	Settings["General"]["Debug"] = self.toggleDebugMode:IsChecked();
	Settings["General"]["Width"] = tonumber(self.aurasWidthValue:GetText());
end