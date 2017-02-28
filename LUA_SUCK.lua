// Function that checks if this is a special case that shouldn't be touched!
local function checkShouldBeModified(type)
	if(type == MT_BIGTUMBLEWEED)		// TODO: Only allow this if it's thokker
		return false
	end
	
	return true
end

// Function that tells us if this should lock Kirby into sucking!
local function checkTargetObjectIsHeavy(mo)
	if(mo.enemy.valid and mo.enemy.type == MT_RING)
		or(mo.enemy.valid and mo.enemy.type == MT_FLINGRING)
		or(mo.enemy.valid and mo.enemy.type == MT_COIN)
		or(mo.enemy.valid and mo.enemy.type == MT_BLUEBALL)	// Get blue balls!
		or(mo.enemy.valid and mo.enemy.type == MT_REDTEAMRING and mo.target.player.ctfteam == 1)
		or(mo.enemy.valid and mo.enemy.type == MT_BLUETEAMRING and mo.target.player.ctfteam == 2)
		return false
	end
	
	return true
end

// Kirby's inhale sucker
addHook("MobjThinker", function(mo)
	// Destroy the object!
	if(mo.sucktimer <= 0)
		P_RemoveMobj(mo)	// Rip
	end
	
	// Sucking functionality
	if(mo.valid and mo.target and mo.target.valid and mo.target.player)	// Paranoid?
		local dist = 32*mo.sucktimer
		mo.targetx = mo.target.x+FixedMul(mo.target.radius+(dist*mo.target.scale), cos(mo.target.angle))
		mo.targety = mo.target.y+FixedMul(mo.target.radius+(dist*mo.target.scale), sin(mo.target.angle))
		mo.targetz = mo.target.z
		if not(mo.eflags & MFE_VERTICALFLIP)
			mo.targetz = mo.target.z+mo.target.height-mo.height		// Match the tops!
		end
		P_TeleportMove(mo, mo.targetx, mo.targety, mo.targetz)
		mo.sucktimer = $1 - 1
		// Are we sucking something?
		if(mo.sucking)
			and(mo.enemy and mo.enemy.valid)
			P_TeleportMove(mo.enemy, mo.x, mo.y, mo.z)
			
			if(mo.enemy.player)	// Player?
				mo.enemy.player.pflags = $1|PF_STASIS		// Can't use abilities!
				mo.enemy.player.pflags = $1|PF_JUMPSTASIS
				mo.enemy.player.powers[pw_nocontrol] = 1
			end
			
			if(mo.enemy.oldflags & MF_FIRE)		// Was this fire?
				mo.enemy.state = mobjinfo[mo.enemy.type].spawnstate	// Spawn state it is!
			end
			
			// Are we about to eat the enemy?
			if(mo.sucktimer <= 0)
				and(checkTargetObjectIsHeavy(mo))
				
				// Gain the enemy's ability!
				// To do that, find some info about the enemy!
				// Hoo boy, this list is big! It can only get bigger from here too!
				local ability = 0
				if(mo.enemy.type == MT_DROPABL)
					or(mo.enemy.abilitytogive)				// So you can make your custom enemies give abilities!
					ability = mo.enemy.abilitytogive
				elseif(mo.enemy.oldflags & MF_FIRE)			// Is this fire?
					or(mo.enemy.type == MT_GREENTV)			// Is this an elemental monitor?
					or(mo.enemy.skin == "blaze")			// Is this 420 blazethecat it?
					ability = 5							// Fire ability
				elseif(mo.enemy.type == MT_KIRBYICEBLOCK)	// Is this an ice block?
					ability = 6							// Ice ability! This is put here because otherwise it would give stone
				elseif(mo.enemy.type == MT_MINUS)			// Is this a minus?
					//or(mo.enemy.type == MT_INV)			// Is this an invincibility monitor?
					or(mo.enemy.type == MT_EGGGUARD)		// Egg guard?
					or(mo.enemy.oldflags & MF_PUSHABLE)		// Is this a pushable?
					ability = 1							// Stone ability
				elseif(mo.enemy.type == MT_DETON)			// Deton?
					or(mo.enemy.type == MT_BLACKTV)			// Is this a bomb monitor?
					or(mo.enemy.type == MT_BIGMINE)			// Is this a mine?
					ability = 2							// Crash ability
				elseif(mo.enemy.type == MT_GOLDBUZZ)		// A buzz?
					or(mo.enemy.type == MT_REDBUZZ)			// Another buzz?
					or(mo.enemy.type == MT_AQUABUZZ)		// Yet another buzz?
					ability = 3							// Mini "ability"
				elseif(mo.enemy.type == MT_YELLOWSHELL)		// A spring shell?
					or(mo.enemy.type == MT_SPRINGSHELL)		// Another spring shell?
					or(mo.enemy.skin == "paper_luigi")		// Is this second banana?
					ability = 4							// High jump ability
				elseif(mo.enemy.type == MT_BLUETV)			// Force shield monitor? Doesn't make much sense...
					ability = 6							// Ice ability... man, nothing in this game has to do with ice!
				elseif(mo.enemy.type == MT_WHITETV)			// Is this a whirlwind monitor?
					ability = 7							// Tornado ability
				elseif(mo.enemy.type == MT_YELLOWTV)		// Is this a ring shield monitor?
					ability = 8							// Plasma ability
				elseif(mo.enemy.type == MT_GFZFISH)			// Is this a stupid dumb robo fish?
					or(mo.enemy.type == MT_CRAWLACOMMANDER)	// Is this a crawla commander?
					ability = 9							// Sleep ability
				elseif(mo.enemy.type == MT_JETTBOMBER)		// Is this a bomber?
					or(mo.enemy.type == MT_SKIM)			// Is this another bomber?
					or(mo.enemy.skin == "bomberman")		// Is this a bomber MAN? *shot*
					ability = 10						// Bomb ability
				elseif(mo.enemy.type == MT_SHARP)			// Is this a sharp?
					or(mo.enemy.type == MT_POINTY)			// Is this an obsolete spike enemy?
					or(mo.enemy.type == MT_UNIDUS)			// Is this an unobsolete spike enemy?
					or(mo.enemy.type == MT_GSNAPPER)		// Is this a turtle bot?
					ability = 11						// Needle ability
				elseif(mo.enemy.type == MT_JETJAW)			// Is this a jet jaw?
					or(mo.enemy.type == MT_VULTURE)			// Is this a BASH?
					or(mo.enemy.type == MT_JETTGUNNER)		// Is this a jetty-syn gunner?
					or(mo.enemy.skin == "tails")			// Is this a Tails? He flies a jet bi plane, sooo....
					or(mo.enemy.skin == "tailscd")			// Same here
					or(mo.enemy.skin == "metal_sonic")		// Is this Metal Sonic? He has a jet thingy....
					or(mo.enemy.skin == "eggpack")			// Is this Eggpack? He flies around with a jet...
					ability = 12						// Jet ability
				elseif(mo.enemy.type == MT_SNAILER)			// Is this that one enemy that's only in ERZ?
					or(mo.enemy.skin == "eggman")			// Is this Eggman in his Eggmobile?
					ability = 13						// Laser ability
				elseif(mo.enemy.type == MT_REDCRAWLA)		// Is this a super crawla?
					or(mo.enemy.type == MT_BLUECRAWLA)		// Is this a normal crawla?
					or(mo.enemy.type == MT_SNEAKERTV)		// Is this a speed shoes monitor?
					or(mo.enemy.skin == "sonic")			// Is this a SANIC?
					or(mo.enemy.skin == "sanic")			// Is this *the* SANIC?
					or(mo.enemy.skin == "shadow")			// Is this a black SANIC?
					or(mo.enemy.skin == "greeneyes")		// Is this a "nobody loves my green eyes" SANIC?
					or(mo.enemy.skin == "modsonic")			// Is this a possible refrence to an unreleased SANIC? :O
					or(mo.enemy.skin == "fsonic")			// Is this sexy SANIC?
					or(mo.enemy.skin == "onfooteggman")		// Is this gotta go fast?
					ability = 14						// Wheel ability
				elseif(mo.enemy.type == MT_FACESTABBER)		// Is this a castle bot face stabber?
					or(mo.enemy.skin == "metaknight")		// Is this OP pls nerf?
					ability = 15						// Sword ability
				elseif(mo.enemy.skin == "knuckles")			// Is this Chuckles?
					or(mo.enemy.skin == "amy")				// Is this amy?
					or(mo.enemy.skin == "mario")			// Unreleased Mario & Luigi Mario?
					or(mo.enemy.skin == "luigi")			// Unreleased Mario & Luigi Luigi?
					or(mo.enemy.skin == "paper_mario")		// Released Paper Mario?
					or(mo.enemy.skin == "kingdedede")		// Is this KING DEY DEY DEY?
					ability = 16						// Hammer ability
				elseif(mo.enemy.skin == "uglyknux")			// Is this ugly knux?
					ability = 99						// Oh no ability!
				elseif(mo.enemy.type == MT_INV)				// Is this an invincibility box?
					ability = 80						// Hyper "ability"
				end
				
				// Wow... after all that, here's a list of enemies and monitors WITHOUT abilities:
				// ------------------------------------------------------------------------------------------
				// ENEMIES
				// MT_TURRET
				// MT_POPUPTURRET
				// MT_ROBOHOOD
				//
				// MONITORS
				// MT_SUPERRINGBOX
				// MT_REDRINGBOX
				// MT_BLUERINGBOX
				// MT_PRUP (1 up)
				// MT_PITYTV
				// MT_EGGMANBOX
				// MT_GRAVITYBOX
				// MT_SCORETVSMALL
				// MT_SCORETVLARGE
				// ------------------------------------------------------------------------------------------
				// Only 3 enemies? Wow, I did a good job spreading these abilities thin! *pats self on back*
				// ....Maybe too good, no more fun in finding out if an enemy has an ability, just dissapointment D:
				
				// Randomize the ability when we get 2 or more ability enemies!
				if(mo.target.player.abilityto and ability)		// Already have an ability?
					or(mo.enemy.type == MT_MIXUPBOX)			// Mixup monitor?
					or(mo.enemy.type == MT_RECYCLETV)			// Recycle monitor?
					or(mo.enemy.type == MT_QUESTIONBOX)			// Random monitor?
					if not(mo.enemy.oldflags & MF_FIRE)			// Not fire though!
						mo.target.player.abilityto = 100		// RANDOM ABILITY!
					end
				elseif(ability)		// This is fine (as long as there's an ability to give!)
					mo.target.player.abilityto = ability
				end
				
				// NO SWORD, HAMMER OR PARASOL! (Or backdrop for now)
			//	if(mo.target.player.abilityto == 15)
			//		or(mo.target.player.abilityto == 16)
			//		or(mo.target.player.abilityto == 19)
			//		or(mo.target.player.abilityto == 23)
			//		mo.target.player.abilityto = 21		// Cutter instead, since it's rare for bad reasons
			//	end
				
				// Remove the object (or make it invisible in case of the player)
				if not(checkShouldBeModified(mo.enemy.type))	// Don't wanna modify it?
					mo.enemy.flags2 = $1|MF2_DONTDRAW	// Not visible!
					mo.target.player.atedontmod = true	// We ate a thing!!!!!
					mo.target.player.atedontmodmobj = mo.enemy	// That's the thing
				elseif not(mo.enemy.player)		// No player?
					if(mo.enemy.oldflags & MF_BOSS)	// Was a boss?
						or(mo.enemy.type == MT_METALSONIC_RACE)	// Race Metal Sonic?
						//P_KillMobj(mo.enemy)		// Kill it first
						G_ExitLevel()	// We won! Yaaay!
					end
					P_RemoveMobj(mo.enemy)
				else
					mo.enemy.flags2 = $1|MF2_DONTDRAW	// Not visible!
					mo.target.player.ateaplayer = true	// We ate a player!!!!!
					mo.target.player.ateplayer = mo.enemy.player	// That's the player
				end
				
				// What if we ate more than one thing on the same frame :O
				if(mo.target.player.inhalestate == 3)
					mo.target.player.atemultiple = true
				end
				
				// Reset the sucking player!
				mo.target.player.inhalestate = 3	// Reset inhaling
				mo.target.state = S_PLAY_RUN1		// Stop sucking
				S_StopSound(mo.target)				// Stop the inhale sfx
				S_StartSound(mo.target, sfx_fill)	// We're filled now!
				
				// For swallowing
				mo.target.player.spintics = 2	// Reset spin tics
			elseif(mo.target.player.inhalestate == 3)	// We're fat AND inhaling?
				and(checkTargetObjectIsHeavy(mo))	// Still an enemy though, rings would be dumb
				mo.target.player.inhalestate = 2	// Nope, that doesn't make sense. Now we're sucking again
				mo.target.player.atemultiple = true	// We've probably gotten more things, so lets tell the player that
			// Collecting rings!
			elseif(mo.enemy.type == MT_RING or mo.enemy.type == MT_FLINGRING or mo.enemy.type == MT_COIN or mo.enemy.type == MT_FLINGCOIN or mo.enemy.type == MT_BLUEBALL)
				or(mo.enemy.type == MT_REDTEAMRING and mo.target.player.ctfteam == 1)
				or(mo.enemy.type == MT_BLUETEAMRING and mo.target.player.ctfteam == 2)
				if(mo.sucktimer <= 0)
					if(mariomode)
						S_StartSound(mo.target, sfx_mario4)
					else
						S_StartSound(mo.target, mo.enemy.info.deathsound)
					end
					P_KillMobj(mo.enemy, mo.target, mo.target)
					P_GivePlayerRings(mo.target.player, 1)
				end
			end
		elseif(mo.sucking and mo.enemy and not mo.enemy.valid)	// Sucking but nothing to suck?!
			and(mo.target.player.inhalestate == 2)
			mo.target.player.inhalestate = 0	// Rip
		end
		
		// The fancy effect!
		mo.flags2 = $1|MF2_DONTDRAW	// We're not even here :O
		if not(leveltime & 1 == mo.sucktimer & 1)
			if(mo.suckyangle == nil)
				local angle = P_RandomKey(10)*36*FRACUNIT
				mo.suckyangle = FixedAngle(angle)
			end
			if(mo.suckyangle1 == nil)
				local angle = P_RandomKey(10)*36*FRACUNIT
				mo.suckyangle1 = FixedAngle(angle)
			end
			if(mo.suckyangle2 == nil)
				local angle = P_RandomKey(10)*36*FRACUNIT
				mo.suckyangle2 = FixedAngle(angle)
			end
			if(mo.suckyangle3 == nil)
				local angle = P_RandomKey(10)*36*FRACUNIT
				mo.suckyangle3 = FixedAngle(angle)
			end
			local rotate = 0
			while(rotate < 4)
				// Get the angle!
				local angle = mo.suckyangle
				if(rotate == 1)
					angle = mo.suckyangle1
				elseif(rotate == 2)
					angle = mo.suckyangle2
				elseif(rotate == 3)
					angle = mo.suckyangle3
				end
				
				local size = mo.sucktimer + 2
				local ringx = FixedMul(sin(angle), (size*size) * FRACUNIT)
				local ringy = 0
				local ringz = FixedMul(cos(angle), (size*size) * FRACUNIT)
				
				local m00 = sin(-mo.target.angle)
				local m01 = cos(-mo.target.angle)
				local m02 = 0
				local m10 = m01
				local m11 = -m00
				local m12 = 0
				local m20 = 0
				local m21 = 0
				local m22 = FRACUNIT
				local transformedRingx = FixedMul(ringx, m00) + FixedMul(ringy, m10) + FixedMul(ringz, m20)
				local transformedRingy = FixedMul(ringx, m01) + FixedMul(ringy, m11) + FixedMul(ringz, m21)
				local transformedRingz = FixedMul(ringx, m02) + FixedMul(ringy, m12) + FixedMul(ringz, m22)
				
				transformedRingx = $1 + mo.x
				transformedRingy = $1 + mo.y
				transformedRingz = $1 + mo.z + (mo.height/2)
				
				local dustheight = FixedMul(mobjinfo[MT_PARTICLE].height, mo.scale)
				local dust = P_SpawnMobj(transformedRingx, transformedRingy, transformedRingz-dustheight, MT_PARTICLE)
				dust.tics = 2
				//local flipval = mo.sucktimer-5
				dust.scale = mo.scale//(-flipval)
				if(mo.eflags & MFE_VERTICALFLIP)
					dust.flags = $1|MFE_VERTICALFLIP
				end
				if(mo.target.eflags & MFE_UNDERWATER)
					dust.sprite = SPR_BUBO	// Bubble now!
				end
				dust.frame = A|TR_TRANS60		// Not as transparent as usual!
				
				rotate = $1 + 1
			end
			// Spin the effect!
			local angle = 36*FRACUNIT/2
			mo.suckyangle = $1 + FixedAngle(angle)
			mo.suckyangle1 = $1 + FixedAngle(angle)
			mo.suckyangle2 = $1 + FixedAngle(angle)
			mo.suckyangle3 = $1 + FixedAngle(angle)
		end
	end
end, MT_KIRBYSUCKS)

// Suck up the objects!
local function suckerCollide(sucker, enemy)
	local isenemysuckable = false
	if(enemy.valid and enemy.flags & MF_ENEMY)
	//	or(enemy.valid and enemy.flags & MF_BOSS)	// OP Pls nerf
		or(enemy.valid and enemy.flags & MF_MONITOR)
		or(enemy.valid and enemy.flags & MF_FIRE)	// FIREEEEEE
		or(enemy.valid and enemy.flags & MF_MISSILE and not(enemy.target == sucker.target))	// IT'S A HOMING SHOT!
		or(enemy.valid and enemy.flags & MF_PUSHABLE)	// Requested, makes gargoyles and things eatable
		or(enemy.valid and enemy.abilitytogive)
		// Special list of mobj types
		or(enemy.valid and enemy.type == MT_RING)
		or(enemy.valid and enemy.type == MT_FLINGRING)
		or(enemy.valid and enemy.type == MT_COIN)
		or(enemy.valid and enemy.type == MT_BLUEBALL)	// Get blue balls!
		or(enemy.valid and enemy.type == MT_REDTEAMRING and sucker.valid and sucker.target.player.ctfteam == 1)
		or(enemy.valid and enemy.type == MT_BLUETEAMRING and sucker.valid and sucker.target.player.ctfteam == 2)
		or(enemy.valid and enemy.type == MT_DROPABL)	// Dropped ability!
		or(enemy.valid and enemy.type == MT_BIGMINE)	// That one underwater mine thingy!
		// Sucking in players?!?!
		or(enemy.valid and enemy.type == MT_PLAYER and enemy != sucker.target and enemy.player and not sucker.target.beingsucked)
		// Metal Sonic because why not
		or(enemy.valid and enemy.type == MT_METALSONIC_RACE)
		or(enemy.valid and enemy.type == MT_METALSONIC_BATTLE)
		// Kirby can suck up the flags in ctf, but not if it's firmly planted in the ground!
		// TODO before allowing: Actualy implement the firmly planted part...
		//or(enemy.valid and enemy.type == MT_REDFLAG)
		//or(enemy.valid and enemy.type == MT_BLUEFLAG)
		// Thokker compatability! Kirby is overpowered!
		or(enemy.valid and enemy.type == MT_BIGTUMBLEWEED)
		isenemysuckable = true
	end
	
	// Blacklist!
	if(enemy.valid and enemy.type == MT_CYBRAKDEMON_ELECTRIC_BARRIER)	// Brak lighting
		or(enemy.valid and enemy.type == MT_KIRBYNEEDLEHURT)			// This would be a dumb thing to suck up
		or(enemy.valid and enemy.type == MT_PLASMA)						// Ditto
		isenemysuckable = false
	end
	
	if(sucker.valid)		// Not rip?
		and(enemy.valid)	// Also not rip?
		// Did we actual HIT the enemy?
		and(sucker.z+sucker.height >= enemy.z)
		and(sucker.z <= enemy.z+enemy.height)
		and(isenemysuckable)
		and not(enemy.beingsucked)	// Don't suck something twice!
		and not(sucker.sucking)		// Don't suck 2 things!
		S_StartSound(enemy, sfx_eat)	// Swipy sound from KRTDL
		if(enemy.flags & MF_ENEMY)		// An enemy! Probably important!
			or(enemy.type == MT_DROPABL)	// Dropped ability!
			or(enemy.flags & MF_MISSILE)	// For missiley stuff
			or(enemy.flags & MF_FIRE)		// For firey stuff
			if(sucker.target.player.inhalestate == 3)
				sucker.target.player.atemultiple = true		// Ate something the same frame?
			end
			sucker.target.player.inhalestate = 2	// Lock into sucking!
		end
		sucker.target.beingsucked = false	// Don't want 2 kirbies eating eachother!
		enemy.beingsucked = true
		sucker.sucking = true
		sucker.enemy = enemy
		// Modify the enemy to not hurt
		enemy.oldflags = enemy.flags	// Gonna need this later!
		if(checkShouldBeModified(enemy.type))
			enemy.flags = $1 & ~MF_ENEMY	// Having a hard time thinking of something witty to say about this... oh well.
			enemy.flags = $1 & ~MF_BOSS		// Not gonna boss me around anymore!
			enemy.flags = $1 & ~MF_PAIN		// Noname would not approve... unless you show him your thighs *bricked*
			enemy.flags = $1 & ~MF_FIRE		// Kae would not approve
			enemy.flags = $1 & ~MF_MISSILE	// Can't hurt you
			enemy.flags = $1 & ~MF_SHOOTABLE	// Can't be hurt
			enemy.flags = $1|MF_NOCLIP		// Not solid!
			enemy.flags = $1|MF_NOCLIPHEIGHT	// Rip all the rings that fell through the world #neverforget ;_;
		end
		
		if(enemy.player)
			enemy.player.pflags = $1|PF_STASIS		// Can't move!
			enemy.player.pflags = $1|PF_JUMPSTASIS	// Also can't jump!
			enemy.player.inhalestate = 0	// Can't use abilities!
		end
		if(enemy.oldflags & MF_FIRE)		// Was this fire?
			enemy.state = mobjinfo[enemy.type].spawnstate	// Spawn state it is!
		end
	end
	
	return false
end

// Add the function to BOTH hooks... not sure if it matters, though
addHook("MobjMoveCollide", suckerCollide, MT_KIRBYSUCKS)
addHook("MobjCollide", suckerCollide, MT_KIRBYSUCKS)
