--TEAM FOUR MAIN

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)


--gas functions
local function add_gas(event)
    local gas_node = display.newCircle(event.x, event.y, 25)
    gas_node:setFillColor(255, 250, 205)
end


--event listeners
Runtime:addEventListener("touch", add_gas)