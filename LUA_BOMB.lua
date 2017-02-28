// The bomb thinker!
addHook("MobjThinker", function(mo)
	// Only have nogravity for the first half second!
	if(mo.gravtime == nil)
		mo.gravtime = 0
	end
	
	mo.gravtime = $1 + 1
	if(mo.gravtime > TICRATE/2)
		mo.flags = $1 & ~MF_NOGRAVITY
	end
	
	// But still no gravity when we're dead!
	if(mo.state >= S_BPLD1 and mo.state <= S_BPLD7)
		mo.flags = $1|MF_NOGRAVITY
		mo.momx = 0
		mo.momy = 0
		mo.momz = 0
		P_RadiusAttack(mo, mo.target, 160*FRACUNIT)
	end
	
	// Play the splode-y sound when we splode!
	if(mo.state == S_BPLD1)
		and not(S_SoundPlaying(mo, sfx_brakrx))
		S_StartSound(mo, sfx_brakrx)	// KA-BEWM
	end
	
	if(mo.eflags & MFE_UNDERWATER)	// Bombs don't work underwater!
		P_RemoveMobj(mo)
	end
end, MT_KIRBYTHROWBOMB)

// Destroy monitors!
addHook("MobjMoveCollide", function(mo, monitor)
	if(monitor.valid and mo.valid)		// We still exsist?
		and(monitor.flags & MF_MONITOR)
		and(monitor.health > 0)		// Monitor isn't already dead?
		// Did we actual HIT the monitor?
		and(mo.z+mo.height >= monitor.z)
		and(mo.z <= monitor.z+monitor.height+(10*FRACUNIT))
		P_KillMobj(monitor, mo, mo.target)	// Rip monitor 1991-2016
	end
end, MT_KIRBYTHROWBOMB)
