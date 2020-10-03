-->8

function generate_clouds()
    chance_to_create = 35
    for i=8, 256 do
        chance = rnd(100)

        if (chance < chance_to_create) then
            new_cloud = {
                x = i*8,
                y = 6 + rnd(32),
                spr=7 + flr(rnd(1)+0.5)*2
            }

            add(clouds, new_cloud)
        end
    end
end

function generate_level()
    local last_platform = {x = -128, y = 0, w = 0, h = 0}
    local platform_generated = 0

    for i=10, 512 do
        local platform_length = 5 + flr(rnd(4))
        local distance_variance = flr(((rnd(72) - 16)/8)+0.5)*8
        local platform_y = 64+flr(rnd(5))*8

        if (i >= 128 or level == 2) then
            platform_length = 10 + flr(rnd(5))
        end

        if (i >= 192 or level == 2) then
            distance_variance = flr(((rnd(100) - 16)/8)+0.5)*8

            if (distance_variance == 0) then
                distance_variance = flr(((rnd(100) - 16)/8)+0.5)*8
            end
        end

        if (i >= 128 and i < 256) then
            platform_y = 64+flr(rnd(2))*8
        end

        if (distance_variance > 0 and distance_variance < 16 ) distance_variance = 16
        if (distance_variance == 0 and i < 128) distance_variance = flr(((rnd(72) - 8)/8)+0.5)*8

        if (i*8 >= last_platform.x+last_platform.w + distance_variance) then
            local new_platform = {
                x = i*8,
                y = platform_y,
                w = platform_length*8,
                h = 8 * (1 + ceil(rnd(2))),
                distance = distance_variance,
                layout = {}
            }
            last_platform = new_platform

            for j=0,(platform_length * (new_platform.h/8)-1) do
                new_platform.layout[j] = 4 + flr(rnd(3))
            end

            add(platforms, new_platform)

            if (platform_generated != 0 and platform_generated % 17 == 0) then
                local new_spark = {
                    x = new_platform.x + (new_platform.w/2) - 4,
                    y = new_platform.y - 12,
                    w = 8,
                    h = 8,
                    value = 45
                }

                add(sparks, new_spark)
            end

            chance = rnd(100)
            if (platform_generated != 0 and platform_generated % 3 + flr(rnd(1)) == 0 and chance <= 90) then
                local new_wall = {
                    x = new_platform.x + (new_platform.w/2) - 10,
                    y = 0,
                    w = 8,
                    h = new_platform.y
                }

                add(walls, new_wall)
            end

            if (platform_generated == 19 and level == 1) then
                torch.x = new_platform.x + (new_platform.w/2) - 10
                torch.y = new_platform.y - 16
                torch.brazen = false
            end

            platform_generated += 1
        end
    end
end

function destroy_platforms()
    for platform in all(platforms) do
        if (platform.x + platform.w < cam.x) then
            del(platforms, platform)
        end
    end
end

function destroy_clouds()
    for cloud in all(clouds) do
        if (cloud.x+16 < cam.x) then
            del(clouds, cloud)
        end
    end
end
