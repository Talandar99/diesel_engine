local function ensure_storage_integrity()
	if not storage then
		return
	end
	storage.diesel_filters = storage.diesel_filters or {}
	storage.reg_to_unit = storage.reg_to_unit or {}

	if not storage.migrated then
		for unit_num, data in pairs(storage.diesel_filters) do
			if type(data) == "table" then
				local engine = data.engine
				local filter = data.filter

				if engine and engine.valid then
					local reg_id = script.register_on_object_destroyed(engine)
					storage.reg_to_unit[reg_id] = unit_num
					storage.diesel_filters[unit_num] = filter
				else
					if filter and filter.valid then
						filter.destroy()
					end
					storage.diesel_filters[unit_num] = nil
				end
			end
		end
		storage.migrated = true
	end
end

script.on_init(ensure_storage_integrity)
script.on_configuration_changed(ensure_storage_integrity)

script.on_event(defines.events.on_script_trigger_effect, function(event)
	ensure_storage_integrity()
	if event.effect_id ~= "diesel-machine-placed" then
		return
	end

	local engine = event.source_entity or event.target_entity
	if not (engine and engine.valid) then
		return
	end

	local filter_name = engine.name .. "-fluid-filter"
	if not prototypes.entity[filter_name] then
		return
	end

	local filter = engine.surface.create_entity({
		name = filter_name,
		position = engine.position,
		direction = engine.direction,
		force = engine.force,
		create_build_effect_smoke = false,
	})

	if filter then
		filter.destructible = false
		filter.add_fluid_box_linked_connection(1, engine, 1)

		local reg_id = script.register_on_object_destroyed(engine)
		local unit_num = engine.unit_number

		storage.diesel_filters[unit_num] = filter
		storage.reg_to_unit[reg_id] = unit_num
	end
end)

script.on_event(defines.events.on_object_destroyed, function(event)
	ensure_storage_integrity()
	local unit_num = storage.reg_to_unit[event.registration_number]
	if unit_num then
		local filter = storage.diesel_filters[unit_num]
		if filter and filter.valid then
			filter.destroy()
		end
		storage.diesel_filters[unit_num] = nil
		storage.reg_to_unit[event.registration_number] = nil
	end
end)

script.on_event(defines.events.on_player_rotated_entity, function(event)
	ensure_storage_integrity()
	local engine = event.entity
	if not (engine and engine.valid) then
		return
	end

	local filter = storage.diesel_filters[engine.unit_number]
	if filter and filter.valid then
		filter.direction = engine.direction
	end
end)
