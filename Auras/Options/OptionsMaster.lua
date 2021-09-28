_G.OptionsMaster = class(Turbine.UI.Control)
function OptionsMaster:Constructor()
	Turbine.UI.Control.Constructor(self);

	self.tabs = {};
	self.activeTab = 0;
	self.tabCount = 0;

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetPosition(1,23);
	self.border:SetZOrder(-1);
	self.border:SetMouseVisible(false);
	self.border:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));

	local panel = Turbine.UI.Control();
	panel:SetSize(200, 300);
	panel:SetBackColor(Turbine.UI.Color(0,0,0));

	local generalOptions = OptionsGeneral();
	local procOptions = OptionsProcs();
	local skillOptions = OptionsSkills();
	self:AddTab("General", generalOptions);
	self:AddTab("Procs", procOptions);
	self:AddTab("Skills", skillOptions);

	self.resetTime = nil;
	self.ReloadHandler = function(delta)
			if self.resetTime ~= nil then
				if self.resetTime < Turbine.Engine.GetGameTime() then
					playerRole = GetRole();
					--for i=1, self.tabCount, 1 do
						--self.tabs[i]:Reload();
					--end
					self.tabs[2]:Reload();
					self.tabs[3]:Reload();
					self.resetTime = nil;
					RemoveCallback(Updater, "Tick", self.ReloadHandler);
				end
			else
				self.resetTime = Turbine.Engine.GetGameTime()+3;
			end
	end
end

function OptionsMaster:AddTab(tabName, tabContent)
	self.tabCount = self.tabCount + 1;

	local newTab = Tab(self, self.tabCount, tabName, tabContent);
	newTab:SetZOrder(2);
	table.insert(self.tabs, newTab);

	if self.tabCount == 1 then
		self:SelectTab(1);
	end
end

function OptionsMaster:SelectTab(tabIndex)
	if tabIndex == self.activeTab or tabIndex > self.tabCount then
		return; 
	end

	if self.activeTab ~= 0 then
		self.tabs[self.activeTab]:ToggleActive(false);
	end

	self.activeTab = tabIndex;

	local tab = self.tabs[self.activeTab];
	if tab ~= nil then
		tab:ToggleActive(true);
		self:SetHeight(tab:GetContentHeight()+31);
	end
	self:ConfigureLayout();
end

function OptionsMaster:SizeChanged(args)
	self:ConfigureLayout();
end

function OptionsMaster:ConfigureLayout()
	local width, height = self:GetSize();
	self.border:SetSize(width, height-29);
	self.tabs[self.activeTab].content:SetWidth(width-3);
end

function OptionsMaster:DeleteTabs()
	self.tabs = nil;
	collectgarbage();
end

function OptionsMaster:Unload()
	if self.resetTime ~= nil then
		RemoveCallback(Updater, "Tick", self.ReloadHandler);
	end
	self:SelectTab(1);
end

function OptionsMaster:Reload()
	playerRole = GetRole();
					--for i=1, self.tabCount, 1 do
						--self.tabs[i]:Reload();
					--end
	self.tabs[2]:Reload();
	self.tabs[3]:Reload();
	--AddCallback(Updater, "Tick", self.ReloadHandler);
end



----------------------------------------------------------
--		Tab Object that the Options Panel will use		--
----------------------------------------------------------
Tab = class(Turbine.UI.Control);
function Tab:Constructor(parent, tabIndex, tabName, tabContent)
	Turbine.UI.Control.Constructor(self);

	self.enabled = tabContent ~= nil;
	self.index = tabIndex;
	self.parent = parent;
	self.content = tabContent;
	self.active = false;

	if (self.enabled) then
		self.content:SetPosition(2,24);
	end

	self:SetMouseVisible(true);
	self:SetParent(self.parent);
	self:SetPosition((self.index-1) * 98, 2);
	self:SetSize(98,21);

	self.background = Turbine.UI.Control();
	self.background:SetParent(self);
	self.background:SetSize(98,21);
	self.background:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.background:SetMouseVisible(false);
	self.background:SetBackground("ExoPlugins/Auras/Resources/TabInactive.tga");

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetText(tabName);
	self.text:SetTop(1);
	self.text:SetSize(98,20);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.text:SetForeColor(Turbine.UI.Color(212/255,175/255,55/255));
	self.text:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.text:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.text:SetMouseVisible(false);
end

function Tab:ToggleActive(active)
	if active == self.active then
		return;
	end

	self.active = active;

	if self.active then
		self.text:SetForeColor(Turbine.UI.Color(1,1,1));
		self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		self.text:SetText(self.text:GetText());
		self.background:SetBackground("ExoPlugins/Auras/Resources/TabActive.tga");
		self.content:SetVisible(true);
		self.content:SetParent(self.parent);
	else
		self.text:SetForeColor(Turbine.UI.Color(212/255,175/255,55/255));
		self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
		self.text:SetText(self.text:GetText());
		self.background:SetBackground("ExoPlugins/Auras/Resources/TabInactive.tga");
		self.content:SetVisible(false);
		self.content:SetParent(nil);
	end
	
end

function Tab:GetContentHeight()
	return self.content:GetHeight();
end

function Tab:SetContentWidth(width)
	self.content:SetWidth(width);
end

function Tab:Reload()
	self.content:Reload();
end

function Tab:MouseEnter(args)
	if not self.active then
		self.text:SetForeColor(Turbine.UI.Color(1,1,1));
		self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
		self.text:SetText(self.text:GetText());
		self.background:SetBackground("ExoPlugins/Auras/Resources/TabActive.tga");
	end
end

function Tab:MouseLeave(args)
	if not self.active then
		self.text:SetForeColor(Turbine.UI.Color(212/255,175/255,55/255));
		self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
		self.text:SetText(self.text:GetText());
		self.background:SetBackground("ExoPlugins/Auras/Resources/TabInactive.tga");
	end
end

function Tab:MouseClick(args)
	self.parent:SelectTab(self.index);
end


----------------------------------------------------------
--	 Header Object that the Options Panel will use  	--
----------------------------------------------------------
Header = class(Turbine.UI.Control);
function Header:Constructor(title, width)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(width,30);

	self.label = Turbine.UI.Label();
	self.label:SetParent(self);
	self.label:SetSize(width,30);
	self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.label:SetForeColor(Turbine.UI.Color(1, 1, 1));
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.label:SetOutlineColor(Turbine.UI.Color(0, 0, 0));
    self.label:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.label:SetText(title);

	self.underline = Turbine.UI.Control();
	self.underline:SetParent(self);
	self.underline:SetSize(200,1);
	self.underline:SetBackColor(Turbine.UI.Color(0.75, 0.1, 0.25, 0.52));
	self.underline:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.underline:SetLeft((width/2)-100);
	self.underline:SetTop(28);
end