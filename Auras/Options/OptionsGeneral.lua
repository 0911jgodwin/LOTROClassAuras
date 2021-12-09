OptionsGeneral = class(Turbine.UI.Control)
function OptionsGeneral:Constructor()
	Turbine.UI.Control.Constructor(self);
	self.width = 200;
	self.height = 300;

	self.fontColor = Turbine.UI.Color(225/255,197/255,110/255);
	
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
	self:SetWidth(self.width);

	self.auraSettings = Turbine.UI.ListBox();
	self.auraSettings:SetParent(self);
	self.auraSettings:SetSize(250, 250);
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

	self.aurasTimerFontSizeControl = Turbine.UI.Control();
	self.aurasTimerFontSizeControl:SetSize(250, 25);

	self.aurasTimerFontSizeLabel = Turbine.UI.Label();
	self.aurasTimerFontSizeLabel:SetParent(self.aurasTimerFontSizeControl);
	self.aurasTimerFontSizeLabel:SetSize(200, 25);
	self.aurasTimerFontSizeLabel:SetText("Timer Font Size: ");
	self.aurasTimerFontSizeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.aurasTimerFontSizeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasTimerFontSizeLabel:SetForeColor(self.fontColor);

	self.aurasTimerFontSizeValue = Turbine.UI.Lotro.TextBox();
	self.aurasTimerFontSizeValue:SetParent(self.aurasTimerFontSizeControl);
	self.aurasTimerFontSizeValue:SetSize(50, 18);
	self.aurasTimerFontSizeValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasTimerFontSizeValue:SetForeColor(self.fontColor);
	self.aurasTimerFontSizeValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.aurasTimerFontSizeValue:SetLeft(200);
	self.aurasTimerFontSizeValue:SetTop(3);

	self.auraSettings:AddItem(self.aurasTimerFontSizeControl);

	self.aurasResourceFontSizeControl = Turbine.UI.Control();
	self.aurasResourceFontSizeControl:SetSize(250, 25);

	self.aurasResourceFontSizeLabel = Turbine.UI.Label();
	self.aurasResourceFontSizeLabel:SetParent(self.aurasResourceFontSizeControl);
	self.aurasResourceFontSizeLabel:SetSize(200, 25);
	self.aurasResourceFontSizeLabel:SetText("Resource Font Size: ");
	self.aurasResourceFontSizeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.aurasResourceFontSizeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasResourceFontSizeLabel:SetForeColor(self.fontColor);

	self.aurasResourceFontSizeValue = Turbine.UI.Lotro.TextBox();
	self.aurasResourceFontSizeValue:SetParent(self.aurasResourceFontSizeControl);
	self.aurasResourceFontSizeValue:SetSize(50, 18);
	self.aurasResourceFontSizeValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasResourceFontSizeValue:SetForeColor(self.fontColor);
	self.aurasResourceFontSizeValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.aurasResourceFontSizeValue:SetLeft(200);
	self.aurasResourceFontSizeValue:SetTop(3);

	self.auraSettings:AddItem(self.aurasResourceFontSizeControl);

	self.aurasResourceHeightControl = Turbine.UI.Control();
	self.aurasResourceHeightControl:SetSize(250, 25);

	self.aurasResourceHeightLabel = Turbine.UI.Label();
	self.aurasResourceHeightLabel:SetParent(self.aurasResourceHeightControl);
	self.aurasResourceHeightLabel:SetSize(200, 25);
	self.aurasResourceHeightLabel:SetText("Resource Bar Height: ");
	self.aurasResourceHeightLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.aurasResourceHeightLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasResourceHeightLabel:SetForeColor(self.fontColor);

	self.aurasResourceHeightValue = Turbine.UI.Lotro.TextBox();
	self.aurasResourceHeightValue:SetParent(self.aurasResourceHeightControl);
	self.aurasResourceHeightValue:SetSize(50, 18);
	self.aurasResourceHeightValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasResourceHeightValue:SetForeColor(self.fontColor);
	self.aurasResourceHeightValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.aurasResourceHeightValue:SetLeft(200);
	self.aurasResourceHeightValue:SetTop(3);

	self.auraSettings:AddItem(self.aurasResourceHeightControl);

	self.aurasResourceYControl = Turbine.UI.Control();
	self.aurasResourceYControl:SetSize(250, 25);

	self.aurasResourceYLabel = Turbine.UI.Label();
	self.aurasResourceYLabel:SetParent(self.aurasResourceYControl);
	self.aurasResourceYLabel:SetSize(200, 25);
	self.aurasResourceYLabel:SetText("Resource Y Position: ");
	self.aurasResourceYLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.aurasResourceYLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasResourceYLabel:SetForeColor(self.fontColor);

	self.aurasResourceYValue = Turbine.UI.Lotro.TextBox();
	self.aurasResourceYValue:SetParent(self.aurasResourceYControl);
	self.aurasResourceYValue:SetSize(50, 18);
	self.aurasResourceYValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasResourceYValue:SetForeColor(self.fontColor);
	self.aurasResourceYValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.aurasResourceYValue:SetLeft(200);
	self.aurasResourceYValue:SetTop(3);

	self.auraSettings:AddItem(self.aurasResourceYControl);

	self.aurasSkillBarYControl = Turbine.UI.Control();
	self.aurasSkillBarYControl:SetSize(250, 25);

	self.aurasSkillBarYLabel = Turbine.UI.Label();
	self.aurasSkillBarYLabel:SetParent(self.aurasSkillBarYControl);
	self.aurasSkillBarYLabel:SetSize(200, 25);
	self.aurasSkillBarYLabel:SetText("Skill Bar Y Position: ");
	self.aurasSkillBarYLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.aurasSkillBarYLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasSkillBarYLabel:SetForeColor(self.fontColor);

	self.aurasSkillBarYValue = Turbine.UI.Lotro.TextBox();
	self.aurasSkillBarYValue:SetParent(self.aurasSkillBarYControl);
	self.aurasSkillBarYValue:SetSize(50, 18);
	self.aurasSkillBarYValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.aurasSkillBarYValue:SetForeColor(self.fontColor);
	self.aurasSkillBarYValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.aurasSkillBarYValue:SetLeft(200);
	self.aurasSkillBarYValue:SetTop(3);

	self.auraSettings:AddItem(self.aurasSkillBarYControl);

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
	self.aurasTimerFontSizeValue:SetText(Settings["General"]["TimerFontSize"]);
	self.aurasResourceFontSizeValue:SetText(Settings["General"]["Resource"]["FontSize"]);
	self.aurasResourceHeightValue:SetText(Settings["General"]["Resource"]["Height"]);
	self.aurasResourceYValue:SetText(Settings["General"]["YPositions"]["Resource"]);
	self.aurasSkillBarYValue:SetText(Settings["General"]["YPositions"]["SkillBar"]);
end

function OptionsGeneral:SaveData()
	Settings["General"]["ShowSkills"] = self.showSkillBars:IsChecked();
	Settings["General"]["Debug"] = self.toggleDebugMode:IsChecked();
	Settings["General"]["Width"] = tonumber(self.aurasWidthValue:GetText());
	Settings["General"]["TimerFontSize"] = tonumber(self.aurasTimerFontSizeValue:GetText());
	Settings["General"]["Resource"]["FontSize"] = tonumber(self.aurasResourceFontSizeValue:GetText());
	Settings["General"]["Resource"]["Height"] = tonumber(self.aurasResourceHeightValue:GetText());
	Settings["General"]["YPositions"]["Resource"] = tonumber(self.aurasResourceYValue:GetText());
	Settings["General"]["YPositions"]["SkillBar"] = tonumber(self.aurasSkillBarYValue:GetText());
end