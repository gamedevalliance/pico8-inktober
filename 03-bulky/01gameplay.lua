function manage_keys()
    if (#keys == 0 and game_state < 2) then
        timer_enabled = false
        game_state = 2
    end


    if (timer_enabled) then
        timer_frame +=1

        if (timer_frame >= 60) then
            timer += 1
            timer_frame = 0
        end
    end

    if (game_state == 0) then
        if (debug and btn(0)) then
            deli(keys,1)
            walk()
            timer_enabled = true
            return
        end


        if (btnp()>0 and not btnp(keys[1])) then
            mistake()
            timer_enabled = true
        end

        if (btnp(keys[1])) then
            deli(keys,1)
            walk()
            timer_enabled = true
        end
    end
end

function mistake()
    game_state = 1
    mistakes += 1
    shake = 0.08
end

function walk()
    if (player.walking_frame == 1) then
        player.walking_frame = player.last_frame == 0 and 2 or 0
        player.last_frame = player.walking_frame
    else
        player.walking_frame = 1
    end

    if (footstep_count % 2 == 0) then
        new_footstep = {
            y = player.y+4,
            spr = last_footstep
        }
        add(footsteps, new_footstep)
        last_footstep = 1 - last_footstep
    end
    footstep_count += 1

    player.y -= 1
end
