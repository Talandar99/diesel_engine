local entities_to_process = {}

for entity_type, entities in pairs(data.raw) do
	if type(entities) == "table" then
		for _, entity in pairs(entities) do
			if type(entity) == "table" and entity.make_space_diesel_variant == true then
				table.insert(entities_to_process, entity)
			end
		end
	end
end

local function make_space_fluid_variant(entity)
	local new_name = entity.name .. "-low-pressure-variant"

	local space_entity = table.deepcopy(entity)

	space_entity.name = new_name
	space_entity.placeable_by = { item = entity.name, count = 1 }

	space_entity.localised_name = {
		"entity-name.low-pressure-diesel-variant",
		entity.localised_name or { "entity-name." .. entity.name },
	}

	if space_entity.minable then
		space_entity.minable.result = entity.name
	end

	if space_entity.energy_source and space_entity.energy_source.type == "fluid" then
		if space_entity.energy_source.fluid_box then
			space_entity.energy_source.fluid_box.filter = "space-diesel-fuel"
		end
	end

	-- hide space entity
	space_entity.hidden_in_factoriopedia = true
	space_entity.hidden = true

	entity.created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "diesel-engine-check-low-pressure-variant",
			},
		},
	}

	data:extend({ space_entity })
end

for _, entity in ipairs(entities_to_process) do
	make_space_fluid_variant(entity)
end
