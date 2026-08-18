local item_tints = require("__base__.prototypes.item-tints")
local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
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
