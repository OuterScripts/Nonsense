-- bedwarz
local GuiLibrary = shared.outerware.lib;
local players = game:GetService("Players");
local textservice = game:GetService("TextService");
local repstorage = game:GetService("ReplicatedStorage");
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace");
local lighting = game:GetService("Lighting");
local textchatservice = game:GetService("TextChatService");
local collectionservice = game:GetService("CollectionService");
local cam = workspace.CurrentCamera;
local outerware = shared.outerware;
local vapeentity = shared.vapeentity;

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
	local v11, v22 = pcall(func)
	if not v11 then
		error('Run (Error) - ' .. v22 .. ' (a module didnt load.)');
	end 
end

GuiLibrary.RemoveObject("ClientKickDisablerOptionsButton")
run(function()
	local nofall = {Enabled = false}
    local falll = game:GetService("StarterPlayer").StarterCharacterScripts.FallDamage
	nofall = outerware.create.custom({
		Name = "NoFall",
		Function = function(callback)
			if callback then
                repeat
                    if falll then
                        falll:Destroy()
                    end
					task.wait()
                until (not nofall.Enabled)
            end
		end,
		HoverText = "no fall damage moment"
	})
end)

run(function()
	local AntiRecover = {Enabled = false}
    local pathh = repstorage.Remotes.CheckAnticheat
	AntiRecover = outerware.create.custom({
		Name = "AntiRecover",
		Function = function(callback)
			if callback then
                repeat
                    if pathh then
                        pathh = function() end
                        pathh:Destroy()
                    end
					task.wait()
                until (not AntiRecover.Enabled)
            end
		end,
		HoverText = "doesnt allow the anticheat to recover itsself."
	})
end)

run(function()
	local Disabler = {Enabled = false}
    local ac = game:GetService("StarterPlayer").StarterCharacterScripts.Anticheat
	Disabler = outerware.create.custom({
		Name = "Disabler",
		Function = function(callback)
			if callback then
                repeat
                    if not GuiLibrary.ObjectsThatCanBeSaved.AntiRecoverOptionsButton.Api.Enabled then
                        GuiLibrary.ObjectsThatCanBeSaved.AntiRecoverOptionsButton.Api.ToggleButton(false)
                    end
                    if ac then
                        ac:Destroy()
                    end
					task.wait()
                until (not Disabler.Enabled)
            end
		end,
		HoverText = "disabler moment"
	})
end)

run(function()
	local InfiniteAura = {Enabled = false}
    local attackmoment = repstorage.Remotes.ItemRemotes.SwordAttack2
	local oldpos
    local getsword = function()
        local gear = lplr.StarterGear
        return gear["Wooden Sword"] and 'Wooden Sword' or gear["Iron Sword"] and 'Iron Sword' or gear["Diamond Sword"] and 'Diamond Sword' or gear["Emerald Sword"] and 'Emerald Sword' or ''
    end
    local issword = function()
        local gear = lplr.StarterGear
        return gear["Wooden Sword"] or gear["Iron Sword"] or gear["Diamond Sword"] or gear["Emerald Sword"] and true or false
    end
	InfiniteAura = outerware.create.custom({
		Name = "InfiniteAura",
		Function = function(callback)
			if callback then
                if (not GuiLibrary.ObjectsThatCanBeSaved.DisablerOptionsButton.Api.Enabled) then
                    warningNotification('InfiniteAura', 'Enable disabler first.', 5)
					InfiniteAura.ToggleButton(true)
                    return
                end
				oldpos = vapeentity.character.HumanoidRootPart.CFrame
                repeat
                    for i,v in players:GetPlayers() do
						if v ~= lplr then
							vapeentity.character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0, 8, 0)
							if issword() then
								attackmoment:InvokeServer(v.Character, v.Character.HumanoidRootPart.Position, getsword())
							end
							task.wait()
							vapeentity.character.HumanoidRootPart.CFrame = oldpos
						end
                    end
					task.wait()
                until (not InfiniteAura.Enabled)
            end
		end,
		HoverText = "inf aura moment"
	})
end)