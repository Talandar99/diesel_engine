-- force override fuel_value for base fluids
-- force override fuel_value / emissions_multiplier for base fluids
local overrides = {
	-------------------------------------------------------
	-- balanced around solid fuel
	-------------------------------------------------------
	-- Vanilla
	["light-oil"] = {
		fuel_value = "1.2MJ",
		emissions_multiplier = 1.0,
	},
	["heavy-oil"] = {
		fuel_value = "0.6MJ",
		emissions_multiplier = 2.0,
	},
	["petroleum-gas"] = {
		fuel_value = "0.6MJ",
		emissions_multiplier = 0.8,
	},
	["crude-oil"] = {
		fuel_value = "0.3MJ",
		emissions_multiplier = 3.0,
	},

	-- Pelagos
	["ethanol"] = {
		fuel_value = "2MJ",
		emissions_multiplier = 0.25,
	},
	["biodiesel"] = {
		fuel_value = "0.8MJ",
		emissions_multiplier = 0.8,
	},
	["methane"] = {
		fuel_value = "0.6MJ",
		emissions_multiplier = 0.8,
	},
	["coconut-oil"] = {
		fuel_value = "0.3MJ",
		emissions_multiplier = 2.0,
	},
	["titanium-sludge"] = {
		fuel_value = "0.15MJ",
		emissions_multiplier = 2.0,
	},

	-- Boompuff Agriculture
	["puff-gas"] = {
		fuel_value = "0.7MJ",
		emissions_multiplier = 0.8,
	},

	-- Maraxis, Vesta
	["hydrogen"] = {
		fuel_value = "0.4MJ",
		emissions_multiplier = 0.8,
	},

	-- Depths of Nauvis
	["uranium-sludge"] = {
		fuel_value = "0.15MJ",
		emissions_multiplier = 2.5,
	},

	-- Spoiled trenches of Fulgora
	["holmium-sludge"] = {
		fuel_value = "0.15MJ",
		emissions_multiplier = 3.0,
	},

	-- On Wayward Seas
	["gleba-resin"] = {
		fuel_value = "0.45MJ",
		emissions_multiplier = 1.5,
	},

	-- rocket fuel is fluid
	["rocket-fuel"] = {
		fuel_value = "1.3MJ",
		emissions_multiplier = 1.5,
	},

	-- apia-carnova
	["glycerin"] = {
		fuel_value = "0.25MJ",
		emissions_multiplier = 1.2,
	},

	-- ferros + hydraulic machines
	["lubricant"] = {
		fuel_value = "0.10MJ",
		emissions_multiplier = 1.0,
	},
	["residual-oil"] = {
		fuel_value = "0.4MJ",
		emissions_multiplier = 2.5,
	},
	["naphtha"] = {
		fuel_value = "0.8MJ",
		emissions_multiplier = 1.1,
	},
	["gasoline"] = {
		fuel_value = "2.0MJ",
		emissions_multiplier = 1,
	},
	-- decomposer
	["organic-sludge"] = {
		fuel_value = "0.25MJ",
		emissions_multiplier = 3.0,
	},
	-- foliax
	["energy-fluid"] = {
		fuel_value = "0.75MJ",
		emissions_multiplier = 0.8,
	},
	["brimfruit-paste"] = {
		fuel_value = "0.6MJ",
		emissions_multiplier = 1.8,
	},
	["foliax-research-catalyst"] = {
		fuel_value = "0.25MJ",
		emissions_multiplier = 2.0,
	},
	-------------------------------------------------------
	["space-diesel-fuel"] = {
		fuel_value = "1.0MJ",
		emissions_multiplier = 1,
	},
}
for name, values in pairs(overrides or {}) do
	if data.raw.fluid[name] then
		if values.fuel_value then
			data.raw.fluid[name].fuel_value = values.fuel_value
		end
		if values.emissions_multiplier then
			data.raw.fluid[name].emissions_multiplier = values.emissions_multiplier
		end
		data.raw.fluid[name].auto_barrel = true
	end
end

if settings.startup["fluid-value-based-flamethrower"].value and data.raw["fluid-turret"]["flamethrower-turret"] then
	local flameturret = data.raw["fluid-turret"]["flamethrower-turret"]
	for fluid_name, values in pairs(overrides or {}) do
		if data.raw.fluid[fluid_name] and values.fuel_value then
			local number_part = util.parse_energy(values.fuel_value) / 1000000 -- MJ

			if number_part > 0 then
				local found = false
				for _, f in pairs(flameturret.attack_parameters.fluids) do
					if f.type == fluid_name then
						f.damage_modifier = number_part
						found = true
						break
					end
				end
				if not found then
					table.insert(flameturret.attack_parameters.fluids, {
						type = fluid_name,
						damage_modifier = number_part,
					})
				end
			end
		end
	end
end

if mods["space-age"] then
	local has_space_variant = false
	local check_types = { "assembling-machine", "inserter", "furnace", "mining-drill" }
	for _, prototype_type in ipairs(check_types) do
		if data.raw[prototype_type] then
			for _, entity in pairs(data.raw[prototype_type]) do
				if entity.make_space_diesel_variant then
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
			for name, values in pairs(overrides or {}) do
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
								category = "organic-or-chemistry",
								localised_name = {
									"recipe-name.space-diesel-from-fluid",
									data.raw.fluid[name].localised_name or { "fluid-name." .. name },
								},
								icons = {
									{
										icon = data.raw.fluid["space-diesel-fuel"].icon,
										icon_size = data.raw.fluid["space-diesel-fuel"].icon_size or 64,
									},
									{
										icon = data.raw.fluid[name].icon,
										icon_size = data.raw.fluid[name].icon_size or 64,
										scale = 0.25,
										shift = { 8, 8 },
									},
								},
								ingredients = {
									{ type = "fluid", name = name, amount = 100 },
									{ type = "fluid", name = "oxygen", amount = 100 },
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
		--redefine oxygen to override other icons because it looks cool
		if settings.startup["override-oxygen-with-diesel-engine-icon"].value then
			data:extend({
				{
					type = "fluid",
					name = "oxygen",
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
	else
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
