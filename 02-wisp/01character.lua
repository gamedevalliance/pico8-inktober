function update_character()
	death()
	update_camera()
	destroy_trails()
	check_for_spark()

	player.dx = player.speed

	if (cam.can_move and game_state == 1) player.fire -= 0.08

	if (btn(3)) then
		player.dx = 1
		cam.x -= 1
		player.fire -= 0.2
		player.spr = 3
	else
		if (btn(4)) then
			player.fire -= 0.1
			player.spr = 3
		else
			player.spr = 1
		end
	end

	trail_timer += 1

	if (trail_timer == trail_timer_limit) then
		new_trail = {x = player.x-1, y = player.y, fire = player.spr == 3}
		add(trails, new_trail)
		trail_timer = 0
		trail_timer_limit = 4 + flr(rnd(player.fire < 50 and 6 or 12)) - (new_trail.fire and 2 or 0)
	end

	if (player.x < cam.x+16) then
		player.dx = player.speed + 0.4
	end

	jump()

	game_progression()

	if (not check_flag(0, flr(player.x+1)/8, flr(player.y)/8) and not check_for_platform({x = 1, y = 0})) then
		player.x += player.dx
	end
	player.y += player.dy
end

function death()
	if (player.x < cam.x - 24) game_state = 2
	if (player.y > cam.y + 128) game_state = 2
	if (player.fire <= 0) game_state = 2
end

function jump()
	if grounded() then
		if (btnp(❎)) then
			has_jumped = true

			if (player.spr == 3) then
				player.dy =- 5
			else
				player.dy =- 4
			end
		else
			player.dy = 0
			-- fix position
			-- or else she'll be sunk into floor
			player.y = flr(flr(player.y)/8)*8
		end
	else
		-- gravity accel
		player.dy += 0.25
	end
end

function update_camera()
	if (player.x-cam.x>(64-40)) then
        cam.can_move = true
	end

	if (cam.can_move and game_state == 1) cam.x += player.speed
end

-->8
-- Utils

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

function grounded()
	v = mget(flr(player.x+4)/8, flr(player.y)/8+1)
	return fget(v, 0) or check_for_platform({x = 0, y = 1})
end

function check_for_platform(offseta, offsetb)
	offseta = offseta or {x = 0, y = 0}
	offsetb = offsetb or {x = 0, y = 0}

	for platform in all(platforms) do
		if (platform.x + platform.w < cam.x + 128) then
			if (collision(player, platform, offseta, offsetb)) return true
		end
	end

	for wall in all(walls) do
		if (wall.x + wall.w < cam.x + 128) then
			if (collision(player, wall, offseta, offsetb)) then
				if (player.spr == 3) then
					del(walls, wall)
					return false
				else
					return true
				end
			end
		end
	end

	return false
end

function check_for_spark()
	for spark in all(sparks) do
		if (collision(player, spark)) then
			del(sparks, spark)
			player.fire = min(player.fire + spark.value, 100)
			return
		end
	end
end

function destroy_trails()
	for trail in all(trails) do
		if (trail.x < cam.x - 16) del(trails, trail)
	end
end

function game_progression()
	score += 1

	if (flr(player.x) % 256 == 0 and #stars < 128) then
		create_stars(5, 2)
	end

	if (flr(player.x) % 1024 == 0) then
		for star in all(stars) do
			star.speed += 0.8
		end
	end

	if (flr(player.x) % 1408 == 0) then
		player.speed = 3
	end

	if (flr(player.x) > torch.x) then
		torch.brazen = true
	end

	if (flr(player.x) > 4096) then
		player.x = 4
		player.y = 32
		player.fire = 100
		cam = {x = 0, y = 0}
		level = 2
		generate_level()
	end
end
