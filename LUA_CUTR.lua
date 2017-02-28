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
end, MT_KIRBYCUTTER)

// Go backwards!
addHook("MobjThinker", function(mo)
	local angle = R_PointToAngle2(mo.target.x, mo.target.y, mo.x, mo.y)
	angle = mo.angle
	P_Thrust(mo, angle, -FRACUNIT*3/2)
	if(mo.lifetime == nil)
		mo.lifetime = 0
	end
	mo.lifetime = $1 + 1
end, MT_KIRBYCUTTER)

// Remove it when we hit the player!
addHook("MobjMoveCollide", function(mo, player)
	if(player.valid and mo.valid)		// We still exsist?
		and(player == mo.target)
		and(mo.lifetime and mo.lifetime > 5)	// Have a chance to get away from the player!
		// Did we actual HIT the player?
		and(mo.z+mo.height >= player.z)
		and(mo.z <= player.z+player.height)
		S_StartSound(mo.target, sfx_s3k4a)
		P_RemoveMobj(mo)
	end
end, MT_KIRBYCUTTER)
