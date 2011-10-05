flammable_module = require "flammable"

module(..., package.seeall)

local flammable = flammable_module.flammable

--a list of all crates
crates = {}
crates.size = 0

--the crate class
crate = {}
setmetatable(crate, {__index = flammable})

function crate:new(x, y)
	local instance = flammable:new(display.newRect(x, y, 50, 50))
	setmetatable(instance, {__index = crate})
	
	return instance
end

function crate:on_enter_frame(elapsed_time)
	flammable.on_enter_frame(self, elapsed_time)
	
	if self.current_heat >= self.flash_point then
		self.body:setFillColor(230, 140, 10)
	else
		self.body:setFillColor(180, 50, 10)
	end
end

function add_crate(x, y)
    crates[crates.size + 1] = crate:new(x, y)
    crates.size = crates.size + 1
end

--updates all crates
function on_enter_frame(elapsed_time)
	for i, crate in ipairs(crates) do
		crate:on_enter_frame(elapsed_time)
	end
end
