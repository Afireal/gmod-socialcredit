
AddCSLuaFile()

local Player = FindMetaTable("Player")

function Player:GetSocialCredit()

	return self:GetNWInt("SocialCredit")

end

if CLIENT then return end

function Player:SetSocialCredit(value)

	assert(isnumber(value), "invalid value")

	value = socialcredit.Clamp(value)

	self:SetNWInt("SocialCredit", value)
	socialcredit.Set(self:SteamID(), value)
	hook.Run("OnSocialCreditUpdated", self)

end

function Player:AddSocialCredit(value)

	assert(isnumber(value), "invalid value")

	self:SetSocialCredit(self:GetSocialCredit() + value)

end
