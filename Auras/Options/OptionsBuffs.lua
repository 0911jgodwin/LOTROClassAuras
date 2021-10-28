OptionsBuffs = class(Turbine.UI.Control);
function OptionsBuffs:Constructor()
	Turbine.UI.Control.Constructor(self);
	self.width = 200;
	self.height = 450;

	self.fontColor = Turbine.UI.Color(225/255,197/255,110/255);
	
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
	self:SetWidth(self.width);

	self.buffSettings = Turbine.UI.ListBox();
	self.buffSettings:SetParent(self);
	self.buffSettings:SetSize(310, 410);
	self.buffSettings:SetTop(30);
	self.buffSettings:SetMouseVisible(false);
	self.buffSettings:SetVisible(true);

	self.buffHeader = Header("Buff Settings", 310);
	self.buffSettings:AddItem(self.buffHeader);

	self.description = Turbine.UI.Label();
	self.description:SetMultiline( true );
	self.description:SetSize(310, 50);
	self.description:SetText("This options page allows you to add and remove buffs from the player buff bar");
	self.description:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.description:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.description:SetForeColor(self.fontColor);

	self.buffSettings:AddItem(self.description);


	self.treeContainer = Turbine.UI.Control();
	self.treeContainer:SetParent(self);
	self.treeContainer:SetSize(310, 300);
	--self.treeContainer:SetTop(130);
	self.treeContainer:SetVisible(true);
	self.buffSettings:AddItem(self.treeContainer);

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

	self.buffSettings:AddItem(self.horizontalRule);

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


	self.addEffectButton = Turbine.UI.Lotro.Button();
	self.addEffectButton:SetParent(self.buttonContainer);
	self.addEffectButton:SetPosition(0, 10);
	self.addEffectButton:SetText("Add New Effect");
	self.addEffectButton:SetSize(150, 20);

	self.addEffectButton.MouseClick = function(sender, args)
		self:AddEffect("Effect Name", "Icon Filepath", "0", "0");
	end

	self.buffSettings:AddItem(self.buttonContainer);
	self.loaded = true;
end

function OptionsBuffs:AddEffect(effectName, effectIcon)
	local effectData = {effectName, effectIcon};

	local effectNode = EffectNode(effectData[1]);

	local effectNodeData = EffectNodeData(effectData, self.treeView);

	self.treeView:GetNodes():Add(effectNode);
	effectNode:GetChildNodes():Add(effectNodeData);
end

function OptionsBuffs:SizeChanged(args)
	if self.loaded then
		self.buffSettings:SetLeft(GetMidpointPosition(self.buffSettings:GetWidth(), self:GetWidth()));
	end
end

function OptionsBuffs:SaveData()
	local nodeList = self.treeView:GetNodes();
	local data = {};
	local currentNode = nil;
	local currentData = nil;
	for i=1, nodeList:GetCount(), 1 do
		currentNode = nodeList:Get(i):GetChildNodes():Get(1);
		currentData = currentNode:GetData();
		data[currentData[1]] = currentData[2];
	end
	Settings["Class"][playerRole]["Buffs"] = data;
end

function OptionsBuffs:LoadData()
	local data = {};
	for key in pairs(Settings["Class"][playerRole]["Buffs"]) do
		table.insert(data, key);
	end

	for key, value in pairs(data) do
		self:AddEffect(value, Settings["Class"][playerRole]["Buffs"][value]);
	end
end

function OptionsBuffs:Reload()
	self.treeView:GetNodes():Clear();
	self:LoadData();
end

function OptionsBuffs:Unload()
	self.treeView:GetNodes():Clear();
	self.buffSettings:ClearItems();
end

EffectNode = class(Turbine.UI.TreeNode);
function EffectNode:Constructor(name)
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

	self.effectName = Turbine.UI.Label();
	self.effectName:SetParent(self.container);
	self.effectName:SetSize(200, 23);
	self.effectName:SetText(name);
	self.effectName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.effectName:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.effectName:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.effectName:SetPosition(50, 0);
	self.effectName:SetMouseVisible(false);

	self.plus = Turbine.UI.Control();
	self.plus:SetParent(self);
	self.plus:SetLeft(280);
	self.plus:SetTop(5);
	self.plus:SetSize(15,15);
	self.plus:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.plus:SetBackground(0x41007E27);
	self.plus:SetMouseVisible(false);
end

function EffectNode:SetName(name)
	self.effectName:SetText(name);
end

function EffectNode:MouseEnter(args)
	self.border:SetBackColor(Turbine.UI.Color(212/255,175/255,55/255));
end

function EffectNode:MouseLeave(args)
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
end

function EffectNode:MouseClick(args)
	if self.expanded then
		self.expanded = false;
		self.plus:SetBackground(0x41007E27);
	else
		self.expanded = true;
		self.plus:SetBackground(0x41007E26);
	end
end

EffectNodeData = class(Turbine.UI.TreeNode);
function EffectNodeData:Constructor(data, parent)
	Turbine.UI.TreeNode.Constructor(self);

	self.rootNode = parent;
	self.Data = data;

	self:SetSize(280, 92);

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetSize(280, 90);
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	self.border:SetMouseVisible(false);

	self.container = Turbine.UI.ListBox();
	self.container:SetParent(self.border);
	self.container:SetSize(278, 88);
	self.container:SetPosition(1,1);
	self.container:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.container:SetMouseVisible(false);

	self.padding = Turbine.UI.Control()
	self.padding:SetSize(278,10);

	self.container:AddItem(self.padding);

	--[<Effect Name>] = {<image ID>, <priority>, <stack number>}
	self.effectNameContainer = Turbine.UI.Control();
	self.effectNameContainer:SetSize(278, 25);

	self.effectNameLabel = Turbine.UI.Label();
	self.effectNameLabel:SetParent(self.effectNameContainer);
	self.effectNameLabel:SetSize(100, 25);
	self.effectNameLabel:SetLeft(5);
	self.effectNameLabel:SetText("Effect Name: ");
	self.effectNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.effectNameLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.effectNameValue = Turbine.UI.Lotro.TextBox();
	self.effectNameValue:SetParent(self.effectNameContainer);
	self.effectNameValue:SetSize(168, 18);
	self.effectNameValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.effectNameValue:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.effectNameValue:SetText(self.Data[1]);
	self.effectNameValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.effectNameValue:SetLeft(105);

	self.effectNameValue.FocusLost = function(sender, args)
		self:GetParentNode():SetName(self.effectNameValue:GetText());
	end

	self.effectImageContainer = Turbine.UI.Control();
	self.effectImageContainer:SetSize(278, 25);

	self.effectImageLabel = Turbine.UI.Label();
	self.effectImageLabel:SetParent(self.effectImageContainer);
	self.effectImageLabel:SetSize(100, 25);
	self.effectImageLabel:SetLeft(5);
	self.effectImageLabel:SetText("Icon Filepath: ");
	self.effectImageLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.effectImageLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.effectImageValue = Turbine.UI.Lotro.TextBox();
	self.effectImageValue:SetParent(self.effectImageContainer);
	self.effectImageValue:SetSize(168, 18);
	self.effectImageValue:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.effectImageValue:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.effectImageValue:SetText(self.Data[2]);
	self.effectImageValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.effectImageValue:SetLeft(105);

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
	self.removeLabel:SetText("Delete Effect");
	self.removeLabel:SetMouseVisible(false);
	self.removeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.removeLabel:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.removeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	
	self.container:AddItem(self.effectNameContainer);

	self.container:AddItem(self.effectImageContainer);

	self.container:AddItem(self.removeContainer);

end

function EffectNodeData:GetData()

	local name = self.effectNameValue:GetText();
	local icon = nil;
	if tonumber(self.effectImageValue:GetText()) then
		icon = tonumber(self.effectImageValue:GetText());
	else
		icon = self.effectImageValue:GetText();
	end

	return {name, icon};
end