// Edited from the old music change lua on the mb
// A lot smaller, and works a lot better!
addHook("ThinkFrame", do
	for player in players.iterate
		if not(player.exiting)
			and(player.mo and player.mo.valid and player.mo.skin == "kirby")
			if(player.powers[pw_sneakers])
				and not(player.prevshoes)
				S_ChangeMusic("KSHOES", true, player)
			end
			player.prevshoes = player.powers[pw_sneakers]
		end
	end
end)
