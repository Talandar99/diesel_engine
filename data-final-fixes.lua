if mods["space-age"] then
	require("prototypes.space-variants")
end

local fluid_properties = require("prototypes.fluid-properties")
require("prototypes.update-fluids")(fluid_properties)
require("prototypes.update-flamethrowers")(fluid_properties)
require("prototypes.space-diesel-logic")(fluid_properties)
require("prototypes.barrel-fuel")(fluid_properties)
require("prototypes.compat")
