data:extend({

	{
		type = "technology",
		name = "diesel-engine",
		icon = "__diesel_engine__/graphics/diesel-engine-unit-tech.png",
		icon_size = 256,
		effects = {
			{ type = "unlock-recipe", recipe = "steel-gear-wheel" },
			{ type = "unlock-recipe", recipe = "diesel-engine-unit" },
		},
		prerequisites = {
			"engine",
			"steel-processing",
			"fluid-handling",
			"lubricant",
		},
		unit = {
			count_formula = "50",
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "chemical-science-pack", 1 },
			},
			time = 30,
		},
	},
})
