math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable_module = require "flammable"
flammable = flammable_module.flammable

module(..., package.seeall)

--initialize gasoline container
--gas_nodes = {}
--gas_nodes.size = 0
--gas_nodes.capacity = 250
--gas_nodes.done = false

--initialize barrel container
barrels = {}

--explosive barrels
barrel = {}
setmetatable(barrel, {__index = flammable})

function barrel:new(x, y)

    barrelImage = display.newImage("Barrel.png", x, y)
    mainDisplay:insert(barrelImage)
    local instance = flammable:new(barrelImage, true)

    instance.body.isFixedRotation = true
    instance.body.density = 1.0
    instance.body.friction = 5
    instance.body.bounce = 0
    
    --barrels catch fire more easily than normal and burn up quickly
    instance.flash_point = instance.flash_point - 5
    --instance.health = 30
    
    setmetatable(instance, {__index = barrel})
    instance.body:addEventListener("touch", instance)
    
    return instance
end

--sets off the barrel when it's touched
function barrel:touch(event)
    if event.phase == "began" then
        self:apply_heat(self.flash_point)
    end
end

--makes the barrel explode shortly after catching fire
function barrel:on_enter_frame(elapsed_time)
	--update heat
	flammable.on_enter_frame(self, elapsed_time)
end

--makes the barrel explode
function barrel:burn_up()
	table.remove(barrels, utils.index_of(barrels, self))
	
	flammable.burn_up(self)
	
	spawn_explosion(self.body.x, self.body.y, 300, self.current_heat)
end

function spawn_barrel(x, y)
    table.insert(barrels, barrel:new(x, y))
end

function spawn_explosion(x, y, radius, heat)
    for i, barrel in ipairs(barrels) do
        local xDist = barrel.body.x - x
        local yDist = barrel.body.y - y
    	local dist_squared = xDist^2 + yDist^2
        if x ~= barrel.body.x and y ~= barrel.body.y
        		and dist_squared < radius^2 then
            barrel:apply_heat(heat)
            
            local dist = math.sqrt(dist_squared)
            local force = (radius - dist) * 30
            barrel.body:applyLinearImpulse(
            				force * xDist / dist,
            				force * yDist / dist,
            				barrel.body.x, barrel.body.y)
        end
    end
end

--THE GAS STATION
-- gas_node = {}
-- function gas_node:new(x, y)--constructor
    -- local node = {x = x, y=y, radius = 15}
    -- node.image = display.newCircle(x, y, 15)
    -- node.image:setFillColor(255, 250, 205)
    -- node.image:scale(1-(gas_nodes.size/gas_nodes.capacity), 1-(gas_nodes.size/gas_nodes.capacity))
    -- setmetatable(node, {__index = gas_node})
    -- return node
-- end

-- function add_gas(event)
    -- if event.phase == "ended" then
        -- gas_nodes.done = true
    -- end
    
    -- if event.phase == "began" and gas_nodes.done == false then
        -- print ("beginning touch")
        -- gas_nodes[gas_nodes.size+1] = gas_node:new(event.x, event.y)
        -- gas_nodes.size = gas_nodes.size+1
        -- return
    -- else
        -- if event.phase == "moved" and gas_nodes.done == false then
            -- local distance = dist(gas_nodes[gas_nodes.size].x, gas_nodes[gas_nodes.size].y,
                -- event.x, event.y)
      
            -- local angle = math.atan2((gas_nodes[gas_nodes.size].y-event.y),(gas_nodes[gas_nodes.size].x-event.x))
            -- local displacement = gas_nodes[gas_nodes.size].radius
            -- for i=0, distance, gas_nodes[gas_nodes.size].radius*2 do
                -- gas_nodes[gas_nodes.size+1] = gas_node:new(event.x+math.cos(angle)*displacement, 
                    -- event.y+math.sin(angle)*displacement)
                -- displacement = displacement + gas_nodes[gas_nodes.size+1].radius
                -- gas_nodes.size = gas_nodes.size+1
                -- if(gas_nodes.size > gas_nodes.capacity) then
                    -- return
                -- end
            -- end
        -- end
    -- end
-- end

-- function erase_gas(event)
    -- if(event.isShake == true) then
        -- gas_nodes.done = false
        -- while gas_nodes.size > 0 do
            -- display.remove(gas_nodes[gas_nodes.size].image)
            -- displayMain:remove(gas_nodes[gas_nodes.size].image)
            -- table.remove(gas_nodes, gas_nodes.size)
            -- gas_nodes.size = gas_nodes.size -1
        -- end
    -- end
-- end
