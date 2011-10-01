sprite = require "sprite"
physics = require "physics"

--initialize gasoline container
local gas_nodes = {}
gas_nodes.size = 0
--initialize barrel container
barrels = {}
barrels.size = 0

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)

--THE BARREL ZONE
barrel = {}
function barrel:new(x, y)--constructor
    local instance = {x=x, y=y, radius = 50}
    instance.image = display.newCircle(x, y, 50)
    instance.image:setFillColor(255, 0, 0)
    setmetatable(instance, {__index = barrel})
    return instance
end

function barrel:touch(event) --detonate barrel
    self.image:setFillColor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

local function load_barrel(x, y)
    barrels[barrels.size+1] = barrel:new(x, y)
    barrels.size = barrels.size + 1
end

--THE GAS STATION
local function add_gas(event)
    local gas_node = display.newCircle(event.x, event.y, 15)
    gas_node:setFillColor(255, 250, 205)
    gas_nodes[gas_nodes.size + 1] = gas_node
    gas_nodes.size = gas_nodes.size + 1
end

local function erase_gas(event)
    while gas_nodes.size > 0 do
        display.remove(gas_nodes[gas_nodes.size])
        table.remove(gas_nodes, gas_nodes.size)
        gas_nodes.size = gas_nodes.size -1
    end
end

--load test level
load_barrel(110, 110)
load_barrel(250, 280)

--event listeners
Runtime:addEventListener("touch", add_gas)
for i=1, barrels.size do
    barrels[i].image:addEventListener("touch", barrels[i])
end
Runtime:addEventListener("accelerometer", erase_gas)