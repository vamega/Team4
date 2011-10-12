barrel = require "explosives"
sprite = require "sprite"

module(..., package.seeall)

--animations
help_btn_sheet = sprite.newSpriteSheet("RangeButton.png", 100, 50)
help_btn_set = sprite.newSpriteSet(help_btn_sheet, 1, 2)
hint_btn_sheet = sprite.newSpriteSheet("HintButton.png", 100, 50)
hint_btn_set = sprite.newSpriteSet(hint_btn_sheet, 1, 2)
scroll_btn_sheet = sprite.newSpriteSheet("ScrollButton.png", 100, 50)
scroll_btn_set = sprite.newSpriteSet(scroll_btn_sheet, 1, 2)
gas_meter_sheet = sprite.newSpriteSheet("GasCan.png", 100, 75)
gas_meter_set = sprite.newSpriteSet(gas_meter_sheet, 1, 9)

buttons = {}
buttons.size = 0
grace = false
scroll_mode = false

gas_meter = {}
help_btn = {}
hint_btn = {}
text_blurb = {}
mode_btn = {}
text = {}
text[1] = "Click on the barrel\nto detonate it.\n\nThe force of the\nexplosion will move\nnearby objects"
text[2] = "Draw a gas line\nbetween the crate\nand barrel\n\nIf you make a\nmistake, shake the\nphone to reset\nlevel"
text[3] = "You can only\ndetonate one barrel\nper level"
--text[4] = "Do your best!"
text[5] = "Water will \nextinguish any\nburning objects"

function gas_meter:new(x, y)
    local instance = {}
    instance.image = sprite.newSprite(gas_meter_set)
    instance.image.x = x
    instance.image.y = y+37.5
    
    setmetatable(instance, {__index = gas_meter})
    return instance

end

function gas_meter:kill()
    self.image:removeSelf()
end

--sprite.newSprite(barrel_burning_set)
function mode_btn:new(x, y)
    local instance = {}
    instance.image = sprite.newSprite(scroll_btn_set)--display.newRect(x, y, 100, 50)
    instance.image.x = x
    instance.image.y = y + 25
    --instance.image:setFillColor(255,255,0)
    instance.image:addEventListener("touch", instance)

    setmetatable(instance, {__index=mode_btn})
    return instance
end

function mode_btn:kill()
    scroll_mode = false
    self.image:removeSelf()
end

function mode_btn:touch(event)
    if gas_covered < gas_allowed then
        grace = true
    end
    --switch between scroll mode and draw mode
    if event.phase == "began" then
        if scroll_mode == false then
            scroll_mode = true
            self.image.currentFrame = 2
            --self.image:setFillColor(255, 128, 0)
        else
            scroll_mode = false
            self.image.currentFrame = 1
            --self.image:setFillColor(255, 255, 0)
        end
    end

end

function help_btn:new(x, y)
    local instance = {}
    instance.image = sprite.newSprite(help_btn_set)--display.newRect(x, y, 100, 50)
    instance.image.x = x
    instance.image.y = y + 25
    --instance.image:setFillColor(255, 0, 0)
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
            self.image.currentFrame = 2
        else--circles need to be removed
            barrel.ghost_flag = false
            barrel.kill_ghosts()
            self.image.currentFrame = 1
        end
    end
end

function text_blurb:new(i)
    local instance = {}
    instance.image = display.newImage("HintScreen2.png")--display.newRect(0, 0, display.contentWidth, display.contentHeight)
    --instance.image:setFillColor(0, 0, 0)
    instance.image:addEventListener("touch", instance)
    --instance.title = display.newText("Hint:", display.contentWidth/2-50, 50, "Helvetica", 48)
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
        self.text:removeSelf()
        self.killed = true
    end
end

function hint_btn:new(x, y)
    local instance = {}
    instance.image = sprite.newSprite(hint_btn_set)--display.newRect(x, y, 100, 50)
    instance.image.x = x
    instance.image.y = y +25
    --instance.image:setFillColor(0, 0, 255)
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
    buttons[buttons.size + 3] = mode_btn:new(x-100, y)
    buttons[buttons.size + 4] = gas_meter:new(50, 0)
    buttons.size = buttons.size + 4
end

function kill_buttons()
    size = buttons.size
    for i=size, 1, -1 do
        buttons[i]:kill()
        table.remove(buttons, i)
    end
    buttons.size = 0

end

function animate_gas(gas_cap, cur_gas)
    if buttons[3] ~= nil then
        buttons[4].image.currentFrame = 9*cur_gas/gas_cap
    end
end