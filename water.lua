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



--make individual water
water = {}

function water:new(x, y)--constructor
    local instance = {}
    instance.name = "water"
    instance.body = display.newRect(x, y, 70, 70)
    instance.body:setFillColor(0, 0, 255)
    physics.addBody(instance.body,"static")
    instance.body.isSensor = true
    instance.body:addEventListener("collision", instance)
    setmetatable(instance, {__index = water})
    return instance
end

function water:collision(event)
    if(event.phase == "began") then
        if(getmetatable(event.other) == gas.gas_metatable)then
            event.other:burn_up()
        elseif(event.other.current_heat ~= nil) then
            event.other.current_heat = 0
        end
        
    end
end

function load_water(x, y)
    waters[waters.size + 1] = water:new(x, y)
    waters.size = waters.size + 1
end

