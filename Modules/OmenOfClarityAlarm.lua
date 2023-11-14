local MODULE_ID = "OmenOfClarityAlarm"
local store = nil
local frame = nil


local UPDATE_DELAY_SLOW = 5
local UPDATE_DELAY_FAST = 0.1
local updateDelay = UPDATE_DELAY_SLOW

local INSET = 4
local DEFAULT_ICON_SIZE = 40
local MINUTES_LEFT_WARNING = 5

-- ************ State ************

local aura = (function()
	local knowsAura, isActive, lastUpdate, timeLeft = false, false, 1800, 0
	return {
		ShouldUpdate = function(elapsed)
			lastUpdate = lastUpdate + elapsed
			return knowsAura and lastUpdate > updateDelay
		end,
		UpdateUI = function()
			knowsAura = WG_Lib_Spellbook.GetIsSpellLearned(WILDGLYPH_T.Spellbook.OmenOfClarity)
				or not Wild_Glyph_Store.IsLockedFrames
			isActive, timeLeft = WG_Lib_Aura_GetIsActiveTimeLeftByTexture(WildGlyph.Icon.Omen_Of_Clarity)
			lastUpdate = 0

			if knowsAura and not isActive then
				frame.Icon:SetAlpha(0.75)
				frame:SetBackdropBorderColor(1, 0, 0, 0.8)
			elseif knowsAura and isActive and timeLeft > 0 and timeLeft < MINUTES_LEFT_WARNING * 60 then
				frame.Icon:SetAlpha(0.4)
				frame:SetBackdropBorderColor(0, 0, 0, 0.1)
			else
				updateDelay = UPDATE_DELAY_SLOW
				frame.Icon:SetAlpha(0.0)
				frame:SetBackdropBorderColor(0, 0, 0, 0)
			end
		end,
	}
end)()

-- ************ UI ************
local setFramePosition = function(f, s)
	WG_Event_FrameLock_SideEffectRestoreSize(s, {
		w=DEFAULT_ICON_SIZE, h=DEFAULT_ICON_SIZE, dx=150, dy=40,
	})
	f:SetWidth(s.FrameMeta.W)
	f:SetHeight(s.FrameMeta.H)
	f:SetPoint("TopLeft", s.FrameMeta.X, s.FrameMeta.Y)
end

local createUI = function()
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetFrameStrata("Low")
	f:SetBackdrop({
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16,
		insets = { left=INSET, right=INSET, top=INSET, bottom=INSET },
	})
	setFramePosition(f, store)

	f.Icon = CreateFrame("Frame", nil, f)
	f.Icon:SetBackdrop({ bgFile = WildGlyph.Icon.Omen_Of_Clarity, tile = false })
	f.Icon:SetPoint("Left", f, "Left", INSET, 0)
	f.Icon:SetPoint("Right", f, "Right", -INSET, 0)
	f.Icon:SetPoint("Top", f, "Top", 0, -INSET)
	f.Icon:SetPoint("Bottom", f, "Bottom", 0, INSET)

	WG_Event_FrameLock_SideEffectMakeMoveable(f, store)
	WG_Event_FrameLock_SideEffectMakeResizeable(f, store, { GripMargin=0 })
	return f
end
-- ************ Event Handlers ************

local EVENTS = {
	"PLAYER_AURAS_CHANGED",
	"SPELLS_CHANGED",-- Open or click thru spellbook, learn/unlearn spell
}

local handleEvent = function()
	if event == "SPELLS_CHANGED" and arg1 ~= "LeftButton"
		or event == "PLAYER_AURAS_CHANGED"
	then
		aura.UpdateUI()
	end
end

-- ************ Initialization ************

local onEnable = function()
	if frame == nil then frame = createUI() end
	frame:SetScript("OnEvent", handleEvent)
	frame:SetScript("OnUpdate", function()
		if aura.ShouldUpdate(arg1) then aura.UpdateUI() end
	end)
	for _k, e in EVENTS do frame:RegisterEvent(e) end
	frame:Show()
	aura.UpdateUI()
	WG_Event_Spellcast_Instant.Subscribe(MODULE_ID, function(spellName)
		if spellName == WILDGLYPH_T.Spellbook.OmenOfClarity then
			-- Buffs don't update right away, but we want fast user feedback
			updateDelay = UPDATE_DELAY_FAST
		end
	end)
end
local onDisable = function ()
	WG_Event_Spellcast_Instant.Dispose(MODULE_ID)
	frame:Hide()
	for _k, e in EVENTS do frame:UnregisterEvent(e) end
end

local OnInterfaceLock  = function ()
	aura.UpdateUI()
end

local OnInterfaceUnlock  = function ()
	aura.UpdateUI()
end

local OnResetFrames = function ()
	store.FrameMeta = nil
	if frame then setFramePosition(frame, store) end
end

local OnSavedVariablesRestore = function (savedVariables)
	store = savedVariables
end

local OnSavedVariablesPersist  = function ()
	return store
end

WG_Module_OmenOfClarityAlarm = {
	Id = MODULE_ID,
	Name = WILDGLYPH_T.ModuleName[MODULE_ID],
	OnEnable = onEnable,
	OnDisable = onDisable,
	OnInterfaceLock = OnInterfaceLock,
	OnInterfaceUnlock = OnInterfaceUnlock,
	OnResetFrames = OnResetFrames,
	OnSavedVariablesRestore = OnSavedVariablesRestore,
	OnSavedVariablesPersist = OnSavedVariablesPersist,
}
