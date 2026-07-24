require("prototypes.item")
require("prototypes.recipe")
require("prototypes.technology")
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
end

-- adding diesel-fuel into maraxsis-diesel-submarine
if data.raw["spider-vehicle"]["maraxsis-diesel-submarine"] then
	local sub = data.raw["spider-vehicle"]["maraxsis-diesel-submarine"]

	sub.energy_source = sub.energy_source or {}
	sub.energy_source.fuel_categories = sub.energy_source.fuel_categories or {}
	sub.movement_energy_consumption = "6.5MW"
	table.insert(sub.energy_source.fuel_categories, "diesel-fuel")
end

if mods["space-age"] then
	data:extend({
		{
			type = "fluid",
			subgroup = "fluid",
			name = "space-diesel-fuel",
			default_temperature = 25,
			base_color = { r = 0.78, g = 0.16, b = 0.12 },
			flow_color = { r = 0.92, g = 0.42, b = 0.15 },
			icon = "__diesel_engine__/graphics/space-diesel-fuel.png",
			icon_size = 64,
			order = "a[fluid]-c[ethanol]",
			pressure_to_speed_ratio = 0.4,
			flow_to_energy_ratio = 0.59,
			auto_barrel = true,
		},
	})

	if not data.raw.fluid["oxygen"] then
		data:extend({
			{
				type = "fluid",
				name = "oxygen",
				subgroup = "space-diesel-fuel",
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
	else
		data.raw.fluid["oxygen"].auto_barrel = true
	end

	data:extend({
		{
			type = "recipe",
			name = "inefficient-electrolysis",
			categories = { "chemistry" },
			enabled = false,
			energy_required = 10,
			ingredients = { { type = "fluid", name = "water", amount = 100 } },
			results = { { type = "fluid", name = "oxygen", amount = 20 } },
			icons = {
				{ icon = data.raw.fluid["water"].icon, icon_size = 64 },
				{ icon = data.raw.fluid["oxygen"].icon, icon_size = 64, scale = 0.45, shift = { 8, -8 } },
			},
			subgroup = "fluid-recipes",
			order = "d[other-chemistry]-c[inefficient-electrolysis]",
		},
	})

	data:extend({
		{
			type = "technology",
			name = "space-diesel",
			icon_size = 128,
			icon = "__diesel_engine__/graphics/space-diesel-fuel-tech.png",
			effects = {
				{ type = "unlock-recipe", recipe = "inefficient-electrolysis" },
			},
			prerequisites = {
				"chemical-science-pack",
				"rocket-silo",
				"automation-science-pack",
				"advanced-oil-processing",
			},
			unit = {
				count = 500,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "chemical-science-pack", 1 },
				},
				time = 60,
			},
			order = "c-a",
		},
	})
end
