math = require "math"
utils = require "utils"
flammable_module = require "flammable"
flammable = flammable_module.flammable

module(..., package.seeall)

--initialize gasoline container
gas_nodes = {}
gas_nodes.size = 0
gas_nodes.capacity = 250
gas_nodes.done = false

--all barrels onscreen
barrels = {}

--explosive barrels
barrel = {}
function barrel:new(x, y)
    local instance = flammable:new(display.newCircle(x, y, 50), true)
    
    instance.body.density = 1.0
    instance.body.friction = 5
    instance.body.bounce = 0
    
    --barrels catch fire more easily than normal and burn up quickly
    instance.flash_point = instance.flash_point - 5
    instance.health = 30
    
    setmetatable(instance, {__index = barrel})
    instance.body:addEventListener("touch", instance)
    
    return instance
end

--sets off the barrel when it's touched
function barrel:touch(event)
    if event.phase == "began" and self.dead == false then
        self:apply_heat(self.flash_point + 5)
    end
end

--makes the barrel explode shortly after catching fire
function barrel:on_enter_frame(elapsed_time)
	--update heat
	flammable.on_enter_frame(self, elapsed_time)
	
	--update the countdown if on fire
	if self.current_heat >= self.flash_point then
		--when on fire, the barrel is orange/yellow
		self.body:setFillColor(255, 180, 0)
		
		--the countdown counts down at a rate of at least 5 units per second
		self.explosion_countdown = self.explosion_countdown
				- math.max(5, self.current_heat - self.flash_point) * elapsed_time
		
		--the barrel explodes once the countdown ends
		--if self.explosion_countdown <= 0 then
			self:explode()
		--end
	else
		--when not on fire, the barrel is red
		self.body:setFillColor(255, 0, 0)
	end
end

--makes the barrel explode
function barrel:burn_up()
	if self.dead == false then
		self:removeSelf()
		table.remove(barrels, utils.index_of(barrels, self))
    	
    	spawn_explosion(self.x, self.y, 300, self.current_heat)
	end
end

function spawn_barrel(x, y)
    table.insert(barrels, barrel:new(x, y))
end

function spawn_explosion(x, y, radius, heat)
    for i, barrel in ipairs(barrels) do
        local xDist = barrel.x - x
        local yDist = barrel.y - y
    	local dist_squared = xDist^2 + yDist^2
        if x ~= barrel.x and y ~= barrel.y
        		and dist_squared < radius^2 then
            barrel:apply_heat(heat)
            
            local dist = math.sqrt(dist_squared)
            local force = (radius - dist) * 30
            barrel.image:applyLinearImpulse(
            				force * xDist / dist,
            				force * yDist / dist,
            				barrel.x, barrel.y)
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

function add_gas(event)
    if event.phase == "ended" then
        gas_nodes.done = true
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
            display.remove(gas_nodes[gas_nodes.size].image)
            table.remove(gas_nodes, gas_nodes.size)
            gas_nodes.size = gas_nodes.size -1
        end
    end
end
