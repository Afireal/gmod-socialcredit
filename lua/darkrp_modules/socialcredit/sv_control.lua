
util.AddNetworkString("SocialCreditControl")

net.Receive("SocialCreditControl", function(len, ply)

	if !IsValid(ply) then return end
	if !CAMI.PlayerHasAccess(ply, socialcredit.Privilege) then return end
 
	local len = net.ReadInt(17)
	local data = net.ReadData(len)

	data = util.JSONToTable(util.Decompress(data) or "[]")

	if data.conVar && data.value then
	
		if string.Left(data.conVar, 3) ~= "sc_" then return end

		local conVar = GetConVar(data.conVar)
		if !conVar then return end

		MsgN(string.format("[%s] %s (%s) set %q to %d", ply:GetUserGroup(), ply:Nick(), ply:SteamID(), data.conVar, data.value))
		conVar:SetInt(data.value)
		return
	
	end

end)