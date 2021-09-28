_G.DragBar = class( Turbine.UI.Window );
function DragBar:Constructor(child, name)
	Turbine.UI.Window.Constructor( self );

	self.child = child;
	self.name = name;

	self.visible = false;
	self.draggable = false;

	self:SetVisible(false);
	self:SetMouseVisible(false);

	--The bar that will contain the gem and label, this is what people click and move.
	self.bar = Turbine.UI.Control();
	self.bar:SetParent(self);
	self.bar:SetMouseVisible(true);
	self.bar:SetVisible(true);
	self.bar.hovered = false;
	self.bar.dragging = false;

	self.bar.MouseEnter = function(sender, args)
		self.bar.hovered = true;
		self.shadowBox:SetVisible(true);
	end

	self.bar.MouseLeave = function(sender, args)
		self.bar.hovered = false;

		if not self.bar.dragging then
			self.shadowBox:SetVisible(false);
		end
	end

	self.bar.MouseDown = function(sender, args)
		if (args.Button == Turbine.UI.MouseButton.Left) then
			self.label:SetBackground("ExoPlugins/Auras/Resources/DragBar/BarClicked.tga");
			self.gem:SetBackground("ExoPlugins/Auras/Resources/DragBar/GemClicked.tga");
			self.startX = args.X;
			self.startY = args.Y;
			self.bar.dragging = true;
		end
	end


	self.bar.MouseUp = function(sender, args)
		if (args.Button == Turbine.UI.MouseButton.Left) then
			self.label:SetBackground("ExoPlugins/Auras/Resources/DragBar/Bar.tga");
			self.gem:SetBackground("ExoPlugins/Auras/Resources/DragBar/Gem.tga");
			self.bar.dragging = false;

			if not self.bar.hovered then
				self.shadowBox:SetVisible(false);
			end
		end
	end

	self.bar.MouseMove = function(sender, args)
		if self.bar.dragging then
			local left, top = self.child:GetPosition();
			local width, height = self:GetSize();
			local x = left + (args.X - self.startX);
			local y = top + (args.Y - self.startY);

			self.child:SetPosition(x, y);
			self:Layout();
		end
	end

	self.bar.SizeChanged = function(sender, args)
		local width, height = sender:GetSize();
		self.label:SetSize(width - 21, 20);
	end


	self.gem = Turbine.UI.Control();
	self.gem:SetParent( self.bar );
	self.gem:SetSize( 21, 20 );
	self.gem:SetBackground( "ExoPlugins/Auras/Resources/DragBar/Gem.tga" );
	self.gem:SetMouseVisible(false);

	self.label = Turbine.UI.Label();
	self.label:SetParent(self.bar);
	self.label:SetPosition(21, 0);
	self.label:SetMultiline(false);
	self.label:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.label:SetText(self.name);
	self.label:SetMouseVisible(false);
	self.label:SetBackground("ExoPlugins/Auras/Resources/DragBar/Bar.tga");

	self.shadowBox = Turbine.UI.Control();
	self.shadowBox:SetParent(self);
	self.shadowBox:SetPosition(0,20);
	self.shadowBox:SetMouseVisible(false);
	self.shadowBox:SetVisible(false);
	self.shadowBox.SizeChanged = function(sender, args)
		local width, height = sender:GetSize();

		self.top:SetWidth(width-20);
		self.right:SetHeight(height - 20);
		self.bottom:SetWidth(width-20);
		self.left:SetHeight(height - 20);

		self.topRight:SetPosition(width - 10, 0);
		self.right:SetPosition(width - 10, 10);
		self.bottomRight:SetPosition(width - 10, height - 10);
		self.bottom:SetPosition(10, height - 10);
		self.bottomLeft:SetPosition(0, height - 10);
	end

	self.topLeft = Turbine.UI.Control();
	self.topLeft:SetParent(self.shadowBox);
	self.topLeft:SetSize(10, 10);
	self.topLeft:SetMouseVisible(false);
	self.topLeft:SetBackground("ExoPlugins/Auras/Resources/DragBar/TopLeft.tga");

	self.top = Turbine.UI.Control();
	self.top:SetParent(self.shadowBox);
	self.top:SetPosition(10, 0);
	self.top:SetSize(10, 10);
	self.top:SetMouseVisible(false);
	self.top:SetBackground("ExoPlugins/Auras/Resources/DragBar/Top.tga");

	self.topRight = Turbine.UI.Control();
	self.topRight:SetParent(self.shadowBox);
	self.topRight:SetSize(10, 10);
	self.topRight:SetMouseVisible(false);
	self.topRight:SetBackground("ExoPlugins/Auras/Resources/DragBar/TopRight.tga");

	self.right = Turbine.UI.Control();
	self.right:SetParent(self.shadowBox);
	self.right:SetSize(10, 10);
	self.right:SetMouseVisible(false);
	self.right:SetBackground("ExoPlugins/Auras/Resources/DragBar/Right.tga");

	self.bottomRight = Turbine.UI.Control();
	self.bottomRight:SetParent(self.shadowBox);
	self.bottomRight:SetSize(10, 10);
	self.bottomRight:SetMouseVisible(false);
	self.bottomRight:SetBackground("ExoPlugins/Auras/Resources/DragBar/BottomRight.tga");

	self.bottom = Turbine.UI.Control();
	self.bottom:SetParent(self.shadowBox);
	self.bottom:SetSize(10, 10);
	self.bottom:SetMouseVisible(false);
	self.bottom:SetBackground("ExoPlugins/Auras/Resources/DragBar/Bottom.tga");

	self.bottomLeft = Turbine.UI.Control();
	self.bottomLeft:SetParent(self.shadowBox);
	self.bottomLeft:SetSize(10, 10);
	self.bottomLeft:SetMouseVisible(false);
	self.bottomLeft:SetBackground("ExoPlugins/Auras/Resources/DragBar/BottomLeft.tga");

	self.left = Turbine.UI.Control();
	self.left:SetParent(self.shadowBox);
	self.left:SetPosition(0, 10);
	self.left:SetSize(10, 10);
	self.left:SetMouseVisible(false);
	self.left:SetBackground("ExoPlugins/Auras/Resources/DragBar/Left.tga");



	self.KeyDown = function( sender, args )
		if args.Action == 0x1000007B then
			self:ToggleDraggable();
		elseif args.Action == 0x100000B3 then
			self:ToggleHUDVisible();
		end
	end

	self:SetWantsKeyEvents( true );
	self:Layout();
end

function DragBar:ToggleDraggable()
	if self.draggable == true then
		self.draggable = false;
	else
		self.draggable = true;
	end
	self:SetVisible(self.draggable);
end

function DragBar:ToggleHUDVisible()
	if self.visible == true then
		self.visible = false;
	else
		self.visible = true;
	end
	self.child:SetVisible(self.visible);
end

function DragBar:Layout()
	local width, height = self.child:GetSize();
	local x, y = self.child:GetPosition();

	self:SetSize(width, height + 20);
	self.bar:SetSize(width, 20);
	self.shadowBox:SetSize(width, height);

	self:SetPosition(x, math.max(y - 20, 0));
end