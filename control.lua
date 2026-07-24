local function ensure_storage_integrity()
	if not storage then
		return
	end
	storage.diesel_filters = storage.diesel_filters or {}
end
script.on_init(ensure_storage_integrity)
script.on_configuration_changed(ensure_storage_integrity)
script.on_event(defines.events.on_script_trigger_effect, function(event)
	ensure_storage_integrity()
	if event.effect_id == "diesel-machine-placed" then
		local engine = event.source_entity or event.target_entity
		if not (engine and engine.valid) then
			return
		end
		local filter_name = engine.name .. "-fluid-filter"
		if prototypes.entity[filter_name] then
			local surface = engine.surface
			local pos = engine.position
			local dir = engine.direction
			local force = engine.force

			local filter = surface.create_entity({
				name = filter_name,
				position = pos,
				direction = dir,
				force = force,
				create_build_effect_smoke = false,
			})

			if filter then
				filter.destructible = false
				filter.add_fluid_box_linked_connection(1, engine, 1)
				storage.diesel_filters[engine.unit_number] = {
					filter = filter,
					engine = engine,
				}
			end
		end
	end
end)

script.on_event({ defines.events.on_player_rotated_entity }, function(event)
	ensure_storage_integrity()
	local engine = event.entity
	if not (engine and engine.valid) then
		return
	end

	if storage.diesel_filters and storage.diesel_filters[engine.unit_number] then
		local data = storage.diesel_filters[engine.unit_number]
		local filter = data.filter

		if filter and filter.valid then
			-- Synchronizujemy rotację ukrytego pieca z obróconą maszyną główną
			filter.direction = engine.direction
		end
	end
end)
local remove_events = {
	defines.events.on_entity_died,
	defines.events.on_player_mined_entity,
	defines.events.on_robot_mined_entity,
	defines.events.script_raised_destroy,
}

script.on_event(remove_events, function(event)
	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	if storage.diesel_filters and storage.diesel_filters[entity.unit_number] then
		local data = storage.diesel_filters[entity.unit_number]
		if data and data.filter and data.filter.valid then
			data.filter.destroy()
		end
		storage.diesel_filters[entity.unit_number] = nil
	end
end)
