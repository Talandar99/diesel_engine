## Diesel Engine
This is library for managing fluid with fuel value for my mods
Here is exactly what happens under the hood, broken down into its core
features:

### 1. Central Fluid Database
- Everything relies on a single configuration file (`fluid-properties.lua`). 
- This is where fuel values (e.g., `1.2MJ`) and emission multipliers for various fluids (both vanilla and from mods like Pelagos,
Krastorio 2, or Foliax) are placed.

### 2. Global Stat Updates
- The script takes table and automatically overwrites the fluid properties
in the game. 
- It also ensures that every listed fluid can be packaged into
barrels (`auto_barrel = true`).

### 3. Smart Flamethrowers
- Script automatically checks which fluids have a fuel value and adds them as
valid ammo. 
- It **scales the damage modifier** of the flamethrower
proportionally to the energy value of the fluid used.

### 4. Barrel Fuel Generation
- Script converts standard (and titanium) barrels into burnable fuel items
(`barrel-fuel.lua`) based on the underlying fluid's fuel value. 
- This allows machines and vehicles that do not support
direct fluid fuel inputs to be powered by barreled fluids instead. 
- The system also calculates acceleration and top-speed bonuses dynamically, based on the
fluid's power and standard rocket fuel stats.

### 5. Space Age Automation (Space Diesel)
* Generates chemical recipes to process any fuel from your list into
`space-diesel-fuel`, maintaining the correct energy conversion ratios.
* Overrides specific icons (like oxygen) to better fit the mod's aesthetic. (this can be changed in settings)
* Automatically generates "space" variants of diesel-powered machines (with
proper fluid filters applied) as long as the mod creator adds the
`make_space_diesel_variant = true` flag to their entity. 

## Space Diesel Variants 
This library includes an automated script that creates "space" variants of machines
(powered by space diesel) for the Space Age expansion. The script automatically
scans the entire game database (`data.raw`) and generates new versions of the
entities.

To make the script pick up your machine (or a machine from another mod), you
just need to add a single, simple flag to its definition:
`make_space_diesel_variant = true`.

### How to use it in your mod?

Simply inject this parameter into your chosen entity during the `data.lua` or `data-updates.lua` phase.

**Example for a custom machine:**
```lua
data:extend({
    {
        type = "assembling-machine",
        name = "my-custom-awesome-diesel-assembling-machine",
        -- ... rest of the standard machine parameters
        make_space_diesel_variant = true, -- <<< ADD THIS LINE <<<
        energy_source = {
            type = "fluid",
            fluid_box = {
                -- fluid box definition
            }
        }
    }
})

```
**Example for an existing machine:**
```lua
if data.raw["assembling-machine"]["calciner"] then
    data.raw["assembling-machine"]["calciner"].make_space_diesel_variant = true
end
```
