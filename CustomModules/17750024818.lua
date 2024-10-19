-- bedwarz
<<<<<<< HEAD
repeat task.wait() until game:IsLoaded()
local GuiLibrary = shared.nonsense.lib;
local players = game:GetService("Players");
local textservice = game:GetService("TextService");
local repstorage = game:GetService("ReplicatedStorage");
local teleportservice = game:GetService("TeleportService");
local inputserv = game:GetService("UserInputService")
local lplr = players.LocalPlayer
=======
local GuiLibrary = shared.outerware.lib;
local starterPlayerService = game:GetService("StarterPlayer")
local playersService = game:GetService("Players");
local textservice = game:GetService("TextService");
local replicatedStorageService = game:GetService("ReplicatedStorage");
local lplr = playersService.LocalPlayer
>>>>>>> 63e3674edf757be7c475274885ac2138536634fb
local workspace = game:GetService("Workspace");
local lighting = game:GetService("Lighting");
local textchatservice = game:GetService("TextChatService");
local collectionservice = game:GetService("CollectionService");
local cam = workspace.CurrentCamera;
local nonsense = shared.nonsense;
local runser = game:GetService('RunService');
local vapeentity = shared.vapeentity;
local connections = {};
local void = nil

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

local warningNotification = function(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/WarningNotification.png");
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44);
		return frame;
	end)
	return (suc and res);
end

local infoNotification = function(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/InfoNotification.png");
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(255, 255, 255);
		return frame;
	end)
	return (suc and res);
end

local run = function(func)
	task.spawn(function()
		local v11, v22 = pcall(func)
		if not v11 then
			error('Run (Error) - ' .. v22 .. ' (a module didnt load.)');
		end 
	end)
end

GuiLibrary.RemoveObject("KillauraOptionsButton")
run(function()
    local Requeue = {Enabled = false}
    Requeue = nonsense.create.custom({
        Name = "Requeue",
        Function = function(callback)
            if callback then
				if lplr then
					teleportservice:Teleport(17750024818, lplr)
				end
				Requeue.ToggleButton(false)
            end
        end,
        HoverText = "requeue into a different match"
    })
end)

run(function()
    local autojoin = {}
    autojoin = nonsense.create.custom({
        Name = 'AutoJoin',
        Function = function(call)
            if call then
                table.insert(autojoin.Connections, runser.Heartbeat:Connect(function()
                    if tostring(lplr.Team) == 'Spectator' then
                        repstorage.Remotes.PlayerStartGame:InvokeServer('Join');
                    end;
                end));
            end;
        end,
        HoverText = 'Automatically joins the match regardless of the match ongoing.'
    });
end);

run(function()
    local Killaura = {Enabled = false};
	local Highlightt = {Enabled = false};
    local Distancee = {Value = 30};
    local oldpos = nil;
	local originalNeckC0 = nil;
	local highlight = nil;
	local closest = nil;
	local distance = nil;
	local issword = function()
		local hotbarItem = lplr.HotbarFolder['1']:GetAttribute('ItemName')
		return hotbarItem ~= nil
	end
	local target = nil
    Killaura = nonsense.create.custom({
        Name = "Killaura",
        Function = function(callback)
            if callback then
				task.spawn(function()
					repeat
						local swords = {
							getsword = lplr.HotbarFolder['1']:GetAttribute('ItemName'),
							hassword = function(plr)
								local hotbarItem = plr.HotbarFolder['1']:GetAttribute('ItemName')
								return hotbarItem ~= nil
							end
						};

						for i, v in players:GetPlayers() do
							if v == lplr then continue end
							distance = Distancee.Value
							if not v.Character or not v.Character:FindFirstChild("HumanoidRootPart") then continue end
							if (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude <= distance then
								closest = v
								distance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
							end
						end

						if vapeentity.isAlive then
							if closest.Character and Highlightt.Enabled and not closest.Character:FindFirstChild('targett') then
								highlight = Instance.new("Highlight")
								highlight.Name = "targett"
								highlight.Parent = closest.Character
								highlight.FillColor = Color3.new(1, 0.5, 0.5)
								highlight.OutlineColor = Color3.new(1, 0, 0)
								highlight.FillTransparency = 0.5
							else 
								if closest.Character and closest.Character:FindFirstChild('targett') then
									closest.Character.targett:Destroy()
								end
							end
							if closest.Character and hassword(lplr) and closest.Character:FindFirstChild('HumanoidRootPart') and closest.Character.HumanoidRootPart.Position.Y < Distancee.Value then
								repstorage.Remotes.ItemRemotes.SwordAttack:FireServer(Ray.new(cam.CFrame.Position, v.Character.HumanoidRootPart.Position).Unit.Direction, swords.getsword);
								task.wait(0.1)
							end
						end
						task.wait()
					until (not Killaura.Enabled)
				end)
            end
        end,
        HoverText = "aura moment"
    })
	Highlightt = Killaura.CreateToggle({
		Name = "Highlight",
		Function = function() end
	})
    Distancee = Killaura.CreateSlider({
        Name = "Distance",
        Min = 1,
        Max = 30,
        Function = function() end,
        Default = 8
    })
end)

run(function()
	local creditstealer = {Enabled = false};
	local remote = repstorage.Remotes:FindFirstChild('GiveTag') or nil
	creditstealer = nonsense.create.custom({
		Name = "CreditStealer",
		Function = function(callback)
			if callback then
				task.spawn(function()
					RunLoops:BindToRenderStep('risxf', function()
						for i,v in players:GetPlayers() do
							if v.Character and remote then
								remote:FireServer(v.Character, 'Sword')
							end	
						end
						task.wait()
					end)
				end)
            else
				RunLoops:UnbindFromRenderStep('risxf')
			end
		end,
		HoverText = "thats my credit moment"
	})
end)
