data:extend({
	{
		type = "bool-setting",
		name = "fluid-value-based-flamethrower",
		setting_type = "startup",
		default_value = true,
		order = "diesel_engine-a",
	},
})
data:extend({
	{
		type = "bool-setting",
		name = "override-oxygen-with-diesel-engine-icon",
		setting_type = "startup",
		default_value = true,
		order = "diesel_engine-b",
	},
})

data:extend({
	{
		type = "bool-setting",
		name = "enable-diesel-engine-item",
		setting_type = "startup",
		default_value = false,
		order = "diesel_engine-c",
	},
})

-- ignore cargo ships powerpole settings to save some collision layers
local function force_setting(setting_type, setting_name, value)
	local setting = data.raw[setting_type .. "-setting"][setting_name]
	if setting then
		if setting_type == "bool" then
			setting.forced_value = value
		else
			setting.allowed_values = { value }
		end
		setting.default_value = value
		setting.hidden = true
	end
end
force_setting("bool", "enable-diesel-engine-item", false)
