// Object freeslots
freeslot("MT_KIRBYFEET", "MT_KIRBYFACE",
"SPR_FEET", "SPR_FACE")

// Array of colors!
local kirbyfeetcolors = {}
kirbyfeetcolors[SKINCOLOR_WHITE] = SKINCOLOR_RED		// Snow
kirbyfeetcolors[SKINCOLOR_SILVER] = SKINCOLOR_BLACK		// White
kirbyfeetcolors[SKINCOLOR_GREY] = SKINCOLOR_ORANGE		// Carbon
kirbyfeetcolors[SKINCOLOR_BLACK] = SKINCOLOR_SILVER		// Black
kirbyfeetcolors[SKINCOLOR_CYAN] = SKINCOLOR_PURPLE		// Ice
kirbyfeetcolors[SKINCOLOR_TEAL] = SKINCOLOR_BLUE		// Blue
kirbyfeetcolors[SKINCOLOR_STEELBLUE] = SKINCOLOR_BLUE	// Ugly
kirbyfeetcolors[SKINCOLOR_BLUE] = SKINCOLOR_PURPLE		// Blue (Classic)
kirbyfeetcolors[SKINCOLOR_PEACH] = SKINCOLOR_TAN		//
kirbyfeetcolors[SKINCOLOR_TAN] = SKINCOLOR_BROWN		//
kirbyfeetcolors[SKINCOLOR_PINK] = SKINCOLOR_RED			// Pink (normal)
kirbyfeetcolors[SKINCOLOR_LAVENDER] = SKINCOLOR_PURPLE	// Grape
kirbyfeetcolors[SKINCOLOR_PURPLE] = SKINCOLOR_LAVENDER	//
kirbyfeetcolors[SKINCOLOR_ORANGE] = SKINCOLOR_RED		// Orange
kirbyfeetcolors[SKINCOLOR_ROSEWOOD] = SKINCOLOR_DARKRED	//
kirbyfeetcolors[SKINCOLOR_BEIGE] = SKINCOLOR_BROWN		//
kirbyfeetcolors[SKINCOLOR_BROWN] = SKINCOLOR_TAN		// Brown
kirbyfeetcolors[SKINCOLOR_RED] = SKINCOLOR_PINK			// Red (Classic)
kirbyfeetcolors[SKINCOLOR_DARKRED] = SKINCOLOR_RED		// Old fire
kirbyfeetcolors[SKINCOLOR_NEONGREEN] = SKINCOLOR_GREEN	//
kirbyfeetcolors[SKINCOLOR_GREEN] = SKINCOLOR_ORANGE		// Green (Classic)
kirbyfeetcolors[SKINCOLOR_ZIM] = SKINCOLOR_GREEN		// Green (Air Ride)
kirbyfeetcolors[SKINCOLOR_OLIVE] =	SKINCOLOR_GOLD		//
kirbyfeetcolors[SKINCOLOR_YELLOW] = SKINCOLOR_RED		// Yellow (Classic)
kirbyfeetcolors[SKINCOLOR_GOLD] = SKINCOLOR_PURPLE		//

addHook("ThinkFrame", do
	for player in players.iterate
		if(player.mo and player.mo.valid and player.mo.skin == "kirby" and (player.mo.sprite == SPR_PLAY or player.mo.sprite == SPR_FATK))	// Are we Kirby?
			// Create the feet
			if not(player.feet and player.feet.valid)
				player.feet = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYFEET)
			end
			// Create the face
			if not(player.face and player.face.valid)
				player.face = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYFACE)
			end
			
			// Set the feet's frame to Kirby's frame! (and tics)
			player.feet.state = player.mo.state
			player.feet.frame = player.mo.frame
			if(player.mo.state >= S_PLAY_FATKIRB_WALK1)
				and(player.mo.state <= S_PLAY_FATKIRB_WALK8)
				player.feet.state = $1 + S_PLAY_RUN1 - S_PLAY_FATKIRB_WALK1
			elseif(player.mo.state >= S_PLAY_KRUN1)
				and(player.mo.state <= S_PLAY_KRUN8)
				player.feet.state = $1 + S_PLAY_RUN1 - S_PLAY_KRUN1
			end
			player.feet.tics = player.mo.tics
			
			// Fat exeptions
			if(player.mo.state == S_PLAY_FATKIRB)
				player.feet.state = S_PLAY_STND
			elseif(player.mo.state == S_PLAY_FATKIRB_FALL)
				or(player.mo.state == S_PLAY_FATKIRB_HANG)
				player.feet.state = S_PLAY_FALL1
			end
			
			// Same for the face!
			player.face.state = player.mo.state
			player.face.frame = player.mo.frame
			if(player.mo.state >= S_PLAY_KRUN1)
				and(player.mo.state <= S_PLAY_KRUN8)
				player.face.state = $1 + S_PLAY_RUN1 - S_PLAY_KRUN1
			end
			player.face.tics = player.mo.tics
			
			// Fat exceptions #2
			if(player.mo.state >= S_PLAY_FATKIRB)
				and(player.mo.state <= S_PLAY_FATKIRB_HANG)
				player.face.state = S_PLAY_FATKIRB_JUMP
			end
			
			// Match the colors!
			// Some colors are refrenced twice. Obviously, due to using else, the later ones won't work.
			if(player.mo.color == 26)
				A_ChangeColorAbsolute(player.feet, 0, 30)
			elseif(player.mo.color > 26)
				and(player.mo.color <= 30)
				A_ChangeColorAbsolute(player.feet, 0, player.mo.color-1)
			elseif(player.mo.color > 26)
				A_ChangeColorAbsolute(player.feet, 0, player.mo.color)
			else
				player.feet.color = kirbyfeetcolors[player.mo.color]	// Match the color!
			end
			
			if(player.copyabl and player.copyabl == 97)	// Ow the edge?
				and not(player.powers[pw_super])		// Not when super!
				player.feet.color = SKINCOLOR_RED
			end
			
			// Color the face the same as the feet
			A_ChangeColorAbsolute(player.face, 0, player.feet.color)
			if(player.copyabl and player.copyabl == 97)	// Ow the edge?
				and not(player.powers[pw_super])		// Not when super!
				player.face.color = SKINCOLOR_ORANGE
			end
			
			// Move the feet and face to Kirby!
			P_TeleportMove(player.feet, player.mo.x, player.mo.y, player.mo.z)
			P_TeleportMove(player.face, player.mo.x, player.mo.y, player.mo.z)
			
			// Make the feet and face's angles the same as the player's!
			player.feet.angle = player.mo.angle
			player.face.angle = player.mo.angle
			
			// Scale them the same too!
			player.feet.scale = player.mo.scale
			player.face.scale = player.mo.scale
			
			// Also height
			player.feet.height = player.mo.height
			player.face.height = player.mo.height
			
			// Set the feet's sprite to the feet's... sprite... yeah could've put that better but whatever
			player.feet.sprite = SPR_FEET
			
			// Same for the face!
			player.face.sprite = SPR_FACE
			
			// REVERSE GRAVITY WOAAAAAH
			if(player.mo.eflags & MFE_VERTICALFLIP)
				player.feet.eflags = $1|MFE_VERTICALFLIP
				player.face.eflags = $1|MFE_VERTICALFLIP
			else
				player.feet.eflags = $1 & ~MFE_VERTICALFLIP
				player.face.eflags = $1 & ~MFE_VERTICALFLIP
			end
			
			// MF2_DONTDRAW WOAAAAAH
			if(player.mo.flags2 & MF2_DONTDRAW)
				player.feet.flags2 = $1|MF2_DONTDRAW
				player.face.flags2 = $1|MF2_DONTDRAW
			else
				player.feet.flags2 = $1 & ~MF2_DONTDRAW
				player.face.flags2 = $1 & ~MF2_DONTDRAW
			end
		else
			if(player.feet and player.feet.valid)
				P_RemoveMobj(player.feet)
			end
			if(player.face and player.face.valid)
				P_RemoveMobj(player.face)
			end
		end
	end
end)
