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
title_lock = true
title_lock_b = true

gas_meter = {}
help_btn = {}
hint_btn = {}
text_blurb = {}
mode_btn = {}

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

--text = {}
--text[1] = "Click on the barrel \\n to detonate it. \\n \\n The force of the \\n explosion will move \\n nearby objects"
--text[2] = "Draw a gas line \n between the crate \n and barrel \n \n If you make a \n mistake, shake the \n phone to reset \n level"
--text[3] = "You can only \n detonate one barrel \n per level"
--text[4] = "Do your best!"
--text[5] = "Water will \n extinguish any \n burning objects"

function text_blurb:new(i)
    local instance = {}
    instance.image = display.newImage("HintScreen2.png")--display.newRect(0, 0, display.contentWidth, display.contentHeight)
    --instance.image:setFillColor(0, 0, 0)
    instance.text = {}
    instance.image:addEventListener("touch", instance)
    --instance.title = display.newText("Hint:", display.contentWidth/2-50, 50, "Helvetica", 48)
    if i==1 then
        instance.text[1] = display.newText("Click on the barrel", 50, 150, "Helvetica", 48)
        instance.text[2] = display.newText("to detonate it.", 50, 200, "Helvetica", 48)
        instance.text[3] = display.newText("The force of the", 50, 250, "Helvetica", 48)
        instance.text[4] = display.newText("explosion will move", 50, 300, "Helvetica", 48)
        instance.text[5] = display.newText("nearby objects.", 50, 350, "Helvetica", 48)
    elseif i==2 then
        instance.text[1] = display.newText("Draw a gas line", 50, 150, "Helvetica", 48)
        instance.text[2] = display.newText("between the crate", 50, 200, "Helvetica", 48)
        instance.text[3] = display.newText("and barrel.", 50, 250, "Helvetica", 48)
        instance.text[4] = display.newText("If you make a", 50, 300, "Helvetica", 48)
        instance.text[5] = display.newText("mistake, shake the", 50, 350, "Helvetica", 48)
        instance.text[6] = display.newText("phone to reset", 50, 400, "Helvetica", 48)
        instance.text[7] = display.newText("level.", 50, 450, "Helvetica", 48)
    elseif i==3 then
        instance.text[1] = display.newText("You can only", 50, 150, "Helvetica", 48)
        instance.text[2] = display.newText("detonate one barrel", 50, 200, "Helvetica", 48)
        instance.text[3] = display.newText("per level.", 50, 250, "Helvetica", 48)
    elseif i==5 then
        instance.text[1] = display.newText("Water will", 50, 150, "Helvetica", 48)
        instance.text[2] = display.newText("extinguish any", 50, 200, "Helvetica", 48)
        instance.text[1] = display.newText("burning objects.", 50, 250, "Helvetica", 48)
    else
        instance.text[1] = display.newText("You're on your", 50, 150, "Helvetica", 48)
        instance.text[2] = display.newText("own!", 50, 200, "Helvetica", 48)
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
        table_size = table.getn(self.text)
        for i=table_size, 1, -1 do
            self.text[i]:removeSelf()
        end
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
    if buttons[4] ~= nil then
        buttons[4].image.currentFrame = 9*cur_gas/gas_cap
    end
end

win_screen = {}

function win_screen:new()
    local instance = {}
    
    instance.background = display.newImage("WinScreen.png")
    
    setmetatable(instance, {__index = title_screen})
    return instance

end


flux = 100
flux_dir = true

title_screen = {}

function title_screen:new()
    local instance = {}
    instance.background = display.newImage("TitleScreenBackground.png")
    instance.background:addEventListener("touch", instance)
    instance.aura = display.newImage("TitleScreenAura.png")
    instance.foreground = display.newImage("TitleScreenTitle.png")
    instance.play = display.newImage("TitleScreenPlay.png")
    instance.play.x = 220
    instance.play.y =  400
    instance.credits = display.newImage("TitleScreenCredits.png")
    instance.credits.x = 220
    instance.credits.y = 500
    instance.credits_img = display.newImage("Credit_Screen.png")
    instance.credits_img.isVisible = false
    title_lock_b = false
    
    setmetatable(instance, {__index = title_screen})
    return instance

end

function title_screen:animate()
    if flux < 2 then
        flux_dir = true
    elseif flux > 99 then
        flux_dir = false
    end
    
    if flux_dir == true then
        flux = flux + 1
    else
        flux = flux -1
    end
    
    self.aura.alpha = flux/100

end

function title_screen:kill()
    self.background:removeSelf()
    self.aura:removeSelf()
    self.foreground:removeSelf()
    self.credits_img:removeSelf()
    self.play:removeSelf()
    self.credits:removeSelf()
end

function title_screen:touch(event)
    if event.phase == "began" then
        if self.credits_img.isVisible==false then
            if event.y < 500 and event.y > 300 then
                self:kill()
                title_lock = false
            elseif event.y > 500 and event.y < 700 then
                self.credits_img.isVisible=true
            end
        else
            self.credits_img.isVisible=false
        end
    end
end

function spawn_title()
    title = title_screen:new()
end

