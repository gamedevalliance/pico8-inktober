-->8

function create_stars(foreground, background)
    foreground = foreground or 0
    background = background or 0

    for i=1,foreground do
        local new_star = {
            x = rnd(128), y = rnd(128),
            col = 7,
            speed = 3 + rnd(0.5)
        }
        add(stars, new_star)
    end
    for i=1,background do
        local new_star = {
            x = rnd(128), y = rnd(128),
            col = 6,
            speed = 3 + rnd(1)
        }
        add(stars, new_star)
    end
end

function update_stars()
	for s in all(stars) do
		s.x-=s.speed
		if s.x<0 then
			s.x=128
			s.y=rnd(128)
		end
	end
end

function draw_stars()
    for s in all(stars) do
 	    pset(cam.x+s.x,cam.y+s.y,s.col)
    end
end
