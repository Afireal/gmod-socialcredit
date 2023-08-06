
local featuresTable = {}
local featuresParams = {}

function socialcredit.GetFeatures()

	return featuresTable

end

local conVarsFlags = SERVER and {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED} or FCVAR_REPLICATED

local function buildFeature(id, eventName, hookFunc, params)

	featuresTable[id] = params or {}

	local command = "sc_"..string.lower(id)
	local printName = socialcredit.Localize(id)
	local featureEnabled = CreateConVar(command, "1", conVarsFlags, "Enable "..printName, "0", "1")

	if SERVER then

		hook.Add(eventName, "SocialCredit."..id, function(...)
		
			if !featureEnabled:GetBool() then return end
			return hookFunc(featuresParams[id], ...)
		
		end)

	end

	if !istable(params) then return end

	featuresParams[id] = {}

	for k,v in pairs(params) do
	
		local command = "sc_"..string.lower(id).."_"..string.lower(k)
		local printName = socialcredit.Localize(k)
		featuresParams[id][k] = CreateConVar(command, tostring(v.defaultValue), conVarsFlags, printName, v.minValue, v.maxValue)
	
	end

end

local GM = GAMEMODE or gmod.GetGamemode()

buildFeature("HoboBenefits", "playerGetSalary", function(params, ply, amount)

	if !ply:getJobTable().hobo then return end
	if ply:GetSocialCredit() < params.needCredit:GetInt() then return end

	ply:AddSocialCredit(-1)

	return false, socialcredit.Localize("hoboBenefitsMsg"), GM.Config.normalsalary

end, {

	needCredit = {
		defaultValue = 80,
		minValue = socialcredit.Config.MinValue,
		maxValue = socialcredit.Config.MaxValue,
	}

})

buildFeature("ArrestEffect", "playerArrested", function(params, ply, time, police)

	local amount = params.influence:GetInt()

	ply:AddSocialCredit(-amount)

	if !IsValid(police) then return end

	police:AddSocialCredit(amount)

end, {

	influence = {
		defaultValue = 10,
		minValue = 1,
		maxValue = 25,
	}

})

buildFeature("TaxesEffect", "onPaidTax", function(params, ply, tax, wallet)

	ply:AddSocialCredit(params.influence:GetInt())

end, {

	influence = {
		defaultValue = 2,
		minValue = 1,
		maxValue = 25,
	}

})

buildFeature("SalaryEffect", "playerGetSalary", function(params, ply, tax, wallet)

	if ply:getJobTable().hobo then return end
	
	ply:AddSocialCredit(params.influence:GetInt())

end, {

	influence = {
		defaultValue = 2,
		minValue = 1,
		maxValue = 25,
	}

})

buildFeature("AllowMayorJob", "playerCanChangeTeam", function(params, ply, job, forced)

	if forced then return end
	
	local jobTable = RPExtraTeams[job]
	if !jobTable then return end

	if !jobTable.mayor then return end
	if ply:GetSocialCredit() >= params.needCredit:GetInt() then return end

	return false, socialcredit.Localize("lowCreditForJob")

end, {

	needCredit = {
		defaultValue = 75,
		minValue = socialcredit.Config.MinValue,
		maxValue = socialcredit.Config.MaxValue,
	}

})

buildFeature("AllowCPJob", "playerCanChangeTeam", function(params, ply, job, forced)

	if forced then return end

	if !GM.CivilProtection[job] then return end
	if ply:GetSocialCredit() >= params.needCredit:GetInt() then return end

	return false, socialcredit.Localize("lowCreditForJob")

end, {

	needCredit = {
		defaultValue = 50,
		minValue = socialcredit.Config.MinValue,
		maxValue = socialcredit.Config.MaxValue,
	}

})

buildFeature("AutoWanted", "OnSocialCreditUpdated", function(params, ply)

	if ply:GetSocialCredit() > socialcredit.Config.MinValue then return end
	if ply:isWanted() then return end

	ply:wanted(nil, socialcredit.Localize("unreliableOne"))

end)

buildFeature("AutoDemote", "OnSocialCreditUpdated", function(params, ply)

	if ply:isMayor() then 

		if ply:GetSocialCredit() > params.MayorLimit:GetInt() then return end

		ply:changeTeam(GM.DefaultTeam, true, true)
		DarkRP.notifyAll(NOTIFY_GENERIC, 5, socialcredit.Localize("mayorDemoted"))

	elseif ply:isCP() then

		if ply:GetSocialCredit() > params.CPLimit:GetInt() then return end
		ply:changeTeam(GM.DefaultTeam, true, true)
		DarkRP.notify(ply, NOTIFY_GENERIC, 5, socialcredit.Localize("playerDemoted"))

	end

end, {

	CPLimit = {
		defaultValue = 25,
		minValue = socialcredit.Config.MinValue,
		maxValue = socialcredit.Config.MaxValue,
	},

	MayorLimit = {
		defaultValue = 30,
		minValue = socialcredit.Config.MinValue,
		maxValue = socialcredit.Config.MaxValue,
	}

})

buildFeature("CitizenKilled", "PlayerDeath", function(params, victim, _, attacker)

	if !(IsValid(attacker) && attacker:IsPlayer()) then return end

	local amount = params.influence:GetInt()

	if victim:isWanted() then
	
		attacker:AddSocialCredit(amount)
		return
	
	end

	if attacker:isCP() && params.CPImmunity:GetBool() then return end

	attacker:AddSocialCredit(-amount)

end, {

	influence = {
		defaultValue = 5,
		minValue = 1,
		maxValue = 50,
	},

	CPImmunity = {
		defaultValue = 0,
		minValue = 0,
		maxValue = 1,
	}

})

buildFeature("AllowCustomJob", "playerCanChangeTeam", function(params, ply, job, forced)

	if forced then return end
	
	local jobTable = RPExtraTeams[job]
	if !jobTable then return end

	if !jobTable.credit then return end
	if ply:GetSocialCredit() >= credit then return end

	return false, socialcredit.Localize("lowCreditForJob")

end)

buildFeature("WeaponConfiscation", "playerWeaponsConfiscated", function(params, police, ply, weapons)

	if table.IsEmpty(weapons) then return end

	local count = table.Count(weapons)
	local amount = params.influence:GetInt()

	ply:AddSocialCredit(-amount*count)

end, {

	influence = {
		defaultValue = 2,
		minValue = 1,
		maxValue = 25,
	}

})

buildFeature("LicenseBonus", "playerGotLicense", function(params, ply, mayor)

	if !(IsValid(mayor) && mayor:IsPlayer()) then return end

	ply:AddSocialCredit(params.influence:GetInt())

end, {

	influence = {
		defaultValue = 1,
		minValue = 1,
		maxValue = 25,
	}

})