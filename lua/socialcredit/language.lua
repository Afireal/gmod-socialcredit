
AddCSLuaFile()

local localizationTable = {}
localizationTable["en"] = include("language/english.lua")
localizationTable["ru"] = include("language/russian.lua")

local curLang = socialcredit.Config.Language

if socialcredit.Config.Language == "" then

	curLang = GetConVar("gmod_language"):GetString()

end

function socialcredit.Localize(key)
	
	if !localizationTable[curLang] then return key end

	return localizationTable[curLang][key] or key

end
