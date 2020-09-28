-- update

function _update60()
	if(band(btn(),64)!=0) poke(0x5f30,1)

	for entity in all(entities) do
		entity:update()
	end
end
