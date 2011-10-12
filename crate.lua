math = require "math"
utils = require "utils"
flammable_module = require "flammable"
sprite = require "sprite"
local flammable = flammable_module.flammable

module(..., package.seeall)

--a list of all crates
crates = {}
crates.size = 0

--animations for crate
crate_burning_sheet = sprite.newSpriteSheet("crate_burning.png", 150, 150)
crate_burning_set = sprite.newSpriteSet(crate_burning_sheet, 1, 8)

--the crate class
crate = {}
setmetatable(crate, {__index = flammable})

function crate:new(x, y)
    local crateImage = sprite.newSprite(crate_burning_set)--display.newRect(x, y, 50, 50)
	crateImage.x = x
    crateImage.y = y
    
    local instance = flammable:new(crateImage, {density=5})
    mainDisplay.mainDisplay:insert(crateImage)
    
    instance.flash_point = instance.flash_point - 3
	instance.heat_increase_rate = instance.heat_increase_rate + 4
	instance.health = 200
    
	setmetatable(instance, {__index = crate})
	
	local frame_count = 8
	instance.frames_per_health_lost = (frame_count - 1) / instance.health
	
	return instance
end

function crate:animate()
    if self.current_heat >= self.flash_point then
        self.body.currentFrame = 1 + math.ceil((200-self.health) * self.frames_per_health_lost)
    end
end

function crate:on_enter_frame(elapsed_time)
	flammable.on_enter_frame(self, elapsed_time)
	
	if self.health > 0 then
		self:animate()
	end
end

function crate:burn_up()
	table.remove(crates, utils.index_of(crates, self))
	crates.size = crates.size -1
	flammable.burn_up(self)
end

function spawn_crate(x, y)
    crates[crates.size + 1] = crate:new(x, y)
    crates.size = crates.size + 1
end
