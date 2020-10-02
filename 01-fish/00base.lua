function _init()
	PLAYER = {x = 52, y = 8}
	fishing_hook = {}
	fishing_line_anchor = {}
	blocks = {}
	fishes = {}
	cam = {x=0, y=0}
	game_state = 0
	fade = 0
	fade_scr(fade)
	lives = 10
	type1_caught = 0
	type2_caught = 0
	type3_caught = 0
	total_score = 0
	debug = false
	last_score_update = 0

	-- Visuals
	clouds = {position1 = rnd(74)+38, position2 = rnd(90)+25}
	camera(cam.x, cam.y)

	generate_level()
	spawn_fishes()
	init_fishing_hook()
end

function reset_round()
	blocks = {}
	fishes = {}
	cam = {x = 0, y = 0}
	game_state = 0
	fade = 0
	fade_scr(fade)

	generate_level()
	spawn_fishes()
	init_fishing_hook()
end

function _update60()
	if (game_state != 3) update_fishes()
	gameplay()
	destroy_blocks()
end

function _draw()
	cls(13)

	if (cam.y > 48*8) then
		cam.y = 0
		cam.x += 128
		fishing_hook.y = 0
		fishing_hook.x += 128
		fishing_line_anchor.x += 128
		generate_level()
		spawn_fishes()
	end

	camera(cam.x, cam.y)

	if (cam.y) < 16 then
		-- Player
		spr(0, PLAYER.x, PLAYER.y, 1, 2)
		-- Boat
		spr(17, PLAYER.x, PLAYER.y+11)

		if (not fishing_hook.launched and lives > 0) print("❎", PLAYER.x + 19, PLAYER.y+8, 1)

		-- Clouds
		spr(4, clouds.position1, 2, 2, 1)
		spr(6, clouds.position2, 2, 2, 1)

		-- Fishing Rod
		spr(1, PLAYER.x+8, PLAYER.y+7)
	end

	-- Water
	map(0, 0, 0, -3, 128, 128)

	-- Blocks
	for block in all(blocks) do
		if (block.y < cam.y+128) then
			spr(block.spr, block.x, block.y)
		end
	end

	for fish in all(fishes) do
		if (fish.y < cam.y+128) then
			spr(fish.spr, fish.x, fish.y, fish.w/8, 1, fish.direction == 1)
		end
	end

	-- Fishing line
	if (lives > 0 or fishing_hook.launched) spr(22, fishing_hook.x, fishing_hook.y)
	draw_fishing_line()

	line(cam.x+0, 424, cam.x+128, 424, 7)

	-- Score
	spr(3, 2, 1)
	print("x"..tostr(type1_caught).."-".."150", 12, 2, 0)
	spr(35, 2, 9)
	print("x"..tostr(type2_caught).."-".."450", 12, 10, 0)
	spr(36,2,17,2,1)
	print("x"..tostr(type3_caught).."-".."1000", 20, 18, 0)

	if (cam.y > 32 or cam.x > 0) then
		print(flr(((cam.y + cam.x) / 2 + 128 * (cam.x / 128))), cam.x+8, cam.y+8, 7)
	end

	if (last_score_update > 0) print("+"..pad(tostr(last_score_update), 5), 128-26, 6, 10)
	print("score:"..pad(tostr(total_score), 5), 128-45, 12, (lives > 0 or fishing_hook.launched) and 0 or 8)
	print("baits:"..pad(tostr(lives), 2), 128-45, 18, 0)

	if game_state == 5 then
		rectfill(64-48,64-20,64+48,64+20, 0)
		print("thanks for playing!", 64-36, 50, 7)
		print("final score: "..pad(tostr(total_score), 5), 64-36, 56, 7)

		print("press 🅾️ to restart", 64-36, 74, 7)
	end

	if (debug) then
		print(stat(0), cam.x+96, cam.y+2, 0)
		print(stat(1), cam.x+96, cam.y+8, 0)
		print(#fishes, cam.x+96, cam.y+14, 0)
		print(#blocks, cam.x+96, cam.y+20, 0)
		print(fishing_hook.x, cam.x+96, cam.y+26)
		print(lives, cam.x+96, cam.y+32)
		print(total_score, cam.x+96, cam.y+38)
		print(fishing_hook.y, fishing_hook.x, fishing_hook.y)
		print(game_state, cam.x+96, cam.y+44)
	end

	if (game_state == 3 or game_state == 4) then
		fade += 0.05
		fade_scr(fade)

		if (fade >= 1) then
			wait(30)

			reset_round()
		end
	end
end

function collision(a,b)
 --w:width (largeur)
 --h:height (hauteur)
	return not (a.x > b.x+b.w-1
	            or a.y > b.y+b.h-1
	            or a.x+a.w-1 < b.x
	            or a.y+a.h-1 < b.y)
end

function show_live_result()
	reset_round()
end

function pad(string,length)
  if (#string==length) return string
  return "0"..pad(string, length-1)
end
