module(..., package.seeall)
gas = require("gas")

--initialize water
waters = {}
waters.size = 0
buckets = {}
buckets.size = 0


--make water containers
--bucket = {}

--function bucket:new(x, y)--constructor
--    local instance = {x=x, y=y}

--a list of all objects in the water
objects_in_water = {}

--make individual water
water = {}

function water:new(x, y)--constructor
    local instance = {}
    instance.name = "water"
    instance.body = display.newCircle(x, y, 50)
    instance.body:setFillColor(0, 0, 255)
    physics.addBody(instance.body, "kinematic", {radius = 50})
    instance.body.isSensor = true
    instance.body:addEventListener("collision", instance)
    setmetatable(instance, {__index = water})
    return instance
end

function water:collision(event)
	if event.other.flammable ~= nil then
		flammable_obj = event.other.flammable
	    if(event.phase == "began") then
	        if getmetatable(flammable_obj) == gas.gas_metatable then
	            flammable_obj:burn_up()
	        elseif flammable_obj.current_heat ~= nil then
	            table.insert(objects_in_water, flammable_obj)
	        end
	    elseif flammable_obj.current_heat ~= nil then
	    	table.remove(objects_in_water, utils.index_of(objects_in_water,
	    				flammable_obj))
	    end
	end
end

function spawn_water(x, y)
    waters[waters.size + 1] = water:new(x, y)
    waters.size = waters.size + 1
end

function on_enter_frame(elapsed_time)
	for i, object in ipairs(objects_in_water) do
		object.current_heat = object.current_heat
						- object.heat_increase_rate * 3 * elapsed_time
		if object.current_heat < 0 then
			object.current_heat = 0
		elseif object.current_heat >= object.flash_point then
			object.current_heat = object.flash_point - 1
		end
	end
end
