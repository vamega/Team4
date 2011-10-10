math = require "math"
utils = require "utils"
flammable_module = require "flammable"
flammable = flammable_module.flammable
sprite = require "sprite"

module(..., package.seeall)

--all gas nodes
gas_nodes = {}
gas_nodes.size = 0
gas_nodes.capacity = 250
gas_nodes.done = false
gas_nodes.lock = false

--THE GAS STATION

--animations for gas
gas_sheet = sprite.newSpriteSheet("FireBrush3.png", 30, 30)
gas_set = sprite.newSpriteSet(gas_sheet, 1,7)

--gasoline is made up of a number of small circular nodes
gas_node = {}
setmetatable(gas_node, {__index = flammable})
gas_metatable = {__index = gas_node}

--[[    local crateImage = sprite.newSprite(crate_burning_set)--display.newRect(x, y, 50, 50)
	crateImage.x = x
    crateImage.y = y
    
    local instance = flammable:new(crateImage, {density=5})
    mainDisplay:insert(crateImage)]]

function gas_node:new(x, y, angle)
    angle = 90+angle*(180/math.pi)
    print ("angle is "..angle)
	local radius = 15-10*(gas_nodes.size/gas_nodes.capacity)
    local nodeImage = sprite.newSprite(gas_set)
    nodeImage.x = x
    nodeImage.y = y
    local scale = 1-.66*(gas_nodes.size/gas_nodes.capacity)
    nodeImage:scale(scale, scale)
    nodeImage:rotate(angle)
	
    local instance = flammable:new(nodeImage, {density = 4000})
    
    instance.body.isSensor = true
    mainDisplay:insert(nodeImage)
    
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
        --self.body:setFillColor(255,0,0)
        self.body.currentFrame = 1+(120-self.health)/20
        --self.body.currentFrame = 1 + math.ceil((300-self.health) * self.frames_per_health_lost)
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
    
    local angle = 0
    
	if event.phase == "began" and gas_nodes.done == false then
        prev_touch_x = event.x
        prev_touch_y = event.y
        --return
    elseif event.phase == "moved" and gas_nodes.done == false then
        local distance = math.sqrt(utils.dist_squared(
        		prev_touch_x, prev_touch_y, event.x, event.y))
  
        angle = math.atan2(event.y - prev_touch_y,
        						event.x - prev_touch_x)
        local displacement = 0
        
        while displacement < distance do
            table.insert(gas_nodes,
            	gas_node:new(prev_touch_x+math.cos(angle)*displacement, 
                			prev_touch_y+math.sin(angle)*displacement, angle))
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
        table.insert(gas_nodes, gas_node:new(event.x, event.y, angle))
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
