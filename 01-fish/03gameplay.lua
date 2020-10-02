-->8
function gameplay()
    if (lives == 0 and not fishing_hook.launched) game_state = 5

    if (game_state == 5 and btn(🅾️)) _init()

    if (btn(❎) and not fishing_hook.launched and lives > 0) launch_fishing_hook()
    if (fishing_hook.launched) update_fishing_hook()

end

function init_fishing_hook()
    fishing_hook = {x = PLAYER.x+10, y = PLAYER.y+15, w=6, h=6, launched = false, speed=1}
    fishing_line_anchor = {x = fishing_hook.x+4, y = fishing_hook.y}
end

function launch_fishing_hook()
    fishing_hook.launched = true
    game_state = 1
    lives -= 1
end

function update_fishing_hook()
    if (game_state == 3 or game_state == 4) return

    fishing_hook.y += fishing_hook.speed
    if fishing_hook.y > 96 or fishing_hook.x > 128 then
        fishing_line_anchor.y = cam.y-32
    end

    if (btn(➡️)) fishing_hook.x += 0.6
    if (btn(⬅️)) fishing_hook.x -= 0.6

    for block in all(blocks) do
        if (block.y == fishing_hook.y) then
            if (collision(fishing_hook, block)) game_over(block)
        end
    end

    for fish in all(fishes) do
        if (fish.y == fishing_hook.y) then
            if (collision(fishing_hook, fish)) then
                fish.caught = true
                wait(15)
                game_over(fish)
            end
        end
    end

    if (fishing_hook.y-cam.y>(64-28)) then
        cam.y+=1
    end
end

function draw_fishing_line()
    line(fishing_line_anchor.x, fishing_line_anchor.y, fishing_hook.x+4, fishing_hook.y, 7)
end

function game_over(object)
    last_score_update = object.value + ((cam.y + cam.x) / 2 + 128 * (cam.x / 128))
    last_score_update = flr(last_score_update)
    total_score += last_score_update
    if (object.value == 1000) type3_caught+=1
    if (object.value == 400) type2_caught+=1
    if (object.value == 150) type1_caught+=1


    if (object.value > 0) game_state = 4 else game_state = 3
end

function wait(_wait)
    repeat
        _wait-=1
        flip()
    until _wait<0
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
