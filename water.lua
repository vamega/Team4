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
    mainDisplay:add(instance.body)
    
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
	        	--use flammable_obj as the key, with the value representing
	        	--the number of pools this object is in
	        	if objects_in_water[flammable_obj] == nil then
		            objects_in_water[flammable_obj] = 1
		        else
		        	objects_in_water[flammable_obj] =
		        		objects_in_water[flammable_obj] + 1
		        end
	        end
	    elseif flammable_obj.current_heat ~= nil then
	    	objects_in_water[flammable_obj] =
	    		objects_in_water[flammable_obj] - 1
	    	
	    	--remove the reference once the object has left all pools
	    	if objects_in_water[flammable_obj] <= 0 then
	    		objects_in_water[flammable_obj] = nil
	    	end
	    end
	end
end

function spawn_water(x, y)
    waters[waters.size + 1] = water:new(x, y)
    waters.size = waters.size + 1
end

function on_enter_frame(elapsed_time)
	for object, v in pairs(objects_in_water) do
		object.current_heat = object.current_heat
						- object.heat_increase_rate * 3 * elapsed_time
		if object.current_heat < 0 then
			object.current_heat = 0
		elseif object.current_heat >= object.flash_point then
			object.current_heat = object.flash_point - 1
		end
	end
end

function remove_all_water()
	for i, water in ipairs(waters) do
		water.body:removeSelf()
		waters[i] = nil
	end
	waters.size = 0
	
	for k, v in pairs(objects_in_water) do
		objects_in_water[k] = nil
	end
end
