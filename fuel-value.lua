-- force override fuel_value for base fluids
-- fuel_value is calculated based on in game value
local overrides = {
	-------------------------------------------------------
	--	balanced arround solid fuel
	-------------------------------------------------------
	-- Vanilla
	["light-oil"] = "1.2MJ",
	["heavy-oil"] = "0.6MJ",
	["petroleum-gas"] = "0.6MJ",
	["crude-oil"] = "0.3MJ",
	-- Pelagos
	["ethanol"] = "2MJ",
	["biodiesel"] = "0.8MJ",
	["methane"] = "0.6MJ",
	["coconut-oil"] = "0.3MJ",
	["titanium-sludge"] = "0.15MJ",
	-- Boompuff Agriculture
	["puff-gas"] = "0.7MJ",
	-- Maraxis, Vesta
	["hydrogen"] = "0.4MJ",
	-- Depths of nauvis
	["uranium-sludge"] = "0.15MJ",
	-- Spoilded trenches of fulgora
	["holmium-sludge"] = "0.15MJ",
	-- On Wayward Seas
	["gleba-resin"] = "0.45MJ",
	-- rocket fuel is fluid
	["rocket-fuel"] = "1.3MJ",
	-- apia-carnova
	["glycerin"] = "0.25MJ",
	-------------------------------------------------------
}

for name, value in pairs(overrides) do
	local fluid = data.raw.fluid[name]
	if fluid then
		-- assign value
		fluid.fuel_value = value
		-- make sure it's barrelable
		fluid.auto_barrel = true
	end
end

if settings.startup["fluid-value-based-flamethrower"].value then
	local flameturret = data.raw["fluid-turret"]["flamethrower-turret"]

	for fluid_name, fuel_value in pairs(overrides) do
		local fluid = data.raw.fluid[fluid_name]
		if fluid then
			local number_part = util.parse_energy(fuel_value) / 1000000 -- MJ

			if number_part and number_part > 0 then
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
		else
		end
	end
end
