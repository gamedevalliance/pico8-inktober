function _init()
	mouse.init()

	-- Money
	jewels = 0

	objects = {
		well = {
			count = 0,
			value = 1,
			cost = 25,
			description = "buy one = get one"
		},
		catapult = {
			count = 0,
			value = 5,
			cost = 75,
			description = "throw stuff maybe"
		},
		guard = {
			count = 0,
			value = 15,
			cost = 175,
			description = "hopefully protect"
		},
		princess = {
			count = 0,
			value = 50,
			cost = 500,
			description = "nice self-insert"
		},
		queen = {
			count = 0,
			value = 150,
			cost = 1500,
			description = "ugh, hate my mom"
		},
		gold = {
			count = 0,
			value = 2,
			cost = 32767,
			description = "beatrice's gold?"
		}
	}

	-- UI
	buttons = {
		{
			x = 32,
			y = 108,
			w = 56,
			h = 16,
			text = "get ◆",
			click = function(self)
				jewels += 1
			end,
		},
		{
			x = 108,
			y = 108,
			w = 16,
			h = 16,
			text = "$",
			click = function()
				upgrade_menu = not upgrade_menu
			end
		}
	}

	upgrade_menu = false
	upgrade_menu_page = 1
	upgrade_menu_buttons = {
		{
			{
				name = "well"
			},
			{
				name = "catapult"
			},
			{
				name = "guard"
			}
		},
		{
			{
				name = "princess"
			},
			{
				name = "queen"
			},
			{
				name = "gold"
			}
		}
	}

	-- Misc
	t = 0

	-- Debug
	last_frame_btn = 0
	debug = false
end

function _update60()
	t += 1

	if (t >= 60) then
		for k, v in pairs(objects) do
			if jewels + v.value * v.count < 0 then
				jewels = 32767
				break
			end

			jewels = min(jewels + v.value * v.count, 32767)
		end
		t = 0
	end

	for btn in all(buttons) do
		if (clicked_btn(btn)) btn.click(btn)
	end

	if (upgrade_menu) then
		i = 0
		for btn in all(upgrade_menu_buttons[upgrade_menu_page]) do
			if (clicked_btn({x = 92, y = 29 + i * 21, w = 14, h = 7}) and (jewels >= objects[btn.name].cost or debug)) then
				objects[btn.name].count += 1
				jewels -= objects[btn.name].cost
			end
			i += 1
		end

		if (clicked_btn({x = 20, y = 85, w = 8, h = 8}) and upgrade_menu_page > 1) then
			upgrade_menu_page -= 1
		end

		if (clicked_btn({x = 100, y = 85, w = 8, h = 8}) and upgrade_menu_page < 2) then
			upgrade_menu_page += 1
		end
	end

	last_frame_btn = mouse.btn()
end

function _draw()
	cls(5)

	map(0, 0, 0, 0)
	rect(8, -8, 119, 103, 1)

	-- Money
	rrectfill(-2, -2, 33, 7, 2, 9, {tl = 0, tr = 0, bl = 0, br = 0})

	print(pad(tostr(jewels), 6).."◆", 1, 1, 10)

	rrectfill(130, -2, 105, 7, 2, 9, {tl = 0, tr = 0, bl = 0, br = 0})

	print(pad(tostr(objects.gold.count), 3).."☉", 108, 1, 10)

	i = 0
	for btn in all(buttons) do
		rrectfill(btn.x,btn.y,btn.x+btn.w,btn.y+btn.h, 0, hovered_btn(btn) and 7 or 4, {tl = 0, tr = 0, bl = 0, br = 0})

		print(btn.text, btn.x+btn.w/2-#btn.text*2+1, btn.y+btn.h/2 - 2, hovered_btn(btn) and 7 or 4)

--[[ 		if (debug) then
			print(btn.x, btn.x, btn.y - 6, 0)
			print(btn.y, btn.x, btn.y - 12, 0)
			print(btn.w, btn.x + btn.w - 6, btn.y - 6, 0)
			print(btn.h, btn.x + btn.w - 6, btn.y - 12, 0)
			print(hovered_btn(btn), (btn.x+btn.w)/2+7, btn.y - 6, 0)
			print(clicked_btn(btn), (btn.x+btn.w)/2+7, btn.y - 12, 0)
		end ]]
		i += 1
	end

	-- Gold
	f = 0
	begin = true
	for i=1,objects.gold.count do
		local gold = 25

		if (begin) then
			gold = 26
			begin = false
		end
		if (i != 1 and i % 12 == 0) then
			gold = 24
		end

		spr(gold, 12 + f * 8, 104 - (i * 8) + (f * (12 * 8)))

		if (i != 0 and i - (f * 12) == 12) then
			f += 1
			begin = true
		end
	end

	-- Upgrade Menu
	if (upgrade_menu) then
		rrectfill(15, 12, 128-16, 128-32, 0, 4, {tl = 0, tr = 0, bl = 0, br = 0})
		print("UPGRADES", 64-16+1, 15, 7)
		print(upgrade_menu_page.."/".."2", 128-30, 15, 7)

		i = 0
		for btn in all(upgrade_menu_buttons[upgrade_menu_page]) do
			text = btn.name.." x"..objects[btn.name].count.."\n"..objects[btn.name].description.."\n".."+"..objects[btn.name].value.."◆/s - "..objects[btn.name].cost.."◆"
			print(text, 21, 23+i*21, jewels >= objects[btn.name].cost and 7 or 5)

			border_color = jewels >= objects[btn.name].cost and (hovered_btn({x = 92, y = 30 + i * 21, w = 14, h = 7}) and 7 or 6) or 5

			rrectfill(92, 30 + i * 21, 106, 37 + i * 21, jewels >= objects[btn.name].cost and 5 or 0, border_color, {tl = 0, tr = 0, bl = 0, br = 0})
			print("GET", 94, 31 + i * 21, border_color)

			i += 1
		end

		border_color = upgrade_menu_page > 1 and (hovered_btn({x = 20, y = 84, w = 8, h = 8}) and 7 or 6) or 5
		rrectfill(20, 128-43, 28, 128-35, upgrade_menu_page > 1 and 5 or 0, border_color, {tl = 0, tr = 0, bl = 0, br = 0})
		print("<", 23, 128-41, border_color)

		border_color = upgrade_menu_page < 2 and (hovered_btn({x = 100, y = 84, w = 8, h = 8}) and 7 or 6) or 5
		rrectfill(100, 128-43, 108, 128-35, upgrade_menu_page < 2 and 5 or 0, border_color, {tl = 0, tr = 0, bl = 0, br = 0})
		print(">", 128-25, 128-41, border_color)
	end

	pset(mouse.pos().x,mouse.pos().y, 7)

	if (debug) then
		print(mouse.pos().x, 128-12, 2, 0)
		print(mouse.pos().y, 128-12, 8, 0)
		print(mouse.btn(), 128-12, 14, 0)
	end
end

mouse = {
	-- Init mouse
	init = function()
		poke(0x5f2d, 1)
	end,

	-- return int:x, int:y, onscreen:bool
	pos = function()
		local x,y = stat(32)-1,stat(33)-1
		return {x = stat(32)-1, y = stat(33)-1}
	end,

	-- return int:btn [0..4]
	-- 0 .. no btn
	-- 1 .. left
	-- 2 .. right
	-- 4 .. middle
	btn = function()
		return stat(34)
	end,
}

function clicked_btn(btn)
	return (hovered_btn(btn) and
	mouse.btn() == 0 and last_frame_btn == 1)
end

function hovered_btn(btn)
	return (mouse.pos().x <= btn.x + btn.w and
	mouse.pos().x >= btn.x and
	mouse.pos().y >= btn.y and
	mouse.pos().y <= btn.y + btn.h)
end

function rrectfill(x0, y0, x1, y1, col, bcol, corners)
  local tl = corners and corners.tl
  local tr = corners and corners.tr
  local bl = corners and corners.bl
  local br = corners and corners.br

  local new_x0 = x0 + max(tl, bl)
  local new_y0 = y0 + max(tl, tr)
  local new_x1 = x1 - max(tr, br)
  local new_y1 = y1 - max(bl, br)

  rectfill(new_x0, new_y0, new_x1, new_y1, col)

  if tl and tl>0 then
    circfill(new_x0, new_y0, tl, col)
  end
  if tr and tr>0 then
    circfill(new_x1, new_y0, tr, col)
  end
  if bl and bl>0 then
    circfill(new_x0, new_y1, bl, col)
  end
  if br and br>0 then
    circfill(new_x1, new_y1, br, col)
  end

  -- draw top rect
  rectfill(new_x0, y0, new_x1, new_y0, bcol)

  -- draw left rect
  rectfill(x0, new_y0, new_x0, new_y1, bcol)

  -- draw right rect
  rectfill(new_x1, new_y0, x1, new_y1, bcol)

  -- draw bottom rect
  rectfill(new_x0, new_y1, new_x1, y1, bcol)
end

function pad(string,length)
  if (#string==length) return string
  return "0"..pad(string, length-1)
end
