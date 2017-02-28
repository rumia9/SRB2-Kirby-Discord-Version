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
end, MT_KIRBYNEEDLEHURT)
