_G = _G or getfenv()
_G.WG_Modules = {
	WG_Module_OmenOfClarityAlarm
}

local initSlashCommandsAndModules = function()
    SLASH_WILDGLYPH1 = "/wg"
    SLASH_WILDGLYPH2 = "/wildglyph"
    _, cl = UnitClass("player")
    if cl == "DRUID" then
        SlashCmdList["WILDGLYPH"] = function() DEFAULT_CHAT_FRAME:AddMessage("Hello WildGlyph", 0, 1, 0) end
		for _k, v in _G.WG_Modules do
			if Wild_Glyph_Store.ModuleEnabled[v.Id] then v.OnEnable() end
		end
    else
        SlashCmdList["WILDGLYPH"]  = function() DEFAULT_CHAT_FRAME:AddMessage(WILDGLYPH_T.UI.WrongClass, 1, 0.5, 0) end
    end
end


local savedVariablesRestore = function()
	Wild_Glyph_Store.IsLockedFrames = Wild_Glyph_Store.IsLockedFrames == true
	Wild_Glyph_Store.ModuleEnabled = Wild_Glyph_Store.ModuleEnabled or {}
	Wild_Glyph_Store.ModuleStore = Wild_Glyph_Store.ModuleStore or {}
	for _k, v in _G.WG_Modules do
		Wild_Glyph_Store.ModuleEnabled[v.Id] = 	Wild_Glyph_Store.ModuleEnabled[v.Id] ~= false
		Wild_Glyph_Store.ModuleStore[v.Id] = Wild_Glyph_Store.ModuleStore[v.Id] or {}
		-- Loading saved variables into each module gives them a chance to set their own defaults.
		v.OnSavedVariablesRestore(Wild_Glyph_Store.ModuleStore[v.Id])
	end
end

local savedVariablesPersist = function()
	for _k, v in _G.WG_Modules do
		Quiver_Store.ModuleStore[v.Id] = v.OnSavedVariablesPersist()
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
		WG_Migrations_Run()
		savedVariablesRestore()
		initSlashCommandsAndModules()
	elseif event == "PLAYER_LOGIN" then
		-- Quiver_Module_UpdateNotifier_Init()
		-- loadPlugins()
	elseif event == "PLAYER_LOGOUT" then
		savedVariablesPersist()
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		-- Quiver_Lib_ActionBar_ValidateCache(arg1)
	end
end)
