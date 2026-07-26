return function(fluid_fuels)
	local machines = {}
	for _, type_entities in pairs(data.raw) do
		for entity_name, entity in pairs(type_entities) do
			if entity.diesel_fuel_fluid_filter == true or entity.diesel_fuel_tips_and_tricks == true then
				table.insert(machines, entity_name)
			end
		end
	end

	local description = { "" }
	table.insert(description, { "tips-and-tricks-description.liquid-fuel-machines-intro" })
	local current_node = description
	local param_count = 2

	for _, machine_name in ipairs(machines) do
		if param_count + 1 > 20 then
			local next_node = { "" }
			table.insert(current_node, next_node)
			current_node = next_node
			param_count = 1
		end

		table.insert(current_node, "\n[entity=" .. machine_name .. "]")
		param_count = param_count + 1
	end

	if param_count + 1 > 20 then
		local next_node = { "" }
		table.insert(current_node, next_node)
		current_node = next_node
		param_count = 1
	end
	table.insert(current_node, { "tips-and-tricks-description.liquid-fuel-list-intro" })
	param_count = param_count + 1

	for fluid_name, stats in pairs(fluid_fuels) do
		if data.raw.fluid[fluid_name] then
			if param_count + 1 > 20 then
				local next_node = { "" }
				table.insert(current_node, next_node)
				current_node = next_node
				param_count = 1
			end

			table.insert(current_node, "\n[fluid=" .. fluid_name .. "]")
			param_count = param_count + 1
		end
	end

	if mods["space-age"] then
		if param_count + 1 > 20 then
			local next_node = { "" }
			table.insert(current_node, next_node)
			current_node = next_node
			param_count = 1
		end
		table.insert(current_node, { "tips-and-tricks-description.liquid-fuel-space-age" })
		param_count = param_count + 1
	end

	local title_icon = ""
	if data.raw.fluid["space-diesel-fuel"] then
		title_icon = "[img=fluid/space-diesel-fuel] "
	else
		title_icon = "[img=fluid/light-oil] "
	end

	local tip = {
		type = "tips-and-tricks-item",
		name = "liquid-fuel",
		order = "z-[liquid-fuel]",
		indent = 1,
		localised_name = { "", title_icon, { "tips-and-tricks-name.liquid-fuel" } },

		localised_description = description,
		starting_status = "locked",
	}

	tip.starting_status = "unlocked"

	data:extend({ tip })
end
