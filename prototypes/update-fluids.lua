return function(fluid_properties)
	for name, values in pairs(fluid_properties or {}) do
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
end
