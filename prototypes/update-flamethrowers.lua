return function(fluid_properties)
	if settings.startup["fluid-value-based-flamethrower"].value and data.raw["fluid-turret"]["flamethrower-turret"] then
		local flameturret = data.raw["fluid-turret"]["flamethrower-turret"]
		for fluid_name, values in pairs(fluid_properties or {}) do
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
end
