local function is_ingredient_in_recipe(recipe, target_item)
	local function check_list(ingredients)
		if not ingredients then
			return false
		end
		for _, ingredient in pairs(ingredients) do
			local ing_name = ingredient.name or ingredient[1]
			if ing_name == target_item then
				return true
			end
		end
		return false
	end

	return check_list(recipe.ingredients)
		or (recipe.normal and check_list(recipe.normal.ingredients))
		or (recipe.expensive and check_list(recipe.expensive.ingredients))
end

local is_used = {
	["diesel-engine-unit"] = false,
	["steel-gear-wheel"] = false,
}

for recipe_name, recipe in pairs(data.raw.recipe) do
	local is_recycling = (recipe.category == "recycling") or string.find(recipe_name, "recycling")

	if not is_recycling and recipe_name ~= "diesel-engine-unit" then
		if is_ingredient_in_recipe(recipe, "diesel-engine-unit") then
			is_used["diesel-engine-unit"] = true
			break
		end
	end
end

for recipe_name, recipe in pairs(data.raw.recipe) do
	local is_recycling = (recipe.category == "recycling") or string.find(recipe_name, "recycling")

	local ignore_recipe = false
	if recipe_name == "diesel-engine-unit" and not is_used["diesel-engine-unit"] then
		ignore_recipe = true
	end

	if not is_recycling and not ignore_recipe and recipe_name ~= "steel-gear-wheel" then
		if is_ingredient_in_recipe(recipe, "steel-gear-wheel") then
			is_used["steel-gear-wheel"] = true
			break
		end
	end
end

local items_to_hide = { "steel-gear-wheel", "diesel-engine-unit" }
local tech = data.raw.technology["diesel-engine"]

for _, item_name in pairs(items_to_hide) do
	if not is_used[item_name] then
		if data.raw.item[item_name] then
			data.raw.item[item_name].hidden = true
		end

		if data.raw.recipe[item_name] then
			data.raw.recipe[item_name].hidden = true
		end

		if tech and tech.effects then
			for i = #tech.effects, 1, -1 do
				local effect = tech.effects[i]
				if effect.type == "unlock-recipe" and effect.recipe == item_name then
					table.remove(tech.effects, i)
				end
			end
		end
	end
end

if tech then
	if not is_used["diesel-engine-unit"] then
		tech.hidden = true
	elseif tech.effects and #tech.effects == 0 then
		tech.hidden = true
	end
end
