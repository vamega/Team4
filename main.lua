sprite = require "sprite"
physics = require "physics"

--local intro = require("levels/intro")
local explosives = require("explosives")


physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

--initialization
barrels = explosives.barrels
gas_nodes = explosives.gas_nodes

--local intro_img = intro.background
--Set up DisplayGroup for everything
mainDisplay = display.newGroup()

--background
background = display.newImage("background.png")
mainDisplay:insert(background)



print("width" .. display.contentWidth .. " height: " .. display.contentHeight)

--load test level
explosives.load_barrel(110, 110)
explosives.load_barrel(250, 280)
explosives.load_barrel(300, 600)
explosives.load_barrel(400, 500)

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

mainDisplay:insert(edge1)
mainDisplay:insert(edge2)
mainDisplay:insert(edge3)
mainDisplay:insert(edge4)

--event listeners
Runtime:addEventListener("touch", explosives.add_gas)
for i=1, barrels.size do
    barrels[i].image:addEventListener("touch", barrels[i])
end
Runtime:addEventListener("accelerometer", explosives.erase_gas)