WG_Migrations_Run = function()
	-- toc version (after 1.0.0) persists to saved variables. A clean
	-- install has no saved variables, which distinguishes a 1.0.0 install.
	if Wild_Glyph_Store == nil then
		Wild_Glyph_Store = {}
	end
end
