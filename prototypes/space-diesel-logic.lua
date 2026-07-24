return function(fluid_properties)
	if mods["space-age"] then
		-------------------------------------------------------------------------------
		local oxygen_name = "oxygen"
		if mods["Krastorio2"] then
			oxygen_name = "kr-oxygen"
		end
		data.raw.recipe["inefficient-electrolysis"].results = { { type = "fluid", name = oxygen_name, amount = 20 } }
		-------------------------------------------------------------------------------
		--redefine oxygen to override other icons because I think it looks cool
		if settings.startup["override-oxygen-with-diesel-engine-icon"].value then
			data:extend({
				{
					type = "fluid",
					name = oxygen_name,
					subgroup = "fluid",
					default_temperature = 25,
					base_color = { r = 0.28, g = 0.68, b = 0.73 },
					flow_color = { r = 0.40, g = 0.78, b = 0.83 },
					icon = "__diesel_engine__/graphics/oxygen.png",
					icon_size = 64,
					order = "a[fluid]-d[oxygen]",
					pressure_to_speed_ratio = 0.4,
					flow_to_energy_ratio = 0.59,
					auto_barrel = true,
				},
			})
		end
		-------------------------------------------------------------------------------
		local has_space_variant = false
		local check_types = { "assembling-machine", "inserter", "furnace", "mining-drill" }

		for _, prototype_type in ipairs(check_types) do
			if data.raw[prototype_type] then
				for _, entity in pairs(data.raw[prototype_type]) do
					if entity.diesel_fuel_fluid_filter then
						has_space_variant = true
						break
					end
				end
			end
			if has_space_variant then
				break
			end
		end

		if has_space_variant and data.raw.fluid["space-diesel-fuel"] then
			if data.raw.technology["space-diesel"] then
				for name, values in pairs(fluid_properties or {}) do
					if name ~= "space-diesel-fuel" and data.raw.fluid[name] and values.fuel_value then
						local input_energy = util.parse_energy(values.fuel_value)
						local target_diesel_energy = util.parse_energy(data.raw.fluid["space-diesel-fuel"].fuel_value)

						if input_energy and input_energy > 0 and target_diesel_energy > 0 then
							local recipe_name = "space-diesel-from-" .. name

							data:extend({
								{
									type = "recipe",
									name = recipe_name,
									energy_required = 10,
									enabled = false,
									categories = { "organic", "chemistry" },
									localised_name = {
										"recipe-name.space-diesel-from-fluid",
										data.raw.fluid[name].localised_name or { "fluid-name." .. name },
									},
									icons = {
										{
											icon = data.raw.fluid["space-diesel-fuel"].icon,
											icon_size = data.raw.fluid["space-diesel-fuel"].icon_size or 64,
											draw_background = true,
										},
										{
											icon = data.raw.fluid[name].icon,
											icon_size = data.raw.fluid[name].icon_size or 64,
											scale = 0.25,
											shift = { 8, 8 },
											draw_background = true,
										},
									},
									ingredients = {
										{ type = "fluid", name = name, amount = 100 },
										{ type = "fluid", name = oxygen_name, amount = 100 },
									},
									results = {
										{
											type = "fluid",
											name = "space-diesel-fuel",
											amount = (100 * input_energy) / target_diesel_energy,
										},
									},
									subgroup = "space-diesel-fuel",
									order = "b[fluid-chemistry]-z-" .. name,
								},
							})

							table.insert(
								data.raw.technology["space-diesel"].effects,
								{ type = "unlock-recipe", recipe = recipe_name }
							)
						end
					end
				end
			end
		else
			-- hide / disable stuff if it's unused
			if data.raw.recipe["inefficient-electrolysis"] then
				data.raw.recipe["inefficient-electrolysis"].hidden = true
				data.raw.recipe["inefficient-electrolysis"].enabled = false
			end
			if data.raw.fluid["space-diesel-fuel"] then
				data.raw.fluid["space-diesel-fuel"].hidden = true
			end
			if data.raw.technology["space-diesel"] then
				data.raw.technology["space-diesel"].hidden = true
				data.raw.technology["space-diesel"].enabled = false
				data.raw.technology["space-diesel"].effects = {}
			end
		end
	end
end
