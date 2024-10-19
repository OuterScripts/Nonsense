-- a work in progress, code sucks

local scrg = Instance.new("ScreenGui");
local base = Instance.new("Frame");
local uicorner = Instance.new("UICorner");
local nonsense = Instance.new("TextLabel")
local seperate = Instance.new("Frame");
local sepcorner = Instance.new("UICorner");
local base2 = Instance.new("Frame");
local install = Instance.new("TextButton");
local sepcorner_2 = Instance.new("UICorner");
local textlabel = Instance.new("TextLabel");
local textlabel_2 = Instance.new("TextLabel");
local barholder = Instance.new("Frame");
local barholdcorner = Instance.new("UICorner");
local bar = Instance.new("Frame");
local barcorner = Instance.new("UICorner");
local dropshadowholder = Instance.new("Frame");
local dropshadow = Instance.new("ImageLabel");
local shadowgrad = Instance.new("UIGradient");
local bargradient = Instance.new("UIGradient");
local guigradient = Instance.new("UIGradient");

local players = game:GetService('Players');
local lplr = players.LocalPlayer;
local tweenservice = game:GetService('TweenService');

scrg.Parent = lplr.PlayerGui;
scrg.ZIndexBehavior = Enum.ZIndexBehavior.Global;
base.Name = "base";
base.Parent = scrg;
base.BackgroundColor3 = Color3.new(1, 1, 1);
base.Position = UDim2.new(0.354669005, 0, 0.350346029, 0);
base.Size = UDim2.new(0, 663, 0, 346);
uicorner.Parent = base;
nonsense.Name = "Nonsense";
nonsense.Parent = base;
nonsense.BackgroundColor3 = Color3.new(0, 0, 0);
nonsense.BackgroundTransparency = 1;
nonsense.Position = UDim2.new(0.348416299, 0, 0.0491329469, 0);
nonsense.Size = UDim2.new(0, 200, 0, 34);
nonsense.Font = Enum.Font.Gotham;
nonsense.Text = "Nonsense";
nonsense.TextColor3 = Color3.new(1, 1, 1);
nonsense.TextSize = 25;
seperate.Name = "seperate";
seperate.Parent = base;
seperate.BackgroundColor3 = Color3.new(1, 1, 1);
seperate.Position = UDim2.new(0.0180995483, 0, 0.182080925, 0);
seperate.Size = UDim2.new(0, 638, 0, 1);
sepcorner.Name = "sepcorner";
sepcorner.Parent = seperate;
sepcorner.CornerRadius = UDim.new(1, 0);
base2.Name = "base2";
base2.Parent = base;
base2.BackgroundColor3 = Color3.new(1, 1, 1);
base2.BackgroundTransparency = 1;
base2.Position = UDim2.new(0.0180995483, 0, 0.245664746, 0);
base2.Size = UDim2.new(0, 638, 0, 261);
install.Name = "install";
install.Parent = base2;
install.BackgroundColor3 = Color3.new(0, 1, 0.533333);
install.Position = UDim2.new(0.357288718, 0, 0.209221974, 0);
install.Size = UDim2.new(0, 182, 0, 65);
install.Visible = true;
install.Text = "";
sepcorner_2.Name = "sepcorner";
sepcorner_2.Parent = install;
sepcorner_2.CornerRadius = UDim.new(0, 4);
textlabel.Parent = install;
textlabel.BackgroundColor3 = Color3.new(1, 1, 1);
textlabel.BackgroundTransparency = 1;
textlabel.Position = UDim2.new(0.082417585, 0, 0.353846163, 0);
textlabel.Size = UDim2.new(0, 152, 0, 19);
textlabel.Font = Enum.Font.GothamBold;
textlabel.Text = "Install";
textlabel.TextColor3 = Color3.new(1, 1, 1);
textlabel.TextSize = 25;
textlabel_2.Parent = base2;
textlabel_2.BackgroundColor3 = Color3.new(1, 1, 1);
textlabel_2.BackgroundTransparency = 1;
textlabel_2.Position = UDim2.new(0.0454545468, 0, 0.57854408, 0);
textlabel_2.Size = UDim2.new(0, 581, 0, 50);
textlabel_2.Font = Enum.Font.Gotham;
textlabel_2.Text = "Please wait while we install Nonsense for you.";
textlabel_2.TextColor3 = Color3.new(1, 1, 1);
textlabel_2.TextSize = 18;
textlabel_2.TextTransparency = 1;
textlabel_2.TextYAlignment = Enum.TextYAlignment.Bottom;
barholder.Name = "barholder";
barholder.Parent = base2;
barholder.BackgroundColor3 = Color3.new(0, 0, 0);
barholder.BackgroundTransparency = 0.6000000238418579;
barholder.Position = UDim2.new(0.0517241396, 0, 0.83141762, 0);
barholder.Size = UDim2.new(0, 0, 0, 0);
barholdcorner.Name = "barholdcorner";
barholdcorner.Parent = barholder;
barholder.Visible = false;
bar.Name = "bar";
bar.Parent = barholder;
bar.BackgroundColor3 = Color3.new(1, 1, 1);
bar.Position = UDim2.new(-0.000631868315, 0, -0.00191752112, 0);
bar.Size = UDim2.new(0, 573, 0, 12);
barcorner.Name = "barcorner";
barcorner.Parent = bar;
dropshadowholder.Name = "dropshadowholder";
dropshadowholder.Parent = base;
dropshadowholder.BackgroundTransparency = 1;
dropshadowholder.Size = UDim2.new(1, 0, 1, 0);
dropshadowholder.ZIndex = 0;
dropshadow.Name = "dropshadow";
dropshadow.Parent = dropshadowholder;
dropshadow.AnchorPoint = Vector2.new(0.5, 0.5);
dropshadow.BackgroundTransparency = 1;
dropshadow.Position = UDim2.new(0.5, 0, 0.5, 0);
dropshadow.Size = UDim2.new(1, 47, 1, 47);
dropshadow.ZIndex = 0;
dropshadow.Image = "rbxassetid://6014261993";
dropshadow.ImageColor3 = Color3.new(0.639216, 0.635294, 0.647059);
dropshadow.ImageTransparency = 0.5;
dropshadow.ScaleType = Enum.ScaleType.Slice;
dropshadow.SliceCenter = Rect.new(49, 49, 450, 450);
shadowgrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 124, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(164, 61, 255))
};
shadowgrad.Rotation = 40;
shadowgrad.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.699999988079071),
	NumberSequenceKeypoint.new(1, 0.699999988079071)
};
shadowgrad.Name = "shadowgrad";
shadowgrad.Parent = dropshadow;
bargradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 124, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(67, 255, 192))
};
bargradient.Name = "bargradient";
bargradient.Parent = bar;
bargradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 124, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(164, 61, 255))
};
guigradient.Rotation = 40;
bargradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.699999988079071),
	NumberSequenceKeypoint.new(1, 0.699999988079071)
};
guigradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 124, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(67, 255, 192))
};
guigradient.Name = "guigradient";
guigradient.Parent = base;
guigradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 124, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(164, 61, 255))
};
guigradient.Rotation = 40;
guigradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.699999988079071),
	NumberSequenceKeypoint.new(1, 0.699999988079071)
};
base2.ClipsDescendants = true;

barholder.Size = UDim2.new(0, 0, 0, 12)
install.MouseButton1Click:Connect(function()
    local start = tweenservice:Create(install, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Position = UDim2.new(0.357288718, 0, 1.03297675, 0) })
    start:Play()
    start.Completed:Connect(function()
        barholder.Visible = true;
        tweenservice:Create(textlabel_2, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
        tweenservice:Create(barholder, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Size = UDim2.new(0, 573, 0, 12) }):Play()
        task.wait(0.3)

    end)
end)