data:extend({
	{
		type = "fuel-category",
		name = "diesel-fuel",
	},
})

-- adding diesel-fuel into maraxsis-diesel-submarine
if data.raw["spider-vehicle"]["maraxsis-diesel-submarine"] then
	local sub = data.raw["spider-vehicle"]["maraxsis-diesel-submarine"]

	sub.energy_source = sub.energy_source or {}
	sub.energy_source.fuel_categories = sub.energy_source.fuel_categories or {}
	sub.movement_energy_consumption = "6.5MW"
	table.insert(sub.energy_source.fuel_categories, "diesel-fuel")
end
