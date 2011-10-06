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

--THE GAS STATION

--gasoline is made up of a number of small 
gas_node = {}
setmetatable(gas_node, {__index = flammable})

function gas_node:new(x, y)
	--gas nodes don't collide with anything
	--local collision_filter = {categoryBits = 0x1, maskBits = 0}
	
    local instance = flammable:new(display.newCircle(x, y,
    				15-10*(gas_nodes.size/gas_nodes.capacity)), true, nil)
    
    instance.body.isSensor = true
    instance.body:setFillColor(155, 150, 145)
    instance.body.density = 300
    
    --gas starts burning early but lasts a while
    instance.flash_point = 4
    instance.health = 200
    
    setmetatable(instance, {__index = gas_node})
    return instance
end

function gas_node:burn_up()
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
    
    if gas_nodes.size == 0 then
    	gas_nodes.done = false
    end
    
	if event.phase == "began" and gas_nodes.done == false then
        prev_touch_x = event.x
        prev_touch_y = event.y
        return
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

function erase_gas(event)
    if(event.isShake == true) then
        gas_nodes.done = false
        while gas_nodes.size > 0 do
        	if gas_nodes[gas_nodes.size] ~= nil then
	            gas_nodes[gas_nodes.size].body:removeSelf()
	            table.remove(gas_nodes, gas_nodes.size)
	        end
	        gas_nodes.size = gas_nodes.size - 1
        end
    end
end
