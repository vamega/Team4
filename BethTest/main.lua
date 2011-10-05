sprite = require "sprite"
physics = require "physics"

local explosives = require("explosives")

physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

--BETH'S TESTING AREA

barrels = explosives.barrels
gas_nodes = explosives.gas_nodes

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)

--load test level
explosives.load_barrel(110, 110)
explosives.load_barrel(250, 280)

--add invisible boundaries so that the penguin doesn't fall offscreen
local edge1 = display.newRect(0, 0, display.contentWidth, 10)
physics.addBody(edge1, "static", {bounce = 0.4})
edge1.isVisible = false
--left edge
local edge2 = display.newRect(0, 0, 10, display.contentHeight)
physics.addBody(edge2, "static", {bounce = 0.4})
edge2.isVisible = false
--right edge
local edge3 = display.newRect(display.contentWidth-10, 0, 10, display.contentHeight)
physics.addBody(edge3, "static", {bounce = 0.4})
edge3.isVisible = false
--bottom edge
local edge4 = display.newRect(0, display.contentHeight-10, display.contentWidth, 10)
physics.addBody(edge4, "static", {bounce = 0.4})
edge4.isVisible = false

--event listeners
Runtime:addEventListener("touch", explosives.add_gas)
for i=1, barrels.size do
    barrels[i].image:addEventListener("touch", barrels[i])
end
Runtime:addEventListener("accelerometer", explosives.erase_gas)