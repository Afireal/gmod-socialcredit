
socialcredit = socialcredit or {}
socialcredit.Version = "1.0b"
socialcredit.Privilege = "SocialCreditControl"
socialcredit.Config = include("socialcredit/config.lua")

local Player = FindMetaTable("Player")

function Player:GetSocialCredit()

	return self:GetNWInt("SocialCredit")

end

hook.Add("OnGamemodeLoaded", "SocialCredit", function()

	if !DarkRP then
	
		print "Social credit system is DarkRP only"
		return
	
	end

	include "socialcredit/language.lua"
	include "socialcredit/util.lua"

	if SERVER then

		resource.AddSingleFile "materials/icon64/social_credit.png"

		AddCSLuaFile "socialcredit/client/menu.lua"

		include "socialcredit/server/control.lua"
		include "socialcredit/server/data.lua"
		include "socialcredit/server/player.lua"
	
	else
	
		include "socialcredit/client/menu.lua"
	
	end

	include "socialcredit/features.lua"

	CAMI.RegisterPrivilege {
		
		Name = socialcredit.Privilege,
		Description = "Access to control social credit system",
		MinAccess = "admin",

	}

	DarkRP.declareChatCommand {

		command = "setcredit",
		description = "Set player social credit by SteamID",
		delay = 1

	}

end)