
socialcredit = socialcredit or {}
socialcredit.Version = "0.7a"
socialcredit.Config = include("socialcredit/config.lua")

include "socialcredit/language.lua"
include "socialcredit/util.lua"

CAMI.RegisterPrivilege {
	
	Name = "Social credit control",
	Description = "Access to control social credit system",
	MinAccess = "admin",

}

local Player = FindMetaTable("Player")

function Player:GetSocialCredit()

	return self:GetNWInt("SocialCredit")

end

hook.Add("OnGamemodeLoaded", "SocialCredit", function()

	assert(DarkRP, "Social credit system is DarkRP only")
	print("Social credit system "..socialcredit.Version)

	include "socialcredit/server/control.lua"
	include "socialcredit/server/data.lua"
	include "socialcredit/server/features.lua"
	include "socialcredit/server/player.lua"

	DarkRP.declareChatCommand{
		command = "setcredit",
		description = "Set player social credit",
		delay = 1
	}

	DarkRP.declareChatCommand{
		command = "setcreditoff",
		description = "Set player social credit by SteamID",
		delay = 1
	}

end)