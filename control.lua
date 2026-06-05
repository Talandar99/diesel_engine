-------------------------------------------------------------------------------
-- space diesel machines
-------------------------------------------------------------------------------
-- Function that checks surface pressure and replaces the entity if it's a diesel machine
local function check_and_replace_entity(entity)
	if not (entity and entity.valid) then
		return
	end

	local surface = entity.surface
	local pressure = surface.get_property("pressure")
	--log(pressure)

	if pressure ~= 0 then
		--	log("pressure not 0")
		return
	end

	--log("pressure equal 0")

	local current_name = entity.name
	local space_variant_name = current_name .. "-space-variant"

	if not prototypes.entity[space_variant_name] then
		return
	end

	local position = entity.position
	local direction = entity.direction
	local force = entity.force
	local player = entity.last_user

	entity.destroy()

	local new_entity = surface.create_entity({
		name = space_variant_name,
		position = position,
		direction = direction,
		force = force,
		fast_replace = true,
		raise_built = false,
	})

	if new_entity and player then
		new_entity.last_user = player
	end
end
-------------------------------------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then
		return
	end

	check_and_replace_entity(event.entity)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local e = event.created_entity or event.entity
	if not e then
		return
	end
	check_and_replace_entity(event.entity)
end)
script.on_event(defines.events.on_space_platform_built_entity, function(event)
	local e = event.entity
	if not (e and e.valid) then
		return
	end
	check_and_replace_entity(event.entity)
end)
-------------------------------------------------------------------------------
