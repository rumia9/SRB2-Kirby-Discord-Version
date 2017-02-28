// Edited from the old music change lua on the mb
// A lot smaller, and works a lot better!
addHook("ThinkFrame", do
	for player in players.iterate
		if not(player.exiting)
			and(player.mo and player.mo.valid and player.mo.skin == "kirby")
			if(player.powers[pw_invulnerability])
				and not(player.previnv)
				S_ChangeMusic("KINVN2", true, player)
			end
			player.previnv = player.powers[pw_invulnerability]
		end
	end
end)
