require("fuel-value")
require("barrel-fuel")

if mods["planet-muluna"] then
	for _, category in pairs(data.raw) do
		for name, proto in pairs(category) do
			if name ~= "lighthouse" then
				local es = proto.energy_source
				if es and es.type == "fluid" and es.burns_fluid == true then
					if proto.surface_conditions ~= nil then
						log("[Diesel Engine] Removing surface_conditions from: " .. name)
						proto.surface_conditions = nil
					end
				end
			end
		end
	end
end
