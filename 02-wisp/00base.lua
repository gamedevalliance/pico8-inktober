function _init()
    -- 0 = Not-Started, 1 = Playing, 2 = End
    game_state = 0

    -- Player and Camera
    player = {x = 4, y = 32, w=8, h=8, dy=0, dx=0, fire = 100, spr=1, speed=2}
    cam = {x = 0, y = 0, can_move = false}
    camera(cam.x, cam.y)

    -- Tutorial Indicator
    has_jumped = false

    -- Level
    level = 1

    clouds = {}
    generate_clouds()

    platforms = {}
    sparks = {}
    walls = {}
    torch = {}
    generate_level()

    stars = {}

    -- Misc
    score = 0
    fade = 0
    fade_scr(0)
    trails = {}
    trail_timer = 0
    trail_timer_limit = 10 + flr(rnd(2))

    -- Enable for some useful stats
    debug = false
end

function _update60()
    if (game_state == 1) then
        update_character()
        destroy_platforms()
        destroy_clouds()

        update_stars()
    end

    if (game_state == 0 and btnp(❎)) then
        game_state = 1
        create_stars(2, 1)
    end

    if (game_state == 3 and btnp(4)) then
        _init()
    end
end

function _draw()
    cls(13)

    -- Camera
    camera(cam.x, cam.y)

    -- Stars
    draw_stars()

    -- Maps
    map(0, 0, 0, 0, 128, 64)

    -- Clouds
    for cloud in all(clouds) do
        spr(cloud.spr, cloud.x, cloud.y, 2, 1)
    end

    -- Platforms
    for platform in all(platforms) do

        local height = 0
        for i=0, #platform.layout do
            if (i != 0 and i % (platform.w/8) == 0) then
                height += 1
            end

            local x = platform.x + i*8 - height*platform.w
            local y = platform.y + height*8

            spr(platform.layout[i], x, y)
        end
    end

    -- Sparks
    for spark in all(sparks) do
        spr(17, spark.x, spark.y)
    end

    -- Torch
    spr (torch.brazen == true and 22 or 21, torch.x, torch.y, 1, 2)

    -- Player
    spr(player.spr, player.x, player.y)

    -- Trail
    for trail in all(trails) do
        spr(trail.fire and 32 or 16, trail.x, trail.y)
    end

    -- Walls
    for wall in all(walls) do
        for i=0,wall.h-8,8 do
            spr(20, wall.x, i)
        end
    end

    -- UI
    rectfill(cam.x+2, cam.y+2, cam.x+27, cam.y+6, player.spr == 1 and 1 or 2)
    rectfill(cam.x+3, cam.y+3, cam.x+26 * max(0.15, player.fire/100), cam.y+5, player.spr == 1 and 12 or 8)
    print(flr(player.fire), cam.x+30, cam.y+2)

    print("score:"..pad(tostr(flr(score)), 5), cam.x+82, cam.y+2, 0)

    -- Tutorial X
    if (not has_jumped and player.x < 48) print("❎", player.x + 10, player.y, game_state == 0 and 6 or 7)

    if (debug) then
        -- CPU and RAM
        print("ram:"..tostr(stat(0)), cam.x+82, cam.y+2, 0)
        print("cpu:"..tostr(stat(1)), cam.x+86, cam.y+8, 0)
        print("plts:"..tostr(#platforms), cam.x+82, cam.y+14, 0)
        print("strs:"..tostr(#stars), cam.x+82, cam.y+20, 0)

        print("g:"..tostr(grounded()), cam.x+2, cam.y+2)
        print("y:"..tostr(player.y), cam.x+2, cam.y+8)
        print("x:"..tostr(player.x), cam.x+2, cam.y+14)
        print("dy:"..tostr(player.dy), cam.x+2, cam.y+20)
        print("dx:"..tostr(player.dx), cam.x+2, cam.y+26)

        for platform in all(platforms) do
            print("w:"..tostr(platform.w).."("..tostr(platform.w/8)..")", platform.x, platform.y - 8)
            print("h:"..tostr(platform.h).."("..tostr(platform.h/8)..")", platform.x, platform.y - 16)
            print("x:"..tostr(platform.x).."("..tostr(platform.x+platform.w)..")", platform.x, platform.y - 24)
            print("y:"..tostr(platform.y), platform.x, platform.y - 30)
            print("d:"..tostr(platform.distance), platform.x, platform.y - 36)
        end
    end

    if (game_state == 2 and fade < 1) then
        fade += 0.04
        fade_scr(fade)

        if (fade > 1) then
            wait(15)
            fade_scr(0)
            game_state = 3
        end
    end

    if (game_state == 3) then
        rectfill(cam.x+64-48,64-20,cam.x+64+48,64+20, 0)
        print("thanks for playing!", cam.x+64-36, 50, 7)
        print("final score: "..pad(tostr(score), 5), cam.x+64-36, 56, 7)

        print("press 🅾️ to restart", cam.x+64-36, 74, 7)
    end

end

function collision(a, b, a_offset, b_offset)
    --w:width (largeur)
    --h:height (hauteur)
    a_offset = a_offset or {x = 0, y = 0}
    b_offset = b_offset or {x = 0, y = 0}

	return not (a.x + a_offset.x > (b.x+b_offset.x)+b.w-1
	            or a.y+a_offset.y > (b.y+b_offset.y)+b.h-1
	            or (a.x + a_offset.x)+a.w-1 < b.x+b_offset.x
	            or (a.y+ a_offset.y)+a.h-1 < b.y+b_offset.y)
end

function fade_scr(fa)
	fa=max(min(1,fa),0)
	local fn=8
	local pn=15
	local fc=1/fn
	local fi=flr(fa/fc)+1
	local fades={
		{1,1,1,1,0,0,0,0},
		{2,2,2,1,1,0,0,0},
		{3,3,4,5,2,1,1,0},
		{4,4,2,2,1,1,1,0},
		{5,5,2,2,1,1,1,0},
		{6,6,13,5,2,1,1,0},
		{7,7,6,13,5,2,1,0},
		{8,8,9,4,5,2,1,0},
		{9,9,4,5,2,1,1,0},
		{10,15,9,4,5,2,1,0},
		{11,11,3,4,5,2,1,0},
		{12,12,13,5,5,2,1,0},
		{13,13,5,5,2,1,1,0},
		{14,9,9,4,5,2,1,0},
		{15,14,9,4,5,2,1,0}
	}

	for n=1,pn do
		pal(n,fades[n][fi],0)
	end
end

function pad(string,length)
    if (#string==length) return string
    return "0"..pad(string, length-1)
end

function wait(_wait)
    repeat
        _wait-=1
        flip()
    until _wait<0
end
