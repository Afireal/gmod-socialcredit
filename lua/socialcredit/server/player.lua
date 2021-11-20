
local Player = FindMetaTable("Player")

function Player:SetSocialCredit(value)

	assert(isnumber(value), "Invalid value")

	self:SetNWInt("SocialCredit", socialcredit.utils.Clamp(value))
	socialcredit.Set(self:SteamID(), value)
	hook.Run("OnSocialCreditUpdated", self)

end

function Player:AddSocialCredit(value)

	assert(isnumber(value), "Invalid value")

	value = self:GetSocialCredit() + value

	self:SetSocialCredit(value)

end

hook.Add("PlayerInitialSpawn", "SocialCredit", function(ply)

	local credit = socialcredit.Get(ply:SteamID()) or socialcredit.Config.DefaultValue
	ply:SetNWInt("SocialCredit", credit)

end)
