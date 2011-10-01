--TEAM FOUR MAIN

local gas_nodes = {}
gas_nodes.size = 0

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)

local function add_gas(event)
    local gas_node = display.newCircle(event.x, event.y, 25)
    gas_node:setFillColor(255, 250, 205)
    gas_nodes[gas_nodes.size + 1] = gas_node
    gas_nodes.size = gas_nodes.size + 1
end

local function erase_gas(event)
    while gas_nodes.size > 0 do
        display.remove(gas_nodes[gas_nodes.size])
        gas_nodes.size = gas_nodes.size -1
    end
end


--event listeners
Runtime:addEventListener("touch", add_gas)

Runtime:addEventListener("accelerometer", erase_gas)