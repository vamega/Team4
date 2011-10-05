physics = require "physics"
math = require "math"
table = require "table"
utils = require "utils"

module(..., package.seeall)

--a superclass for all flammable objects
flammable = {}

--takes an image and converts it to a flammable physics object
--if object_shape is defined, it is used as the shape of the physics
--object; otherwise, the object will be defined as a circle or rectangle
--depending on whether circular is specified
function flammable:new(image, circular, object_shape, collision_filter)
	instance = {body=image}
	instance.body.flammable = instance
	
	--convert to a physics object
	if object_shape then
		--use a polygonal physics object
		physics.addBody(instance.body, "dynamic", {bounce=0.1,
					shape=object_shape, filter=collision_filter})
	elseif circular then
		--use a circular physics object
		physics.addBody(instance.body, "dynamic", {bounce=0.1,
					radius=instance.body.width/2, filter=collision_filter})
	else
		--use a rectangular physics object
		physics.addBody(instance.body, "dynamic", {bounce=0.1,
					filter=collision_filter})
	end
	
	instance.body.linearDamping = 3
	instance.body.angularDamping = 3
	
	--current_heat increases by heat_increase_rate units per second
	--if this is touching a burning object; when current_heat
	--passes flash_point, this object starts to burn
	--(note that current_heat never decreases, but it also never
	--goes higher than the heat value of the hottest nearby object)
	instance.current_heat = 0
	instance.heat_increase_rate = 20
	instance.flash_point = 20
	
	--when this object is on fire, it burns up and eventually is removed
	--health represents how long it has left, and min_burn_rate/max_burn_rate
	--represent how slowly/quickly it can burn (if it is just barely at
	--the flash point, it will burn at min_burn_rate, whereas if it is
	--much hotter, it will burn at up to max_burn_rate)
	instance.health = 50
	instance.min_burn_rate = 2
	instance.max_burn_rate = 15
	
	instance.nearby_objects={}
	
	setmetatable(instance, {__index = flammable})
	instance.body:addEventListener("collision", instance)
	return instance
end

--this will be called whenever a flammable object collides with
--or stops touching another object
function flammable:collision(event)
	local other = event.other
	
	--ignore objects that aren't flammable
	if other.flammable == nil then
		return
	end
	
	--other.flammable is actually a reference to the flammable data
	--structure associated with that body
	if(event.phase == "began") then
		table.insert(self.nearby_objects, other.flammable)
	else
		table.remove(self.nearby_objects, utils.index_of(
							self.nearby_objects, other.flammable))
	end
end

--removes a flammable object when it fully burns up
function flammable:burn_up()
	self.body:removeSelf()
end

--increases a flammable object's heat if it is touching burning objects
function flammable:on_enter_frame(elapsed_time)
	local highest_heat_value = 0
	
	--find the hottest burning object touching this
	for i, object in ipairs(self.nearby_objects) do
		if object.current_heat > highest_heat_value and 
				object.current_heat >= object.flash_point then
			highest_heat_value = object.current_heat
		end
	end
	
	--increase this object's heat to approach the highest heat value found
	if highest_heat_value > self.current_heat then
		self.current_heat = math.min(highest_heat_value,
							self.current_heat +
							self.heat_increase_rate * elapsed_time)
	end
	
	--if this is on fire, decrease its health
	if self.current_heat >= self.flash_point then
		self.health = self.health - math.max(self.min_burn_rate,
					  			math.min(self.max_burn_rate,
								self.current_heat - self.flash_point))
		
		if self.health <= 0 then
			self:burn_up()
		end
	end
end

--increases the flammable object's heat to match the given heat value
function flammable:apply_heat(heat)
	--TODO: increase this based on heat_increase_rate rather than all the way
	self.current_heat = heat
end
