-- bridge duel
local nonsense = shared.nonsense;
local gui = shared.GuiLibrary;
local players = game:GetService('Players');
local Players = players;
local replicatedstorage = game:GetService('ReplicatedStorage');
local proximityservice = game:GetService('ProximityPrompt');
local inputservice = game:GetService('UserInputService');
local inputserv = inputservice
local runser = game:GetService('runser');
local lplr = players.LocalPlayer;
local camera = workspace.CurrentCamera or workspace.Camera;
local mouse = lplr:GetMouse();
local destruct = false
local isAlive = function() end;
local tweenservice = game:GetService("TweenService")
local TweenService = tweenservice
local tweenService = tweenservice
local UserInputService = game:GetService("UserInputService")

local knit = replicatedstorage.Packages.Knit
local services = knit:WaitForChild('Services')
local toolservice = services:WaitForChild('ToolService')
local combatservice = services:WaitForChild("CombatService")

local store = {
	attackremote = toolservice:WaitForChild("RF").AttackPlayerWithSword,
	updaterotationremote = toolservice:WaitForChild("RF").UpdateHeadRotation,
	blockremote = toolservice:WaitForChild("RF").ToggleBlockSword,
	isBlocking = function()
        return lplr:GetAttribute("Blocking")
    end,
    isEating = function()
        return lplr:GetAttribute("Eating")
    end,
    isSlow = function()
        return lplr.Character.Humanoid.WalkSpeed <= 15 and true or false
    end
}

local vapeentity = shared.vapeentity
local whitelist = shared.vapewhitelist
local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = runser.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = runser.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = runser.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local run = function(func) task.spawn(pcall, func) end
local playerconnections = {}

local oldhp = lplr.Character.Humanoid.Health
table.insert(playerconnections, lplr.Character.Humanoid.HealthChanged:Connect(function(newhp)
    print('damage speed moment')
	local speed = tweenService:Create(lplr.Character.Humanoid, TweenInfo.new(1), {WalkSpeed = 35}) 
	if newhp < oldhp then
		speed:Play()
		speed.Completed:Connect(function()
			lplr.Character.Humanoid.WalkSpeed = 13
		end)
		oldhp = newhp
	elseif newhp > oldhp then
		oldhp = newhp
	end
end))

local getsword = function()
	return game.PlaceId == 11630038968 and 'WoodenSword' or 'Sword'
end
print(getsword())
local spoofSword = function()
	local tool = lplr.Character:FindFirstChildWhichIsA('Tool')
	local swordname = getsword()
	if tool.Name ~= swordname then
		tool.Parent = lplr.Backpack
		lplr.Backpack[swordname].Parent = lplr.Character
	end
end
local spoofItem = function(item)
	local item = lplr.Backpack:FindFirstChild(item)
	if item then
		item.Parent = lplr.Character
	end
end

local isAlive = function(p, n)
    local plr = p or lplr
    local alive = false
    if plr.Character and plr.Character:FindFirstChildWhichIsA('Humanoid') and plr.Character.PrimaryPart and plr.Character:FindFirstChild('Head') then 
        alive = true
    end
    local success, health = pcall(function() return plr.Character:FindFirstChildWhichIsA('Humanoid').Health end)
    if success and health <= 0 and not n then
        alive = false
    end
    return alive
end

local GetTarget = function(distance, healthmethod, raycast, npc, team)
    local magnitude, target = (distance or healthmethod and 0 or math.huge), {}
    for i,v in next, Players:GetPlayers() do 
        if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
            if healthmethod and v.Character.Humanoid.Health < magnitude then 
                magnitude = v.Character.Humanoid.Health
                target.Human = true
                target.RootPart = v.Character.HumanoidRootPart
                target.Humanoid = v.Character.Humanoid
                target.Player = v
				target.Character = v.Character
                continue
            end 
            local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if playerdistance < magnitude then 
                magnitude = playerdistance
                target.Human = true
                target.RootPart = v.Character.HumanoidRootPart
                target.Humanoid = v.Character.Humanoid
                target.Player = v
				target.Character = v.Character
            end
        end
    end
    return target
end

local GetAllTargets = function(distance, sort)
    local targets = {}
    for i,v in Players:GetPlayers() do 
        if v ~= lplr and isAlive(v) and isAlive(lplr, true) and v.Team ~= lplr.Team then 
            local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if playerdistance <= (distance or math.huge) then
                table.insert(targets, {Human = true, RootPart = v.Character.PrimaryPart, Humanoid = v.Character.Humanoid, Player = v})
            end
        end
    end
    if sort then 
        table.sort(targets, sort)
    end
    return targets
end

run(function() -- made by outer in the sigma 5.0 project.
    local keystroke = {}
    local autojoin = {}
    local Keystrokes = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local S = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local W = Instance.new("Frame")
    local TextLabel_2 = Instance.new("TextLabel")
    local L = Instance.new("Frame")
    local TextLabel_3 = Instance.new("TextLabel")
    local R = Instance.new("Frame")
    local TextLabel_4 = Instance.new("TextLabel")
    local A = Instance.new("Frame")
    local TextLabel_5 = Instance.new("TextLabel")
    local D = Instance.new("Frame")
    local TextLabel_6 = Instance.new("TextLabel")
    
    Keystrokes.Name = "Keystrokes"
    Keystrokes.Parent = lplr.PlayerGui
    Keystrokes.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Keystrokes.ResetOnSpawn = false
    Keystrokes.Enabled = false
    Frame.Parent = Keystrokes
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BackgroundTransparency = 1
    Frame.BorderColor3 = Color3.new(0, 0, 0)
    Frame.Position = UDim2.new(0.406093687, 0, 0.362694293, 0)
    Frame.Size = UDim2.new(0, 212, 0, 212)
    S.Name = "S"
    S.Parent = Frame
    S.BackgroundColor3 = Color3.new(0, 0, 0)
    S.BackgroundTransparency = 0.4000000059604645
    S.BorderColor3 = Color3.new(0, 0, 0)
    S.Position = UDim2.new(0.338648677, 0, 0.3398996, 0)
    S.Size = UDim2.new(0, 67, 0, 67)
    TextLabel.Parent = S
    TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0.256396621, 0, 0.262082219, 0)
    TextLabel.Size = UDim2.new(0, 31, 0, 31)
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.Text = "S"
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextSize = 30
    W.Name = "W"
    W.Parent = Frame
    W.BackgroundColor3 = Color3.new(0, 0, 0)
    W.BackgroundTransparency = 0.4000000059604645
    W.BorderColor3 = Color3.new(0, 0, 0)
    W.Position = UDim2.new(0.338648677, 0, -0.00230551674, 0)
    W.Size = UDim2.new(0, 67, 0, 67)
    TextLabel_2.Parent = W
    TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel_2.Position = UDim2.new(0.256396621, 0, 0.262082458, 0)
    TextLabel_2.Size = UDim2.new(0, 31, 0, 31)
    TextLabel_2.Font = Enum.Font.Gotham
    TextLabel_2.Text = "W"
    TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
    TextLabel_2.TextSize = 30
    L.Name = "L"
    L.Parent = Frame
    L.BackgroundColor3 = Color3.new(0, 0, 0)
    L.BackgroundTransparency = 0.4000000059604645
    L.BorderColor3 = Color3.new(0, 0, 0)
    L.Position = UDim2.new(-0.00200000009, 0, 0.683102012, 0)
    L.Size = UDim2.new(0, 104, 0, 67)
    TextLabel_3.Parent = L
    TextLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel_3.BackgroundTransparency = 1
    TextLabel_3.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel_3.Position = UDim2.new(0.342935115, 0, 0.262082696, 0)
    TextLabel_3.Size = UDim2.new(0, 31, 0, 31)
    TextLabel_3.Font = Enum.Font.Gotham
    TextLabel_3.Text = "L"
    TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
    TextLabel_3.TextSize = 30
    R.Name = "R"
    R.Parent = Frame
    R.BackgroundColor3 = Color3.new(0, 0, 0)
    R.BackgroundTransparency = 0.4000000059604645
    R.BorderColor3 = Color3.new(0, 0, 0)
    R.BorderSizePixel = 0
    R.Position = UDim2.new(0.50748831, 0, 0.683286011, 0)
    R.Size = UDim2.new(0, 104, 0, 67)
    TextLabel_4.Parent = R
    TextLabel_4.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel_4.BackgroundTransparency = 1
    TextLabel_4.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel_4.Position = UDim2.new(0.345505506, 0, 0.262082696, 0)
    TextLabel_4.Size = UDim2.new(0, 31, 0, 31)
    TextLabel_4.Font = Enum.Font.Gotham
    TextLabel_4.Text = "R"
    TextLabel_4.TextColor3 = Color3.new(1, 1, 1)
    TextLabel_4.TextSize = 30
    A.Name = "A"
    A.Parent = Frame
    A.BackgroundColor3 = Color3.new(0, 0, 0)
    A.BackgroundTransparency = 0.4000000059604645
    A.BorderColor3 = Color3.new(0, 0, 0)
    A.BorderSizePixel = 0
    A.Position = UDim2.new(-0.000652097282, 0, 0.338416904, 0)
    A.Size = UDim2.new(0, 67, 0, 67)
    TextLabel_5.Parent = A
    TextLabel_5.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel_5.BackgroundTransparency = 1
    TextLabel_5.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel_5c
    TextLabel_5.Position = UDim2.new(0.25639686, 0, 0.247156858, 0)
    TextLabel_5.Size = UDim2.new(0, 31, 0, 31)
    TextLabel_5.Font = Enum.Font.Gotham
    TextLabel_5.Text = "A"
    TextLabel_5.TextColor3 = Color3.new(1, 1, 1)
    TextLabel_5.TextSize = 30
    D.Name = "D"
    D.Parent = Frame
    D.BackgroundColor3 = Color3.new(0, 0, 0)
    D.BackgroundTransparency = 0.4000000059604645
    D.BorderColor3 = Color3.new(0, 0, 0)
    D.BorderSizePixel = 0
    D.Position = UDim2.new(0.679251611, 0, 0.337691963, 0)
    D.Size = UDim2.new(0, 67, 0, 67)
    TextLabel_6.Parent = D
    TextLabel_6.BackgroundColor3 = Color3.new(1, 1, 1)
    TextLabel_6.BackgroundTransparency = 1
    TextLabel_6.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel_6.BorderSizePixel = 0
    TextLabel_6.Position = UDim2.new(0.25639686, 0, 0.262082219, 0)
    TextLabel_6.Size = UDim2.new(0, 31, 0, 31)
    TextLabel_6.Font = Enum.Font.Gotham
    TextLabel_6.Text = "D"
    TextLabel_6.TextColor3 = Color3.new(1, 1, 1)
    TextLabel_6.TextSize = 30
    local dragging
    local draginput
    local dragstart
    local startposition
    keystroke = nonsense.create.custom({
        Name = 'Keystrokes',
        Function = function(call)
            Keystrokes.Enabled = call
            if call then
                local airplane = function(input)
                    if input.KeyCode == Enum.KeyCode.W then
                        tweenservice:Create(W, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                    elseif input.KeyCode == Enum.KeyCode.A then
                        tweenservice:Create(A, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                    elseif input.KeyCode == Enum.KeyCode.S then
                        tweenservice:Create(S, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                    elseif input.KeyCode == Enum.KeyCode.D then
                        tweenservice:Create(D, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        tweenservice:Create(L, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        tweenservice:Create(R, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
                    end
                end
                
                local aferhg = function(input)
                    if input.KeyCode == Enum.KeyCode.W then
                        tweenservice:Create(W, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()
                    elseif input.KeyCode == Enum.KeyCode.A then
                        tweenservice:Create(A, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()
                    elseif input.KeyCode == Enum.KeyCode.S then
                        tweenservice:Create(S, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()
                    elseif input.KeyCode == Enum.KeyCode.D then
                        tweenservice:Create(D, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        tweenservice:Create(L, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        tweenservice:Create(R, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()
                    end
                end
                
                local update = function(input)
                    tweenservice:Create(Frame, TweenInfo.new(0.3), {Position = UDim2.new(startposition.X.Scale, startposition.X.Offset + input.Position - dragstart.X, startposition.Y.Scale, startposition.Y.Offset + input.Position - dragstart.Y)}):Play()
                end
                Frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragstart = input.Position
                        startposition = Frame.Position
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)
                
                Frame.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        draginput = input
                    end
                end)
                inputserv.InputChanged:Connect(function(input)
                    if dragging and input == draginput then
                        update(input)
                    end
                end)
                inputserv.InputBegan:Connect(airplane)
                inputserv.InputEnded:Connect(aferhg)		
            else
                Keystrokes:Destroy()	
            end
        end
    })
end)

})
local findfirstsword = function(typ)
	if typ == 'boolean' then
		return lplr.Character:FindFirstChild(getsword()) and true or false
	else
		return lplr.Character:FindFirstChild(getsword()) and getsword() or ''
	end
end

run(function()
    local isrunning = false
    local currenthold
    local range = {Value = 25}
    local aple = {Enabled = false}
    local attacking
    local viewmodel
    local oldweld
    local projaura = {Enabled = false}
    local killaura = {}
    local animations = {
        sigma5 = {
            {CFrame = CFrame.new(0, 0.25, 2.5) * CFrame.Angles(math.rad(-40), math.rad(60), math.rad(110)), Time = 0.08},
            {CFrame =  CFrame.new(0,-1.25,2.5) * CFrame.Angles(math.rad(-40), math.rad(60), math.rad(170)), Time = 0.16}
        }
    }
    local killauraconnection = {
        Block = function(bool, item)
            bool = bool or true
            item = item or getsword()
            store.blockremote:InvokeServer(bool, item)
        end
    }
    local blocking = false
    local block = function()
        local shouldBlock = true
        killauraconnection.Block(shouldBlock, findfirstsword())
        blocking = shouldBlock
    end
    local wsfd = function()
        for i,v in camera.Viewmodel:GetChildren() do
            if i == 10 then currenthold = v break end		
        end
    end
    local attacking = false
    local unblock = function()
        local shouldBlock = false
        killauraconnection.Block(shouldBlock, findfirstsword())
        blocking = shouldBlock
    end
    local killaurabox = nil
    wsfd()
    local animationplaying = false
    killaura = nonsense.create.custom({
		Name = "Killaura",
		Function = function(call)
			if call then
                if oldweld then
                    tweenservice:Create(currenthold.Handle.MainPart, TweenInfo.new(0.35), {C0 = oldweld}):Play()
                end
                task.spawn(function()
                    oldweld = currenthold.Handle.MainPart.C0
                end)
                task.spawn(function()
                    RunLoops:BindToRenderStep('ka', function()
                        task.spawn(function()
                            local plr = GetTarget(range.Value)
                            if plr.Character and whitelist:get(plr) < whitelist:get(lplr) then
                                store.attackremote:InvokeServer(plr.Character, true, getsword())
                                task.spawn(wsfd)
                                task.spawn(spoofSword)
                                if aple.Enabled then
                                    task.spawn(function()
                                        pcall(function()
                                            if not killaurabox then
                                                killaurabox = Instance.new('Part', plr.Character)
                                                killaurabox.Material = Enum.Material.Neon
                                                killaurabox.Transparency = 0.5
                                                killaurabox.Color = Color3.fromRGB(0, 166, 253)
                                                killaurabox.CanCollide = false
                                                killaurabox.Anchored = true
                                                killaurabox.Size = Vector3.new(4,6,4)
                                                killaurabox.Position = plr.RootPart.Position
                                            end
                                            if killaurabox.Parent ~= plr.Character then
                                                killaurabox:Remove()
                                                killaurabox = Instance.new('Part', plr.Character)
                                                killaurabox.Material = Enum.Material.Neon
                                                killaurabox.Transparency = 0.5
                                                killaurabox.Color = Color3.fromRGB(0, 166, 253)
                                                killaurabox.CanCollide = false
                                                killaurabox.Anchored = true
                                                killaurabox.Size = Vector3.new(4,6,4)
                                                killaurabox.Position = plr.RootPart.Position
                                            end
                                            killaurabox.Position = plr.RootPart.Position
                                        end)
                                    end)
                                end
                                attacking = true
                                task.spawn(block)
                                if not animationplaying then
                                    animationplaying = true
                                    for i,v in animations.sigma5 do
                                        if not animationplaying then return end
                                        tweenService:Create(currenthold.Handle.MainPart, TweenInfo.new(v.Time), {C0 = oldweld * v.CFrame}):Play()
                                        task.wait(v.Time)
                                    end
                                    animationplaying = false
                                end
                            else
                                task.spawn(unblock)
                                animationplaying = false
                                killaurabox:Remove()
                                attacking = false
                                tweenservice:Create(currenthold.Handle.MainPart, TweenInfo.new(0.35), {C0 = oldweld}):Play()
                            end
                        end)
                    end)
                end)
            else
                funclib.endLoop('ka')
                killaurabox:Remove()
                isrunning = false
                animationplaying = false
                attacking = false
                tweenservice:Create(currenthold.Handle.MainPart, TweenInfo.new(0.35), {C0 = oldweld}):Play()
            end
        end
    })
    range = killaura.CreateSlider({
        Name = "Range",
        Min = 1,
        Max = 50,
        Function = function(val) end,
        Default = 25,
        HoverText = "Range of the opponent."
    })
    aple = killaura.CreateToggle({
		Name = "Killaura Box",
		Function = function() end,
		HoverText = "uh box around target (circle soon :pray:)",
		Default = true
	})
end)

local fovchanger = {};
local oldfov = camera.FieldOfView
fovchanger = object.player.createobject({
	name = 'FOVChanger',
	call = function(call)
		if call then
			RunLoops:BindToRenderStep('fov', function()
				camera.FieldOfView = 120
			end)
		else
			funclib.endLoop('fov')
		end
	end
})

local velocityused = false
local velocity = {}
velocity = object.combat.createobject({
    name = 'Velocity',
    call = function(call)
		if call then 
			combatservice:WaitForChild("RE").KnockBackApplied:Destroy()
		end
    end
})

local OldRoot
local NewRoot
-- by qwerty thanks for the clone
local function CreateClonedCharacter()
	lplr.Character.Parent = game
	print('1')
	lplr.Character.HumanoidRootPart.Archivable = true
	OldRoot = lplr.Character.HumanoidRootPart 
	NewRoot = OldRoot:Clone()
	print('2')
	NewRoot.Parent = lplr.Character
	OldRoot.Parent = workspace
	lplr.Character.PrimaryPart = NewRoot
	print('3')
	lplr.Character.Parent = workspace
	OldRoot.Transparency = 0.4
	print("Created clone character")
end

local function RemoveClonedCharacter()
	OldRoot.Transparency = 1
	lplr.Character.Parent = game
	OldRoot.Parent = lplr.Character
	NewRoot.Parent = workspace
	lplr.Character.PrimaryPart = OldRoot
	lplr.Character.Parent = workspace
	NewRoot:Remove()
	NewRoot = {} 
	OldRoot = {}
	OldRoot.CFrame = NewRoot.CFrame
	print("Destroyed clone character")
end
local pingspoof = { -- ty qwerty
	connection = nil
}
local clonepos
local bticks = 0
local Blinking = false
local show = false

local function roundup(num)
	return math.ceil(num)
end

local delayValue = 65

if not sigma.cheatengine then
	pingspoof = object.world.createobject({
		Name = "PingSpoof",
		Function = function(callback)
			pingspoofboost = callback
			if callback then
				bticks = 0
				RunLoops:BindToRenderStep("PingSpoof",function()
					bticks = bticks + 1
					if isAlive(lplr) then
						if bticks >= (delayValue) then
							print('false')
							sethiddenproperty(lplr.Character.HumanoidRootPart, "NetworkIsSleeping", false)
							bticks = 0
							Blinking = false
							show = true
						else
							print(true)
							sethiddenproperty(lplr.Character.HumanoidRootPart, "NetworkIsSleeping", true)
							Blinking = true
							show = false
						end
					end
				end)
			else
				funclib.endLoop("PingSpoof")
			end
		end,
		Info = "Fakes high ping"
	})
end
local groundnottouched = false
local speed
speed = object.movement.createobject({ 
	name = 'Speed',
	call = function(call)
		if call then
			local raycastparameters = RaycastParams.new()
			RunLoops:BindToRenderStep("Speed", function(time, delta)
				lplr.Character.Humanoid.WalkSpeed = 13
                local newpos = (lplr.Character.Humanoid.MoveDirection * 15 * delta)
                raycastparameters.FilterDescendantsInstances = {lplr.Character}
                local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, newpos, raycastparameters)
                if ray then newpos = (ray.Position - lplr.Character.HumanoidRootPart.Position) end
                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newpos
				if attacking then
					if speed.Enabled then
						local customjump = tweenService:Create(lplr.Character.Humanoid, TweenInfo.new(0.2), {WalkSpeed = 35})
						if lplr.Character.Humanoid.FloorMaterial == Enum.Material.Air and lplr.Character.Humanoid.MoveDirection ~= Vector3.zero and fakejumped then
							customjump:Play()
						end

						customjump.Completed:Connect(function()
							lplr.Character.Humanoid.WalkSpeed = 13
						end)
						
						if lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
							customjump:Cancel()
							customjump = tweenService:Create(lplr.Character.Humanoid, TweenInfo.new(0.2), {WalkSpeed = 35})
						end
						if lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and lplr.Character.Humanoid.MoveDirection ~= Vector3.zero then
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 36, lplr.Character.HumanoidRootPart.Velocity.Z)
						end
						if lplr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
							fakejumped = true
						else
							fakejumped = false
						end
					end
				end
			end)
		else
			funclib.endLoop("Speed")
			lplr.Character.Humanoid.WalkSpeed = 16
			raycastparameters:Destroy()
		end
	end,
	info = 'Makes you run faster than others'
})

local antivoid = {
	connection = nil
};
local antivoidpart;
antivoid = object.world.createobject({
	name = 'AntiVoid',
	call = function(call)
		if call then
			task.spawn(function()
				antivoidpart = Instance.new('Part')
				antivoidpart.Size = Vector3.new(9e9, 2, 9e9)
				antivoidpart.Anchored = true
				antivoidpart.Transparency = 0.95
				antivoidpart.Position = (lplr.Character.HumanoidRootPart.Position - Vector3.new(0, 32, 0))
				antivoidpart.Parent = workspace
				antivoidpart.CanCollide = false
				antivoid.connection = antivoidpart.Touched:Connect(function(touchedParent)
					if touchedParent.Parent == lplr.Character and isAlive(lplr) then
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 120, 0)
					end
				end)
			end)
		else
			antivoidpart:Destroy()
		end
	end,
    Info = 'Prevents you from falling into the void.'
})

projaura = object.combat.createobject({
	name = 'AutoShoot',
	call = function(call)
		if call then
			task.spawn(function()
				repeat
					local target = GetTarget(100)
					if target.Character then
						spoofItem('DefaultBow')
						task.spawn(function() camera.Viewmodel:FindFirstChild('DefaultBow'):Remove() end)
						local args = {
							[1] = target.RootPart.Position + Vector3.new(-2, -1, 0),
							[2] = 100
						}
						
						lplr.Character.DefaultBow.__comm__.RF.Fire:InvokeServer(unpack(args))	
					end
					task.wait(1)
				until (not projaura.Enabled)
			end)
		end
	end
})


local airjump = {
	connection = nil
};
airjump = object.player.createobject({
	name = 'AirJump',
	call = function(call)
		if call then
			airjump.connection = inputservice.JumpRequest:Connect(function()
				lplr.Character.Humanoid:ChangeState('Jumping')
			end)
		else
			airjump.connection:Disconnect()
		end
	end,
	Info = 'Unlimited Jump Attempt.'
})

local NoSlowdown = {}
NoSlowdown = object.player.createobject({
	Name = "NoSlowdown",
	Function = function(call)
		if call then
			RunLoops:BindToRenderStep('NoSlow', function()
				if store.isBlocking() or store.isEating() or store.isSlow() then
					lplr.Character.Humanoid.WalkSpeed = 16.83
				end
			end)
		else
			funclib.endLoop("NoSlow")
		end
	end
})

local viewmodelmod = {};
viewmodelmod = object.item.createobject({
	name = 'ViewModelMod',
	call = function(call)
		if call then
			RunLoops:BindToRenderStep('vmod', function()
				getViewModel()
				if not attacking then 
					currenthold.MainPart.Mesh.Offset = Vector3.new(6,-3,5) 
				else
					currenthold.MainPart.Mesh.Offset = Vector3.new(0,0,0) 
				end
			end)
		else
			funclib.endLoop('vmod')
			currenthold.MainPart.Mesh.Offset = Vector3.new(0,0,0) 
		end
	end
})

run(function()
    local Fly = {Enabled = false, Connections = {}}
    local VerticalSpeed = {Value = 75}
    local YCFrame = 0
    local FlyUp = false
    local FlyDown = false

    Fly = object.movement.createobject({
        Name = "Fly",
        Function = function(callback)
            if callback then
				table.insert(Fly.Connections, inputserv.InputBegan:Connect(function(input1)
					if inputserv:GetFocusedTextBox() ~= nil then return end
                    if input1.KeyCode == Enum.KeyCode.Space then
                        FlyUp = true
                    elseif input1.KeyCode == Enum.KeyCode.LeftShift then
                        FlyDown = true
                    end
				end))
				table.insert(Fly.Connections, inputserv.InputEnded:Connect(function(input1)
                    if input1.KeyCode == Enum.KeyCode.Space then
						FlyUp = false
					elseif input1.KeyCode == Enum.KeyCode.LeftShift then
						FlyDown = false
					end
				end))
				if inputserv.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						table.insert(Fly.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
							FlyUp = jumpButton.ImageRectOffset.X == 146
						end))
						FlyUp = jumpButton.ImageRectOffset.X == 146
					end)
				end
                YCFrame = lplr.Character.HumanoidRootPart.CFrame.Y
                RunLoops:BindToRenderStep('Flight',function()
                    if FlyUp then
                        YCFrame += VerticalSpeed.Value
                    elseif FlyDown then
                        YCFrame -= VerticalSpeed.Value
                    end
                    local cframe = {lplr.Character.HumanoidRootPart.CFrame:GetComponents()}
                    cframe[2] = YCFrame
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(unpack(cframe))
                    local velo = lplr.Character.HumanoidRootPart.Velocity
                    lplr.Character.HumanoidRootPart.Velocity = Vector3.new(velo.X, 0, velo.Z)
                end)
            else
				FlyUp = false
				FlyDown = false
                funclib.endLoop('Flight')
            end
        end,
		bind = Enum.KeyCode.G
    })
end)