if getgenv and not getgenv().shared then getgenv().shared = {} end
if ({identifyexecutor()})[1] == 'Synapse Z' and syn and syn.toast_notification ~= nil then syn.toast_notification = nil end
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end

if tostring(game.PlaceId) == '11630038968' then
	
end

local function displayErrorPopup(text, func)
	local oldidentity = getidentity()
	setidentity(8)
	local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
	local prompt = ErrorPrompt.new("Default")
	prompt._hideErrorCode = true
	local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	prompt:setErrorTitle("Vape")
	prompt:updateButtons({{
		Text = "OK",
		Callback = function() 
			prompt:_close() 
			if func then func() end
		end,
		Primary = true
	}}, 'Default')
	prompt:setParent(gui)
	prompt:_open(text)
	setidentity(oldidentity)
end

local function vapeGithubRequest(scripturl)
	if not isfile("nonsense/"..scripturl) then
		local suc, res
		task.delay(15, function()
			if not res and not errorPopupShown then 
				errorPopupShown = true
				displayErrorPopup("The connection to github is taking a while, Please be patient.")
			end
		end)
		suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/OuterScripts/Nonsense/"..readfile("nonsense/Developer/commithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then
			if identifyexecutor and ({identifyexecutor()})[1] == 'Wave' then 
				displayErrorPopup('use syn z :money_mouth:')
				error(res)
			end
			displayErrorPopup("Failed to connect to github : nonsense/"..scripturl.." : "..res)
			error(res)
		end
		if scripturl:find(".lua") then res = "-- Remove to remove AutoUpdate\n"..res end
		writefile("nonsense/"..scripturl, res)
	end
	return readfile("nonsense/"..scripturl)
end

if not shared.VapeDeveloper then 
	local commit = "main"
	for i,v in pairs(game:HttpGet("https://github.com/OuterScripts/Nonsense"):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			break
		end
	end
	if commit then
		if isfolder("vape") then 
			if ((not isfile("nonsense/Developer/commithash.txt")) or (readfile("nonsense/Developer/commithash.txt") ~= commit or commit == "main")) then
				for i,v in pairs({"nonsense/universal.lua", "nonsense/initiate.lua", "nonsense/Libraries/GuiLibrary.lua"}) do 
					if isfile(v) and readfile(v):find("-- Remove to remove AutoUpdate") then
						delfile(v)
					end 
				end
				if isfolder("nonsense/CustomModules") then 
					for i,v in pairs(listfiles("nonsense/CustomModules")) do 
						if isfile(v) and readfile(v):find("-- Remove to remove AutoUpdate") then
							delfile(v)
						end 
					end
				end
				if isfolder("nonsense/Libraries") then 
					for i,v in pairs(listfiles("nonsense/Libraries")) do 
						if isfile(v) and readfile(v):find("-- Remove to remove AutoUpdate.") then
							delfile(v)
						end 
					end
				end
				writefile("nonsense/Developer/commithash.txt", commit)
			end
		else
			makefolder("vape")
			writefile("nonsense/Developer/commithash.txt", commit)
		end
	else
		displayErrorPopup("Failed to connect to github, please try using a VPN.")
		error("Failed to connect to github, please try using a VPN.")
	end
end

return loadstring(readfile("nonsense/initiate.lua"))()
