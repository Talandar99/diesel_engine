local item_sounds = require("__base__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")

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
})

if mods["Krastorio2"] then
	data.raw["item"]["steel-gear-wheel"].localised_name = { "item-name.heavy-steel-gear-wheel" }
end

local tech = data.raw["technology"]["steel-processing"]
if tech then
	tech.effects = tech.effects or {}
	local exists = false
	for _, effect in ipairs(tech.effects) do
		if effect.type == "unlock-recipe" and effect.recipe == "steel-gear-wheel" then
			exists = true
			break
		end
	end
	if not exists then
		data:extend({
			{
				type = "recipe",
				name = "steel-gear-wheel",
				categories = { "advanced-crafting" },
				ingredients = { { type = "item", name = "steel-plate", amount = 2 } },
				results = { { type = "item", name = "steel-gear-wheel", amount = 1 } },
				enabled = false,
				allow_productivity = true,
			},
		})
		table.insert(tech.effects, {
			type = "unlock-recipe",
			recipe = "steel-gear-wheel",
		})
	end
end
