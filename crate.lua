utils = require "utils"
flammable_module = require "flammable"
local flammable = flammable_module.flammable

module(..., package.seeall)

--a list of all crates
crates = {}
crates.size = 0

--the crate class
crate = {}
setmetatable(crate, {__index = flammable})

function crate:new(x, y)
	local instance = flammable:new(display.newRect(x, y, 50, 50))
	setmetatable(instance, {__index = crate})
	
	--crates have plenty of health and burn slowly
	instance.health = 100
	instance.min_burn_rate = 1
	instance.max_burn_rate = 10
	
	return instance
end

function crate:on_enter_frame(elapsed_time)
	flammable.on_enter_frame(self, elapsed_time)
	
	if self.health <= 0 then
		return
	end
	
	if self.current_heat >= self.flash_point then
		self.body:setFillColor(230, 140, 10)
	else
		self.body:setFillColor(180, 50, 10)
	end
end

function crate:burn_up()
	table.remove(crates, utils.index_of(crates, self))
	
	flammable.burn_up(self)
end

function spawn_crate(x, y)
    crates[crates.size + 1] = crate:new(x, y)
    crates.size = crates.size + 1
end