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

--gasoline is made up of a number of small 
gas_node = {}
setmetatable(gas_node, {__index = flammable})

function gas_node:new(x, y)
	--gas nodes don't collide with anything
	local collision_filter = {categoryBits = 0x1, maskBits = 0}
	
    local instance = flammable:new(display.newCircle(x, y,
    				15-10*(gas_nodes.size/gas_nodes.capacity)), true, nil,
    				collision_filter)
    
    
    instance.body:setFillColor(155, 150, 145)
    
    --gas starts burning early but lasts a while
    instance.flash_point = 5
    instance.health = 100
    
    setmetatable(instance, {__index = gas_node})
    return instance
end

function gas_node:burn_up()
	flammable.burn_up(self)
	
	table.remove(gas_nodes, utils.index_of(gas_nodes, self))
	
	--do not decrement gas_nodes.size, because otherwise the player could
	--draw an infinitely long line of gas
end

function add_gas(event)
    if event.phase == "ended" then
        gas_nodes.done = true
    end
    
	if event.phase == "began" and gas_nodes.done == false then
        table.insert(gas_nodes, gas_node:new(event.x, event.y))
        gas_nodes.size = gas_nodes.size+1
        return
    elseif event.phase == "moved" and gas_nodes.done == false then
        local distance = math.sqrt(utils.dist_squared(
        		gas_nodes[gas_nodes.size].body.x,
        		gas_nodes[gas_nodes.size].body.y,
            	event.x, event.y))
  
        local angle = math.atan2((gas_nodes[gas_nodes.size].body.y-event.y),
        						(gas_nodes[gas_nodes.size].body.x-event.x))
        local displacement = gas_nodes[gas_nodes.size].body.width / 2
        
        for i=0, distance, gas_nodes[gas_nodes.size].body.width do
            table.insert(gas_nodes,
            	gas_node:new(event.x+math.cos(angle)*displacement, 
                			event.y+math.sin(angle)*displacement))
            displacement = displacement + gas_nodes[gas_nodes.size+1].body.width / 2
            gas_nodes.size = gas_nodes.size+1
            if gas_nodes.size > gas_nodes.capacity then
                gase_nodes.done = true
                return
            end
        end
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
