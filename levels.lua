math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable_module = require "flammable"
barrel = require "explosives"
crate = require "crate"
water = require "water"
gas = require "gas"
buttons = require "buttons"

module(..., package.seeall)

edges = {}

edge = {}
function edge:new(x, y, w, h, t)
    local instance = {}
    instance.image = display.newRect(x, y, w, h)
    --instance.image.isVisible = false
    instance.image:setFillColor(255,0,0)
    instance.type = t
    
    instance.image:addEventListener("touch", instance)
    setmetatable(instance, {__index = edge})
    return instance
end

function edge:touch(event)
    print("registered touch")
    if level_pannable[cur_level] == true then
        if self.type == "top" then
            if background.y < 0 then
                mainDisplay:translate(0, 10)
            end
        elseif self.type == "bot" then
            if background.height > display.contentHeight then
                mainDisplay:translate(0, -10)
            end
        elseif self.type == "left" then
            if background.x < 0 then
                mainDisplay:translate(10, 0)
            end
        elseif self.type == "right" then
            --pan right if we can
            if background.x > display.contentHeight then
                mainDisplay:translate(-10, 0)
            end
        end
    end
end

--add invisible scroll boundaries
edges[1] = edge:new(0, 0, display.contentWidth, 30, "top")
edges[2] = edge:new(0, 0, 30, display.contentHeight, "left")
edges[3] = edge:new(display.contentWidth-30, 0, 30, display.contentHeight)
edges[4] = edge:new(0, display.contentHeight-30, display.contentWidth, 30)

text = {}
levels_capacity = {0, 700, 350, 500, 500}
level_pannable = {false, false, false, false, false}
background = display.newImage("background.png")
number_of_levels = 6
cur_level = 1
reset_lock = false


function reset_level(event)
    if(event.isShake == true) then
        reset_lock = true
        kill_level()
        spawn_level(cur_level)
    end
end

function kill_level()
    table_size = table.getn(text)
    for i=1, table_size do
        display.remove(text[i])
    end
    
    table_size = table.getn(flammable_module.flammable_list)
    for i =table_size, 1, -1 do
        flammable_module.flammable_list[i]:burn_up()
    end
    buttons.kill_buttons()
    barrel.ghost_flag = false
    
    water.remove_all_water()
end

function spawn_level(level)
    reset_lock = false
    cur_level = level
    gas.distance_allowed = levels_capacity[level]
    gas.distance_covered = 0
    if level == 1 then
        background = display.newImage("background.png")
        mainDisplay:insert(background)
        barrel.spawn_barrel(100, 100)
        crate.spawn_crate(100, 200)
        crate.spawn_crate(100, 400)
        text[1] = display.newText("Click on the\nbarrel to\ndetonate it", 
            200, 100, "Helvetica", 48)
        text[2] = display.newText("The force of\nthe explosion\n will move\n nearby objects",
            125, 400, "Helvetica", 48)
    elseif level == 2 then
        background = display.newImage("background.png")
        mainDisplay:insert(background)
        barrel.spawn_barrel(100, 100)
        crate.spawn_crate(200,100)
        crate.spawn_crate(display.contentWidth-100, display.contentHeight-100)
        text[1]= display.newText("Draw a gas line \nbetween the crate\nand barrel", 0, 200, "Helvetica", 48)
        text[2] = display.newText("If you mess up\nshake the phone\nto reset level", 0, 400, "Helvetica", 48)
    elseif level ==3 then
        crate.spawn_crate(50, 50)
        crate.spawn_crate(50, 700)
        barrel.spawn_barrel(100, 300)
        barrel.spawn_barrel(100, 400)
        barrel.spawn_barrel(100, 500)
        crate.spawn_crate(display.contentWidth-50, 400)
    elseif level == 4 then
        crate.spawn_crate(400, 600)
        crate.spawn_crate(100, 100)
        barrel.spawn_barrel(160, 650)
        barrel.spawn_barrel(100, 750)
    elseif level == 5 then
        crate.spawn_crate(400, 600)
        crate.spawn_crate(100, 100)
        barrel.spawn_barrel(160, 650)
        barrel.spawn_barrel(100, 750)
        water.spawn_water(150, 570)
        water.spawn_water(200, 600)
        water.spawn_water(250, 630)
    end
    buttons.spawn_btn(300, 0)  
end
