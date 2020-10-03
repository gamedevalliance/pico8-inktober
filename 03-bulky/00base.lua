function _init()
    -- Game State
    -- 0 = Playing, 1 = Mistake, 2 = Fade End, 3 = End
    game_state = 0
    level = 1

    -- Camera
    cam = {x = 0, y = 128}
    shake = 0

    -- Player
    player = {x = 56, y = 244, walking_frame = 1, last_frame = 0}
    footsteps = {{y = player.y+6, spr = 1}}

    footstep_count = 0
    last_footstep = 0

    -- Keys
    keys = {}
    key_xposition = 97
    key_enum = {
        "⬅️",
        "➡️",
        "⬆️",
        "⬇️",
        "🅾️",
        "❎"
    }

    -- Timers
    timer = 0
    timer_frame = 0
    timer_enabled = false
    mistake_timer = 0
    mistakes = 0

    -- Misc
    fade = 0
    debug = false

    generate_key_sequence()
end

function _update60()
    manage_keys()

    if (game_state == 1) then
        if (mistake_timer >= 30) then
            game_state = 0
            mistake_timer = 0
        end

        mistake_timer += 1
    end

    if (player.y-cam.y<(64)) then
        cam.y = max(0, cam.y-1)
    end

    if (game_state == 3 and btnp(4)) then
        _init()
    end
end

function _draw()
    cls(15)

    -- Shaking
    doshake()

    -- Map
    map(0, 0, 0, 0)

    for footstep in all(footsteps) do
        spr(28+footstep.spr, player.x, footstep.y)
    end

    -- End House
    spr(40, 54, 0, 2, 2)

    -- Player
    spr(12+player.walking_frame, player.x, player.y)

    -- Keys
    rectfill(cam.x+(key_xposition-1), cam.y-1, cam.x+(key_xposition+7), cam.y+128, 0)

    i = 0
    for key in all(keys) do
        if (i <= 14) then
            print(key_enum[key+1], cam.x+key_xposition, cam.y+4+(i*8), (game_state == 1 and i == 0) and 8 or i == 0 and 7 or 5)

            if (debug) print(key, cam.x+(key_xposition+9), cam.y+4+(i*8), 0)

            i += 1
        end
    end

    -- Timer
    rectfill(cam.x+1, cam.y+1, cam.x+37, cam.y+7, 0)
    print ("timer:"..pad(tostr(timer), 3), cam.x+2, cam.y+2, 7)

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
        print("final time: "..pad(tostr(timer), 3), cam.x+64-30, 60, 7)

        print("press 🅾️ to restart", cam.x+64-36, 74, 7)
    end

    -- Debug
    if (debug) then
        print("state:"..game_state, cam.x+2, cam.y+120, black)
    end
end

function generate_key_sequence()
    for i=0,237 do
        key = flr(rnd(6))

        add(keys, key)
    end
end

-- Taken from Krystman at https://www.lexaloffle.com/bbs/?pid=34136
function doshake()
 -- this function does the
 -- shaking
 -- first we generate two
 -- random numbers between
 -- -16 and +16
 local shakex=4-rnd(8)
 local shakey=4-rnd(8)

 -- then we apply the shake
 -- strength
 shakex*=shake
 shakey*=shake

 -- then we move the camera
 -- this means that everything
 -- you draw on the screen
 -- afterwards will be shifted
 -- by that many pixels
 camera(cam.x+shakex,cam.y+shakey)

 -- finally, fade out the shake
 -- reset to 0 when very low
 shake = shake*0.95
 if (shake<0.05) shake=0
end

function pad(string,length)
    if (#string==length) return string
    return "0"..pad(string, length-1)
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

function wait(_wait)
    repeat
        _wait-=1
        flip()
    until _wait<0
end
