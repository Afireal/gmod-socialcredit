
local cache = {}

hook.Add("OnGamemodeLoaded", "SocialCredit", function()

	sql.Query("CREATE TABLE IF NOT EXISTS socialcredit (steamid VARCHAR(25), credit INT, PRIMARY KEY (`steamid`));")

end)

hook.Add("PlayerInitialSpawn", "SocialCredit", function(ply)

	local steamid = ply:SteamID()

	if socialcredit.Config.DisableDB then
	
		cache[steamid] = cache[steamid] or socialcredit.Config.DefaultValue

		ply:SetNWInt("SocialCredit", cache[steamid])
		return
	
	end

	local credit = cache[steamid]

	if !credit then

		local tbl = sql.Query("SELECT * FROM `socialcredit` WHERE steamid = "..sql.SQLStr(steamid)..";")

		if !istable(tbl) then

			credit = socialcredit.Config.DefaultValue
			sql.Query("INSERT INTO `socialcredit` VALUES("..sql.SQLStr(steamid)..", "..credit..");")

		else

			tbl = tbl[1] // ¯\_(ツ)_/¯
			credit = tonumber(tbl.credit)

		end
	
		cache[steamid] = credit
	
	end

	ply:SetNWInt("SocialCredit", credit)

end)

local function validateSteamID(steamid)

	if !isstring(steamid) then return false end

	return steamid:match("^STEAM_%d:%d:%d+$")

end

function socialcredit.Get(steamid)

	assert(validateSteamID(steamid), "invalid SteamID")

	return cache[steamid]

end

function socialcredit.Set(steamid, value)

	assert(validateSteamID(steamid), "invalid SteamID")
	assert(isnumber(value), "invalid value")

	//value = socialcredit.Clamp(value)
	cache[steamid] = value

end

local function saveAll()

	if socialcredit.Config.DisableDB then
		
		MsgN("Social credit data cannot be saved")
		return
	
	end

	MsgN("Saving social credit data...")
	sql.Begin()

		for steamid, credit in pairs(cache) do
		
			sql.Query("UPDATE `socialcredit` SET credit = "..credit.." WHERE steamid = "..sql.SQLStr(steamid)..";")
		
		end

	sql.Commit()
	MsgN("Social credit data saved")

end

hook.Add("ShutDown", "SocialCredit", saveAll)

concommand.Add("sc_saveall", function(ply)

	if IsValid(ply) then return end

	saveAll()

end)

local function wipeOut()

	MsgN("Wiping out social credit data...")
	cache = {}

	// faster way
	sql.Query("DROP TABLE socialcredit;")
	sql.Query("CREATE TABLE socialcredit (steamid VARCHAR(25), credit INT, PRIMARY KEY (`steamid`));")

	sql.Begin()

		for _, ply in ipairs(player.GetAll()) do

			cache[ply:SteamID()] = socialcredit.Config.DefaultValue
			ply:SetNWInt("SocialCredit", socialcredit.Config.DefaultValue)

			sql.Query("INSERT INTO `socialcredit` VALUES("..sql.SQLStr(steamid)..", "..socialcredit.Config.DefaultValue..");")

		end

	sql.Commit()
	MsgN("Social credit data wiped out")

end

local function wipeOut_nodb()

	MsgN("Wiping out social credit data...")
	cache = {}

	for _, ply in ipairs(player.GetAll()) do

		cache[ply:SteamID()] = socialcredit.Config.DefaultValue
		ply:SetNWInt("SocialCredit", socialcredit.Config.DefaultValue)

	end
	MsgN("Social credit data wiped out")

end

concommand.Add("sc_wipeout", function(ply)

	if IsValid(ply) then return end

	local func = socialcredit.Config.DisableDB && wipeOut_nodb || wipeOut
	func()

end)