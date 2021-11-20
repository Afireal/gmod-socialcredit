
DarkRP.definePrivilegedChatCommand("setcredit", "Social credit control", function(ply, text)

	local args = string.Explode(" ", text)
	if !args then return "" end

	local target = DarkRP.findPlayer(args[1])
	local value = tonumber(args[2])

	if !(IsValid(target) && isnumber(value)) then

		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
		return ""

	end

	target:SetSocialCredit(value)
	socialcredit.utils.LogAction(ply, "setcredit", text)
	return ""

end)

DarkRP.definePrivilegedChatCommand("setcreditoff", "Social credit control", function(ply, text)

	local args = string.Explode(" ", text)
	if !args then return "" end

	local target = args[1]
	local value = tonumber(args[2])

	if !(socialcredit.utils.ValidateSteamID(target) && isnumber(value)) then

		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
		return ""

	end

	socialcredit.Set(target, value)
	socialcredit.utils.LogAction(ply, "setcreditoff", text)
	return ""

end)