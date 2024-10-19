
local function vapeGithubRequest(scripturl)
	if not isfile("nonsense/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/OuterScripts/OuterWare/"..readfile("nonsense/commithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then return nil end
		if scripturl:find(".lua") then res = "--remove this or ur getting reset\n"..res end
		writefile("nonsense/"..scripturl, res)
	end
	return readfile("nonsense/"..scripturl)
end

shared.CustomSaveVape = 6872274481
if isfile("nonsense/CustomModules/6872274481.lua") then
	loadstring(readfile("nonsense/CustomModules/6872274481.lua"))()
else
	local publicrepo = vapeGithubRequest("CustomModules/6872274481.lua")
	if publicrepo then
		loadstring(publicrepo)()
	end
end