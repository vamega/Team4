math = require "math"
utils = require "utils"
flammable_module = require "flammable"
flammable = flammable_module.flammable

module(..., package.seeall)

--all gas nodes
gas_nodes = {}
gas_nodes.size = 0
gas_nodes.capacity = 250
gas_nodes.done = false
gas_nodes.lock = false

--THE GAS STATION

--gasoline is made up of a number of small circular nodes
gas_node = {}
setmetatable(gas_node, {__index = flammable})
gas_metatable = {__index = gas_node}

function gas_node:new(x, y)
	local radius = 15-10*(gas_nodes.size/gas_nodes.capacity)
	
	circle = display.newCircle(x, y, radius)
    local instance = flammable:new(circle, {radius = radius, density = 4000})
    
    instance.body.isSensor = true
    instance.body:setFillColor(155, 150, 145)
    mainDisplay:insert(circle)
    instance.body.density = 100
    
    --gas starts burning early and gets hot quickly
    instance.flash_point = 4
    instance.heat_increase_rate = 30 - radius / 3
    instance.health = 120
    
    setmetatable(instance, gas_metatable)
    return instance
end

function gas_node:on_enter_frame(elapsed_time)
    if gas_nodes.lock == false then
        --update heat
        flammable.on_enter_frame(self, elapsed_time)
        --update animation
        self:animate()
    end
end

function gas_node:animate()
    if self.current_heat >= self.flash_point then
        self.body:setFillColor(255,0,0)
    end
end

function gas_node:burn_up()
    --mainDisplay:remove(self.body)
	flammable.burn_up(self)
	
	table.remove(gas_nodes, utils.index_of(gas_nodes, self))
	gas_nodes.size = gas_nodes.size - 1
end

local prev_touch_x = 0
local prev_touch_y = 0

function add_gas(event)
    if event.phase == "ended" then
        gas_nodes.done = true
        return
    end
    
	if event.phase == "began" and gas_nodes.done == false then
        prev_touch_x = event.x
        prev_touch_y = event.y
        --return
    elseif event.phase == "moved" and gas_nodes.done == false then
        local distance = math.sqrt(utils.dist_squared(
        		prev_touch_x, prev_touch_y, event.x, event.y))
  
        local angle = math.atan2(event.y - prev_touch_y,
        						event.x - prev_touch_x)
        local displacement = 0
        
        while displacement < distance do
            table.insert(gas_nodes,
            	gas_node:new(prev_touch_x+math.cos(angle)*displacement, 
                			prev_touch_y+math.sin(angle)*displacement))
            displacement = displacement + gas_nodes[gas_nodes.size+1].body.width / 2
            gas_nodes.size = gas_nodes.size+1
            if gas_nodes.size > gas_nodes.capacity then
                gas_nodes.done = true
                return
            end
        end
        
        prev_touch_x = event.x
        prev_touch_y = event.y
    end
    
    if gas_nodes.size < gas_nodes.capacity and gas_nodes.done == false then
        table.insert(gas_nodes, gas_node:new(event.x, event.y))
        gas_nodes.size = gas_nodes.size + 1
    end
end

function reset_gas()
     gas_nodes.done = false
    while gas_nodes.size > 0 do
        if gas_nodes[gas_nodes.size] ~= nil then
            gas_nodes[gas_nodes.size]:burn_up()
        else
            gas_nodes.size = gas_nodes.size - 1
        end
    end
end
