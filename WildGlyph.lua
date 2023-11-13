_G = _G or getfenv()

local initSlashCommandsAndModules = function()
    SLASH_WILDGLYPH1 = "/wg"
    SLASH_WILDGLYPH2 = "/wildglyph"
    _, cl = UnitClass("player")
    if c1 == "DRUID" then
        SlashCmdList["WILDGLYPH"] = function() DEFAULT_CHAT_FRAME:AddMessage("Hello WildGlyph", 0, 1, 0) end
    else
        SlashCmdList["WILDGLYPH"]  = function() DEFAULT_CHAT_FRAME:AddMessage(WILDGLYPH_T.UI.WrongClass, 1, 0.5, 0) end
    end
end



--[[
    loading
]]
local frame = CreateFrame("Frame", nil)
frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" and arg1 == "WildGlyph" then
		-- Quiver_Migrations_Run()
		-- savedVariablesRestore()
		initSlashCommandsAndModules()
	elseif event == "PLAYER_LOGIN" then
		-- Quiver_Module_UpdateNotifier_Init()
		-- loadPlugins()
	elseif event == "PLAYER_LOGOUT" then
		-- savedVariablesPersist()
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		-- Quiver_Lib_ActionBar_ValidateCache(arg1)
	end
end)
