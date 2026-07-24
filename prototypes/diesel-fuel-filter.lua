return function(fluid_properties)
	local extensions = {
		{
			type = "recipe-category",
			name = "diesel-fuel-fluid-filter-category",
		},
	}

	for fluid_name, _ in pairs(fluid_properties) do
		if data.raw.fluid[fluid_name] then
			local surf_conditions = nil
			if fluid_name ~= "space-diesel-fuel" then
				surf_conditions = { { property = "pressure", min = 100 } }
			end
			table.insert(extensions, {
				type = "recipe",
				name = "diesel-fuel-fluid-filter-" .. fluid_name,
				categories = { "diesel-fuel-fluid-filter-category" },
				enabled = true,
				hidden = true,
				hide_from_player_crafting = true,
				energy_required = 0.099,
				ingredients = { { type = "fluid", name = fluid_name, amount = 1 } },
				results = { { type = "fluid", name = fluid_name, amount = 1 } },
				surface_conditions = surf_conditions,
			})
		end
	end

	data:extend(extensions)
	local function apply_fluid_filter_mechanic(entity)
		if not (entity.energy_source and entity.energy_source.type == "fluid" and entity.energy_source.fluid_box) then
			return
		end
		local original_pipes = table.deepcopy(entity.energy_source.fluid_box.pipe_connections)
		local original_pipe_pictures = table.deepcopy(entity.energy_source.fluid_box.pipe_picture)
		local original_covers = table.deepcopy(entity.energy_source.fluid_box.pipe_covers)
		local existing_filter = table.deepcopy(entity.energy_source.fluid_box.filter)
		local existing_filters = table.deepcopy(entity.energy_source.fluid_box.filters)

		entity.energy_source.fluid_box.filter = nil
		entity.energy_source.fluid_box.filters = nil

		entity.energy_source.fluid_box.pipe_connections = {
			{ connection_type = "linked", linked_connection_id = 1 },
		}
		local filter_proxy = {
			type = "furnace",
			name = entity.name .. "-fluid-filter",
			icons = entity.icons or { { icon = entity.icon, icon_size = entity.icon_size } },
			flags = {
				"placeable-neutral",
				"player-creation",
				"no-automated-item-insertion",
				"no-automated-item-removal",
			},
			hidden = true,
			hidden_in_factoriopedia = true,
			selectable_in_game = false,
			collision_mask = { layers = {} },
			collision_box = entity.collision_box,
			crafting_categories = { "diesel-fuel-fluid-filter-category" },
			crafting_speed = 1000,
			source_inventory_size = 0,
			result_inventory_size = 0,
			energy_usage = "1W",
			energy_source = { type = "void" },

			show_recipe_icon = false,
			show_recipe_icon_on_map = false,

			graphics_set = {
				animation = {
					filename = "__core__/graphics/empty.png",
					size = 1,
					frame_count = 1,
				},
			},

			fluid_boxes = {
				{
					production_type = "input",
					pipe_covers = original_covers,
					volume = 100,
					pipe_connections = original_pipes,
					pipe_picture = original_pipe_pictures,
					filter = existing_filter,
					filters = existing_filters,
				},
				{
					production_type = "output",
					volume = 100,
					pipe_connections = {
						{ connection_type = "linked", linked_connection_id = 1 },
					},
				},
			},
		}

		data:extend({ filter_proxy })

		entity.created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
					type = "script",
					effect_id = "diesel-machine-placed",
				},
			},
		}
	end

	for entity_type, entities in pairs(data.raw) do
		if type(entities) == "table" then
			for _, entity in pairs(entities) do
				if type(entity) == "table" and entity.diesel_fuel_fluid_filter == true then
					apply_fluid_filter_mechanic(entity)
				end
			end
		end
	end
end
