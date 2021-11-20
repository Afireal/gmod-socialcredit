
AddCSLuaFile()

local localizationTable = {}
localizationTable["en"] = include("language/english.lua")
localizationTable["ru"] = include("language/russian.lua")

function socialcredit.Localize(key, default)

	default = default or key
	
	if !localizationTable[socialcredit.Config.Language] then return default end

	return localizationTable[socialcredit.Config.Language][key] or default

end
