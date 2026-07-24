data:extend({
	{
		type = "recipe",
		name = "steel-gear-wheel",
		categories = { "advanced-crafting" },
		ingredients = { { type = "item", name = "steel-plate", amount = 2 } },
		results = { { type = "item", name = "steel-gear-wheel", amount = 1 } },
		allow_productivity = true,
	},
	{
		type = "recipe",
		name = "diesel-engine-unit",
		categories = { "advanced-crafting" },
		energy_required = 15,
		ingredients = {
			{ type = "item", name = "engine-unit", amount = 1 },
			{ type = "item", name = "steel-plate", amount = 1 },
			{ type = "item", name = "iron-gear-wheel", amount = 2 },
			{ type = "item", name = "steel-gear-wheel", amount = 2 },
			{ type = "item", name = "pipe", amount = 3 },
			{ type = "fluid", name = "lubricant", amount = 20 },
		},
		results = { { type = "item", name = "diesel-engine-unit", amount = 1 } },
		allow_productivity = true,
	},
})
