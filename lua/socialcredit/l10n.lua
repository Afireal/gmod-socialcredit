
AddCSLuaFile()

local localization = {}
localization["en"] = include("language/english.lua")
localization["ru"] = include("language/russian.lua")

local curLang = socialcredit.Config.Language

if socialcredit.Config.Language == "" then

	curLang = GetConVar("gmod_language"):GetString()

end

if !localization[curLang] then

	curLang = "en"

end

function socialcredit.Localize(key)
	
	if !localization[curLang] then return key end

	return localization[curLang][key] or key

end
