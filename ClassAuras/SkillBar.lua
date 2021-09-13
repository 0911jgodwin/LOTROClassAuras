SkillBar = class( Turbine.UI.Control );
function SkillBar:Constructor(parent, width, height, iconSize, alignment, showOffCD)
	Turbine.UI.Control.Constructor( self );

	self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible( true );

	self.iconSize = iconSize;
	self.showOffCD = showOffCD;

    self.activeSkills = {};
	self.activeCount = 0;
	self.skills = {};
	self.priority = {};
	self.skillCount = 0;

    if alignment == Turbine.UI.ContentAlignment.MiddleCenter then 
		self.SortSkills = function()
			local count = 0
			if self.showOffCD then
				for k,v in spairs(self.skills, function(t,a,b) return self.priority[b] > self.priority[a] end) do
					local position = (self:GetWidth() / 2) - ((self.iconSize / 2) * self.skillCount) + (count * self.iconSize);
					self.skills[k]:SetPosition(position, 0)
					count = count + 1;
				end
			else
				for k,v in spairs(self.activeSkills, function(t,a,b) return self.priority[b] > self.priority[a] end) do
					local position = (self:GetWidth() / 2) - ((self.iconSize / 2) * self.activeCount) + (count * self.iconSize);
					self.skills[k]:SetPosition(position, 0)
					count = count + 1;
				end
			end
		end
	elseif alignment == Turbine.UI.ContentAlignment.MiddleRight then
		self.SortSkills = function()
			local count = 0
			if self.showOffCD then
				for k,v in spairs(self.skills, function(t,a,b) return self.priority[b] > self.priority[a] end) do
					self.skills[k]:SetPosition(self:GetWidth() - (count * self.iconSize), 0)
					count = count + 1;
				end
			else
				for k,v in spairs(self.activeSkills, function(t,a,b) return self.priority[b] > self.priority[a] end) do
					self.skills[k]:SetPosition(self:GetWidth() - (count * self.iconSize), 0)
					count = count + 1;
				end
			end
		end
	else
		self.SortSkills = function()
			local count = 0
			if self.showOffCD then
				for k,v in spairs(self.skills, function(t,a,b) return self.priority[b] > self.priority[a] end) do
					self.skills[k]:SetPosition(count * self.iconSize, 0)
					count = count + 1;
				end
			else
				for k,v in spairs(self.activeSkills, function(t,a,b) return self.priority[b] > self.priority[a] end) do
					self.skills[k]:SetPosition(count * self.iconSize, 0)
					count = count + 1;
				end
			end
		end
	end

	if not self.showOffCD then
		self.UpdateHandler = function(delta)
			for key, value in pairs(self.activeSkills) do
				if self.skills[key]:Update(delta) then
					self.activeSkills[key] = nil;
					self.activeCount = self.activeCount - 1;
					self.skills[key]:SetVisible(false);
					self.SortSkills();
					if self.activeCount <= 0 then
						RemoveCallback(Updater, "Tick", self.UpdateHandler);
					end
				end
			end
		end
	else
		self.UpdateHandler = function(delta)
			for key, value in pairs(self.activeSkills) do
				self.skills[key]:Update(delta);
			end
		end
	end
end

function SkillBar:AddSkill( name, skill, priority )
	self.skillCount = self.skillCount + 1;
	self.skills[name] = skill;
	self.priority[name] = priority;
	if self.showOffCD then
		self.SortSkills();
	else
		self.skills[name]:SetVisible(false);
	end
end

function SkillBar:TriggerCooldown (name, cooldown)
	if self.skills[name]:SetCooldown(cooldown) then
		if self.activeSkills[name] then
			return;
		end
		self.activeSkills[name] = true;
		self.activeCount = self.activeCount + 1;
		if not self.showOffCD then
			self.skills[name]:SetVisible(true);
			self.SortSkills();
		end
		if self.activeCount == 1 then
			AddCallback(Updater, "Tick", self.UpdateHandler);
		end
	else
		if self.activeSkills[name] then
			self.activeSkills[name] = false;
			self.activeCount = self.activeCount - 1;
			if not self.showOffCD then
				self.skills[name]:SetVisible(false);
				self.SortSkills();
			end
			if self.activeCount <= 0 then
				RemoveCallback(Updater, "Tick", self.UpdateHandler);
			end
		end
	end
end

function SkillBar:ToggleHighlight (name, bool)
	if self.skills[name] then
		self.skills[name]:ToggleHighlight(bool);
	end
end

function SkillBar:ToggleActive (name, bool, timer)
	if self.skills[name] then
		if timer ~= nil then
			self.skills[name]:ToggleActive(bool, timer);
		else
			self.skills[name]:ToggleActive(bool);
		end
	end
end

function SkillBar:Unload()
	if self.activeCount > 0 then
		RemoveCallback(Updater, "Tick", self.UpdateHandler);
	end

	for key, value in pairs(self.activeSkills) do
		self.skills[key]:Unload();
	end
	self.activeSkills = {};
	self.activeCount = 0;
	self.skills = {};
	self.priority = {};
	self.skillCount = 0;
	self:SetParent(nil);
	self = nil;
end