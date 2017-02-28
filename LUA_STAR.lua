// --------------------------------------------------------
// Kirby's dropped ability
// --------------------------------------------------------

// Timer and bouncing!
addHook("MobjThinker", function(mo)
	// Destroy the object!
	if(mo.timetolive and mo.timetolive <= 0)
		and(mo.health > 0)
		P_KillMobj(mo)	// Rip
		mo.health = 0	// Paranoid?
	end
	
	// Bouncy floor!
	if(P_IsObjectOnGround(mo))
		P_SetObjectMomZ(mo, 10*FRACUNIT)
	end
	
	if(mo.timetolive == nil)
		mo.timetolive = TICRATE*5	// 5 Seconds
	end
	
	mo.timetolive = $1 - 1
	
end, MT_DROPABL)

// Completely intangible dispite being solid!
addHook("MobjMoveCollide", function(mo, pointless)
	return false	// Nope
end, MT_DROPABL)

// --------------------------------------------------------
// Star Kirby spits!
// --------------------------------------------------------

// Destroy monitors!
addHook("MobjMoveCollide", function(mo, monitor)
	if(monitor.valid and mo.valid)		// We still exsist?
		and(monitor.flags & MF_MONITOR)
		and(monitor.health > 0)		// Monitor isn't already dead?
		// Did we actual HIT the monitor?
		and(mo.z+mo.height >= monitor.z)
		and(mo.z <= monitor.z+monitor.height+(10*FRACUNIT))
		P_KillMobj(monitor, mo, mo.target)	// Rip monitor 1991-2016
		if not(mo.thisisbig)
			P_KillMobj(mo)
			mo.momx = 0
			mo.momy = 0
		end
	end
end, MT_STARN)

// Plow through enemies!
addHook("MobjMoveCollide", function(mo, enemy)
	if(enemy.valid and mo.valid)		// We still exsist?
		and(enemy.flags & MF_ENEMY)
		and(enemy.health > 0)		// Enemy isn't already dead?
		and(mo.thisisbig)			// Only when we're big!
		// Did we actual HIT the enemy?
		and(mo.z+mo.height >= enemy.z)
		and(mo.z <= enemy.z+enemy.height)
		P_KillMobj(enemy, mo, mo.target)	// Rip enemy 1991-2016
	end
end, MT_STARN)
