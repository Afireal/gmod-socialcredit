
AddCSLuaFile()
local CONFIG = {}

-- If "" set, depends on 'gmod_language' ConVar
CONFIG.Language = ""

CONFIG.DefaultValue = 100
CONFIG.MinValue = 0
CONFIG.MaxValue = 100

CONFIG.SaveFile = "social_credit.json"

CONFIG.EnableLog = true

return CONFIG