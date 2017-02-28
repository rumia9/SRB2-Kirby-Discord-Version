// This variable decides wether Kirby uses the sucking sound from Return to Dreamland, or the one in Melee!
local sucksound = 2		// 0 = RTDL, 1 = Melee, 2 = Smash Bros 4
local thisisthokker = false	// Thokker compatability!

// Thokker compatability
COM_AddCommand("kicker", function(player)
	if(thisisthokker)
		thisisthokker = false
		CONS_Printf(player, "Thokker compatability is off!")
		CONS_Printf(player, "Match will now randomize abilities!")
	else
		thisisthokker = true
		CONS_Printf(player, "Thokker compatability is on!")
		CONS_Printf(player, "Match will not randomize abilities!")
	end
end)

// -----------------------------------------------------
// Object and states freeslot
// -------------------------------------------------------------------------------------------------------------------
// Objects
freeslot("MT_STAR", "MT_KIRBYSUCKS", "MT_STARN", "MT_DROPABL", "MT_KIRBYSPITFIRE", "MT_KIRBYSPITICE", "MT_KIRBYFREEZE",
"MT_KIRBYICEBLOCK", "MT_PLASMA", "MT_KIRBYSNOT", "MT_KIRBYBOMB", "MT_KIRBYTHROWBOMB", "MT_KIRBYNEEDLEHURT",
"MT_KIRBYBEAM", "MT_KIRBYCUTTER", "MT_KIRBYSPITAIR",
// -------------------------------------------------------------------------------------------------------------------
// Common
"S_PLAY_FLOAT1", "S_PLAY_FLOAT2", "S_PLAY_FLOAT3", "S_PLAY_FLOAT4", "S_PLAY_FLOAT5", "S_PLAY_FLOAT6", "S_PLAY_FLOAT7",
"S_PLAY_KIRBYSWIM1", "S_PLAY_KIRBYSWIM2", "S_PLAY_KIRBYSWIM3", "S_PLAY_KIRBYSWIM4", "S_PLAY_KIRBYSWIM5", "S_PLAY_KIRBYSWIM6", "S_PLAY_KIRBYSWIM7", "S_PLAY_KIRBYSWIM8",
"S_PLAY_KIRBYJUMP", "S_PLAY_KIRBYFLIP1", "S_PLAY_KIRBYFLIP2", "S_PLAY_KIRBYFLIP3", "S_PLAY_KIRBYFLIP4", "S_PLAY_KIRBYFLIP5", "S_PLAY_KIRBYFLIP6", "S_PLAY_KIRBYFLIP7", "S_PLAY_KIRBYFLIP8", "S_PLAY_KIRBYFLIP9", "S_PLAY_KIRBYFLIP10",
"S_PLAY_THROWTHING",
"S_PLAY_KRUN1", "S_PLAY_KRUN2", "S_PLAY_KRUN3", "S_PLAY_KRUN4", "S_PLAY_KRUN5", "S_PLAY_KRUN6", "S_PLAY_KRUN7", "S_PLAY_KRUN8",
// -------------------------------------------------------------------------------------------------------------------
// Far Kirby
"S_PLAY_FATKIRB",
"S_PLAY_FATKIRB_WALK1", "S_PLAY_FATKIRB_WALK2", "S_PLAY_FATKIRB_WALK3", "S_PLAY_FATKIRB_WALK4", "S_PLAY_FATKIRB_WALK5", "S_PLAY_FATKIRB_WALK6", "S_PLAY_FATKIRB_WALK7", "S_PLAY_FATKIRB_WALK8",
"S_PLAY_FATKIRB_JUMP", "S_PLAY_FATKIRB_FALL", "S_PLAY_FATKIRB_HANG",
// -------------------------------------------------------------------------------------------------------------------
// Abilities
"S_PLAY_STONE", "S_PLAY_STONE2", "S_PLAY_WEIGHT", "S_PLAY_STATUE",
"S_PLAY_TORNADO1", "S_PLAY_TORNADO2", "S_PLAY_TORNADO3", "S_PLAY_TORNADO4", "S_PLAY_TORNADO5", "S_PLAY_TORNADO6", "S_PLAY_TORNADO7", "S_PLAY_TORNADO8",
"S_PLAY_SPARK",
"S_PLAY_NEEDLE",
"S_PLAY_WHEELE1", "S_PLAY_WHEELE2", "S_PLAY_WHEELE3", "S_PLAY_WHEELE4",
// -------------------------------------------------------------------------------------------------------------------
// SECRET ABILITIES WOAH!
"MT_KIRBYBIT", "MT_KIRBYBITSHOT")
// -------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------------
// Sound freeslot
// -----------------------------------------------------
freeslot("sfx_run", "sfx_floatm", "sfx_float4", "sfx_puff", "sfx_land",
"sfx_rsuck", "sfx_rsuckl", "sfx_msuck", "sfx_msuckl", "sfx_4suck", "sfx_4suckl", "sfx_eat", "sfx_fill", "sfx_spit", "sfx_spitl", "sfx_swalow",
"sfx_abilit", "sfx_abilid", "sfx_abilir", "sfx_ice", "sfx_sword", "sfx_rock", "sfx_hard", "sfx_thud", "sfx_starod",
"sfx_falco", "sfx_pawnch", "sfx_tornad", "sfx_wheele", "sfx_sleep", "sfx_wakeup", "sfx_hijump",
"sfx_kbeam", "sfx_cutter", "sfx_mike3", "sfx_mike2", "sfx_mike1",
// SECRET ABILITY SOUNDS WOAAAH
"sfx_nouse", "sfx_edgysh", "sfx_bshoot", "sfx_ohno")

// -----------------------------------------------------
// blockingWall
// -----------------------------------------------------
local tester = nil // Misc object used for testing
local function blockingWall(mobj, angle, maxdist)
    if not (tester and tester.valid) then // Spawn a new one!
        tester = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_GARGOYLE) // Has the best chance of not getting cleared on spawn
        tester.flags = MF_NOGRAVITY|MF_NOCLIPTHING // Make sure it won't move or block things
        tester.flags2 = $1|MF2_DONTDRAW // Don't see the gargoyle! (can be commented out for testing if needed)
    end
    
    // Match tester size to mobj size
    tester.radius = mobj.radius
    tester.height = mobj.height
    
    P_TeleportMove(tester, mobj.x, mobj.y, mobj.z) // Move tester to mobj's position
    P_InstaThrust(tester, angle, maxdist) // Misuse P_InstaThrust to easily get the distance to move
    return not P_TryMove(tester, tester.momx+mobj.x, tester.momy+mobj.y, true) // Return the inverse of P_TryMove (since it returns true on successful move, false on blocked)
end

// Functions that contain all the abilities!

// Ability-granting function
local function kirbyGetAbility(player, ability)
	if(ability)
		player.copyabl = ability
		player.mo.state = S_PLAY_RUN1
		S_StartSound(player.mo, sfx_abilit)
		player.abilityto = 0	// Reset this
		return true
	else
		return false
	end
end

// Ability-granting command
COM_AddCommand("grantability", function(player, abl)
	if(player.mo and player.mo.valid)
		if(player.mo.skin == "kirby")
			if(#player == 0)	// Host only, sorry!
				or(player == admin)	// Or we're the admin!
				if(tonumber(abl) and tonumber(abl) >= 1)
					kirbyGetAbility(player, tonumber(abl))
				else
					CONS_Printf(player, "Oh no, that's not a valid ability!")
				end
			else
				CONS_Printf(player, "Oh no, only the server or admin can use this command!")
			end
		else
			CONS_Printf(player, "Oh no, you're not Kirby!")
		end
	else
		CONS_Printf(player, "Oh no, you have to be in-game to use this!")
	end
end)

// -------------------------
// Normal Kirby
local function kirbySucks(player)
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.inhalestate == 2)	// Not locked into inhaling
		and not(player.inhalestate == 3)	// Not fat Kirby
		and(player.mo.health > 0)	// Can't suck if you're dead!
		// Make sure we have control
		and not(player.pflags & PF_STASIS)
		and not(player.exiting)		// Also not exiting
		player.cansuck = true
	end
	
	if not(player.cmd.buttons & BT_USE)		// No longer holding?
		or(player.inhalestate == 2)			// Not when locked into inhaling
		or(player.inhalestate == 3)			// Not when fat Kirby
		or(player.pflags & PF_STASIS)
		or(player.exiting)
		or(player.mo.health <= 0)	// Can't suck if you're dead!
		or(P_PlayerInPain(player))		// Not after getting hurt!
		player.cansuck = false
	end
	
	// Initiate the suckage
	if(player.cansuck)
		and not(player.inhalestate == 2)
		and not(player.inhalestate == 3)
		if not(player.inhalestate)	// Just started?
			player.inhalelooper = 0	// Start the sound
			player.smashfix = true
		end
		player.inhalestate = 1	// Start inhaling!
	end
	
	// Stop inhaling!
	if(player.inhalestate == 1)	// Not locked into inhaling
		and not(player.cmd.buttons & BT_USE)
		player.inhalestate = 0
		S_StopSound(player.mo)	// Stop playing the inhale sound!
		player.mo.state = S_PLAY_RUN1
	end
	
	// Inhaling logic!
	if(player.inhalestate == 1 or player.inhalestate == 2)	// Inhaling?
		player.normalspeed = 0	// Can't move!
		player.jumpfactor = 0	// Can't jump!
		if not(player.powers[pw_nocontrol])
			player.powers[pw_nocontrol] = 1	// Still can't move!
		end
		player.mo.state = S_PLAY_GASP	// *GASP*
		
		// SWHOOOOOOOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIISHHHHHSSHSSHSHSHHSHSSSHSHSHS
		if not(player.inhalelooper == nil)
			if(player.inhalelooper == 0)
				if(sucksound == 0)				// Return to dreamland
					or((player.mo.eflags & MFE_UNDERWATER) and sucksound == 1)
					S_StartSound(player.mo, sfx_rsuck)
				elseif(sucksound == 1)			// Melee
					S_StartSound(player.mo, sfx_msuck)
				else
					S_StartSound(player.mo, sfx_4suck)
				end
			end
			if(sucksound == 0)				// Return to dreamland
				or((player.mo.eflags & MFE_UNDERWATER) and sucksound == 1)
				if(player.inhalelooper == TICRATE*34/35)
					S_StartSound(player.mo, sfx_rsuckl)
				end
				player.inhalelooper = $1 + 1	// Use the looping sound
				if(player.inhalelooper > TICRATE*44/35)
					player.inhalelooper = TICRATE*34/35
				end
			elseif(sucksound == 1)			// Melee
				local endtime = TICRATE*31/35
				if(player.inhalelooper == endtime)
					S_StartSound(player.mo, sfx_msuckl)
				end
				player.inhalelooper = $1 + 1	// Use the looping sound
				if(player.inhalelooper > TICRATE*72/35)
					player.inhalelooper = endtime
				end
			else
				local endtime = TICRATE*18/35
				local notthisframe = false
				if(player.inhalelooper == endtime)
					or not(S_SoundPlaying(player.mo, sfx_4suck) or S_SoundPlaying(player.mo, sfx_4suckl))
					S_StartSound(player.mo, sfx_4suckl)
					player.inhalelooper = endtime
					if(player.smashfix)
						notthisframe = true
						player.smashfix = false
					end
				end
				player.inhalelooper = $1 + 1	// Use the looping sound
				if(player.inhalelooper > TICRATE*10/35)
					and not(player.smashfix)
					and not(notthisframe)
					player.inhalelooper = endtime
				end
			end
		end
		
		// The actualy important part: THE SUCKY WOOOOOOOOOOOOOOO
		local gotox = player.mo.x+FixedMul(player.mo.radius+(160*player.mo.scale), cos(player.mo.angle))
		local gotoy = player.mo.y+FixedMul(player.mo.radius+(160*player.mo.scale), sin(player.mo.angle))
		local suckyobj = P_SpawnMobj(gotox, gotoy, player.mo.z, MT_KIRBYSUCKS)
		suckyobj.target = player.mo
		suckyobj.sucktimer = 5		// How long this thing sucks
		// Match this thing to the player
		suckyobj.scale = player.mo.scale
		
		suckyobj.flags2 = $1|MF2_DONTDRAW
		if(player.mo.eflags & MFE_VERTICALFLIP)
			suckyobj.eflags = $1|MFE_VERTICALFLIP
		else
			P_TeleportMove(suckyobj, gotox, gotoy, player.mo.z+player.mo.height-suckyobj.height)
		end
	end
	
	// Fat logic!
	if(player.inhalestate == 3)
		// Did we eat an un-modifyable object?
		if(player.atedontmod)
			and(player.atedontmodmobj and player.atedontmodmobj.valid)
			P_TeleportMove(player.atedontmodmobj, player.mo.x, player.mo.y, player.mo.z)
			player.atedontmodmobj.momx = player.mo.momx
			player.atedontmodmobj.momy = player.mo.momy
			player.atedontmodmobj.momz = player.mo.momz
			player.atedontmodmobj.flags2 = $1|MF2_DONTDRAW
			if(player.mo.eflags & MFE_VERTICALFLIP)
				player.atedontmodmobj.eflags = $1|MFE_VERTICALFLIP
			else
				player.atedontmodmobj.eflags = $1 & ~MFE_VERTICALFLIP
			end
		elseif(player.atedontmod)										// Lost the object?
			and not(player.atedontmodmobj and player.atedontmodmobj.valid)
			player.atedontmod = false
			S_StartSound(player.mo, sfx_swalow)
			player.badtime = leveltime
			player.inhalestate = 0		// Rip everything
		end
		// Did we eat a player?
		if(player.ateaplayer)
			and(player.ateplayer and player.ateplayer.valid)
			P_TeleportMove(player.ateplayer.mo, player.mo.x, player.mo.y, player.mo.z)
			player.ateplayer.powers[pw_nocontrol] = player.powers[pw_nocontrol]+1	// Never gonna get out
			player.ateplayer.powers[pw_flashing] = TICRATE*3	// Fixes ring losing
			player.ateplayer.mo.state = S_PLAY_PAIN	// Owchies
			player.ateplayer.pflags = $1|PF_STASIS
			player.ateplayer.pflags = $1|PF_JUMPSTASIS
			player.ateplayer.mo.momx = player.mo.momx
			player.ateplayer.mo.momy = player.mo.momy
			player.ateplayer.mo.momz = player.mo.momz
			player.ateplayer.mo.flags2 = $1|MF2_DONTDRAW
			if(player.mo.eflags & MFE_VERTICALFLIP)
				player.ateplayer.mo.eflags = $1|MFE_VERTICALFLIP
			else
				player.ateplayer.mo.eflags = $1 & ~MFE_VERTICALFLIP
			end
		elseif(player.ateaplayer and player.ateplayer and not player.ateplayer.valid)	// Lost the player somehow?
			player.ateaplayer = false
			S_StartSound(player.mo, sfx_swalow)
			player.badtime = leveltime
			player.inhalestate = 0		// Rip everything
		end
	end
	
	// Ability gaining logic!
	if(player.inhalestate == 3)	// Full and we have an ability to go to?
		and(player.spintics >= TICRATE*20/35)
		//and(P_IsObjectOnGround(player.mo))	// Only on the ground! Also means not when hurt!
		and not(P_PlayerInPain(player))			// Not in pain!
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't eat if you're dead!
		
		// Does this thing have an ability?
		if(player.abilityto)
			if not(player.abilityto == 80)	// Not hyper!
				if(player.abilityto == 100)	// Random ability?
					player.abilityto = P_RandomKey(17)+1	// RANDOM ABILITY! (Put the number of abilities here)
					if(player.abilityto > 17)				// Avoid getting mike with 2/1 charge(s)!
						player.abilityto = $1+2
					end
				end
				kirbyGetAbility(player, player.abilityto)	// Get the ability!
			else
				//kirbyGetAbility(player, 0)
				//A_Invincibility(player.mo)
				player.powers[pw_invulnerability] = (20*TICRATE) + 1
				//print("Should be invincible?")
				S_StartSound(player.mo, sfx_abilit)
				player.abilityto = 0	// Reset this
			end
		end
		
		// Is this a special-case mobj?
		if(player.atedontmod)
			and(player.atedontmodmobj and player.atedontmodmobj.valid)
			// Set free the eaten object
			P_InstaThrust(player.atedontmodmobj, player.mo.angle, -7*FRACUNIT)
			P_SetObjectMomZ(player.atedontmodmobj, 7*FRACUNIT)
			
			// Reset the player's flags!
			player.atedontmodmobj.flags2 = $1 & ~MF2_DONTDRAW
			player.atedontmodmobj.beingsucked = false
		end
		
		// Okay, is it a player?
		player.badissilver = false
		if(player.ateaplayer)
			and(player.ateplayer and player.ateplayer.valid)
			and(player.ateplayer.mo and player.ateplayer.mo.valid)
			
			// Skin stuff
			if(player.ateplayer.mo.skin == "silver")
				S_StartSound(player.ateplayer.mo, sfx_nouse)
				player.badissilver = true
			end
			
			// Steal the player's ability!
			if(player.ateplayer.copyabl)
				kirbyGetAbility(player, player.ateplayer.copyabl)
				if(player.copyabl == 3)	// Mini ability?
					player.mo.scale = FRACUNIT	// Reset the size
				end
				player.ateplayer.copyabl = 0
			end
			
			// Set free the eaten player
			P_InstaThrust(player.ateplayer.mo, player.mo.angle, -7*FRACUNIT)
			P_SetObjectMomZ(player.ateplayer.mo, 7*FRACUNIT)
			player.ateplayer.powers[pw_flashing] = TICRATE
			
			// Reset the player's flags!
			player.ateplayer.mo.flags2 = $1 & ~MF2_DONTDRAW
			player.ateplayer.mo.flags = $1|MF_SHOOTABLE	// Can be hurt
			player.ateplayer.mo.flags = $1 & ~MF_NOCLIP	// Can't noclip things
			player.ateplayer.mo.flags = $1 & ~MF_NOCLIPHEIGHT
			player.ateplayer.mo.beingsucked = false
		end
		
		if not(player.copyabl)	// No ability in the end?
			and not(player.powers[pw_invulnerability] == (20*TICRATE) + 1)	// Not invinciblity!
			
			S_StartSound(player.mo, sfx_swalow)
			player.badtime = leveltime
		end
		
		// Reset Kirby
		player.inhalestate = 0	// Reset the state
		player.atemultiple = false	// Reset this value so we don't randomize the ability next time!
		player.ateaplayer = false	// Not eaten anymore
		player.atedontmod = false	// Ditto
	end
	
	local pressedspin = false
	if(player.spintics == 1)	// We pressed spin?
		and not(player.lastspinpress == nil)
		and(leveltime-player.lastspinpress < TICRATE/4)	// And we double tapped!
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.exiting)		// Also not exiting
		and not(P_PlayerInPain(player))	// Not when hurt!
		pressedspin = true
	end
	if(player.mo.state == S_PLAY_GASP)
		pressedspin = true
	end
	
	// Spitting logic!
	if(player.inhalestate == 3)	// Full?
		and(pressedspin)		// Pressed spin?
		and(player.mo.health > 0)	// Can't spit if you're dead!
		
		// Spit the star!
		if not(player.ateaplayer)
			and not(player.atedontmod)
			local star = P_SPMAngle(player.mo, MT_STARN, player.mo.angle, 1)
			if(star and star.valid)		// We could've hit something this frame?
				star.target = player.mo
				star.scale = player.mo.scale
				star.thisisbig = false
				if(player.atemultiple)
					star.scale = $1*2
					star.thisisbig = true
					if(player.mo.eflags & MFE_VERTICALFLIP)
						P_TeleportMove(star, star.x, star.y, star.z-(star.height/2))	// Move the star down so it doesn't hit the floor instantly!
					end
				end
			end
		else
			// Spit the mobj!
			if(player.atedontmod)
				and(player.atedontmodmobj and player.atedontmodmobj.valid)
				// Set free the eaten object
				P_InstaThrust(player.atedontmodmobj, player.mo.angle, 80*FRACUNIT)
				P_SetObjectMomZ(player.atedontmodmobj, 5*FRACUNIT)
				
				// Reset the mobj's flags!
				player.atedontmodmobj.flags2 = $1 & ~MF2_DONTDRAW
				player.atedontmodmobj.beingsucked = false
			end
			// Spit the player!
			if(player.ateaplayer)
				and(player.ateplayer and player.ateplayer.valid)
				// Set free the eaten player
				P_InstaThrust(player.ateplayer.mo, player.mo.angle, 80*FRACUNIT)
				P_SetObjectMomZ(player.ateplayer.mo, 5*FRACUNIT)
				player.ateplayer.powers[pw_flashing] = 0	// Not getting out without a few bruises though!
				
				// Reset the player's flags!
				player.ateplayer.mo.flags2 = $1|MF2_DONTDRAW
				player.ateplayer.mo.flags = $1|MF_SHOOTABLE	// Can be hurt
				player.ateplayer.mo.flags = $1 & ~MF_NOCLIP	// Can't noclip things
				player.ateplayer.mo.flags = $1 & ~MF_NOCLIPHEIGHT
				player.ateplayer.mo.beingsucked = false
			end
		end
		
		// Play the sounds!
		if(player.atemultiple)
			S_StartSound(player.mo, sfx_spitl)
		else
			S_StartSound(player.mo, sfx_spit)
		end
		
		// Reset Kirby
		player.inhalestate = 0	// Reset the state
		player.abilityto = 0	// Reset this too!
		player.atemultiple = false	// Reset this value so we don't spit multiple next time!
		player.ateaplayer = false	// Not eaten anymore
		player.atedontmod = false	// Ditto
		player.mo.state = S_PLAY_GASP	// Spit!
	end
end

// Droping abilities
local function kirbyDropAbility(player)
	// Can't drop abilities in match!
	if not(G_RingSlingerGametype())
		or(thisisthokker)
		if(player.copyabl == 3)	// Mini ability?
			player.mo.scale = FRACUNIT	// Reset the size
		end
		if(player.copyabl == 98)// QP ability?
			or(player.copyabl == 97)	// Or ow the edge
			P_RestoreMusic(player)	// Stop the special theme!
		end
		S_StartSound(player.mo, sfx_abilir)
		local drop = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+player.mo.height, MT_DROPABL)
		drop.abilitytogive = player.copyabl
		drop.scale = player.mo.scale
		if(player.mo.eflags & MFE_VERTICALFLIP)
			P_TeleportMove(drop, player.mo.x, player.mo.y, player.mo.z)
			drop.eflags = $1|MFE_VERTICALFLIP
		end
		P_InstaThrust(drop, player.mo.angle, -7*FRACUNIT)
		P_SetObjectMomZ(drop, 5*FRACUNIT)
		player.copyabl = 0
	end
end

// -------------------------
// Ability functions

// Stone
local function kirbyDoRock(player)
	// Unstoneing
	if(player.spintics == 1 and player.inhalestate)
		or(player.exiting and player.inhalestate)		// Also not exiting
		S_StartSound(player.mo, sfx_rock)
		player.inhalestate = 0
		player.mo.flags = $1|MF_SHOOTABLE	// So things can hit you
		player.mo.flags = $1 & ~MF_PUSHABLE
	// Initiate the drop
	elseif(player.spintics == 1)
		and not(player.inhalestate)
		and not(player.flystate)	// Can't do this when flying!
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.inhalestate = TICRATE/2	// Have to wait half a second to fall
		S_StartSound(player.mo, sfx_rock)
		player.mo.momx = $1 / 2
		player.mo.momy = $1 / 2
		player.mo.momz = 0
		player.stonetic = leveltime	// Used for animation
	end
	// Falling delay
	if(player.inhalestate > 1)
		player.inhalestate = $1 - 1
		if not(P_IsObjectOnGround(player.mo))
			player.mo.momz = 0
		else
			P_SetObjectMomZ(player.mo, -20*FRACUNIT)	// For sliding down slopes
		end
	// Falling down
	elseif(player.inhalestate == 1)
		if not(P_IsObjectOnGround(player.mo))
			P_SetObjectMomZ(player.mo, -40*FRACUNIT)
		else
			P_SetObjectMomZ(player.mo, -20*FRACUNIT)	// For sliding down slopes
		end
		if not(P_IsObjectOnGround(player.mo))
			player.mo.momx = 0
			player.mo.momy = 0
		end
		if(P_IsObjectOnGround(player.mo))
			and not(player.prevground)
			// Hit the ground
			S_StartSound(player.mo, sfx_hard)
			P_NukeEnemies(player.mo, player.mo, 1024*FRACUNIT)
		end
	end
	// Stone frame
	if(player.inhalestate)
		// Choose a stone based on level time!
		if not(player.stonetic % 4)
			player.mo.state = S_PLAY_STATUE
		elseif not(player.stonetic % 3)
			player.mo.state = S_PLAY_WEIGHT
		elseif not(player.stonetic % 2)
			player.mo.state = S_PLAY_STONE2
		else
			player.mo.state = S_PLAY_STONE
		end
		player.jumpfactor = 0	// No jumpies!
		player.normalspeed = 0	// Or movies!... movies... ugh...
		player.mo.flags = $1|MF_PUSHABLE	// So you can activate push switches (and be pushed)
		player.pflags = $1|PF_JUMPED	// So you can hit things
		player.mo.flags = $1 & ~MF_SHOOTABLE	// So things can't hit you
		if(P_CheckDeathPitCollide(player.mo))
			player.mo.flags = $1|MF_SHOOTABLE	// Unless a death pit
		end
		if not(player.powers[pw_nocontrol])
			player.powers[pw_nocontrol] = 1	// Can't move!
		end
	end
end

// Crash
local function kirbyDoCrash(player)
	if not(leveltime%5)	// Every fifth frame
		player.mo.color = SKINCOLOR_ORANGE	// Flashy!
	end
	if(player.spintics == 1)	// Pressed
		and not(player.flystate)	// Not flying
		and not(player.inhalestate)	// Not already using the ability
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.inhalestate = TICRATE*3	// Wait three seconds
		S_StartSound(player.mo, sfx_rumble)
	end
	// Lock the player in place
	if(player.inhalestate > 0)
		player.normalspeed = 0
		player.jumpfactor = 0
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		if not(player.inhalestate % 3)
			P_FlashPal(player, 1, 2)	// EPELEPSY WARNING SEIZURES AHOY
		end
	end
	// KA-BEWM
	if(player.inhalestate == 1)
		S_StartSound(player.mo, sfx_bkpoof)
		P_NukeEnemies(player.mo, player.mo, 1024*FRACUNIT*5)
		P_FlashPal(player, 4, TICRATE/3)
		player.copyabl = 0	// No more crash!
		player.mo.flags = $1 & ~MF_SHOOTABLE	// Can get hurt again!
		player.mo.flags = $1 & ~MF_NOCLIP		// Solid again!
	end
	// Timer
	if(player.inhalestate)
		player.inhalestate = $1 - 1
		player.mo.flags = $1|MF_SHOOTABLE
		player.mo.flags = $1|MF_NOCLIP		// Don't get inhaled!
	end
end

// Hi Jump
local function kirbyDoHiJump(player)
	if(player.spintics == 1)
		and(P_IsObjectOnGround(player.mo))
		and not(player.pflags & PF_JUMPSTASIS)	// No jumping if jumping isn't allowed
		and not(player.powers[pw_nocontrol])	// Can't jump like this either
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(P_PlayerInPain(player))	// Not when in pain!
		//and not(player.inhalestate)
		P_SetObjectMomZ(player.mo, 25*FRACUNIT)
		S_StartSound(player.mo, sfx_hijump)
		player.mo.state = S_PLAY_KIRBYJUMP
		player.inhalestate = TICRATE*3/2	// ATTAAAAAACK
	end
	
	if(player.inhalestate)
		player.pflags = $1|PF_JUMPED
		// Attack things in match!
		if(G_RingSlingerGametype())
			and not(thisisthokker)
			P_RadiusAttack(player.mo, player.mo, player.mo.radius)
		end
		if not(leveltime%5)	// Every fifth frame
			player.mo.color = SKINCOLOR_ORANGE	// Flashy!
		end
		player.inhalestate = $1 - 1
		if(player.mo.momz*P_MobjFlip(player.mo) < 0)
			player.inhalestate = 0
		end
		if(player.inhalestate == 0)
			player.pflags = $1 & ~PF_JUMPED		// Stop attacking things!
		end
	end
end

// Kirby Boom: Fire/Ice
local function kirbyDoFireIce(player, fireice)
	if not(player.mo.eflags & MFE_UNDERWATER)
		and not(multiplayer)
		if(fireice)
			player.mo.color = SKINCOLOR_CYAN	// Blue for ice
		else
			player.mo.color = SKINCOLOR_ORANGE	// Red for fire
		end
	end
	
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.exiting)		// Not exiting
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(P_PlayerInPain(player))	// Not when in pain!
		and not(player.mo.eflags & MFE_UNDERWATER)	// Not underwater!
		player.cansuck = true
	end
	
	if not(player.cmd.buttons & BT_USE)		// No longer holding?
		or(player.pflags & PF_STASIS)
		or(player.exiting)
		or(player.mo.health <= 0)
		or(P_PlayerInPain(player))	// Not when in pain!
		or(player.mo.eflags & MFE_UNDERWATER)
		player.cansuck = false
	end
	
	// Initiate the blowing
	if(player.cansuck)
		player.inhalestate = 1	// Start blowing!
	end
	
	// Stop blowing!
	if(player.inhalestate)
		and(not(player.cmd.buttons & BT_USE) or (player.mo.eflags & MFE_UNDERWATER))
		player.inhalestate = 0
		S_StopSound(player.mo)	// Stop playing the fire/ice sound!
		player.mo.state = S_PLAY_RUN1
	end
	
	// Blowing logic!
	if(player.inhalestate)	// Blowing?
		and not(fireice and player.mo.eflags & MFE_UNDERWATER)	// Can't blow ice underwater
		player.normalspeed = 0	// Can't move!
		player.jumpfactor = 0	// Can't jump!
		if not(player.powers[pw_nocontrol])
			player.powers[pw_nocontrol] = 1	// Still can't move!
		end
		player.mo.state = S_PLAY_GASP	// *GASP*
		
		// Slow down the player!
		//player.mo.momx = $1*6/7
		//player.mo.momy = $1*6/7
		
		// Play the sound!
		if(fireice)
			if not(S_SoundPlaying(player.mo, sfx_ice))
				S_StartSound(player.mo, sfx_ice)	// Ice sound
			end
		else
			if not(leveltime % 5)
				and not(player.mo.eflags & MFE_UNDERWATER)
				S_StartSound(player.mo, sfx_koopfr)	// Fire sound
			end
		end
		
		// Spit the fire/ice!
		local gotox = player.mo.x+FixedMul(player.mo.radius*2, cos(player.mo.angle))
		local gotoy = player.mo.y+FixedMul(player.mo.radius*2, sin(player.mo.angle))
		
		if not(leveltime % 3)	// Every third frame
			if(player.mo.eflags & MFE_UNDERWATER)
				/*local spitfire = P_SPMAngle(player.mo, MT_PARTICLE, player.mo.angle, 1)
				if(spitfire and spitfire.valid)
					P_TeleportMove(spitfire, gotox, gotoy, spitfire.z)
				end*/
			else
				if(fireice)	// Ice
					local spitfire = P_SPMAngle(player.mo, MT_KIRBYSPITICE, player.mo.angle, 0)
					if(spitfire and spitfire.valid)
						P_TeleportMove(spitfire, gotox, gotoy, spitfire.z)
					end
				else		// Fire
					local spitfire = P_SPMAngle(player.mo, MT_KIRBYSPITFIRE, player.mo.angle, 1)
					if(spitfire and spitfire.valid)
						P_TeleportMove(spitfire, gotox, gotoy, spitfire.z)
					end
				end
			end
		end
	end
	
	// Ice's ability to freeze!
	/*local hasiced = false
	if(fireice)
		and not(player.inhalestate)	// Not using abilities
		and(player.cmd.buttons & BT_CUSTOM1)
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		//and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		
		player.normalspeed = 0	// Can't move!
		player.jumpfactor = 0	// Can't jump!
		//if(player.powers[pw_nocontrol] <= 1)
		//	player.powers[pw_nocontrol] = 1	// Still can't move!
		//end
		// Slow down the player!
		//player.mo.momx = $1*6/7
		//player.mo.momy = $1*6/7
		
		player.mo.state = S_PLAY_STND	// Animate
		
		// Play the sound!
		if not(S_SoundPlaying(player.mo, sfx_ice))
			S_StartSound(player.mo, sfx_ice)	// Ice sound
		end
		
		// Spawn the aura!
		local freezeaura = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYFREEZE)
		if(freezeaura.valid)	// Make sure we still exsist!
			freezeaura.frame = leveltime%4|TR_TRANS20
			freezeaura.momx = player.mo.momx
			freezeaura.momy = player.mo.momy
			freezeaura.momz = player.mo.momz
			if(player.mo.eflags & MFE_VERTICALFLIP)
				freezeaura.eflags = $1|MFE_VERTICALFLIP	// Flip the freeze with the player!
			end
		end
		
		hasiced = true
	end
	
	// Crappy freezing fix
	if(player.previce)
		and not(hasiced)
		S_StopSound(player.mo)
	end
	
	player.previce = hasiced*/
end

// Tornado
local function kirbyDoTornado(player)
	if(P_IsObjectOnGround(player.mo))
		player.cansuck = true
	end
	
	if(player.spintics == 1)	// Just pressed
		and not(player.inhalestate)	// Not already using the ability
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])// Same here
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
	//	and(P_IsObjectOnGround(player.mo))	// Only do it on the ground!
		and(player.cansuck)			// Don't use it multiple times in the air!
		player.inhalestate = TICRATE*2
		player.mo.state = S_PLAY_TORNADO1
		player.savez = player.mo.z
		player.cansuck = false
	end
	
	// You spin me right round
	if(player.inhalestate)
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
	//	and not(player.pflags & PF_STASIS)	// Make sure we have control
	//	and not(player.powers[pw_nocontrol])// Same here
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		
		// Hurt things!
		player.pflags = $1|PF_JUMPED
		// Attack things in match!
		if(G_RingSlingerGametype())
			and not(thisisthokker)
			P_RadiusAttack(player.mo, player.mo, player.mo.radius)
		end
		
		if(player.powers[pw_nocontrol] <= 1)
			and not((player.pflags & PF_ANALOGMODE) or (player.mo.flags2 & MF2_TWOD) or twodlevel)	// Only in 3d non-analog!
			player.powers[pw_nocontrol] = 1
		end
		
		// Thrust the player forwards!
	//	P_InstaThrust(player.mo, player.mo.angle, 30*FRACUNIT)
		player.mo.momx = $1 - player.cmomx
		player.mo.momy = $1 - player.cmomy
		player.mo.momx = $1*16/17
		player.mo.momy = $1*16/17
		player.mo.momx = $1 + player.cmomx
		player.mo.momy = $1 + player.cmomy
		P_Thrust(player.mo, player.mo.angle, 3*FRACUNIT)
		
		// Go up!
		if(player.cmd.buttons & BT_USE)
			//player.inhalestate = TICRATE*2
			P_SetObjectMomZ(player.mo, FRACUNIT+1, true)
		end
		
		// Max height
		if(player.mo.eflags & MFE_VERTICALFLIP)
			if(player.mo.z < player.savez-(400*FRACUNIT))
				P_TeleportMove(player.mo, player.mo.x, player.mo.y, player.savez-(400*FRACUNIT))
				player.mo.momz = 0
			end
		else
			if(player.mo.z > player.savez+(400*FRACUNIT))
				P_TeleportMove(player.mo, player.mo.x, player.mo.y, player.savez+(400*FRACUNIT))
				player.mo.momz = 0
			end
		end
		
		// Spam the tornado sound!
		if not(leveltime%5)
			S_StartSound(player.mo, sfx_tornad)
		end
		
		// Almost done?
		if(player.inhalestate == 1)
			player.mo.momx = $1/2
			player.mo.momy = $1/2
			player.mo.momz = $1/2
			player.mo.state = S_PLAY_RUN1	// Reset state
		end
		
		player.inhalestate = $1 - 1
	end
	
	if not(player.mo.state >= S_PLAY_TORNADO1 and player.mo.state <= S_PLAY_TORNADO8)
		and(player.inhalestate)	// Tornadoing when you cant tornado?
		player.inhalestate = 0	// Nope
	end
end

// Spark
local function kirbyDoPlasma(player)
	if not(player.mo.eflags & MFE_UNDERWATER)
		and not(multiplayer)
		player.mo.color = SKINCOLOR_GREEN	// Green for plasma... even though it's spark whatever
	end
	
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.exiting)		// Not exiting
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(player.mo.eflags & MFE_UNDERWATER)	// Not underwater!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.cansuck = true
	end
	
	if not(player.cmd.buttons & BT_USE)		// No longer holding?
		//or(player.pflags & PF_STASIS)
		or(player.exiting)
		or(player.mo.health <= 0)
		or(P_PlayerInPain(player))	// Not when in pain!
		or(player.mo.eflags & MFE_UNDERWATER)
		if(player.cansuck)
			player.inhalestate = 0
			S_StopSound(player.mo)	// Stop playing the electricity sound!
			S_StartSound(player.mo, sfx_s3k41)	// Play a fancy ending sound!
			player.mo.state = S_PLAY_RUN1
		end
		player.cansuck = false
	end
	
	// Initiate the sparks!
	if(player.cansuck)
		player.inhalestate = 1	// Start blowing!
	end
	
	if(player.inhalestate)	// Using the ability
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		//and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		
		player.normalspeed = 0	// Can't move!
		player.jumpfactor = 0	// Can't jump!
		if(player.powers[pw_nocontrol] <= 1)
			player.powers[pw_nocontrol] = 1	// Still can't move!
		end
		// Slow down the player!
		//player.mo.momx = $1*6/7
		//player.mo.momy = $1*6/7
		
		// Play the sound!
		if not(leveltime%4)
			S_StartSound(player.mo, sfx_s3k40)
		end
		
		player.mo.state = S_PLAY_SPARK	// Strike a pose!... or lighting, that works too
		// Spawn the aura!
		/*local plasma = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_PLASMA)
		if(plasma and plasma.valid)	// Make sure we still exsist!
			P_TeleportMove(plasma, player.mo.x, player.mo.y, player.mo.z)
			plasma.frame = leveltime%2|TR_TRANS20
			plasma.momx = player.mo.momx
			plasma.momy = player.mo.momy
			plasma.momz = player.mo.momz
			if(player.mo.eflags & MFE_VERTICALFLIP)
				plasma.eflags = $1|MFE_VERTICALFLIP	// Flip the aura with the player!
				P_TeleportMove(plasma, player.mo.x, player.mo.y, player.mo.z+player.mo.height-plasma.height)
			end
		end*/
		
		// Hurt enemies!
		local toheight = FixedMul(mobjinfo[MT_PLASMA].height, player.mo.scale)
		local visualobj = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+(player.mo.height/2)-(toheight/2), MT_PLASMA)
		local hurtobj = P_SpawnMobj(player.mo.x+player.mo.momx, player.mo.y+player.mo.momy, player.mo.z+(player.mo.height/2)-(toheight/2)+player.mo.momz, MT_PLASMA)
		hurtobj.scale = player.mo.scale	// Same scale!
		hurtobj.target = player.mo	// Our missile!
		hurtobj.flags2 = $1|MF2_DONTDRAW	// Don't draw!
		if(player.mo.eflags & MFE_VERTICALFLIP)
			hurtobj.eflags = $1|MFE_VERTICALFLIP
		end
		// The visual bit!
		visualobj.scale = player.mo.scale	// Same scale!
		visualobj.target = player.mo	// Our missile!
		visualobj.frame = leveltime%2|TR_TRANS40	// Animate and transparent!
		if(player.mo.eflags & MFE_VERTICALFLIP)
			visualobj.eflags = $1|MFE_VERTICALFLIP
		end
	end
end

// Sleep "ability"
local function kirbyDoSleep(player)
	if not(player.inhalestate)		// Just started sleeping?
		player.inhalestate = TICRATE*5	// Shhhh, we're asleep!
	end
	
	if(player.inhalestate)
		
		player.mo.state = S_PLAY_STND	// Zzzzzzzz
		player.mo.momx = player.cmomx		// Can't move at all
		player.mo.momy = player.cmomy		// Still can't move at all
		if not(player.powers[pw_nocontrol])
			player.powers[pw_nocontrol] = 1	// No control
		end
		
		// Spawn a bubble!
		if not(player.inhalestate%TICRATE)	// Every second
			S_StartSound(player.mo, sfx_sleep)
			local snot = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+player.mo.height, MT_KIRBYSNOT)
			if(snot and snot.valid)		// We still exsist?
				if(player.mo.eflags & MFE_VERTICALFLIP)	// Flipped?
					snot.eflags = $1|MFE_VERTICALFLIP
					P_TeleportMove(snot, snot.x, snot.y, player.mo.z)
				end
				P_SetObjectMomZ(snot, 5*FRACUNIT)
			end
		end
		
		if(player.inhalestate == 1)	// About to end?
			or(P_PlayerInPain(player))	// Or we got hit?
			or(player.mo.eflags & MFE_TOUCHWATER)	// Can't sleep very well when touching water!
			or(player.mo.eflags & MFE_UNDERWATER)	// Can't sleep very well when in the water!
			player.copyabl = 0	// Reset ability!
			player.abilityto = 0	// Reset this
			S_StartSound(player.mo, sfx_wakeup)
			if not(P_PlayerInPain(player))
				and(P_IsObjectOnGround(player.mo))		// Also being on the ground is important
				P_SetObjectMomZ(player.mo, 5*FRACUNIT)	// Jump into the air, but not if we got hurt!
			end
		end
		
		player.inhalestate = $1 - 1
	end
end

// Bomb
local function kirbyDoBomb(player)
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(player.mo.eflags & MFE_UNDERWATER)	// Bombs don't work underwater!
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(player.mo.state == S_PLAY_THROWTHING)	// Can't grab a bomb if you're throwing one!
		if(player.cansuck)
			player.cansuck = false
			P_SPMAngle(player.mo, MT_KIRBYTHROWBOMB, player.mo.angle, 1)
			player.mo.state = S_PLAY_THROWTHING		// Throwing frame!
		else
			player.cansuck = true
			player.isrunning = false
			// Slow down the player!
		/*	player.mo.momx = $1-player.cmomx
			player.mo.momy = $1-player.cmomy
			player.mo.momx = $1/4
			player.mo.momy = $1/4
			player.mo.momx = $1+player.cmomx
			player.mo.momy = $1+player.cmomy*/
		end
	end
	
	// Bombs don't work underwater!
	if(player.mo.eflags & MFE_UNDERWATER)
		or(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		player.cansuck = false
	end
	
	// Do we have a bomb?
	if(player.cansuck)
		// Find out where to put this thing!
		local targz = player.mo.z+player.mo.height
		if(player.mo.eflags & MFE_VERTICALFLIP)
			targz = player.mo.z-FixedMul(mobjinfo[MT_KIRBYBOMB].height, player.mo.scale)
		end
		
		// Bomb spawning!
		if not(player.heldbomb and player.heldbomb.valid)	// Don't have a bomb?
			player.heldbomb = P_SpawnMobj(player.mo.x, player.mo.y, targz, MT_KIRBYBOMB)	// Then spawn one!
			player.heldbomb.timelefttosplode = TICRATE*3	// 3 Seonds till dentonation!
		end
		
		// Flip the bomb with us!
		if(player.mo.eflags & MFE_VERTICALFLIP)
			player.heldbomb.eflags = $1|MFE_VERTICALFLIP
		else
			player.heldbomb.eflags = $1 & ~MFE_VERTICALFLIP
		end
		
		// Move the bomb to the right spot!
		P_TeleportMove(player.heldbomb, player.mo.x, player.mo.y, targz)
		
		// Splode the bomb if we've been holding it too long!
		player.heldbomb.timelefttosplode = $1 - 1
		if(player.heldbomb.timelefttosplode <= 0)
			P_DamageMobj(player.mo, player.heldbomb, player.heldbomb)
			player.cansuck = false
			S_StartSound(player.heldbomb, sfx_brakrx)	// KA-BEWM
			P_RadiusAttack(player.heldbomb, player.mo, 160*FRACUNIT)
			P_KillMobj(player.heldbomb)
			player.heldbomb.health = 0	// Paranoid
		end
		
		// Animation!
		if(player.mo.state >= S_PLAY_STND and player.mo.state <= S_PLAY_RUN8)
			// Change the sprite!
		//	player.mo.sprite = SPR_KRUN
			if not(player.mo.state >= S_PLAY_KRUN1 and player.mo.state <= S_PLAY_KRUN8)
				player.mo.state = S_PLAY_KRUN1
			end
			// Faster animation!
			if(player.mo.tics > 1)
				player.mo.tics = 1//$1 - 1
			end
		end
		
		if(player.mo.state >= S_PLAY_KIRBYFLIP1 and player.mo.state <= S_PLAY_KIRBYFLIP10)
			player.mo.state = S_PLAY_FALL1
		end
	elseif(player.heldbomb and player.heldbomb.valid and player.heldbomb.health > 0)
		P_RemoveMobj(player.heldbomb)
	end
end

// Needle
local function kirbyDoNeedle(player)
	if not(multiplayer)
		player.mo.color = SKINCOLOR_YELLOW
	end
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.exiting)		// Not exiting
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.cansuck = true
		S_StartSound(player.mo, sfx_s3k42)
	end
	
	if not(player.cmd.buttons & BT_USE)		// No longer holding?
		or(player.pflags & PF_STASIS)
		or(player.exiting)
		or(player.mo.health <= 0)
		or(P_PlayerInPain(player))	// Not when in pain!
		or(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		player.cansuck = false
	end
	
	// Initiate the SPIKES OF DEATH
	if(player.cansuck)
		and(player.inhalestate <= 0)
		player.inhalestate = 1	// Start blowing!
	end
	
	// Stop needling!
	if(player.inhalestate)
		and not(player.cmd.buttons & BT_USE)
		player.inhalestate = 0
		player.mo.state = S_PLAY_RUN1
	end
	
	if(player.inhalestate)	// Using the ability
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		//and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		
		player.normalspeed = 0	// Can't move!
		player.jumpfactor = 0	// Can't jump!
		if(player.powers[pw_nocontrol] <= 1)
			player.powers[pw_nocontrol] = 1	// Still can't move!
		end
		
		// Stop the player on the ground!
		if(P_IsObjectOnGround(player.mo))
			player.mo.momx = player.cmomx
			player.mo.momy = player.cmomy
		end
		
		player.mo.state = S_PLAY_NEEDLE	// Animate
		
		player.previnhalestate = player.inhalestate
		player.inhalestate = 1
		
		// Latch onto walls!
		if not(P_IsObjectOnGround(player.mo))
			local a2 = 0
			local a3 = 0
			while(a2 < 8)
				and(player.inhalestate == 1)
				if(blockingWall(player.mo, a3, FRACUNIT))		// A wall?
					player.inhalestate = 2
					if(player.previnhalestate == 1)
						S_StartSound(player.mo, sfx_spkdth)
					end
				end
				
				a2 = $1+1
				
				// This part is terrible, but since adding ANGLE_45 would be inaccuret....
				if(a2 == 1)
					a3 = ANGLE_45
				elseif(a2 == 2)
					a3 = ANGLE_90
				elseif(a2 == 3)
					a3 = ANGLE_135
				elseif(a2 == 4)
					a3 = ANGLE_180
				elseif(a2 == 5)
					a3 = ANGLE_225
				elseif(a2 == 6)
					a3 = ANGLE_270
				elseif(a2 == 2)
					a3 = ANGLE_315
				end
			end
			
			// Latch onto ceilings!
			if(player.mo.eflags & MFE_VERTICALFLIP)
				if(player.mo.z <= player.mo.floorz)
					player.inhalestate = 2
					if(player.previnhalestate == 1)
						S_StartSound(player.mo, sfx_spkdth)
					end
				end
			else
				if(player.mo.z + player.mo.height >= player.mo.ceilingz)
					player.inhalestate = 2
					if(player.previnhalestate == 1)
						S_StartSound(player.mo, sfx_spkdth)
					end
				end
			end
		end
		
		// Wall physics!
		if(player.inhalestate == 2)
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
			
			// Not on a wall anymore!
			if(P_IsObjectOnGround(player.mo))
				player.inhalestate = 1
			end
		end
		
		// Hurt enemies!
		local toheight = FixedMul(mobjinfo[MT_KIRBYNEEDLEHURT].height, player.mo.scale)
		local hurtobj = P_SpawnMobj(player.mo.x+player.mo.momx, player.mo.y+player.mo.momy, player.mo.z+(player.mo.height/2)-(toheight/2)+player.mo.momz, MT_KIRBYNEEDLEHURT)
		hurtobj.scale = player.mo.scale	// Same scale!
		hurtobj.target = player.mo	// Our missile!
		if(player.mo.eflags & MFE_VERTICALFLIP)
			hurtobj.eflags = $1|MFE_VERTICALFLIP
		end
	end
end

// Jet
local function kirbyDoJet(player)
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.jumptics == 1)	// Pressing jump?
		and(player.jettime)		// Jet doesn't do anything special, so to keep from being unsuckable, this is here!
		and not(player.flystate)	// Not flying
		and not(player.mo.eflags & MFE_UNDERWATER)	// Jet doesn't work underwater!
		and not(player.prevground)	// Not previously on the ground
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		player.cansuck = true
	end
	
	if not(player.cmd.buttons & BT_JUMP)		// No longer holding?
		or not(player.jettime)					// Ran out of fule?
		or(player.mo.eflags & MFE_UNDERWATER)	// Jet doesn't work underwater!
		or(player.pflags & PF_STASIS)
		or(player.exiting)
		player.cansuck = false
	end
	
	// Stop jetting!
	if(player.cansuck)
		and not(player.cmd.buttons & BT_JUMP)
		S_StopSound(player.mo)
		player.mo.state = S_PLAY_FALL1
	end
	
	// Actualy using the ability
	if(player.cansuck)
		P_SetObjectMomZ(player.mo, FRACUNIT+1, true)	// GO UP!
		player.jettime = $1 - 1	// Less time to use it!
		
		// Play the sound!
		if not(leveltime%5)
			S_StartSound(player.mo, sfx_koopfr)	// Jet sound
		end
		
		// Create the effect!
		if not(leveltime%3)
			local jetflame = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z-mobjinfo[MT_KIRBYSPITFIRE].height, MT_KIRBYSPITFIRE)
			if(jetflame and jetflame.valid)	// Still exsist?
				jetflame.target = player.mo	// Don't hurt the player!
				jetflame.momz = player.mo.momz - (10*FRACUNIT)
				if(player.mo.eflags & MFE_VERTICALFLIP)
					jetflame.eflags = $1|MFE_VERTICALFLIP
					P_TeleportMove(jetflame, player.mo.x, player.mo.y, player.mo.z+player.mo.height)
					jetflame.momz = player.mo.momz + (10*FRACUNIT)
				end
			end
		end
		
		// Animate!
		player.mo.state = S_PLAY_FALL1
	end
	
	// Reset the timer
	if(P_IsObjectOnGround(player.mo))
		player.jettime = TICRATE*3/2	// 1.5 seconds!
	end
	
	// TODO: Add jet kicking!
end

// Laser
local function kirbyDoLaser(player)
	if(player.spintics == 1)	// Pressed?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		player.inhalestate = TICRATE/4
	end
	
	// Cancle the laser
	if(player.flystate)	// Not flying
		or(P_PlayerInPain(player))	// Not in pain
		or(player.pflags & PF_SLIDING)	// Not sliding
		or(player.pflags & PF_SPINNING)	// Not rolling
		or(player.exiting)		// Not exiting
		or not(player.mo.health > 0)	// Can't do this if you're dead!
		player.inhalestate = 0
	end
	
	// Slow down the player
	if(player.inhalestate)
		player.normalspeed = 0	// Can't move!
		player.jumpfactor = 0	// Can't jump!
		if not(player.powers[pw_nocontrol])
			player.powers[pw_nocontrol] = 1	// Still can't move!
		end
		
		// Slow down the player!
		//player.mo.momx = $1*6/7
		//player.mo.momy = $1*6/7
		
		player.inhalestate = $1 - 1
	end
	
	if(player.inhalestate == 1)	// Shoot the laser
		S_StartSound(player.mo, sfx_rlaunc)
		P_SPMAngle(player.mo, MT_ROCKET, player.mo.angle, 1)
	end
end

// Wheele
local function kirbyDoWheele(player)
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.exiting)		// Not exiting
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(player.cansuck)
		player.cansuck = true
	elseif(player.spintics == 1 and player.cansuck)		// Pressed again?
		//or((player.pflags & PF_STASIS) and player.cansuck)
		or(player.exiting and player.cansuck)
		or(player.mo.health <= 0 and player.cansuck)
		or(P_PlayerInPain(player) and player.cansuck)
		player.cansuck = false
		player.inhalestate = 0
		player.mo.momx = $1/2
		player.mo.momy = $1/2
		S_StopSound(player.mo)	// Stop playing the wheel sound!
		player.mo.state = S_PLAY_RUN1
		player.pflags = $1 & ~PF_JUMPED
	end
	
	// Initiate the rolling
	if(player.cansuck)
		player.inhalestate = 1	// Start rolling!
	end
	
	// They see me rollin...
	if(player.inhalestate)
		player.charability = CA_GLIDEANDCLIMB	// Break walls!
		player.pflags = $1|PF_THOKKED			// But don't glide!
		player.charflags = $1|SF_RUNONWATER		// Run over water!
		player.runspeed = FRACUNIT*6			// Always run over water!
		// Can only go fast on the ground
		if(P_IsObjectOnGround(player.mo))
			if(player.cmd.buttons & BT_JUMP)	// Slow?
				P_Thrust(player.mo, player.mo.angle, 2*FRACUNIT)	// Gotta go slow!
			else
				P_Thrust(player.mo, player.mo.angle, 5*FRACUNIT)	// Gotta go fast!
			end
			player.normalspeed = 0	// Wheele movement only please
			player.powers[pw_nocontrol] = 1	// Can't move
		end
		// Animate!
		if not(player.mo.state >= S_PLAY_WHEELE1 and player.mo.state <= S_PLAY_WHEELE4)
			player.mo.state = S_PLAY_WHEELE1
		end
		if(leveltime%5)	// Play the sound!
			S_StartSound(player.mo, sfx_wheele)
		end
		
		// The effect!
		if not(leveltime%3)	// Create the effect!
			and(P_IsObjectOnGround(player.mo))
			and not(player.mo.eflags & MFE_TOUCHWATER)
			and not(player.mo.eflags & MFE_UNDERWATER)
			if(player.mo.eflags & MFE_VERTICALFLIP)		// Upside down
				local dust = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+player.mo.height, MT_PARTICLE)
				if(player.mo.eflags & MFE_TOUCHWATER)
					or(player.mo.eflags & MFE_UNDERWATER)
					dust.sprite = SPR_BUBO
				end
				dust.tics = 5	// Five tics
			else
				local dust = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_PARTICLE)
				if(player.mo.eflags & MFE_TOUCHWATER)
					or(player.mo.eflags & MFE_UNDERWATER)
					dust.sprite = SPR_BUBO
				end
				dust.tics = 5	// Five tics
			end
		end
		// Play turn sound!
		if(player.angleprev and player.mo.angle != player.angleprev)
			and not(leveltime%6)
			and(P_IsObjectOnGround(player.mo))
			S_StartSound(player.mo, sfx_run)
		end
		player.pflags = $1|PF_JUMPED	// Hurt things!
		player.jumpfactor = 0		// Can't jump though
		
		// Hit walls!
		local ang = R_PointToAngle2(0, 0, player.mo.momx, player.mo.momy)
		local dist = R_PointToDist2(0, 0, player.mo.momx, player.mo.momy)
		//if(dist < player.mo.scale)
			dist = player.mo.scale
		//end
		if(blockingWall(player.mo, ang, dist) and player.prevblockwall)
			P_InstaThrust(player.mo, player.mo.angle/*ang*/, -5*FRACUNIT)
			P_SetObjectMomZ(player.mo, 5*FRACUNIT)
			player.cansuck = false
			player.inhalestate = 0
			player.powers[pw_nocontrol] = TICRATE/2
			S_StopSound(player.mo)
			S_StartSound(player.mo, sfx_hard)
			player.mo.state = S_PLAY_FALL1
			player.pflags = $1 & ~PF_JUMPED
		end
		player.prevblockwall = blockingWall(player.mo, ang, dist)
	end
	player.angleprev = player.mo.angle	// For turning
end

// Sword
local function kirbyDoSword(player)
	//print("No ability yet!")
end

// Hammer
local function kirbyDoHammer(player)
	//print("No ability yet!")
end

// Mike
local function kirbyDoMike(player)
	if not(leveltime%5)	// Every fifth frame
		player.mo.color = SKINCOLOR_ORANGE	// Flashy!
	end
	
	// Start the attack!
	if(player.spintics == 1)	// Pressed
		and not(player.flystate)	// Not flying
		and not(player.inhalestate)	// Not already using the ability
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.inhalestate = TICRATE	// Wait a second
		P_NukeEnemies(player.mo, player.mo, (1024*FRACUNIT*5)/3)
		P_FlashPal(player, 4, player.inhalestate/2)
		player.mo.state = S_PLAY_GASP
		
		// Play the sound!
		if(player.copyabl == 17)
			S_StartSound(player.mo, sfx_mike3)
		elseif(player.copyabl == 18)
			S_StartSound(player.mo, sfx_mike2)
		else
			S_StartSound(player.mo, sfx_mike1)
		end
	end
	
	// Lock the player in place
	if(player.inhalestate > 0)
		player.normalspeed = 0
		player.jumpfactor = 0
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		player.mo.state = S_PLAY_GASP
	end
	
	// Finish the attack!
	if(player.inhalestate == 1)
		player.copyabl = $1+1	// Next charge!
		if(player.copyabl > 19)	// 0 charges?
			player.copyabl = 0	//Rip mike 1992-2016
		end
		player.mo.flags = $1 & ~MF_SHOOTABLE	// Can get hurt again!
		player.mo.flags = $1 & ~MF_NOCLIP		// Solid again!
		player.mo.state = S_PLAY_STND			// Normal animation again
	end
	
	// Timer
	if(player.inhalestate)
		player.inhalestate = $1 - 1
		player.mo.flags = $1|MF_SHOOTABLE
		player.mo.flags = $1|MF_NOCLIP		// Don't get inhaled!
	end
end

// ------------------------------------------------------------
// SECRET ABILITIES WOOOAAAAAH
// Based off of memes or my own personal intrests
// Most of them (read: all of them) have nothing to do with Kirby
// ------------------------------------------------------------

// Ow the edge ability
local function kirbyDoEdge(player)
	// Change the color to black for edgyness!
//	if not(multiplayer)				// Screw player identification in multiplayer, we're too edgy for that!
		player.mo.color = SKINCOLOR_BLACK
//	end
	
	// I AM ALL OF ME (AND ALL OF ME IS EDGY)
	S_ChangeMusic(636, true, player)
	
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.exiting)		// Not exiting
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.cansuck = true
	end
	
	if not(player.cmd.buttons & BT_USE)		// No longer holding?
		or(player.flystate)			// Can't shoot and fly, because puffing and shooting are on the same button!
		or(player.pflags & PF_STASIS)
		or(player.exiting)
		or(player.mo.health <= 0)
		or(P_PlayerInPain(player))	// Not when in pain!
		or(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		player.cansuck = false
	end
	
	// Shooting
	if(player.cansuck)
		and not(leveltime%3)
		S_StartSound(player.mo, sfx_edgysh)
		P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.mo.angle, 1)
	end
end

// QP Shooting ability
// It's really big, so probably nobody who's looking here will miss it
local function kirbyDoQpShooting(player)
	// Change the color to white!
	if not(multiplayer)
		player.mo.color = SKINCOLOR_WHITE
	end
	
	// Play QP's theme!
	S_ChangeMusic(701, true, player)
	
	// Button detecion
	if(player.cansuck == nil)
		player.cansuck = false
	end
	
	if(player.spintics == 1)	// Pressing spin?
		and not(player.flystate)	// Not flying
		and not(P_PlayerInPain(player))	// Not in pain
		and not(player.pflags & PF_SLIDING)	// Not sliding
		and not(player.pflags & PF_SPINNING)	// Not rolling
		and not(player.exiting)		// Not exiting
		and not(player.pflags & PF_STASIS)	// Make sure we have control
		and not(player.powers[pw_nocontrol])
		and not(player.exiting)		// Also not exiting
		and(player.mo.health > 0)	// Can't do this if you're dead!
		and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		and not(P_PlayerInPain(player))	// Not when in pain!
		player.cansuck = true
	end
	
	if not(player.cmd.buttons & BT_USE)		// No longer holding?
		or(player.flystate)			// Can't shoot and fly, because puffing and shooting are on the same button!
		or(player.pflags & PF_STASIS)
		or(player.exiting)
		or(player.mo.health <= 0)
		or(P_PlayerInPain(player))	// Not when in pain!
		or(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
		player.cansuck = false
	end
	
	// Make the bits!... woah, that's a lot of stuff!
	if(player.kirbybit1 == nil or not player.kirbybit1.valid)
		player.kirbybit1 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit2 == nil or not player.kirbybit2.valid)
		player.kirbybit2 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit3 == nil or not player.kirbybit3.valid)
		player.kirbybit3 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit4 == nil or not player.kirbybit4.valid)
		player.kirbybit4 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit5 == nil or not player.kirbybit5.valid)
		player.kirbybit5 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit6 == nil or not player.kirbybit6.valid)
		player.kirbybit6 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit7 == nil or not player.kirbybit7.valid)
		player.kirbybit7 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit8 == nil or not player.kirbybit8.valid)
		player.kirbybit8 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit9 == nil or not player.kirbybit9.valid)
		player.kirbybit9 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit10 == nil or not player.kirbybit10.valid)
		player.kirbybit10 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit11 == nil or not player.kirbybit11.valid)
		player.kirbybit11 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	if(player.kirbybit12 == nil or not player.kirbybit12.valid)
		player.kirbybit12 = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_KIRBYBIT)
	end
	
	player.kirbybit1.angle = player.mo.angle+FixedAngle(7*FRACUNIT)		// Make the bit face the same way as the player
	player.kirbybit1.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit2.angle = player.mo.angle-FixedAngle(7*FRACUNIT)		// Make the bit face the same way as the player
	player.kirbybit2.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit3.angle = player.mo.angle+FixedAngle(21*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit3.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit4.angle = player.mo.angle-FixedAngle(21*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit4.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit5.angle = player.mo.angle+FixedAngle(35*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit5.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit6.angle = player.mo.angle-FixedAngle(35*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit6.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit7.angle = player.mo.angle+FixedAngle(49*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit7.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit8.angle = player.mo.angle-FixedAngle(49*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit8.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit9.angle = player.mo.angle+FixedAngle(63*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit9.color = player.mo.color			// Make the bit the same color as the player
	player.kirbybit10.angle = player.mo.angle-FixedAngle(63*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit10.color = player.mo.color		// Make the bit the same color as the player
	player.kirbybit11.angle = player.mo.angle+FixedAngle(77*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit11.color = player.mo.color		// Make the bit the same color as the player
	player.kirbybit12.angle = player.mo.angle-FixedAngle(77*FRACUNIT)	// Make the bit face the same way as the player
	player.kirbybit12.color = player.mo.color		// Make the bit the same color as the player
	
	// Flipping the bits
	if(player.mo.eflags & MFE_VERTICALFLIP)	// FIXME
		player.kirbybit1.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit2.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit3.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit4.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit5.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit6.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit7.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit8.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit9.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit10.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit11.eflags = $1|MFE_VERTICALFLIP
		player.kirbybit12.eflags = $1|MFE_VERTICALFLIP
	else
		player.kirbybit1.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit2.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit3.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit4.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit5.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit6.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit7.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit8.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit9.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit10.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit11.eflags = $1 & ~MFE_VERTICALFLIP
		player.kirbybit12.eflags = $1 & ~MFE_VERTICALFLIP
	end
	
	// Scale the bits!
	player.kirbybit1.scale = player.mo.scale
	player.kirbybit2.scale = player.mo.scale
	player.kirbybit3.scale = player.mo.scale
	player.kirbybit4.scale = player.mo.scale
	player.kirbybit5.scale = player.mo.scale
	player.kirbybit6.scale = player.mo.scale
	player.kirbybit7.scale = player.mo.scale
	player.kirbybit8.scale = player.mo.scale
	player.kirbybit9.scale = player.mo.scale
	player.kirbybit10.scale = player.mo.scale
	player.kirbybit11.scale = player.mo.scale
	player.kirbybit12.scale = player.mo.scale
	
	// Bit 1 target positions
	player.kirbybit1.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit1.angle))
	player.kirbybit1.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit1.angle))
	player.kirbybit1.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 2 target positions
	player.kirbybit2.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit2.angle))
	player.kirbybit2.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit2.angle))
	player.kirbybit2.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 3 target positions
	player.kirbybit3.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit3.angle))
	player.kirbybit3.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit3.angle))
	player.kirbybit3.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 4 target positions
	player.kirbybit4.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit4.angle))
	player.kirbybit4.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit4.angle))
	player.kirbybit4.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 5 target positions
	player.kirbybit5.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit5.angle))
	player.kirbybit5.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit5.angle))
	player.kirbybit5.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 6 target positions
	player.kirbybit6.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit6.angle))
	player.kirbybit6.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit6.angle))
	player.kirbybit6.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 7 target positions
	player.kirbybit7.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit7.angle))
	player.kirbybit7.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit7.angle))
	player.kirbybit7.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 8 target positions
	player.kirbybit8.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit8.angle))
	player.kirbybit8.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit8.angle))
	player.kirbybit8.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 9 target positions
	player.kirbybit9.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit9.angle))
	player.kirbybit9.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit9.angle))
	player.kirbybit9.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 10 target positions
	player.kirbybit10.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit10.angle))
	player.kirbybit10.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit10.angle))
	player.kirbybit10.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 11 target positions
	player.kirbybit11.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit11.angle))
	player.kirbybit11.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit11.angle))
	player.kirbybit11.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Bit 12 target positions
	player.kirbybit12.targx = player.mo.x+FixedMul(60*player.mo.scale, cos(player.kirbybit12.angle))
	player.kirbybit12.targy = player.mo.y+FixedMul(60*player.mo.scale, sin(player.kirbybit12.angle))
	player.kirbybit12.targz = player.mo.z+player.mo.height/2	// TODO: also add on a way for it to aim with the player
	
	// Move the bits to their target location!
	P_TeleportMove(player.kirbybit1, player.kirbybit1.targx, player.kirbybit1.targy, player.kirbybit1.targz)
	P_TeleportMove(player.kirbybit2, player.kirbybit2.targx, player.kirbybit2.targy, player.kirbybit2.targz)
	P_TeleportMove(player.kirbybit3, player.kirbybit3.targx, player.kirbybit3.targy, player.kirbybit3.targz)
	P_TeleportMove(player.kirbybit4, player.kirbybit4.targx, player.kirbybit4.targy, player.kirbybit4.targz)
	P_TeleportMove(player.kirbybit5, player.kirbybit5.targx, player.kirbybit5.targy, player.kirbybit5.targz)
	P_TeleportMove(player.kirbybit6, player.kirbybit6.targx, player.kirbybit6.targy, player.kirbybit6.targz)
	P_TeleportMove(player.kirbybit7, player.kirbybit7.targx, player.kirbybit7.targy, player.kirbybit7.targz)
	P_TeleportMove(player.kirbybit8, player.kirbybit8.targx, player.kirbybit8.targy, player.kirbybit8.targz)
	P_TeleportMove(player.kirbybit9, player.kirbybit9.targx, player.kirbybit9.targy, player.kirbybit9.targz)
	P_TeleportMove(player.kirbybit10, player.kirbybit10.targx, player.kirbybit10.targy, player.kirbybit10.targz)
	P_TeleportMove(player.kirbybit11, player.kirbybit11.targx, player.kirbybit11.targy, player.kirbybit11.targz)
	P_TeleportMove(player.kirbybit12, player.kirbybit12.targx, player.kirbybit12.targy, player.kirbybit12.targz)
	
	// Shooting!
	if(player.cansuck)
		and not(leveltime%3)
		S_StartSound(player.mo, sfx_bshoot)
		P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.mo.angle+FixedAngle(3*FRACUNIT), 1)
		P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.mo.angle-FixedAngle(3*FRACUNIT), 1)
		P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.mo.angle+FixedAngle(1*FRACUNIT), 1)
		P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.mo.angle-FixedAngle(1*FRACUNIT), 1)
	end
	
	// Bit shooting!
	if(player.cansuck)
		and not(leveltime%6)
		//------------------------------------------------------------------------------------------
		local bullet1 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit1.angle, 0)
		if not(bullet1 == nil)
			P_TeleportMove(bullet1, player.kirbybit1.x, player.kirbybit1.y, player.kirbybit1.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet2 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit2.angle, 0)
		if not(bullet2 == nil)
			P_TeleportMove(bullet2, player.kirbybit2.x, player.kirbybit2.y, player.kirbybit2.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet3 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit3.angle, 0)
		if not(bullet3 == nil)
			P_TeleportMove(bullet3, player.kirbybit3.x, player.kirbybit3.y, player.kirbybit3.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet4 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit4.angle, 0)
		if not(bullet4 == nil)
			P_TeleportMove(bullet4, player.kirbybit4.x, player.kirbybit4.y, player.kirbybit4.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet5 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit5.angle, 0)
		if not(bullet5 == nil)
			P_TeleportMove(bullet5, player.kirbybit5.x, player.kirbybit5.y, player.kirbybit5.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet6 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit6.angle, 0)
		if not(bullet6 == nil)
			P_TeleportMove(bullet6, player.kirbybit6.x, player.kirbybit6.y, player.kirbybit6.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet7 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit7.angle, 0)
		if not(bullet7 == nil)
			P_TeleportMove(bullet7, player.kirbybit7.x, player.kirbybit7.y, player.kirbybit7.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet8 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit8.angle, 0)
		if not(bullet8 == nil)
			P_TeleportMove(bullet8, player.kirbybit8.x, player.kirbybit8.y, player.kirbybit8.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet9 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit9.angle, 0)
		if not(bullet9 == nil)
			P_TeleportMove(bullet9, player.kirbybit9.x, player.kirbybit9.y, player.kirbybit9.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet10 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit10.angle, 0)
		if not(bullet10 == nil)
			P_TeleportMove(bullet10, player.kirbybit10.x, player.kirbybit10.y, player.kirbybit10.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet11 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit11.angle, 0)
		if not(bullet11 == nil)
			P_TeleportMove(bullet11, player.kirbybit11.x, player.kirbybit11.y, player.kirbybit11.z)
		end
		//------------------------------------------------------------------------------------------
		local bullet12 = P_SPMAngle(player.mo, MT_KIRBYBITSHOT, player.kirbybit12.angle, 0)
		if not(bullet12 == nil)
			P_TeleportMove(bullet12, player.kirbybit12.x, player.kirbybit12.y, player.kirbybit12.z)
		end
	end
end

// Boom Knuckles
// Quickly thrown together in about 5 seconds, because who needs to fix glitches right? Especialy since boom.
local function kirbyDoBoomKnuckles(player)
	//if(paused)	// Is the game paused?
	if(player.flycounter < 6)
		S_StartSound(player.mo, sfx_ohno, player)
		player.flycounter = 6	// Infinite flight via pausing!
	end
	
	if(player.cmd.buttons & BT_USE)
		P_SPMAngle(player.mo, MT_KIRBYTHROWBOMB, player.mo.angle, 1)
		if not(leveltime%10)
			S_StartSound(player.mo, sfx_ohno)
		end
	end
end

// -------------------------
// Fly functions

// Floating
// TODO: Use the new mobjgravity function!
local function kirbyFloating(player)
	if not(player.mo.eflags & MFE_UNDERWATER)
		P_SetObjectMomZ(player.mo, gravity/2, true)	// Half gravity!
	else
		P_SetObjectMomZ(player.mo, gravity*7, false)	// Float upwards in water
	end
	// Hold the button to fly!
	if(player.jumptics > TICRATE*20/35)
		and(player.cmd.buttons & BT_JUMP)
		player.jumptics = 0
	end
	// Going faster than normal?
	local nspeed = player.normalspeed+(6*FRACUNIT)
	if(player.powers[pw_super] or player.powers[pw_sneakers])
		nspeed = $1 * 2
	end
	if(FixedDiv(abs(player.mo.momx-player.cmomx)+abs(player.mo.momy-player.cmomy), player.mo.scale) > nspeed)
		player.mo.momx = $1 - player.cmomx
		player.mo.momy = $1 - player.cmomy
		player.mo.momx = $1*160/161
		player.mo.momy = $1*160/161
		player.mo.momx = $1 + player.cmomx
		player.mo.momy = $1 + player.cmomy
	end
end

// Puffing
local function kirbyPuff(player)
	player.flystate = 0
	S_StartSound(player.mo, sfx_puff)
	player.mo.state = S_PLAY_GASP
	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0
	local gotox = player.mo.x+FixedMul(player.mo.radius*2, cos(player.mo.angle))
	local gotoy = player.mo.y+FixedMul(player.mo.radius*2, sin(player.mo.angle))
	
	local puff = P_SPMAngle(player.mo, MT_KIRBYSPITAIR, player.mo.angle, 0)
	if(puff and puff.valid)
		P_TeleportMove(puff, gotox, gotoy, puff.z)
	end
end

// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// Think Frame
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
addHook("ThinkFrame", do
	for player in players.iterate
		// Initialize variables
		if(player.inhalestate == nil)
			// Also used for abilities!
			player.inhalestate = 0	// 0 = normal, 1 = inhaling, 2 = locked inhaling (sucking something in), 3 = fat Kirby
		end
		if(player.copyabl == nil)
			player.copyabl = 0	// 0 = nothing, 1 = rock
		end
		if(player.flycounter == nil)
			or(player.mo and player.mo.valid and P_IsObjectOnGround(player.mo))
			player.flycounter = 6	// How many presses you have left
		end
		if(player.flystate == nil)
			player.flystate = 0		// 0 = nope, 1 = flypls
		end
		
		// ---------------------------------
		// Input stuff
		if(player.jumptics == nil)
			or not(player.cmd.buttons & BT_JUMP)
			player.jumptics = 0
		else
			player.jumptics = $1 + 1
		end
		if(player.spintics == nil)
			or not(player.cmd.buttons & BT_USE)
			player.spintics = 0
		else
			player.spintics = $1 + 1
		end
		// Toss flag = lose ability
		// It's binded to that key so you can't use abilities when carrying the flag!
		if(player.tossflagtics == nil)
			or not(player.cmd.buttons & BT_TOSSFLAG)
			player.tossflagtics = 0
		else
			player.tossflagtics = $1 + 1
		end
		
		// ------------------------------------
		// Kirby Main loop
		// ------------------------------------
		if(player.mo and player.mo.valid and player.mo.skin == "kirby")	// Are we Kirby?
			and(leveltime > 1)	// Reset variables on level load!
			and(player.mo.health > 0)	// Hacky fix
			and not(player.pflags & PF_NIGHTSMODE)		// NiGHTS super sonic defenetly shouldn't do kirby things!
			// ------------------------------------
			// Abilities
			// ------------------------------------
			
			player.normalspeed = skins[player.mo.skin].normalspeed	// Reset normalspeed every frame
			
			// Better air acceleration!
			if(P_IsObjectOnGround(player.mo))
				player.thrustfactor = 3
			else
				player.thrustfactor = 5
			end
			
			
			// ------------------------------------
			// Running!
			
			// Find out what the player is inputing!
			local countmove = player.cmd.forwardmove	// Without analog and in 3d, this is what we want!
/*			if(twodlevel)
				countmove = abs(player.cmd.forwardmove)	// In a 2d-only level, forward move = left/right!
			else*/if(player.mo.flags2 & MF2_TWOD or twodlevel)			// ^ nevermind, the wiki was wrong ;-;
				countmove = abs(player.cmd.sidemove)	// In 2d mode in a 3d level, sidemove is what we want!
			elseif(player.pflags & PF_ANALOGMODE)
				countmove = abs(player.cmd.forwardmove)+abs(player.cmd.sidemove)	// 3D analog = all directions
			end
			
			// Initiate the run if we pressed a certant ammount of time ago
			if(player.lastforwardtime)
				and(leveltime-player.lastforwardtime < TICRATE/4)
				and(leveltime-player.lastforwardtime > 1)	// Not the same frame!
				and(countmove > 0)
				and(P_IsObjectOnGround(player.mo))
				player.isrunning = true
			end
			
			// Last press detection
			if(countmove <= 0)
				player.isrunning = false
			else
				player.lastforwardtime = leveltime
			end
			
			// Other running stuff
			local invnospeed = false
			if(player.powers[pw_invulnerability])
				and not(player.powers[pw_sneakers])
				invnospeed = true
			end
			
			if(invnospeed)
				player.normalspeed = $1+(FRACUNIT*6)
			end
			
	/*		if(gametype == GT_RACE or gametype == GT_COMPETITION)	// Auto run in other gametypes!
				and(P_IsObjectOnGround(player.mo))
				//and not(player.copyabl)	// Not when using an ability! That would be op!
				player.normalspeed = $1*3/2		// 1.5 times faster in race!
				player.isrunning = false		// Cancle normal running!
				player.thrustfactor = $1*3/2
			else*/if(P_IsObjectOnGround(player.mo))
				and(player.isrunning)
				player.normalspeed = $1+(FRACUNIT*6)	// Only 6 units faster?! That's not much!
				player.thrustfactor = $1*3/2		// Better acceleration though!
			end
			
			// Turning super!
			if(player.cmd.buttons & BT_CUSTOM1)	// Custom 1 for super!
				and(player.health > 50)
				and(player.powers[pw_emeralds] == 127)
				and not(player.powers[pw_super])
				and not(player.powers[pw_nocontrol])
				P_DoSuperTransformation(player, false)
			end
			
			if(player.mo.scale < FRACUNIT)	// Small?
				and not(player.copyabl == 3)	// Don't already have the mini ability?
				if(player.copyabl)			// Don't drop a no-ability star!
					kirbyDropAbility(player)	// Drop the old ability
				end
				kirbyGetAbility(player, 3)	// Grant the mini ability!
			end
			
			if not(player.powers[pw_shield] & SH_FIREFLOWER)
				and not(player.powers[pw_super])
				player.mo.color = player.skincolor		// Reset the color!
			elseif(player.powers[pw_shield] & SH_FIREFLOWER)
				and not(player.powers[pw_super])
				player.mo.color = SKINCOLOR_RED
			end
			
			player.charability = skins[player.mo.skin].ability
			player.skinflags = skins[player.mo.skin].flags
			player.runspeed = skins[player.mo.skin].runspeed
			if(player.copyabl == 0)	// No ability?
				kirbySucks(player)
			else
				// Abilities!
				
				// Discard ability
				if(player.tossflagtics == 1 or player.mo.health < 0)
					and not(player.inhalestate)
					kirbyDropAbility(player)	// Rip ability
				end
				
				// Abilities!
				if(player.copyabl == 1)		// Stone
					kirbyDoRock(player)
				elseif(player.copyabl == 2)	// Crash
					kirbyDoCrash(player)
				elseif(player.copyabl == 3)	// Mini
					player.mo.scale = FRACUNIT/2	// Not gonna make a function for this one line, that would be dumb
				elseif(player.copyabl == 4)	// Hi Jump
					kirbyDoHiJump(player)
				elseif(player.copyabl == 5)	// Fire
					kirbyDoFireIce(player, 0)
				elseif(player.copyabl == 6)	// Ice
					kirbyDoFireIce(player, 1)
				elseif(player.copyabl == 7)	// Tornado
					kirbyDoTornado(player)
				elseif(player.copyabl == 8)	// Plasma
					kirbyDoPlasma(player)
				elseif(player.copyabl == 9)	// Sleep
					kirbyDoSleep(player)
				elseif(player.copyabl == 10)// Bomb
					kirbyDoBomb(player)
				elseif(player.copyabl == 11)// Needle
					kirbyDoNeedle(player)
				elseif(player.copyabl == 12)// Jet
					kirbyDoJet(player)
				elseif(player.copyabl == 13)// Laser
					kirbyDoLaser(player)
				elseif(player.copyabl == 14)// Wheele
					kirbyDoWheele(player)
				elseif(player.copyabl == 15)// Sword
					kirbyDoSword(player)
				elseif(player.copyabl == 16)// Hammer
					kirbyDoHammer(player)
				elseif(player.copyabl == 17)// Mike
					or(player.copyabl == 18)
					or(player.copyabl == 19)
					kirbyDoMike(player)
				// -------------------------------------------------
				// SECRET ABILITIES WOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH
				elseif(player.copyabl == 97)// Ow the edge
					kirbyDoEdge(player)
				elseif(player.copyabl == 98)// QP Shooting
					kirbyDoQpShooting(player)
				elseif(player.copyabl == 99)// Boom Knuckles
					kirbyDoBoomKnuckles(player)
				end
			end
			
			// Flash orange when we have invincibility!
			if(player.powers[pw_invulnerability])
				and not(leveltime%5)
				player.mo.color = SKINCOLOR_ORANGE
			end
			
			// Flash red when we have speed shoes!
			if(player.powers[pw_sneakers])
				and not(leveltime%5)
				player.mo.color = SKINCOLOR_RED
			end
			
			// ------------------------------------
			// ------------------------------------
			// Floating
			// ------------------------------------
			// ------------------------------------
			if(player.powers[pw_super])
				player.flycounter = 6		// Infinite fly when super!
			end
			
			if(player.flycounter > 0)
				and(player.jumptics == 1)	// Just pressed jump?
				and not(player.prevground)	// Not jumping this frame!
				and not(player.inhalestate)	// Not using an ability!
				and not(player.copyabl == 10 and player.cansuck)	// Not when holding a bomb!
				and not(player.copyabl == 12)	// Not using jet!
				and not(player.pflags & PF_STASIS)	// Can't float if you can't control!
				and not(player.exiting)
				and not(player.pflags & PF_MACESPIN)	// Not on a CEZ chain!
				and not(player.hackyprevchain)			// Not the hacky prev chain!
				and not(player.pflags & PF_SPINNING)	// Not when spinning!
				and not(player.pflags & PF_NIGHTSMODE)	// Don't mess with NiGHTS, man
				and(player.mo.health > 0)	// Can't float if you're dead!
				and not(P_PlayerInPain(player))	// Not when in pain!
				and not(player.mo.eflags & MFE_UNDERWATER and player.flycounter == 6)	// Can't start floating underwater!
				and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
				S_StartSound(player.mo, sfx_floatm)
				P_SetObjectMomZ(player.mo, 7*FRACUNIT)	// So reverse gravity works
				player.flycounter = $1 - 1
				player.flystate = 1		// Start flying
				player.mo.state = S_PLAY_FLOAT1
				player.jumping = false	// Don't cut momz when floating!
			end
			
			// In the middle of flying
			if(player.flystate)
				kirbyFloating(player)
			end
			
			// Slowing down
			if(player.flystate)
				and(player.flycounter <= 0)
				//player.normalspeed = skins[player.mo.skin].normalspeed/3
				player.mo.momx = $1*6/7
				player.mo.momy = $1*6/7
			end
			
			// ------------------------------------
			// Swiming
			// ------------------------------------
			if(player.mo.eflags & MFE_UNDERWATER)	// Underwater = reset fly counter
				player.flycounter = 6	// Reset this
			end
			
			if(player.mo)
				and(player.mo.eflags & MFE_UNDERWATER)	// Underwater?
				and(not player.inhalestate or (player.inhalestate == 3 and not player.copyabl))	// Not inhaling
				and not(player.flystate)				// Not when already floating
				and not(player.pflags & PF_STASIS)		// Can't swim if you can't control!
				and not(player.exiting)					// Same here
				and not(player.pflags & PF_MACESPIN)	// Not on a CEZ chain!
				and not(player.hackyprevchain)			// Not the hacky prev chain!
				and not(player.pflags & PF_SPINNING)	// Not when spinning!
				and not(player.pflags & PF_NIGHTSMODE)	// Don't mess with NiGHTS, man
				and(player.mo.health > 0)				// Can't swim if you're dead!
				and not(P_PlayerInPain(player))			// Not when in pain!
				and(player.cmd.buttons & BT_JUMP)		// Holding jump
				and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
				P_SetObjectMomZ(player.mo, 5*FRACUNIT, false)
				if not(player.mo.state >= S_PLAY_KIRBYSWIM1 and player.mo.state <= S_PLAY_KIRBYSWIM8)
					and not(not(player.copyabl) and player.inhalestate == 3)
					player.mo.state = S_PLAY_KIRBYSWIM1
				elseif not(player.copyabl)
					and(player.inhalestate == 3)
					if not(player.mo.state >= S_PLAY_FATKIRB_WALK1 and player.mo.state <= S_PLAY_FATKIRB_WALK8)
						player.mo.state = S_PLAY_FATKIRB_WALK1
					end
					if(player.mo.tics > 2)
						player.mo.tics = 2
					end
					P_SetObjectMomZ(player.mo, 5*FRACUNIT/2, false)
				end
			elseif(player.mo.eflags & MFE_UNDERWATER)	// Still underwater?
				and not(P_IsObjectOnGround(player.mo))	// Not on the ground?
				and(not player.inhalestate or (player.inhalestate == 3 and not player.copyabl))	// Not inhaling
				and not(player.flystate)				// Not when already floating
				and not(player.pflags & PF_NIGHTSMODE)	// Don't mess with NiGHTS, man
				and(player.mo.health > 0)				// Can't swim if you're dead!
				and not(P_PlayerInPain(player))			// Not when in pain!
				and not(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Not hanging!
				player.mo.state = S_PLAY_FALL1			// Falling!
			elseif not(player.mo.eflags & MFE_UNDERWATER)	// Not underwater?
				and not(P_IsObjectOnGround(player.mo))	// Not on the ground?
				and not(player.pflags & PF_NIGHTSMODE)	// Don't mess with NiGHTS, man
				and(player.mo.state >= S_PLAY_KIRBYSWIM1 and player.mo.state <= S_PLAY_KIRBYSWIM8)	// Swimming too?
				and(not player.inhalestate or (player.inhalestate == 3 and not player.copyabl))	// Not inhaling
				player.mo.state = S_PLAY_FALL1			// Falling!
			end
			
			// ------------------------------------
			// Exhailing
			// ------------------------------------
			if(player.spintics == 1)	// Just pressed spin?
				and not(P_IsObjectOnGround(player.mo))
				and(player.flystate)	// Flying?
				and not(player.pflags & PF_STASIS)	// Can't puff if you can't control!
				and not(player.exiting)
				and(player.mo.health > 0)	// Can't puff if you're dead!
				kirbyPuff(player)
			end
			
			if(P_IsObjectOnGround(player.mo))// On the ground?
				and(player.flystate)	// Flying?
				and(player.mo.health > 0)	// Can't puff if you're dead!
				kirbyPuff(player)
			end
			
			if not(player.mo.state >= S_PLAY_FLOAT1 and player.mo.state <= S_PLAY_FLOAT7)	// Not floating?
				and(player.flystate)	// Flying too?
				player.mo.state = S_PLAY_FLOAT7
			//	kirbyPuff(player)	// Nop
			end
			
			if(P_PlayerInPain(player))	// Got hurt?
				and(player.flystate)	// Flying too?
				kirbyPuff(player)	// Rip
				player.mo.state = S_PLAY_PAIN
			end
			
			// Can't float on chains!
			if((player.pflags & PF_MACESPIN) and player.flystate)
				or(player.hackyprevchain and player.flystate)			// Not the hacky prev chain!
				kirbyPuff(player)	// Rip
				player.mo.state = S_PLAY_ATK1	// Reset the animation!
			end
			
			// Can't float when spinning (in zoom tubes)!
			if(player.pflags & PF_SPINNING)
				and(player.flystate)
				kirbyPuff(player)	// Rip
				player.mo.state = S_PLAY_ATK1	// Reset the animation!
			end
			
			if(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))
				if(player.flystate)
					kirbyPuff(player)	// Can't float on ropes!
				end
				player.flycounter = 6	// Reset the counter!
			end
			
			if(player.flycounter <= 0)
				and(player.flystate)	// Can't fly, but flying?
				and(player.mo.momz*P_MobjFlip(player.mo) < 0)
				// I NEED TO BREATH
				kirbyPuff(player)
			end
			
			// This is copied from MarioAndLuigi.wad, since apparently I don't care enough to make this for Kirby in the first place :V
			// ------------------------------------------------------------
			// Jumping!
			// ------------------------------------------------------------
			player.jumpfactor = skins[player.mo.skin].jumpfactor
			if(P_IsObjectOnGround(player.mo) or player.climbing or player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))
				and not(player.mo.eflags & MFE_UNDERWATER)	// Not underwater though!
				and(player.jumptics == 1)
				and(player.mo.health > 0)		// Not dead yet!
				and not(player.exiting)
				and not(player.powers[pw_nocontrol])	// Need control!
				and not(player.pflags & PF_STASIS)		// Ditto
				P_DoJump(player, true)
				player.secondjump = 0
				player.mo.state = S_PLAY_KIRBYJUMP
				player.pflags = $1 & ~PF_THOKKED
				player.pflags = $1 & ~PF_JUMPED			// Can't hurt things by jumping!
			end
			
			// If letting go of the jump button while still on ascent, cut the jump height.
			if(player.jumping and P_MobjFlip(player.mo)*player.mo.momz > 0)
				and not(player.cmd.buttons & BT_JUMP)
				player.mo.momz = $1/2
				player.jumping = false
				if(player.mo.state == S_PLAY_KIRBYJUMP)
					if(player.copyabl == 10 and player.cansuck)	// Using bomb?
						or(player.copyabl == 15)	// Or sword?
						or(player.copyabl == 16)	// Or hammer?
						player.mo.state = S_PLAY_FALL1	// No flipping!
					else
						player.mo.state = S_PLAY_KIRBYFLIP1
					end
				end
			end
			
			player.jumpfactor = 0
			// ------------------------------------------------------------
			
		//	player.pflags = $1|PF_THOKKED	// Dissable the whirlwind shield! (and the bomb shield)
			
			// ------------------------------------
			// Running animation
			// ------------------------------------
			if((player.mo.state >= S_PLAY_RUN1 and player.mo.state <= S_PLAY_RUN8) or (player.mo.state >= S_PLAY_KRUN1 and player.mo.state <= S_PLAY_KRUN8) or (player.mo.state >= S_PLAY_FATKIRB_WALK1 and player.mo.state <= S_PLAY_FATKIRB_WALK8))
				and(/*(player.speed > 26*player.mo.scale and (gametype == GT_RACE or gametype == GT_COMPETITION)) or */player.isrunning)
				and(P_IsObjectOnGround(player.mo))	// Only on the ground!
				// Change animation!
				if(player.mo.state >= S_PLAY_RUN1 and player.mo.state <= S_PLAY_RUN8)
					player.mo.state = S_PLAY_KRUN1
				end
				// Faster animation!
				if(player.mo.tics > 1)
					player.mo.tics = 1//$1 - 1
				end
				// Running sound!
				if not(player.prevrun)
					S_StartSound(player.mo, sfx_run)
					// Also the effect!
					if(player.mo.eflags & MFE_VERTICALFLIP)		// Upside down
						local dust = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z+player.mo.height, MT_PARTICLE)
						if(player.mo.eflags & MFE_TOUCHWATER)
							or(player.mo.eflags & MFE_UNDERWATER)
							dust.sprite = SPR_BUBO
						end
						dust.tics = 5	// Five tics
					else
						local dust = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_PARTICLE)
						if(player.mo.eflags & MFE_TOUCHWATER)
							or(player.mo.eflags & MFE_UNDERWATER)
							dust.sprite = SPR_BUBO
						end
						dust.tics = 5	// Five tics
					end
				end
				player.prevrun = true
			else
				if(player.mo.state >= S_PLAY_KRUN1 and player.mo.state <= S_PLAY_KRUN8)
					and(player.prevrun)
					and not(player.copyabl == 10 and player.cansuck)
					player.mo.state = S_PLAY_RUN1
				end
				player.prevrun = false
			end
			
			// ------------------------------------
			// Landing sound
			// ------------------------------------
			if(player.mo.health > 0)	// Not when dead!
				// MFE_JUSTHITFLOOR is unreliable, so instead we use our prevground
				if(P_IsObjectOnGround(player.mo))
					and not(player.prevground)
					S_StartSound(player.mo, sfx_land)
				end
				
				// Ceiling sound
				if(player.mo.eflags & MFE_VERTICALFLIP)
					if(player.mo.z + player.mo.momz < player.mo.floorz)
						and not(mariomode)
						S_StartSound(player.mo, sfx_land)
					end
				else
					if(player.mo.z + player.mo.height + player.mo.momz > player.mo.ceilingz)
						and not(mariomode)
						S_StartSound(player.mo, sfx_land)
					end
				end
			end
			
			// ------------------------------------
			// Falling
			if(player.panim == PA_RUN or player.panim == PA_WALK or (player.mo.state >= S_PLAY_STND and player.mo.state <= S_PLAY_TAP2))
				and not(P_IsObjectOnGround(player.mo))
				player.mo.state = S_PLAY_FALL1
			end
			
			// Go into Kirbyjump when springing!
			if(player.mo.state == S_PLAY_SPRING)
				player.mo.state = S_PLAY_KIRBYJUMP
				player.flycounter = 6
			end
			
			// Oh yeah, also flipping
			if(player.mo.momz*P_MobjFlip(player.mo) < 2*player.mo.scale)
				and(player.mo.state == S_PLAY_KIRBYJUMP)
				if(player.copyabl == 10 and player.cansuck)	// Using bomb?
					or(player.copyabl == 15)	// Or sword?
					or(player.copyabl == 16)	// Or hammer?
					player.mo.state = S_PLAY_FALL1	// No flipping!
				else
					player.mo.state = S_PLAY_KIRBYFLIP1
				end
			end
			
			// ------------------------------------------------
			// Misc
			// ------------------------------------------------
			// Have an ability?
			if(player.copyabl)
				and(player.gotflag)		// Got the flag?
				kirbyDropAbility(player)	// Drop the ability for another Kirby to use!... Hopefuly one on your team!
			end
			
			// Fat Kirby animation!
			if not(player.copyabl)
				and(player.inhalestate == 3)
				if(P_IsObjectOnGround(player.mo))
					if not(player.speed)
						player.mo.state = S_PLAY_FATKIRB
					elseif not(player.mo.state >= S_PLAY_FATKIRB_WALK1 and player.mo.state <= S_PLAY_FATKIRB_WALK8)
						player.mo.state = S_PLAY_FATKIRB_WALK1
					end
					if(player.mo.state >= S_PLAY_FATKIRB_WALK1)
						and(player.mo.state <= S_PLAY_FATKIRB_WALK8)
						local maxtics = 4
						local kirbyspeed = abs(player.mo.momx-player.cmomx)+abs(player.mo.momy-player.cmomy)
						
						// Change speed!
						if(kirbyspeed > 13<<FRACBITS)
							maxtics = 2
						elseif(kirbyspeed > 7<<FRACBITS)
							maxtics = 3
						end
						
						if(player.mo.tics > maxtics)
							player.mo.tics = maxtics
						end
						
						// Running
						if(player.prevrun)
							and(player.mo.tics > 1)
							player.mo.tics = $1 - 1
						end
						
						player.panim = PA_WALK	// Analog fix
					end
				elseif not(player.mo.state >= S_PLAY_KIRBYSWIM1 and player.mo.state <= S_PLAY_KIRBYSWIM8)
					if(player.mo.state == S_PLAY_KIRBYJUMP)
						player.mo.state = S_PLAY_FATKIRB_JUMP
					elseif(player.pflags & (PF_CARRIED|PF_ITEMHANG|PF_ROPEHANG))	// Hang on to stuff!
						player.mo.state = S_PLAY_FATKIRB_HANG
					elseif(player.mo.state < S_PLAY_FATKIRB)
						or(player.mo.state > S_PLAY_FATKIRB_HANG)
						or(player.mo.state == S_PLAY_FATKIRB_JUMP and player.mo.momz*P_MobjFlip(player.mo) < 0)
						or(player.mo.state <= S_PLAY_FATKIRB_WALK8 and not(player.mo.eflags & MFE_UNDERWATER))
						player.mo.state = S_PLAY_FATKIRB_FALL		// Falling!
					end
				end
			elseif(player.mo.state >= S_PLAY_FATKIRB)
				and(player.mo.state <= S_PLAY_FATKIRB_HANG)
				player.mo.state = S_PLAY_RUN1		// Don't be fat when you're not fat!
			end
			
		elseif(player.mo)
			// Reset Kirby-specific variables!
			if(player.copyabl)
				and(player.inhalestate)
				player.mo.flags = $1|MF_SHOOTABLE	// So things can hit you
			end
			player.inhalestate = 0
			player.flycounter = 6
			player.flystate = 0
			player.badtime = -TICRATE	// Lol nope
			player.cansuck = false	// Wheel fix
			player.jettime = TICRATE*3/2	// Jet fix, though it doesn't matter...
			player.ateaplayer = false		// Nope, we infact DID NOT eat a player!
			
			// Have an ability?
			if(player.copyabl)
				and not(player.mo.skin == "kirby" and player.mo.health > 0)	// Not kirby
				kirbyDropAbility(player)	// Drop the ability for another Kirby to use!
			end
			
			// Bomb fix
			if(player.mo.health <= 0)
				and(player.heldbomb and player.heldbomb.valid and player.heldbomb.health > 0)
				player.cansuck = false
				S_StartSound(player.heldbomb, sfx_brakrx)	// KA-BEWM
				P_RadiusAttack(player.heldbomb, player.mo, 160*FRACUNIT)
				P_KillMobj(player.heldbomb)
				player.heldbomb.health = 0	// Paranoid
			end
			
			// Random ability in ring slinging gametypes!
		/*	if(G_RingSlingerGametype())
				and not(thisisthokker)
				and not(player.mo.skin == "kirby")
				player.copyabl = P_RandomKey(7)+1	// RANDOM ABILITY!
				
				// 10 abilities!
				// That's out of 16 (main) abilities!
				if(player.copyabl == 1)		// Rock doesn't need one, since it's already 1!
					player.copyabl == 1
				elseif(player.copyabl == 2)
					player.copyabl = 5
				elseif(player.copyabl == 3)
					player.copyabl = 10
				elseif(player.copyabl == 4)
					player.copyabl = 11
				// Abilities that need fixing!
				elseif(player.copyabl == 5)
					player.copyabl = 4
				elseif(player.copyabl == 6)
					player.copyabl = 7
				elseif(player.copyabl == 7)
					player.copyabl = 8
				elseif(player.copyabl == 8)
					player.copyabl = 12
				// Abilities that have yet to be added!
				elseif(player.copyabl == 9)
					player.copyabl = 15
				elseif(player.copyabl == 10)
					player.copyabl = 16
				// Oh no
				elseif(player.copyabl == 11)
					player.copyabl = 99
				end
			end*/
		end
		
		// ------------------------------------
		// Previous variables
		if(player.mo and player.mo.valid)
			and(P_IsObjectOnGround(player.mo))
			player.prevground = true
		else
			player.prevground = false
		end
		player.prevflycount = player.flycounter
		if(player.spintics == 1)
			player.lastspinpress = leveltime
		end
		player.hackyprevchain = false
		if(player.pflags & PF_MACESPIN)
			player.hackyprevchain = true
		end
		
		// Remove the bits if we're not QP shooting Kirby!
		if not(player.copyabl == 98)
			if(player.kirbybit1 and player.kirbybit1.valid)
				P_RemoveMobj(player.kirbybit1)
			end
			if(player.kirbybit2 and player.kirbybit2.valid)
				P_RemoveMobj(player.kirbybit2)
			end
			if(player.kirbybit3 and player.kirbybit3.valid)
				P_RemoveMobj(player.kirbybit3)
			end
			if(player.kirbybit4 and player.kirbybit4.valid)
				P_RemoveMobj(player.kirbybit4)
			end
			if(player.kirbybit5 and player.kirbybit5.valid)
				P_RemoveMobj(player.kirbybit5)
			end
			if(player.kirbybit6 and player.kirbybit6.valid)
				P_RemoveMobj(player.kirbybit6)
			end
			if(player.kirbybit7 and player.kirbybit7.valid)
				P_RemoveMobj(player.kirbybit7)
			end
			if(player.kirbybit8 and player.kirbybit8.valid)
				P_RemoveMobj(player.kirbybit8)
			end
			if(player.kirbybit9 and player.kirbybit9.valid)
				P_RemoveMobj(player.kirbybit9)
			end
			if(player.kirbybit10 and player.kirbybit10.valid)
				P_RemoveMobj(player.kirbybit10)
			end
			if(player.kirbybit11 and player.kirbybit11.valid)
				P_RemoveMobj(player.kirbybit11)
			end
			if(player.kirbybit12 and player.kirbybit12.valid)
				P_RemoveMobj(player.kirbybit12)
			end
		end
	end
end)

/*
addHook("MapLoad", do
	for player in players.iterate
		// Random ability in ring slinging gametypes!
		if(G_RingSlingerGametype())
			and not(thisisthokker)
			player.copyabl = P_RandomKey(7)+1	// RANDOM ABILITY!
			
			// 10 abilities!
			// That's out of 17 (main) abilities!
		//	if(player.copyabl == 1)		// Rock doesn't need one, since it's already 1!
		//		player.copyabl == 1
		//	elseif(player.copyabl == 2)
				player.copyabl = 5
			elseif(player.copyabl == 3)
				player.copyabl = 10
			elseif(player.copyabl == 4)
				player.copyabl = 11
			// Abilities that need fixing!
			elseif(player.copyabl == 5)
				player.copyabl = 4
			elseif(player.copyabl == 6)
				player.copyabl = 7
			elseif(player.copyabl == 7)
				player.copyabl = 8
			elseif(player.copyabl == 8)
				player.copyabl = 12
			// Abilities that have yet to be added!
			elseif(player.copyabl == 9)
				player.copyabl = 15
			elseif(player.copyabl == 10)
				player.copyabl = 16
			// Oh no
			elseif(player.copyabl == 11)
				player.copyabl = 99
			end
		end
	end
end)
*/

// Makes Kirby lose his ability when he gets hurt!
addHook("MobjDamage", function(mobj, source, attacker, notused)
	if(mobj.valid and mobj.skin == "kirby")
		and not(mobj.player.powers[pw_super])	// Can't get hurt when super!
		and(mobj.player.health > 0)	// And we're still alive
		if(mobj.player.copyabl)	// We have an ability?
			mobj.player.inhalestate = 0
			kirbyDropAbility(mobj.player)		// Rip ability
		end
		// Splode the bomb if we were holding it!
		if(mobj.player.heldbomb and mobj.player.heldbomb.valid and mobj.player.heldbomb.health > 0)
			mobj.player.cansuck = false
			S_StartSound(mobj.player.heldbomb, sfx_brakrx)	// KA-BEWM
			P_RadiusAttack(mobj.player.heldbomb, mobj, 160*FRACUNIT)
			P_KillMobj(mobj.player.heldbomb)
			mobj.player.heldbomb.health = 0	// Paranoid
		end
	end
end, MT_PLAYER)
