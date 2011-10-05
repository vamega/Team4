sprite = require "sprite"
physics = require "physics"
math = require "math"

crate = require "crate"
explosives = require "explosives"

physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

barrels = explosives.barrels
gas_nodes = explosives.gas_nodes

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)

--load test level
explosives.load_barrel(110, 110)
explosives.load_barrel(250, 280)
explosives.load_barrel(300, 600)
explosives.load_barrel(400, 360)

crate.add_crate(300, 380)
crate.add_crate(249, 400)
crate.add_crate(198, 389)
crate.add_crate(240, 451)
crate.add_crate(70, 580)
crate.crates[2].current_heat = crate.crates[2].flash_point + 1
crate.crates[5].body:applyForce(20, -20, crate.crates[1].body.x,
										crate.crates[1].body.y - 2)

--add invisible boundaries so that objects don't go offscreen
local top_edge = display.newRect(0, 0, display.contentWidth, 10)
physics.addBody(top_edge, "static", {bounce = 0.4})
top_edge.isVisible = false
local left_edge = display.newRect(0, 0, 10, display.contentHeight)
physics.addBody(left_edge, "static", {bounce = 0.4})
left_edge.isVisible = false
local right_edge = display.newRect(display.contentWidth-10, 0, 10, display.contentHeight)
physics.addBody(right_edge, "static", {bounce = 0.4})
right_edge.isVisible = false
local bottom_edge = display.newRect(0, display.contentHeight-10, display.contentWidth, 10)
physics.addBody(bottom_edge, "static", {bounce = 0.4})
bottom_edge.isVisible = false

--event listeners
Runtime:addEventListener("touch", explosives.add_gas)
for i=1, barrels.size do
    barrels[i].image:addEventListener("touch", barrels[i])
end

Runtime:addEventListener("accelerometer", explosives.erase_gas)

--game loop
local last_frame_time = 0
local function on_enter_frame(event)
	local elapsed_time = (event.time - last_frame_time) / 1000
	elapsed_time = math.min(0.2, elapsed_time)
	
	last_frame_time = event.time
	
	crate.on_enter_frame(elapsed_time)
end

Runtime:addEventListener("enterFrame", on_enter_frame)
