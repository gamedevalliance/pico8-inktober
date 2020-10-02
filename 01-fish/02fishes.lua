-->8
function spawn_fishes()
    distance_between_fishes = 16
    max_fishes_per_screen = 4

    first_fish_chance = 98
    second_fish_chance = 2
    third_fish_chance = 0

    can_spawn = true
    spawned = 0
    last_fish_y = 0

    initial_y = cam.x == 0 and 8 or 12

    for i=initial_y,52 do
        -- First Layer
        if (cam.x == 0 and i == 24) then
            first_fish_chance = 65
            second_fish_chance = 35
        end

        -- Second Layer
        if (cam.x == 128 and i == 24) then
            first_fish_chance = 40
            second_fish_chance = 50
            third_fish_chance = 10
        end

        if (cam.x == 256 and i == 16) then
            first_fish_chance = 25
            second_fish_chance = 50
            third_fish_chance = 25
        end

        if (cam.x > 256) then
            first_fish_chance = 10
            second_fish_chance = 50
            third_fish_chance = 40
        end

        if can_spawn == true and i*8 - last_fish_y > distance_between_fishes then
            fish_kind = get_fish_kind()

            new_fish = {
                x = cam.x+rnd(64)+32,
                y = i*8,
                w = fish_kind.w,
                h = 8,
                speed = fish_kind.speed,
                spr=fish_kind.spr,
                value=fish_kind.value,
                caught=false,
                direction = sgn(flr(rnd(2)-1)),
                last_collide = 0
            }
            last_fish_y = new_fish.y

            add(fishes, new_fish)
            spawned += 1
        end

        if (spawned == max_fishes_per_screen) can_spawn = false
        if (i % 12 == 0) then
            can_spawn = true
            spawned = 0
        end
    end
end

function get_fish_kind()
    fish_kind_roll = rnd(second_fish_chance > first_fish_chance and second_fish_chance or first_fish_chance)

    if (fish_kind_roll < third_fish_chance) then
        return {
            spr = 36,
            speed = 0.6,
            value = 1000,
            w = 16
        }
    elseif (fish_kind_roll < second_fish_chance) then
        return {
            spr = 35,
            speed = 0.8,
            value = 400,
            w = 8
        }
    elseif (fish_kind_roll < first_fish_chance) then
        return {
            spr = 3,
            speed = 0.6,
            value = 150,
            w = 8
        }
    end
end

function update_fishes()
    for fish in all(fishes) do
        fish.last_collide-=1

        if (fish.y < cam.y - 8) del(fishes, fish)
        if (fish.x < cam.x or fish.x > cam.x + 128) del(fishes, fish)

        if (fish.y < cam.y+148 and not fish.caught) then
            fish.x += fish.direction * fish.speed

            for block in all(blocks) do
                if (block.collide and block.y == fish.y) then
                    if (collision(fish, block)) then
                        if (fish.last_collide > 0) del(fishes, fish)

                        fish.direction = -fish.direction
                        fish.last_collide += 30
                    end
                end
            end
        end
    end
end
