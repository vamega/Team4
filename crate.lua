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
    local instance = flammable:new(crateImage)
    mainDisplay:insert(crateImage)
    instance.image = crateImage
	setmetatable(instance, {__index = crate})
	
	--crates have plenty of health, so they last a while
	instance.health = 300
	
	return instance
end

function crate:animate()
    if self.current_heat >= self.flash_point then
        self.image.currentFrame = (300-self.health)/37.5
    end

end

function crate:on_enter_frame(elapsed_time)
	flammable.on_enter_frame(self, elapsed_time)
	
	if self.health <= 0 then
		return
	end
	
    self:animate()
	--if self.current_heat >= self.flash_point then
	--	self.body:setFillColor(230, 140, 10)
	--else
	--	self.body:setFillColor(180, 50, 10)
	--end
end

function crate:burn_up()
	table.remove(crates, utils.index_of(crates, self))
	
	flammable.burn_up(self)
end

function spawn_crate(x, y)
    crates[crates.size + 1] = crate:new(x, y)
    crates.size = crates.size + 1
end
