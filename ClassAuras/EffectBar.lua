EffectBar = class(Turbine.UI.Control)
function EffectBar:Constructor( parent, width, height, alignment )
	Turbine.UI.Control.Constructor(self);
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetMouseVisible(false);
	self:SetVisible(true);

	self.iconSize = 32;
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
			--Updater.Unsubscribe(self);
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