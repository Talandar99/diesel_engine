return function(fluid_properties)
	local BARREL_CAPACITY = 50

	for fluid_name, _ in pairs(fluid_properties or {}) do
		local fluid = data.raw.fluid[fluid_name]

		if fluid then
			local fuel_value = fluid.fuel_value
			if type(fuel_value) == "string" then
				local parsed_energy = util.parse_energy(fuel_value)

				if parsed_energy > 0 then
					local number_part = parsed_energy / 1000000
					local unit = "MJ"

					for _, spec in ipairs({
						{ suffix = "-barrel", burnt = "barrel" },
						{ suffix = "-titanium-barrel", burnt = "titanium-barrel" },
					}) do
						local barrel = data.raw.item[fluid_name .. spec.suffix]

						if barrel then
							barrel.fuel_value = tostring(number_part * BARREL_CAPACITY) .. unit
							barrel.fuel_category = "diesel-fuel"
							barrel.burnt_result = spec.burnt

							local acceleration = number_part
							while acceleration > 10 do
								acceleration = acceleration / 1000
							end

							local rocket = data.raw.item["rocket-fuel"]
							if rocket then
								barrel.fuel_acceleration_multiplier = 1 + (acceleration / 2)
								barrel.fuel_emissions_multiplier = rocket.fuel_emissions_multiplier
								barrel.fuel_glow_color = rocket.fuel_glow_color
								barrel.fuel_top_speed_multiplier = rocket.fuel_top_speed_multiplier
							end
						end
					end
				end
			end
		end
	end
end
