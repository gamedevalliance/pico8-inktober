function _init()
	entities = {}

	for i=0,25 do
		new_entity = {
			x=rnd(96),
			y=rnd(96),
			radius=12+rnd(2),
			color=1+rnd(3),
			update=function(self)
				self.x+=rnd(6) - 3
				self.y+=rnd(6) - 3
			end
		}

		add(entities, new_entity)
	end
end

function _draw()
	cls(0)

	for entity in all(entities) do
		circfill(entity.x, entity.y, entity.radius, entity.color)
		spr(1, entity.x, entity.y)
	end
end
