data:extend({
	{
		type = "fuel-category",
		name = "diesel-fuel",
	},
})

if mods["space-age"] then
	data:extend({
		{
			type = "item-subgroup",
			name = "space-diesel-fuel",
			group = "intermediate-products",
			order = "ab",
		},
	})
	data:extend({
		{
			type = "fluid",
			subgroup = "fluid",
			name = "space-diesel-fuel",
			default_temperature = 25,
			base_color = { r = 0.5, g = 0.75, b = 0.85 }, --update this
			flow_color = { r = 0.6, g = 0.76, b = 0.86 }, --update this
			icon = "__diesel_engine__/graphics/space-diesel-fuel.png",
			icon_size = 64,
			order = "a[fluid]-c[ethanol]",
			pressure_to_speed_ratio = 0.4,
			flow_to_energy_ratio = 0.59,
			auto_barrel = true,
		},
	})
end

-- adding diesel-fuel into maraxsis-diesel-submarine
if data.raw["spider-vehicle"]["maraxsis-diesel-submarine"] then
	local sub = data.raw["spider-vehicle"]["maraxsis-diesel-submarine"]

	sub.energy_source = sub.energy_source or {}
	sub.energy_source.fuel_categories = sub.energy_source.fuel_categories or {}
	sub.movement_energy_consumption = "6.5MW"
	table.insert(sub.energy_source.fuel_categories, "diesel-fuel")
end
