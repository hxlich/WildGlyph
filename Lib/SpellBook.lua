
local getSpellIndexByName = function(spellName)
	local _schoolName, _schoolIcon, indexOffset, numEntries = GetSpellTabInfo(GetNumSpellTabs())
	local numSpells = indexOffset + numEntries
	local offset = 0
	for spellIndex=numSpells, offset+1, -1 do
		if GetSpellName(spellIndex, BOOKTYPE_SPELL) == spellName then
			return spellIndex;
		end
	end
	return nil
end

local CheckNewCd = function(cooldown, lastCdStart, spellName)
	local spellId = getSpellIndexByName(spellName)
	if spellId ~= nil then
		local timeStartCD, durationCD = GetSpellCooldown(spellId, BOOKTYPE_SPELL)
		-- Sometimes spells return a CD of 0 when cast fails.
		-- If it's non-zero, we have a valid timeStart to check.
		if durationCD == cooldown and timeStartCD ~= lastCdStart then
			return true, timeStartCD
		end
	end
	return false, lastCdStart
end

local CheckNewGCD = function(lastCdStart)
	return CheckNewCd(1.5, lastCdStart, QUIVER_T.Spellbook.Serpent_Sting)
end


local GetIsSpellLearned = function(spellName)
	local i = 0
	while true do
		i = i + 1
		local name, _rank = GetSpellName(i, BOOKTYPE_SPELL)
		if not name then return false
		elseif name == spellName then return true
		end
	end
end

WG_Lib_Spellbook = {
	CheckNewCd=CheckNewCd,
	CheckNewGCD=CheckNewGCD,
	GetIsSpellLearned = GetIsSpellLearned,
	-- GetSpellNameFromTexture=GetSpellNameFromTexture,
	-- HUNTER_CASTABLE_SHOTS=HUNTER_CASTABLE_SHOTS,
}
