barrel = require "explosives"

module(..., package.seeall)

buttons = {}
buttons.size = 0
grace = false

help_btn = {}

function help_btn:new(x, y)
    local instance = {}
    instance.image = display.newRect(x, y, 100, 50)
    instance.image:setFillColor(255, 0, 0)   
    instance.image:addEventListener("touch", instance)
    
    setmetatable(instance, {__index = help_btn})
    return instance
end

function help_btn:touch(event)
    if gas_covered < gas_allowed then
        grace = true
    end

    if event.phase == "began" then
        if barrel.ghost_flag == false then--spawn ghosts
            barrel.ghost_flag = true
            barrel.spawn_ghosts()
        else--circles need to be removed
            barrel.ghost_flag = false
            barrel.kill_ghosts()
        end
    end
end

function spawn_btn(x, y)
    buttons[buttons.size + 1] = help_btn:new(x, y)
    buttons.size = buttons.size + 1
end

function kill_buttons()
    size = buttons.size
    for i=size, 1, -1 do
        display.remove(buttons[i].image)
        table.remove(buttons, i)
    end
    buttons.size = 0

end

--[[function help_btn:kill()
    print("trying to kill button")
    display.remove(self.image)
    buttons.size = buttons.size - 1
end]]