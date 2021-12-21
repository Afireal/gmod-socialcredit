
AddCSLuaFile()

local localizationTable = {}
localizationTable["en"] = include("language/english.lua")
localizationTable["ru"] = include("language/russian.lua")

function socialcredit.Localize(key)
	
	if !localizationTable[socialcredit.Config.Language] then return key end

	return localizationTable[socialcredit.Config.Language][key] or key

end
