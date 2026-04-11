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
