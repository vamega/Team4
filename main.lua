sprite = require "sprite"
physics = require "physics"
math = require "math"
utils = require "utils"
crate = require "crate"
--explosives = require "explosives"
gas = require "gas"
levels = require "levels"
water = require "water"
buttons = require "buttons"
--require "collisionmanager"


gas_covered = gas.distance_covered
gas_allowed = gas.distance_allowed

local explosives = require("explosives")

system.activate( "multitouch" )

mainDisplay.init_scale_values()

display.getCurrentStage():insert(mainDisplay.mainDisplay)

physics.start()
--physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

--initialization
barrels = explosives.barrels
waters = water.waters

--calls on_enter_frame for all items in the given table
local function update_all(table_to_update, elapsed_time)
for i, object in ipairs(table_to_update) do
object:on_enter_frame(elapsed_time)
end
end

level = 0
spawned = true
title = nil

--game loop
local last_frame_time = 0
local function on_enter_frame(event)
local elapsed_time = (event.time - last_frame_time) / 1000
elapsed_time = math.min(0.2, elapsed_time)

last_frame_time = event.time

update_all(flammable_module.flammable_list, elapsed_time)
water.on_enter_frame(elapsed_time)
    levels.scroll_update()
    if buttons.title_lock == true and buttons.title_lock_b == true then
        title = buttons.title_screen:new()
    elseif buttons.title_lock==true then
        title:animate()
    else
        if spawned == false and levels.reset_lock == false and level < levels.number_of_levels then
            print ("spawning level"..level)
            levels.spawn_level(level)
            spawned = true
        end
        
        if crate.crates.size==0 and table.getn(explosives.barrels)==0
                and level< levels.number_of_levels then
            print ("killing level")
            levels.kill_level()
            level = level+1
            spawned = false
        end
    end
end

--add invisible boundaries so that objects don't go offscreen
top_edge = display.newRect(0, 0, levels.background.width, 10)
physics.addBody(top_edge, "static", {bounce = 0.4})
top_edge.isVisible = false
left_edge = display.newRect(0, 0, 10, levels.background.height)
physics.addBody(left_edge, "static", {bounce = 0.4})
left_edge.isVisible = false
right_edge = display.newRect(levels.background.width-10, 0, 10, levels.background.height)
physics.addBody(right_edge, "static", {bounce = 0.4})
right_edge.isVisible = false
bottom_edge = display.newRect(0, levels.background.height-10, levels.background.width, 10)
physics.addBody(bottom_edge, "static", {bounce = 0.4})
bottom_edge.isVisible = false

mainDisplay.mainDisplay:insert(top_edge)
mainDisplay.mainDisplay:insert(left_edge)
mainDisplay.mainDisplay:insert(right_edge)
mainDisplay.mainDisplay:insert(bottom_edge)

--event listeners
--Runtime:addEventListener("touch", gas.add_gas)
Runtime:addEventListener("accelerometer", levels.reset_level)
Runtime:addEventListener("enterFrame", on_enter_frame)
Runtime:addEventListener("touch", levels.scrollTouch)
mainDisplay.mainDisplay:addEventListener( "touch", mainDisplay.mainDisplay)

