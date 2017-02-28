local maxabilities = 29		// How many abilities are in the game

local function kirbyhud(v, player, camera)
	if not(player.mo and player.mo.skin == "kirby")
		return	// Nope no hud for you
	end
	
	// --------------------------------------------
	// Icons
	// --------------------------------------------
	local badname = v.cachePatch("NAMEB")	// That's no good!
	local badicon = v.cachePatch("ICONB")
	local hypername = v.cachePatch("NAMEHYPR")
	local hypericon = v.cachePatch("ICONHYPR")
	local mixname = v.cachePatch("NAMEMIX")		// Unused
	local mixicon = v.cachePatch("ICONMIX")		// Unused
	local nousename = v.cachePatch("NAMEJUIC")
	local nouseicon = v.cachePatch("ICONJUIC")
	// --------------------------------------------
	
	local drawname = nil
	local drawicon = nil
	
	// --------------------------------------------
	// Load the icons here
	// --------------------------------------------
	if(player.powers[pw_invulnerability])
		drawname = hypername
		drawicon = hypericon
	elseif(player.badtime and player.badtime+TICRATE > leveltime)	// Been a second since a bad copy?
		if not(player.badissilver)
			drawname = badname
			drawicon = badicon
		else	// We ate silver?
			drawname = nousename	// It's no use!
			drawicon = nouseicon
		end
	elseif(player.copyabl == 0)			// Normal Kirby?
		and(player.abilityto == 100)	// 100 = mix!
		drawname = v.cachePatch("NAME0")
		drawicon = mixicon
	elseif(v.patchExists("NAME"+player.copyabl))		// Is there a patch to use?
		drawname = v.cachePatch("NAME"+player.copyabl)	// Load the name!
		drawicon = v.cachePatch("ICON"+player.copyabl)	// Load the icon!
	else
		drawname = v.cachePatch("NAME0")		// Kirby!
		drawicon = v.cachePatch("ICON0")		// Ditto!
	end
	
	// Draw the hud!
	if(G_RingSlingerGametype())		// Match/ctf both have emeralds, shown at the same spot!
		v.draw(0, 232, drawname)	// Instead, just draw the name at the bottom! That won't cover the emeralds!
	else
		v.draw(0, 200, drawname)
		v.draw(0, 200, drawicon)
	end
	
end

hud.add(kirbyhud, player)
