sprite = require "sprite"
physics = require "physics"

physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

--BETH'S TESTING AREA

--initialize gasoline container
local gas_nodes = {}
gas_nodes.size = 0
gas_nodes.capacity = 250
--initialize barrel container
barrels = {}
barrels.size = 0

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)

--THE BARREL ZONE
barrel = {}
function barrel:new(x, y, i)--constructor
    local instance = {x=x, y=y, i=i, radius = 50, dead = false}
    instance.image = display.newCircle(x, y, 50)
    instance.image:setFillColor(255, 0, 0)
    physics.addBody( instance.image, {density = 1.0, friction = 0.3, bounce = 0, radius = 50 } )
    setmetatable(instance, {__index = barrel})
    return instance
end

local function kill_barrel(index)
    explode(barrels[index].x, barrels[index].y, 300)
    display.remove(barrels[index].image)
    table.remove(barrels, index)
end

function barrel:touch(event) --detonate barrel
    if event.phase == "began" and self.dead == false then
        self.dead = true
        self.image:setFillColor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        local myclosure = function() return kill_barrel(self.i) end
        timer.performWithDelay(2000, myclosure)
    end
end

local function load_barrel(x, y)
    barrels[barrels.size + 1] = barrel:new(x, y, barrels.size + 1)
    barrels.size = barrels.size + 1
end

local function dist(x1, y1, x2, y2)
    return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

function explode(x, y, radius)
    for i =1, barrels.size do
        if (x ~= barrels[i].x and y ~= barrels[i].y and dist(x, y, barrels[i].x, barrels[i].y) < radius) then
            print ("Trying to displace barrel " .. i)
            print ("Point 1 is " .. x .. ", " .. y)
            print ("Point 2 is " .. barrels[i].x .. ", " .. barrels[i].y)
            angle = math.atan2(y-barrels[i].y, x-barrels[i].x)
            print ("Angle is " .. angle)
            barrels[i].image:applyLinearImpulse(-math.cos(angle)*50, -math.sin(angle)*50, barrels[i].x, barrels[i].y)
        end
    end
end

--THE GAS STATION
gas_node = {}
function gas_node:new(x, y)--constructor
    local node = {x = x, y=y, radius = 15}
    node.image = display.newCircle(x, y, 15)
    node.image:setFillColor(255, 250, 205)
    setmetatable(node, {__index = gas_node})
    return node
end

local function add_gas(event)
    if gas_nodes.size < gas_nodes.capacity then
        gas_nodes[gas_nodes.size+1] = gas_node:new(event.x, event.y)
        gas_nodes.size = gas_nodes.size + 1
    end
end

local function erase_gas(event)
    while gas_nodes.size > 0 do
        display.remove(gas_nodes[gas_nodes.size].image)
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