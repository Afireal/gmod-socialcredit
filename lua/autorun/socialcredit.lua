
socialcredit = socialcredit or {}
socialcredit.Version = "2.0"
socialcredit.Privilege = "SocialCreditControl"
socialcredit.Config = include("socialcredit/config.lua")

CAMI.RegisterPrivilege {
		
	Name = socialcredit.Privilege,
	Description = "Access to control social credit system",
	MinAccess = "superadmin",

}

function socialcredit.Clamp(value)

	return math.Clamp(value, socialcredit.Config.MinValue, socialcredit.Config.MaxValue)

end

function socialcredit.GetFeatures()

	return {}

end

include "socialcredit/player.lua"
include "socialcredit/l10n.lua"

if CLIENT then return end

resource.AddSingleFile "materials/icon64/social_credit.png"

include "socialcredit/data.lua"
