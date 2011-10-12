math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable_module = require "flammable"
flammable = flammable_module.flammable
water = require "water"

module(..., package.seeall)

--the spritesheet
local barrel_burning_sheet = sprite.newSpriteSheet("WaterBarrel.png", 147, 200)
local barrel_burning_set = sprite.newSpriteSet(barrel_burning_sheet, 1, 8);

--the water barrel
water_barrel = {}
setmetatable(water_barrel, {__index = flammable})

function water_barrel:new(x, y)
	local image = sprite.newSprite(barrel_burning_set)
	image.x = x
	image.y = y
	mainDisplay.mainDisplay:insert(image)
	
	local instance = flammable:new(image, {radius = 70})
	
	instance.body.isFixedRotation = true
	instance.body.friction = 5
	
	instance.health = 100
	
	setmetatable(instance, {__index = water_barrel})
	
	return instance
end

function water_barrel:animate()
    if self.current_heat >= self.flash_point then
        self.body.currentFrame = (100-self.health)/10
    else
    	self.body.currentFrame = 1
    end
end

function water_barrel:on_enter_frame(elapsed_time)
	flammable.on_enter_frame(self, elapsed_time)
	
	self:animate()
end

function water_barrel:burn_up()
	flammable.burn_up(self)
	
	spawn_water_around(self.body.x, self.body.y, 70, 6)
	water.spawn_water(self.body.x, self.body.y)
end

function spawn_water_around(x, y, radius, water_count)
	local angle = 0
	local angle_increment = 2 * math.pi / water_count
	
	while angle < 2 * math.pi do
		water.spawn_water(x + radius * math.cos(angle),
						  y + radius * math.sin(angle))
		angle = angle + angle_increment
	end
end

function spawn_water_barrel(x, y)
	water_barrel:new(x, y)
end
