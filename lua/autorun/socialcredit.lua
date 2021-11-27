
socialcredit = socialcredit or {}
socialcredit.Version = "0.8a"
socialcredit.Config = include("socialcredit/config.lua")

local Player = FindMetaTable("Player")

function Player:GetSocialCredit()

	return self:GetNWInt("SocialCredit")

end

hook.Add("OnGamemodeLoaded", "SocialCredit", function()

	assert(DarkRP, "Social credit system is DarkRP only")
	print("Social credit system "..socialcredit.Version)

	include "socialcredit/language.lua"
	include "socialcredit/util.lua"

	if SERVER then

		AddCSLuaFile "socialcredit/client/menu.lua"

		include "socialcredit/server/control.lua"
		include "socialcredit/server/data.lua"
		include "socialcredit/server/player.lua"
	
	else
	
		include "socialcredit/client/menu.lua"
	
	end

	include "socialcredit/features.lua"

	CAMI.RegisterPrivilege {
		
		Name = "Social credit control",
		Description = "Access to control social credit system",
		MinAccess = "admin",

	}

	DarkRP.declareChatCommand {
		command = "setcredit",
		description = "Set player social credit by SteamID",
		delay = 1
	}

end)