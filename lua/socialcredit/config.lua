
AddCSLuaFile()
local CONFIG = {}

-- If "" set, depends on 'gmod_language' ConVar
CONFIG.Language = ""

CONFIG.DefaultValue = 100
CONFIG.MinValue = 0
CONFIG.MaxValue = 100

-- Hide control panel from context menu
CONFIG.HideIcon = false

-- Makes social credit reset after a server restart. Can be useful
CONFIG.DisableDB = false

return CONFIG