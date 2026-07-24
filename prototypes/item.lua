local item_tints = require("__base__.prototypes.item-tints")
local item_sounds = require("__base__.prototypes.item_sounds")
data:extend({

	{
		type = "item",
		name = "steel-gear-wheel",
		icon = "__diesel_engine__/graphics/steel-gear-wheel.png",
		subgroup = "intermediate-product",
		order = "a[basic-intermediates]-ab[steel-gear-wheel]",
		inventory_move_sound = item_sounds.metal_small_inventory_move,
		pick_sound = item_sounds.metal_small_inventory_pickup,
		drop_sound = item_sounds.metal_small_inventory_move,
		stack_size = 100,
		random_tint_color = item_tints.iron_rust,
		weight = 2 * kg,
	},
	{
		type = "item",
		name = "diesel-engine-unit",
		icon = "__diesel_engine__/graphics/diesel-engine-unit-icon.png",
		subgroup = "intermediate-product",
		order = "c[advanced-intermediates]-ab[diesel-engine-unit]",
		inventory_move_sound = item_sounds.metal_large_inventory_move,
		pick_sound = item_sounds.metal_large_inventory_pickup,
		drop_sound = item_sounds.metal_large_inventory_move,
		stack_size = 50,
		weight = 5 * kg,
	},
})
