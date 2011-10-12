math = require "math"
utils = require "utils"
flammable_module = require "flammable"
flammable = flammable_module.flammable
sprite = require "sprite"
button = require "buttons"

module(..., package.seeall)

--all gas nodes
gas_nodes = {}
distance_covered = 0
distance_allowed = 300

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

function gas_node:new(x, y, angle, radius)
    local nodeImage = sprite.newSprite(gas_set)
    --print(mainDisplay.mainDisplay.xScale)
    nodeImage.x = x * (1/mainDisplay.mainDisplay.xScale)
    nodeImage.y = y * (1/mainDisplay.mainDisplay.yScale)
    
    local scale = radius/15
    nodeImage:scale(scale, scale)
    nodeImage:rotate(angle)
	
    local instance = flammable:new(nodeImage, {density = 4000, radius = radius})
    
    instance.body.isSensor = true
    mainDisplay.mainDisplay:insert(nodeImage)
    
    --gas starts burning early and gets hot quickly
    instance.flash_point = 4
    instance.heat_increase_rate = 50 - radius / 3
    instance.health = 180
    
    setmetatable(instance, gas_metatable)
    return instance
end

function gas_node:on_enter_frame(elapsed_time)
    --update heat
    flammable.on_enter_frame(self, elapsed_time)
    --update animation
    self:animate()
end

function gas_node:animate()
    if self.current_heat >= self.flash_point then
        self.body.currentFrame = 1+(120-self.health)/20
    end
end

function gas_node:burn_up()
	flammable.burn_up(self)
	
	table.remove(gas_nodes, utils.index_of(gas_nodes, self))
end

local prev_touch_x = 0
local prev_touch_y = 0

function add_gas(event)
    if event.phase == "ended" then
        if button.grace == false then
            distance_covered = distance_allowed
            return
        else
            button.grace = false
        end
    end
    
    local angle = 0
    local image_angle = 90
    
	if event.phase == "began" and distance_covered < distance_allowed then
        prev_touch_x = event.x
        prev_touch_y = event.y
        --return
    elseif event.phase == "moved" and distance_covered < distance_allowed then
        local distance = math.sqrt(utils.dist_squared(
        		prev_touch_x, prev_touch_y, event.x, event.y))
        
  		--don't respond until the pointer has travelled a significant distance
  		if distance < 10 then
  			return
  		end
        
        distance = math.min(distance_allowed - distance_covered, distance)
  		
        angle = math.atan2(event.y - prev_touch_y,
        						event.x - prev_touch_x)
        image_angle = 90+angle*(180/math.pi)
        local displacement = 0
        local new_node = nil
        local radius = 15
        
        while displacement < distance do
        	radius = 15 - 10 * (distance_covered + displacement) / distance_allowed
        	new_node = gas_node:new(prev_touch_x+math.cos(angle)*displacement, 
                		prev_touch_y+math.sin(angle)*displacement, image_angle,
                		radius)
            table.insert(gas_nodes, new_node)
            displacement = displacement + radius
        end
        
        --displacement may be slightly greater than distance, so we have
        --to calculate exactly where the endpoint was
        prev_touch_x = prev_touch_x + math.cos(angle)*displacement
        prev_touch_y = prev_touch_y + math.sin(angle)*displacement
        
        distance_covered = distance_covered + displacement
    end
    
	--[[if gas_nodes.size < gas_nodes.capacity and gas_nodes.done == false then
        table.insert(gas_nodes, gas_node:new(event.x, event.y, image_angle))
        gas_nodes.size = gas_nodes.size + 1
    end]]
end

function reset_gas()
    distance_covered = 0
    for k, v in pairs(gas_nodes) do
    	v:burn_up()
    	gas_nodes[k] = nil
    end
end
