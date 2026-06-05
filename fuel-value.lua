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
	-------------------------------------------------------
	["space-diesel-fuel"] = {
		fuel_value = "1.0MJ",
		emissions_multiplier = 1,
	},
}

for name, values in pairs(overrides) do
	local fluid = data.raw.fluid[name]
	if fluid then
		if values.fuel_value then
			fluid.fuel_value = values.fuel_value
		end

		if values.emissions_multiplier then
			fluid.emissions_multiplier = values.emissions_multiplier
		end

		fluid.auto_barrel = true
	end
end

if settings.startup["fluid-value-based-flamethrower"].value then
	local flameturret = data.raw["fluid-turret"]["flamethrower-turret"]

	for fluid_name, values in pairs(overrides) do
		local fluid = data.raw.fluid[fluid_name]
		local fuel_value = values.fuel_value

		if fluid and fuel_value then
			local number_part = util.parse_energy(fuel_value) / 1000000 -- MJ

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
	local space_diesel = data.raw.fluid["space-diesel-fuel"]
	if space_diesel then
		local has_space_variant = false
		local check_types = { "assembling-machine", "inserter", "furnace", "mining-drill" }

		for _, prototype_type in ipairs(check_types) do
			if data.raw[prototype_type] then
				for entity_name, _ in pairs(data.raw[prototype_type]) do
					if string.find(entity_name, "%-space%-variant$") then
						has_space_variant = true
						break
					end
				end
			end
			if has_space_variant then
				break
			end
		end

		if has_space_variant then
			local created_recipes = {}

			for name, values in pairs(overrides) do
				local input_fluid = data.raw.fluid[name]

				if name ~= "space-diesel-fuel" and input_fluid and values.fuel_value then
					local input_energy = util.parse_energy(values.fuel_value)
					local target_diesel_energy = util.parse_energy(space_diesel.fuel_value)

					if input_energy and input_energy > 0 and target_diesel_energy > 0 then
						local output_amount = (100 * input_energy) / target_diesel_energy
						local recipe_name = "space-diesel-from-" .. name

						local recipe_icons = {
							{
								icon = space_diesel.icon,
								icon_size = space_diesel.icon_size or 64,
							},
							{
								icon = input_fluid.icon,
								icon_size = input_fluid.icon_size or 64,
								scale = 0.25,
								shift = { 8, 8 },
							},
						}

						local localized_name = {
							"recipe-name.space-diesel-from-fluid",
							input_fluid.localised_name or { "fluid-name." .. name },
						}

						data:extend({
							{
								type = "recipe",
								name = recipe_name,
								energy_required = 10,
								enabled = false,
								category = "organic-or-chemistry",
								localised_name = localized_name,
								icons = recipe_icons,
								ingredients = {
									{ type = "fluid", name = name, amount = 100 },
								},
								results = {
									{ type = "fluid", name = "space-diesel-fuel", amount = output_amount },
								},
								surface_conditions = {
									{
										property = "pressure",
										min = 1,
									},
								},
								subgroup = "space-diesel-fuel",
								order = "b[fluid-chemistry]-z-" .. name,
							},
						})
						table.insert(created_recipes, recipe_name)
					end
				end
			end
			local space_tech = data.raw.technology["space-platform"]
			if space_tech and #created_recipes > 0 then
				space_tech.effects = space_tech.effects or {}
				for _, r_name in ipairs(created_recipes) do
					table.insert(space_tech.effects, {
						type = "unlock-recipe",
						recipe = r_name,
					})
				end
			end
		end
	end
end
