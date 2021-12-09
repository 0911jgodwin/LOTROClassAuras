_G.OptionsSkills = class(Turbine.UI.Control);
function OptionsSkills:Constructor()
	Turbine.UI.Control.Constructor(self);
	self.width = 200;
	self.height = 700;

	self.fontColor = Turbine.UI.Color(225/255,197/255,110/255);
	
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
	self:SetWidth(self.width);

	self.procSettings = Turbine.UI.ListBox();
	self.procSettings:SetParent(self);
	self.procSettings:SetSize(310, 650);
	self.procSettings:SetTop(30);
	self.procSettings:SetMouseVisible(false);
	self.procSettings:SetVisible(true);

	self.procHeader = Header("Skill Settings", 310);
	self.procSettings:AddItem(self.procHeader);

	self.description = Turbine.UI.Label();
	self.description:SetMultiline( true );
	self.description:SetSize(310, 50);
	self.description:SetText("This options page allows you to add, move, and remove skills from the skillbar");
	self.description:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.description:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.description:SetForeColor(self.fontColor);

	self.procSettings:AddItem(self.description);

	self.rowsContainer = Turbine.UI.Control();
	self.rowsContainer:SetParent(self);
	self.rowsContainer:SetSize(310, 100);
	self.rowsContainer:SetVisible(true);
	self.procSettings:AddItem(self.rowsContainer);

	self.rowSettings = Turbine.UI.ListBox();
	self.rowSettings:SetParent(self.rowsContainer);
	self.rowSettings:SetSize(300, 100);
	self.rowSettings:SetMouseVisible(false);
	self.rowSettings:SetVisible(true);

	self.rowScrollBar = Turbine.UI.Lotro.ScrollBar();
	self.rowScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	self.rowScrollBar:SetParent( self.rowsContainer );
	self.rowScrollBar:SetPosition( 300, 0 );
	self.rowScrollBar:SetSize( 10, 100 );

	self.rowSettings:SetVerticalScrollBar( self.rowScrollBar );

	self.spacer = Turbine.UI.Control();
	self.spacer:SetParent(self);
	self.spacer:SetSize(310, 20);
	self.spacer:SetVisible(true);
	self.procSettings:AddItem(self.spacer);


	self.treeContainer = Turbine.UI.Control();
	self.treeContainer:SetParent(self);
	self.treeContainer:SetSize(310, 300);
	self.treeContainer:SetVisible(true);
	self.procSettings:AddItem(self.treeContainer);

	-- Create the tree view control.
	self.treeView = Turbine.UI.TreeView();
	self.treeView:SetParent( self.treeContainer );
	self.treeView:SetSize( 300, 300 );
	self.treeView:SetIndentationWidth( 10 );

	-- Give the tree view a scroll bar.
	self.treeScrollBar = Turbine.UI.Lotro.ScrollBar();
	self.treeScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	self.treeScrollBar:SetParent( self.treeContainer );
	self.treeScrollBar:SetPosition( 300, 0 );
	self.treeScrollBar:SetSize( 10, 300 );

	self.treeView:SetVerticalScrollBar( self.treeScrollBar );

	self:LoadData();

	self.horizontalRule = Turbine.UI.Control();
	self.horizontalRule:SetSize(310, 1);
	self.horizontalRule:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));

	self.procSettings:AddItem(self.horizontalRule);

	self.buttonContainer = Turbine.UI.Control();
	self.buttonContainer:SetParent(self);
	self.buttonContainer:SetSize(310, 30);

	self.acceptButton = Turbine.UI.Lotro.Button();
	self.acceptButton:SetParent(self.buttonContainer);
	self.acceptButton:SetPosition(160, 10);
	self.acceptButton:SetText("Save Changes");
	self.acceptButton:SetSize(150, 20);

	self.acceptButton.MouseClick = function(sender, args)
		self:SaveData();
		Reload();
	end


	self.addSkillButton = Turbine.UI.Lotro.Button();
	self.addSkillButton:SetParent(self.buttonContainer);
	self.addSkillButton:SetPosition(0, 10);
	self.addSkillButton:SetText("Add New Skill");
	self.addSkillButton:SetSize(150, 20);

	self.addSkillButton.MouseClick = function(sender, args)
		self:AddSkill("Skill Name", "Icon Filepath", "0", "0");
	end

	self.procSettings:AddItem(self.buttonContainer);
	self.loaded = true;
end

function OptionsSkills:AddSkill(skillName, skillIcon, skillX, skillY, skillResponsive, skillVisible)
	local skillData = {skillName, skillIcon, skillX, skillY, skillResponsive, skillVisible};

	local skillNode = SkillNode(skillData[1]);

	local skillNodeData = SkillNodeData(skillData, self.treeView);

	self.treeView:GetNodes():Add(skillNode);
	skillNode:GetChildNodes():Add(skillNodeData);
end

function OptionsSkills:SizeChanged(args)
	if self.loaded then
		self.procSettings:SetLeft(GetMidpointPosition(self.procSettings:GetWidth(), self:GetWidth()));
	end
end

function OptionsSkills:SaveData()
	local nodeList = self.treeView:GetNodes();
	local data = {};
	local currentNode = nil;
	local currentData = nil;
	for i=1, nodeList:GetCount(), 1 do
		currentNode = nodeList:Get(i):GetChildNodes():Get(1);
		currentData = currentNode:GetData();
		data[currentData[1]] = {currentData[2], currentData[3], currentData[4], currentData[5], currentData[6]};
	end
	Settings["Class"][playerRole]["Skills"]["SkillData"] = data;

	local data = {};
	for key, value in spairs(self.rowData) do
		local info = value:GetData();
		data[info[1]] = info[2];
	end

	Settings["Class"][playerRole]["Skills"]["RowInfo"] = data;
end

function OptionsSkills:LoadData()
	local data = {};
	for key in pairs(Settings["Class"][playerRole]["Skills"]["SkillData"]) do
		table.insert(data, key);
	end

	table.sort(data, function(a,b)
		return SortSkills(Settings["Class"][playerRole]["Skills"]["SkillData"][a], Settings["Class"][playerRole]["Skills"]["SkillData"][b])
	end);
	
	for key, value in pairs(data) do
		self:AddSkill(value, 
			Settings["Class"][playerRole]["Skills"]["SkillData"][value][1], 
			Settings["Class"][playerRole]["Skills"]["SkillData"][value][2], 
			Settings["Class"][playerRole]["Skills"]["SkillData"][value][3], 
			Settings["Class"][playerRole]["Skills"]["SkillData"][value][4], 
			Settings["Class"][playerRole]["Skills"]["SkillData"][value][5]);
	end

	local data = {};

	for key, value in spairs(Settings["Class"][playerRole]["Skills"]["RowInfo"]) do
		local rowNode = RowNode(key, value);
		self.rowSettings:AddItem(rowNode);
		table.insert(data, rowNode);
	end

	self.rowData = data;
end

function OptionsSkills:Reload()
	self.treeView:GetNodes():Clear();
	self.rowSettings:ClearItems();
	self:LoadData();
end

function OptionsSkills:Unload()
	self.treeView:GetNodes():Clear();
	self.rowSettings:ClearItems();
	self.procSettings:ClearItems();
end

RowNode = class(Turbine.UI.Control);
function RowNode:Constructor(number, iconSize)
	Turbine.UI.Control.Constructor(self);
	self:SetSize(300, 27);

	self.number = number;

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetSize(300, 25);
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	self.border:SetMouseVisible(false);

	self.container = Turbine.UI.Control();
	self.container:SetParent(self);
	self.container:SetSize(298, 23);
	self.container:SetPosition(1,1);
	self.container:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.container:SetMouseVisible(false);

	self.rowName = Turbine.UI.Label();
	self.rowName:SetParent(self.container);
	self.rowName:SetSize(200, 23);
	self.rowName:SetText("Row " .. number);
	self.rowName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.rowName:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.rowName:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.rowName:SetPosition(50, 0);
	self.rowName:SetMouseVisible(false);


	self.rowIconSize = Turbine.UI.Lotro.TextBox();
	self.rowIconSize:SetParent(self.container);
	self.rowIconSize:SetSize(45, 19);
	self.rowIconSize:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.rowIconSize:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.rowIconSize:SetText(iconSize);
	self.rowIconSize:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.rowIconSize:SetLeft(205);
	self.rowIconSize:SetTop(2);
end

function RowNode:GetData()
	local data = {self.number, self.rowIconSize:GetText()};
	return data;
end

SkillNode = class(Turbine.UI.TreeNode);
function SkillNode:Constructor(name)
	Turbine.UI.TreeNode.Constructor(self);

	self.expanded = false;

	self:SetSize(300, 27);

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetSize(300, 25);
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	self.border:SetMouseVisible(false);

	self.container = Turbine.UI.Control();
	self.container:SetParent(self);
	self.container:SetSize(298, 23);
	self.container:SetPosition(1,1);
	self.container:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.container:SetMouseVisible(false);

	self.procName = Turbine.UI.Label();
	self.procName:SetParent(self.container);
	self.procName:SetSize(200, 23);
	self.procName:SetText(name);
	self.procName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.procName:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.procName:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.procName:SetPosition(50, 0);
	self.procName:SetMouseVisible(false);

	self.plus = Turbine.UI.Control();
	self.plus:SetParent(self);
	self.plus:SetLeft(280);
	self.plus:SetTop(5);
	self.plus:SetSize(15,15);
	self.plus:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.plus:SetBackground(0x41007E27);
	self.plus:SetMouseVisible(false);
end

function SkillNode:SetName(name)
	self.procName:SetText(name);
end

function SkillNode:MouseEnter(args)
	self.border:SetBackColor(Turbine.UI.Color(212/255,175/255,55/255));
end

function SkillNode:MouseLeave(args)
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
end

function SkillNode:MouseClick(args)
	if self.expanded then
		self.expanded = false;
		self.plus:SetBackground(0x41007E27);
	else
		self.expanded = true;
		self.plus:SetBackground(0x41007E26);
	end
end

SkillNodeData = class(Turbine.UI.TreeNode);
function SkillNodeData:Constructor(data, parent)
	Turbine.UI.TreeNode.Constructor(self);

	self.rootNode = parent;
	self.Data = data;

	self:SetSize(280, 172);

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetSize(280, 170);
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	self.border:SetMouseVisible(false);

	self.container = Turbine.UI.ListBox();
	self.container:SetParent(self.border);
	self.container:SetSize(278, 168);
	self.container:SetPosition(1,1);
	self.container:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.container:SetMouseVisible(false);

	self.padding = Turbine.UI.Control()
	self.padding:SetSize(278,10);

	self.container:AddItem(self.padding);

	self.skillNameContainer = Turbine.UI.Control();
	self.skillNameContainer:SetSize(278, 25);

	self.skillNameLabel = Turbine.UI.Label();
	self.skillNameLabel:SetParent(self.skillNameContainer);
	self.skillNameLabel:SetSize(100, 25);
	self.skillNameLabel:SetLeft(5);
	self.skillNameLabel:SetText("Skill Name: ");
	self.skillNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillNameLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.skillNameValue = Turbine.UI.Lotro.TextBox();
	self.skillNameValue:SetParent(self.skillNameContainer);
	self.skillNameValue:SetSize(168, 18);
	self.skillNameValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillNameValue:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.skillNameValue:SetText(self.Data[1]);
	self.skillNameValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.skillNameValue:SetLeft(105);

	self.skillNameValue.FocusLost = function(sender, args)
		self:GetParentNode():SetName(self.skillNameValue:GetText());
	end

	self.skillImageContainer = Turbine.UI.Control();
	self.skillImageContainer:SetSize(278, 25);

	self.skillImageLabel = Turbine.UI.Label();
	self.skillImageLabel:SetParent(self.skillImageContainer);
	self.skillImageLabel:SetSize(100, 25);
	self.skillImageLabel:SetLeft(5);
	self.skillImageLabel:SetText("Icon Filepath: ");
	self.skillImageLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillImageLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.skillImageValue = Turbine.UI.Lotro.TextBox();
	self.skillImageValue:SetParent(self.skillImageContainer);
	self.skillImageValue:SetSize(168, 18);
	self.skillImageValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillImageValue:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.skillImageValue:SetText(self.Data[2]);
	self.skillImageValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.skillImageValue:SetLeft(105);

	self.skillPositionContainer = Turbine.UI.Control();
	self.skillPositionContainer:SetSize(278, 25);

	self.skillXPosLabel = Turbine.UI.Label();
	self.skillXPosLabel:SetParent(self.skillPositionContainer);
	self.skillXPosLabel:SetSize(80, 25);
	self.skillXPosLabel:SetLeft(5);
	self.skillXPosLabel:SetText("X Position: ");
	self.skillXPosLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillXPosLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.skillXPosValue = Turbine.UI.Lotro.TextBox();
	self.skillXPosValue:SetParent(self.skillPositionContainer);
	self.skillXPosValue:SetSize(40, 18);
	self.skillXPosValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillXPosValue:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.skillXPosValue:SetText(self.Data[3]);
	self.skillXPosValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.skillXPosValue:SetLeft(88);

	self.skillYPosLabel = Turbine.UI.Label();
	self.skillYPosLabel:SetParent(self.skillPositionContainer);
	self.skillYPosLabel:SetSize(80, 25);
	self.skillYPosLabel:SetLeft(140);
	self.skillYPosLabel:SetText("Y Position: ");
	self.skillYPosLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillYPosLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.skillYPosValue = Turbine.UI.Lotro.TextBox();
	self.skillYPosValue:SetParent(self.skillPositionContainer);
	self.skillYPosValue:SetSize(40, 18);
	self.skillYPosValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillYPosValue:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.skillYPosValue:SetText(self.Data[4]);
	self.skillYPosValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.skillYPosValue:SetLeft(228);

	self.skillResponsiveContainer = Turbine.UI.Control();
	self.skillResponsiveContainer:SetSize(278, 25);

	self.skillResponsive = Turbine.UI.Lotro.CheckBox();
	self.skillResponsive:SetSize(250, 25);
	self.skillResponsive:SetText("Skill is Responsive: ");
	self.skillResponsive:SetParent(self.skillResponsiveContainer);
	self.skillResponsive:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillResponsive:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.skillResponsive:SetChecked(self.Data[5]);
	self.skillResponsive:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.skillResponsive:SetLeft(5);

	self.skillVisibleContainer = Turbine.UI.Control();
	self.skillVisibleContainer:SetSize(278, 25);

	self.skillVisible = Turbine.UI.Lotro.CheckBox();
	self.skillVisible:SetSize(250, 25);
	self.skillVisible:SetText("Visible Off Cooldown: ");
	self.skillVisible:SetParent(self.skillVisibleContainer);
	self.skillVisible:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.skillVisible:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.skillVisible:SetChecked(self.Data[6]);
	self.skillVisible:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.skillVisible:SetLeft(5);
	


	self.removeContainer = Turbine.UI.Control();
	self.removeContainer:SetSize(310, 20);

	self.removeBackground = Turbine.UI.Control();
	self.removeBackground:SetSize(140, 20);
	self.removeBackground:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	self.removeBackground:SetParent(self.removeContainer);
	self.removeBackground.MouseEnter = function(sender, args)
		self.removeBackground:SetBackColor(Turbine.UI.Color(212/255,175/255,55/255));
	end
	self.removeBackground.MouseLeave = function(sender, args)
		self.removeBackground:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	end
	self.removeBackground.MouseClick = function(sender, args)
		self.rootNode:GetNodes():Remove(self:GetParentNode());
	end
	self.removeBackground:SetLeft(75);


	self.removeLabel = Turbine.UI.Label();
	self.removeLabel:SetParent(self.removeBackground);
	self.removeLabel:SetSize(138, 18);
	self.removeLabel:SetPosition(1, 1);
	self.removeLabel:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.removeLabel:SetText("Delete Skill");
	self.removeLabel:SetMouseVisible(false);
	self.removeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.removeLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.removeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	
	self.container:AddItem(self.skillNameContainer);

	self.container:AddItem(self.skillImageContainer);

	self.container:AddItem(self.skillPositionContainer);

	self.container:AddItem(self.skillResponsiveContainer);

	self.container:AddItem(self.skillVisibleContainer);

	self.container:AddItem(self.removeContainer);

end

function SkillNodeData:GetData()

	local name = self.skillNameValue:GetText();
	local icon = nil;
	if tonumber(self.skillImageValue:GetText()) then
		icon = tonumber(self.skillImageValue:GetText());
	else
		icon = self.skillImageValue:GetText();
	end
	local xpos = tonumber(self.skillXPosValue:GetText());
	local ypos = tonumber(self.skillYPosValue:GetText());
	local responsive = self.skillResponsive:IsChecked();
	local visible = self.skillVisible:IsChecked();

	return {name, icon, xpos, ypos, responsive, visible};
end