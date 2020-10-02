-->8
function generate_level()
	initial_y = cam.x == 0 and 4 or 0
	max_block_width = 4

	first_block = true
	for i=initial_y,64 do

		-- First Layer
		if (i == 32) max_block_width = 5

		-- Second Layer
		if (cam.x >= 128) then
			max_block_width = 6
		end

		if (first_block) then
			current_width = 1
		else
			current_width = flr(rnd(max_block_width))
		end

		first_block = false
		for j=0,current_width do
			new_blocks = {
				{
					x = cam.x + (8*j),
					y = i*8,
					w = 8,
					h = 8,
					spr = rnd(2)+20,
					collide = (j == current_width),
					value = 0
				},
				{
					x = (cam.x + 120) - (8*j),
					y = i * 8,
					w = 8,
					h = 8,
					spr = rnd(2)+20,
					collide = (j == current_width),
					value = 0
				}
			}

			for block in all(new_blocks) do
				add(blocks, block)
			end
		end

	end
end

function destroy_blocks()
	for block in all(blocks) do
		if (block.y < cam.y-8) del(blocks, block)
		if (block.x < cam.x or block.x > cam.x + 128) del(blocks, block)
	end
end
