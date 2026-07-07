-- force override fuel_value / emissions_multiplier for base fluids
return {
	-------------------------------------------------------
	-- balanced around solid fuel
	-------------------------------------------------------
	-- Vanilla
	["light-oil"] = { fuel_value = "1.2MJ", emissions_multiplier = 1.0 },
	["heavy-oil"] = { fuel_value = "0.6MJ", emissions_multiplier = 2.0 },
	["petroleum-gas"] = { fuel_value = "0.6MJ", emissions_multiplier = 0.8 },
	["crude-oil"] = { fuel_value = "0.3MJ", emissions_multiplier = 3.0 },

	-- Pelagos
	["ethanol"] = { fuel_value = "2MJ", emissions_multiplier = 0.25 },
	["biodiesel"] = { fuel_value = "0.8MJ", emissions_multiplier = 0.8 },
	["methane"] = { fuel_value = "0.6MJ", emissions_multiplier = 0.8 },
	["coconut-oil"] = { fuel_value = "0.3MJ", emissions_multiplier = 2.0 },
	["titanium-sludge"] = { fuel_value = "0.15MJ", emissions_multiplier = 2.0 },

	-- Boompuff Agriculture
	["puff-gas"] = { fuel_value = "0.7MJ", emissions_multiplier = 0.8 },

	-- Maraxis, Vesta
	["hydrogen"] = { fuel_value = "0.4MJ", emissions_multiplier = 0.8 },

	-- Depths of Nauvis
	["uranium-sludge"] = { fuel_value = "0.15MJ", emissions_multiplier = 2.5 },

	-- Spoiled trenches of Fulgora
	["holmium-sludge"] = { fuel_value = "0.15MJ", emissions_multiplier = 3.0 },

	-- On Wayward Seas
	["gleba-resin"] = { fuel_value = "0.45MJ", emissions_multiplier = 1.5 },

	-- rocket fuel is fluid
	["rocket-fuel"] = { fuel_value = "1.3MJ", emissions_multiplier = 1.5 },

	-- apia-carnova
	["glycerin"] = { fuel_value = "0.25MJ", emissions_multiplier = 1.2 },

	-- ferros + hydraulic machines
	["lubricant"] = { fuel_value = "0.10MJ", emissions_multiplier = 1.0 },
	["residual-oil"] = { fuel_value = "0.4MJ", emissions_multiplier = 2.5 },
	["naphtha"] = { fuel_value = "0.8MJ", emissions_multiplier = 1.1 },
	["gasoline"] = { fuel_value = "2.0MJ", emissions_multiplier = 1 },

	-- decomposer
	["organic-sludge"] = { fuel_value = "0.25MJ", emissions_multiplier = 3.0 },

	-- foliax
	["energy-fluid"] = { fuel_value = "0.75MJ", emissions_multiplier = 0.8 },
	["brimfruit-paste"] = { fuel_value = "0.6MJ", emissions_multiplier = 1.8 },
	["foliax-research-catalyst"] = { fuel_value = "0.25MJ", emissions_multiplier = 2.0 },

	-- Krastorio 2
	["kr-biomethanol"] = { fuel_value = "0.75MJ", emissions_multiplier = 0.8 },
	["biomethanol"] = { fuel_value = "0.75MJ", emissions_multiplier = 0.8 },

	-------------------------------------------------------
	["space-diesel-fuel"] = { fuel_value = "1.0MJ", emissions_multiplier = 1 },
}
