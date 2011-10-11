barrel = require "explosives"

module(..., package.seeall)

buttons = {}
buttons.size = 0
grace = false

help_btn = {}
hint_btn = {}
text_blurb = {}
text = {}
text[1] = "Click on the barrel\nto detonate it.\n\nThe force of the\nexplosion will move\nnearby objects"
text[2] = "Draw a gas line\nbetween the crate\nand barrel\n\nIf you make a\nmistake, shake the\nphone to reset\nlevel"
text[3] = "You can only\ndetonate one barrel\nper level"
--text[4] = "Do your best!"
text[5] = "Water will \nextinguish any\nburning objects"

function help_btn:new(x, y)
    local instance = {}
    instance.image = display.newRect(x, y, 100, 50)
    instance.image:setFillColor(255, 0, 0)   
    instance.image:addEventListener("touch", instance)
    
    setmetatable(instance, {__index = help_btn})
    return instance
end

function help_btn:kill()
    self.image:removeSelf()
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

function text_blurb:new(i)
    local instance = {}
    instance.image = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    instance.image:setFillColor(0, 0, 0)
    instance.image:addEventListener("touch", instance)
    instance.title = display.newText("Hint:", display.contentWidth/2-50, 50, "Helvetica", 48)
    if text[i]~=nil then
        instance.text = display.newText(text[i], 50, 150, "Helvetica", 48)
    else
        instance.text = display.newText("You're on your\nown!", 50, 150, "Helvetica", 48)
    end
    instance.killed= false
    if barrel.barrel_lock == false then
        instance.changed_barrel = true
        barrel.barrel_lock = true
    else
        instance.changed_barrel = false
    end

    setmetatable(instance, {__index = text_blurb})
    return instance
end

function text_blurb:touch(event)
    if gas_covered < gas_allowed then
        grace = true
    end
    
    if self.changed_barrel == true then
        barrel.barrel_lock = false
    end
    
    self:kill()
end

function text_blurb:kill()
    if self.killed == false then
        self.image:removeSelf()
        self.title:removeSelf()
        self.text:removeSelf()
        self.killed = true
    end
end

function hint_btn:new(x, y)
    local instance = {}
    instance.image = display.newRect(x, y, 100, 50)
    instance.image:setFillColor(0, 0, 255)
    instance.image:addEventListener("touch", instance)
    instance.blurb = nil
    
    setmetatable(instance, {__index = hint_btn})
    return instance
end

function hint_btn:kill()
    if self.blurb~=nil then
        self.blurb:kill()
    end
    self.image:removeSelf()
end

function hint_btn:touch(event)
    if gas_covered < gas_allowed then
        grace = true
    end
    
    --spawn a help blurb
    if event.phase == "began" then
       self.blurb = text_blurb:new(level)
    end
end

function spawn_btn(x, y)
    buttons[buttons.size + 1] = help_btn:new(x, y)
    buttons[buttons.size + 2] = hint_btn:new(x+100, y)
    buttons.size = buttons.size + 2
end

function kill_buttons()
    size = buttons.size
    for i=size, 1, -1 do
        buttons[i]:kill()
        table.remove(buttons, i)
    end
    buttons.size = 0

end