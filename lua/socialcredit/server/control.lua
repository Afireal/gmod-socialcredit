
DarkRP.definePrivilegedChatCommand("setcredit", socialcredit.Privilege, function(ply, text)

	local args = string.Explode(" ", text)
	if !args then return "" end

	local target = args[1]
	local value = tonumber(args[2])

	if !(socialcredit.utils.ValidateSteamID(target) && isnumber(value)) then

		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
		return ""

	end

	socialcredit.utils.LogAction(ply, "setcredit", text)

	target = player.GetBySteamID(target) or target

	if isstring(target) then
	
		socialcredit.Set(target, value)
		return ""
	
	end

	target:SetSocialCredit(value)
	return ""

end)

util.AddNetworkString("SocialCreditControl")

net.Receive("SocialCreditControl", function(len, ply)

	if !IsValid(ply) then return end
	if !CAMI.PlayerHasAccess(ply, socialcredit.Privilege) then return end
 
	local len = net.ReadInt(17)
	local data = net.ReadData(len)

	data = socialcredit.utils.Transcript(data)

	if data.conVar && data.value then
	
		if string.Left(data.conVar, 3) ~= "sc_" then return end

		local conVar = GetConVar(data.conVar)
		if !conVar then return end

		socialcredit.utils.LogAction(ply, data.conVar, data.value)
		conVar:SetInt(data.value)
		return
	
	end

end)