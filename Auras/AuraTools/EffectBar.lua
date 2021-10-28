_G.EffectBar = class(Turbine.UI.Control)
function EffectBar:Constructor( parent, width, height, alignment, iconSize )
	Turbine.UI.Control.Constructor(self);
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	self.iconSize = iconSize;
	self.effects = {};
	self.priority = {};
	self.activeEffects = {};
	self.activeCount = 0;

	if alignment == Turbine.UI.ContentAlignment.MiddleCenter then 
		self.SortEffects = function()
			local count = 0
			for k,v in spairs(self.activeEffects, function(t,a,b) return self.priority[b] > self.priority[a] end) do
				local position = (self:GetWidth() / 2) - ((self.iconSize / 2) * self.activeCount) + (count * self.iconSize);
				self.effects[k]:SetPosition(position, 0)
				count = count + 1;
			end
		end
	elseif alignment == Turbine.UI.ContentAlignment.MiddleRight then
		self.SortEffects = function()
			local count = 0
			for k,v in spairs(self.activeEffects, function(t,a,b) return self.priority[b] > self.priority[a] end) do
				self.effects[k]:SetPosition(self:GetWidth() - (count * self.iconSize), 0)
				count = count + 1;
			end
		end
	else
		self.SortEffects = function()
			local count = 0
			for k,v in spairs(self.activeEffects, function(t,a,b) return self.priority[b] > self.priority[a] end) do
				self.effects[k]:SetPosition(count * self.iconSize, 0)
				count = count + 1;
			end
		end
	end

	self.UpdateHandler = function(delta)
		for key, value in pairs(self.activeEffects) do
			if self.effects[key]:Update(delta) then
				self:SetInactive(key);
			end
		end
	end
end

function EffectBar:AddEffect( name, effect, priority )
	self.effects[name] = effect;
	self.priority[name] = priority;
end

function EffectBar:GetIconSize()
	return self.iconSize;
end

function EffectBar:SetActive( name, duration )
	--Check if effect is already active, if so we just want to update the timer
	if self.activeEffects[name] then
		self.effects[name]:StartTimer(duration);
		return;
	end

	self.activeEffects[name] = true;
	self.activeCount = self.activeCount + 1;

	self.effects[name]:SetVisible(true);
	self.effects[name]:StartTimer(duration);

	if self.activeCount == 1 then
		AddCallback(Updater, "Tick", self.UpdateHandler);
	end
	self.SortEffects();
end

function EffectBar:SetInactive( name )
	--If the effect is active do the thing
	if self.activeEffects[name] then
		self.activeEffects[name] = nil;
		self.effects[name]:SetVisible(false);
		self.activeCount = self.activeCount - 1;
		if self.activeCount <= 0 then
			RemoveCallback(Updater, "Tick", self.UpdateHandler);
		end
		self.SortEffects();
	end
end

function EffectBar:Unload()
	if self.activeCount > 0 then
		RemoveCallback(Updater, "Tick", self.UpdateHandler);
	end
	for key, value in pairs(self.effects) do
		self.effects[key]:Unload();
	end
	self.effects = {};
	self.priority = {};
	self.activeEffects = {};
	self:SetParent(nil);
	self = nil;
end

_G.EffectWindow = class(Turbine.UI.Window)
function EffectWindow:Constructor( parent, width, height, alignment, iconSize )
	Turbine.UI.Window.Constructor(self);
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	self.iconSize = iconSize;
	self.effects = {};
	self.durations = {};
	self.activeEffects = {};
	self.activeCount = 0;
	self.effectsPerRow = math.floor(width / iconSize);

	if alignment == Turbine.UI.ContentAlignment.MiddleCenter then 
		self.SortEffects = function()
			local count = 0
			self:UpdateDurations();
			for k,v in spairs(self.activeEffects, function(t,a,b) return self.durations[b] > self.durations[a] end) do
				local position = (self:GetWidth() / 2) - ((self.iconSize / 2) * self.activeCount) + (count * self.iconSize);
				self.effects[k]:SetPosition(position, 0)
				count = count + 1;
			end
		end
	elseif alignment == Turbine.UI.ContentAlignment.MiddleRight then
		self.SortEffects = function()
			local count = 0;
			local row = 1;
			self:UpdateDurations();
			for k,v in spairs(self.activeEffects, function(t,a,b) return self.durations[b] > self.durations[a] end) do
				if count > (self.effectsPerRow - 1) then
					count = 0;
					row = row + 1;
				end
				self.effects[k]:SetPosition(self:GetWidth() - ((count + 1) * self.iconSize), self:GetHeight()-(row * self.iconSize));
				count = count + 1;
			end
		end
	else
		self.SortEffects = function()
			local count = 0;
			local row = 1;
			self:UpdateDurations();
			for k,v in spairs(self.activeEffects, function(t,a,b) return self.durations[b] > self.durations[a] end) do
				if count > (self.effectsPerRow - 1) then
					count = 0;
					row = row + 1;
				end
				self.effects[k]:SetPosition(count * self.iconSize, self:GetHeight()-(row * self.iconSize));
				count = count + 1;
			end
		end
	end

	self.UpdateHandler = function(delta)
		for key, value in pairs(self.activeEffects) do
			if self.effects[key]:Update(delta) then
				self:SetInactive(key);
			end
		end
	end
end

function EffectWindow:AddEffect( name, effect )
	self.effects[name] = effect;
end

function EffectWindow:UpdateDurations()
	for key, value in pairs(self.activeEffects) do
		self.durations[key] = self.effects[key]:GetDuration();
	end
end

function EffectWindow:GetIconSize()
	return self.iconSize;
end

function EffectWindow:SetActive( name, duration )
	--Check if effect is already active, if so we just want to update the timer
	if self.activeEffects[name] then
		self.effects[name]:StartTimer(duration);
		self.SortEffects();
		return;
	end

	self.activeEffects[name] = true;
	self.activeCount = self.activeCount + 1;

	self.effects[name]:SetVisible(true);
	self.effects[name]:StartTimer(duration);

	if self.activeCount == 1 then
		AddCallback(Updater, "Tick", self.UpdateHandler);
	end
	self.SortEffects();
end

function EffectWindow:SetInactive( name )
	--If the effect is active do the thing
	if self.activeEffects[name] then
		self.activeEffects[name] = nil;
		self.effects[name]:SetVisible(false);
		self.activeCount = self.activeCount - 1;
		if self.activeCount <= 0 then
			RemoveCallback(Updater, "Tick", self.UpdateHandler);
		end
		self.SortEffects();
	end
end

function EffectWindow:Unload()
	if self.activeCount > 0 then
		RemoveCallback(Updater, "Tick", self.UpdateHandler);
	end
	for key, value in pairs(self.effects) do
		self.effects[key]:Unload();
	end
	self.effects = {};
	self.activeEffects = {};
	self.durations = {};
	self:SetParent(nil);
	self = nil;
end

function EffectWindow:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};

	Settings["General"]["Buffs"]["Position"] = Data;
end