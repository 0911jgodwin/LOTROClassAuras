_G.SkillBar = class( Turbine.UI.Control );
function SkillBar:Constructor(parent, width, height, rowInfo, rowCount, alignment)
	Turbine.UI.Control.Constructor( self );

	self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible( true );

	self.RowInfo = rowInfo;
	self.Skills = {};
	self.Grid = {};
	self.maxWidth = 0;
	self.maxHeight = rowCount;
	self.width = self:GetWidth();

	for i = 1, rowCount do
		self.Grid[i] = {};
	end
end

function SkillBar:AddSkill( name, skill, x, y )
	self.Skills[name] = skill;
	self.Grid[y][x] = name;
	if x > self.maxWidth then
		self.maxWidth = x;
	end
	self:Sort();
end

function SkillBar:TriggerCooldown (name, cooldown)
	self.Skills[name]:SetCooldown(cooldown);
end

function SkillBar:Sort()
	local count = 0
	local name = "";
	local yPosition = 0;
	local activeCount = 0;
	for row = 1, self.maxHeight do
		activeCount = self:GetActiveCount(row);
		for column = 1, self.maxWidth do
			name = self.Grid[row][column];
			if name ~= nil then
				if self.Skills[name]:IsVisible() then
					self.Skills[name]:SetPosition(self.width / 2 - self.RowInfo[row] / 2 * activeCount + count * self.RowInfo[row], yPosition);
					count = count + 1
				end
			end
		end
		yPosition = yPosition + (self.RowInfo[row] - math.ceil((self.RowInfo[row]/16)*3)) + 2;
		count = 0;
	end
end

function SkillBar:GetActiveCount(row)
	local activeCount = 0;
	for i = 1, self.maxWidth do
		skillName = self.Grid[row][i];
		if skillName ~= nil then
			if self.Skills[skillName]:IsVisible() then
				activeCount = activeCount + 1;
			end
		end
	end
	return activeCount;
end

function SkillBar:ToggleHighlight (name, bool)
	if self.Skills[name] then
		self.Skills[name]:ToggleHighlight(bool);
	end
end

function SkillBar:ToggleActive (name, bool, timer)
	if self.Skills[name] then
		if timer ~= nil then
			self.Skills[name]:ToggleActive(bool, timer);
		else
			self.Skills[name]:ToggleActive(bool);
		end
	end
end

function SkillBar:Unload()
	for key, value in pairs(self.Skills) do
		self.Skills[key]:Unload();
	end
	self.RowInfo = {};
	self.Skills = {};
	self.Grid = {};
	self:SetParent(nil);
	self = nil;
end