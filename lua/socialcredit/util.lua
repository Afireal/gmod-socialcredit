
AddCSLuaFile()
socialcredit.utils = socialcredit.utils or {}

function socialcredit.utils.ValidateSteamID(steamid)

	-- ¯\_(ツ)_/¯
	return util.SteamIDTo64(steamid) ~= "0"

end

function socialcredit.utils.Clamp(value)

	return math.Clamp(value, socialcredit.Config.MinValue, socialcredit.Config.MaxValue)

end

if CLIENT then return end

function socialcredit.utils.LogAction(ply, cmd, args)

	if !socialcredit.Config.EnableLog then return end

	if !IsValid(ply) then
	
		ServerLog("[superadmin] Console: "..cmd.." "..args.."\n")
		return
	
	end

	ServerLog("["..ply:GetUserGroup().."] "..ply:Nick().." ("..ply:SteamID().."): "..cmd.." "..args.."\n")

end
