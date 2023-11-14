WG_Lib_Aura_GetIsActiveTimeLeftByTexture = function (targetTexture)
	-- This seems to check debuffs as well (tested with deserter)
	local maxIndex = WildGlyph.Buff_Cap - 1
	for i=0,maxIndex do
		local texture = GetPlayerBuffTexture(i)
		if texture == targetTexture then
			local timeLeft = GetPlayerBuffTimeLeft(i)
			return true, timeLeft
		end
	end
	return false, 0
end
