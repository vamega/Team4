module(..., package.seeall)
explosives = require("explosives")

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

function water:new(x, y, i)--constructor
    local instance = {x=x, y=y, i=i, length = 40, height = 40}
    water.name = "water"
    instance.image = display.newRect(x, y, 70, 70)
    instance.image:setFillColor(0, 0, 255)
    physics.addBody(instance.image,"static", {bounce = 0.4} )
    setmetatable(instance, {__index = water})
    return instance
end

function load_water(x, y)
    waters[waters.size + 1] = water:new(x, y, waters.size + 1)
    waters.size = waters.size + 1
end

