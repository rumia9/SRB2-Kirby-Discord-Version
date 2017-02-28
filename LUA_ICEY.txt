// Spited ice turns enemies into ice blocks!
addHook("MobjMoveCollide", function(mo, enemy)
	if(enemy.valid and mo.valid)		// We still exsist?
		and(enemy.flags & MF_ENEMY)
		and(enemy.health > 0)		// Enemy isn't already dead?
		// Did we actual HIT the enemy?
		and(mo.z+mo.height >= enemy.z)
		and(mo.z <= enemy.z+enemy.height+(10*FRACUNIT))
		P_SpawnMobj(enemy.x, enemy.y, enemy.z, MT_KIRBYICEBLOCK)	// Spawn the new ice block
		P_KillMobj(enemy)
	end
end, MT_KIRBYSPITICE)

// Same for freeze!
addHook("MobjMoveCollide", function(mo, enemy)
	if(enemy.valid and mo.valid)		// We still exsist?
		and(enemy.flags & MF_ENEMY)
		and(enemy.health > 0)		// Enemy isn't already dead?
		// Did we actual HIT the enemy?
		and(mo.z+mo.height >= enemy.z)
		and(mo.z <= enemy.z+enemy.height+(10*FRACUNIT))
		P_SpawnMobj(enemy.x, enemy.y, enemy.z, MT_KIRBYICEBLOCK)	// Spawn the new ice block
		P_KillMobj(enemy)
	end
end, MT_KIRBYFREEZE)
