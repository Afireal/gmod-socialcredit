
socialcredit.ulx = socialcredit.ulx or {}

local cat = "Social credit"

function socialcredit.ulx.Set(actor, target, value)

	target:SetSocialCredit(value)
	ulx.fancyLogAdmin(actor, "#A изменил социальный рейтинг #T на #i", target, value)
	ulx.fancyLogAdmin(actor, socialcredit.Localize("adminSetCredit"), target, value)

end
local setcredit = ulx.command(cat, "ulx setcredit", socialcredit.ulx.Set, "!setcredit")
setcredit:addParam{type=ULib.cmds.PlayerArg}
setcredit:addParam{type=ULib.cmds.NumArg, min=socialcredit.Config.MinValue, max=socialcredit.Config.MaxValue, default=socialcredit.Config.MinValue, hint="credit", ULib.cmds.round}
setcredit:defaultAccess(ULib.ACCESS_ADMIN)
setcredit:help(socialcredit.Localize("setCredit"))

function socialcredit.ulx.Reset(actor, target)

	target:SetSocialCredit(socialcredit.Config.DefaultValue)
	ulx.fancyLogAdmin(actor, socialcredit.Localize("adminResetCredit"), target)

end
local resetcredit = ulx.command(cat, "ulx resetcredit", socialcredit.ulx.Reset, "!resetcredit")
resetcredit:addParam{type=ULib.cmds.PlayerArg}
resetcredit:defaultAccess(ULib.ACCESS_ADMIN)
resetcredit:help(socialcredit.Localize("resetCredit"))