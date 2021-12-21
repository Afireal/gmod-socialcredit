
local tempData = {}

if file.Exists(socialcredit.Config.SaveFile, "DATA") then

	tempData = file.Read(socialcredit.Config.SaveFile)
	assert(tempData, "Failed to read save file")

	tempData = util.JSONToTable(tempData)

else

	file.Write(socialcredit.Config.SaveFile, "[]")
 
end

function socialcredit.Get(steamid)

	assert(socialcredit.utils.ValidateSteamID(steamid), "Invalid SteamID")

	return tempData[steamid]

end

function socialcredit.Set(steamid, value)

	assert(socialcredit.utils.ValidateSteamID(steamid), "Invalid SteamID")
	assert(isnumber(value), "Invalid value")

	value = socialcredit.utils.Clamp(value)
	tempData[steamid] = value

end

function socialcredit.SaveAll()

	file.Write(socialcredit.Config.SaveFile, util.TableToJSON(tempData))

end

hook.Add("ShutDown", "SocialCredit", socialcredit.SaveAll)

concommand.Add("sc_saveall", function(ply)

	if !IsValid(ply) then goto ALLOWED end
	if !CAMI.PlayerHasAccess(ply, socialcredit.Privilege) then return end

	::ALLOWED::
	socialcredit.SaveAll()

end)