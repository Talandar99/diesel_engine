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
	--debug log
	--log(pressure)
	if pressure > 100 then
		--debug log
		--log("pressure not 100")
		return
	end
	--debug log
	--log("pressure equal 100")

	local current_name = entity.name
	local space_variant_name = current_name .. "-low-pressure-variant"

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
script.on_event(defines.events.on_script_trigger_effect, function(event)
	if event.effect_id == "diesel-engine-check-low-pressure-variant" then
		check_and_replace_entity(event.target_entity)
	end
end)
-------------------------------------------------------------------------------
