math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable_module = require "flammable"
barrel = require "explosives"
crate = require "crate"
water = require "water"
gas = require "gas"
buttons = require "buttons"
water_barrel = require "water_barrel"
mainDisplay = require "mainDisplay"

module(..., package.seeall)




edges = {}        --1  2   3    4   5       6  7    8   9   10  11  12  13 14   15
levels_capacity = {0, 600, 225, 500, 750, 500, 0,1100,700,900,1200,1200,300,500, 1300, 0}
level_pannable = {true, true, false, false, false, true, true, true, true, true, true,true,true,true,true, false}
background = display.newImage("Background1.png", 0, 0)
number_of_levels = 16

background = display.newImage("Background1.png", 0, 0)
mainDisplay.mainDisplay:insert(background)
number_of_levels = 17

cur_level = 0

reset_lock = false


displacex = 0
displacey = 0
edge = {}
function edge:new(x, y, w, h, t)
    local instance = {x=x, y=y}
    instance.image = display.newRect(x, y, w, h)
    instance.image.isVisible = false
    --instance.image:setFillColor(255,0,0)
    instance.type = t
    instance.scroll_lock = false
    
    
    --instance.image:addEventListener("touch", instance)
    setmetatable(instance, {__index = edge})
    return instance
end

function edge:reset()
    self.scroll_lock = false
end

function edge:scroll()
    if level_pannable[cur_level] == true then
        if self.type == "top" then
            if displacey < 0 then
                mainDisplay.mainDisplay:translate(0, 10)
                displacey = displacey + 10
            end
        elseif self.type == "bot" then
            if background.height + displacey > display.contentHeight then
                mainDisplay.mainDisplay:translate(0, -10)
                displacey = displacey - 10
            end
        elseif self.type == "left" then
            if displacex < 0 then
                mainDisplay.mainDisplay:translate(10, 0)
                displacex = displacex + 10
            end
        elseif self.type == "right" then
            --pan right if we can
            if background.width + displacex > display.contentWidth then
                mainDisplay.mainDisplay:translate(-10, 0)
                displacex = displacex - 10
            end
        end
    end
    --self.scroll_lock = false
end

function edge:contains(x, y)
    if self.x < x and self.image.width+self.x > x and self.y < y and self.image.height+self.y > y then
        return true
    end
    return false
end

function scrollTouch(event)
    for i=1, 4 do
        if edges[i]:contains(event.x, event.y)==true then
            --print(edges[i].type.." registered")
            edges[i].scroll_lock = true
        else
            edges[i].scroll_lock = false
        end
    end
    event.x = event.x-displacex
    event.y = event.y-displacey
    
    if buttons.scroll_mode == false then
        gas.add_gas(event)
    end
    
    if event.phase=="ended" or event.phase=="cancelled" then
        reset_edges()
    end

end

function scroll_update()
    buttons.animate_gas(gas.distance_allowed, gas.distance_covered)
    for i=1, 4 do
        if edges[i].scroll_lock == true then
            edges[i]:scroll()
        end
    end
end

--[[function edge:touch(event)
    self.scroll_lock = true
    self.ev = event
    print ("scroll activated"..self.type)
end]]

--add invisible scroll boundaries
edges[1] = edge:new(50, 50, display.contentWidth, 50, "top")
edges[2] = edge:new(0, 0, 50, display.contentHeight, "left")
edges[3] = edge:new(display.contentWidth-50, 0, 50, display.contentHeight, "right")
edges[4] = edge:new(0, display.contentHeight-50, display.contentWidth, 50, "bot")

function reset_edges()
    for i=1, 4 do
        edges[i]:reset()
    end

end

function reset_level(event)
    if(event.isShake == true) then
        reset_lock = true
        local prev_displacex = displacex
        local prev_displacey = displacey
        kill_level()
        spawn_level(cur_level)
        
    	mainDisplay.mainDisplay:translate(prev_displacex, prev_displacey)
    	displacex = prev_displacex
    	displacey = prev_displacey
    end
end

function kill_level()
    barrel.barrel_lock = false
    
    mainDisplay.mainDisplay:translate(-displacex, -displacey)
    displacex=0
    displacey=0
    
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
    if level == 0 then
        --intro level goes here
    elseif level == 1 then
        
        barrel.spawn_barrel(100, 100)
        crate.spawn_crate(100, 200)
        crate.spawn_crate(100, 400)
    elseif level == 2 then
        barrel.spawn_barrel(100, 100)
        crate.spawn_crate(200, 100)
        crate.spawn_crate(380, 754)
    elseif level ==3 then
        crate.spawn_crate(50, 50)
        crate.spawn_crate(50, 700)
        barrel.spawn_barrel(100, 300)
        barrel.spawn_barrel(100, 400)
        barrel.spawn_barrel(100, 500)
        crate.spawn_crate(430, 400)
    elseif level == 4 then
        crate.spawn_crate(400, 600)
        crate.spawn_crate(100, 100)
        barrel.spawn_barrel(160, 650)
        barrel.spawn_barrel(100, 750)
    elseif level == 5 then
        crate.spawn_crate(400, 550)
        crate.spawn_crate(100, 100)
        barrel.spawn_barrel(160, 650)
        barrel.spawn_barrel(100, 750)
        water.spawn_water(150, 600)
        water.spawn_water(200, 625)
        water.spawn_water(250, 650)
        water.spawn_water(300, 675)
        water.spawn_water(350, 700)
        water.spawn_water(400, 750)
    elseif level == 6 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(100,250)
        barrel.spawn_barrel(400,700)
        barrel.spawn_barrel(500,600)
        crate.spawn_crate(100,550)
        crate.spawn_crate(680,400)
        crate.spawn_crate(680,750)
    elseif level == 7 then
        crate.spawn_crate(100,100)
        crate.spawn_crate(100,781)
        crate.spawn_crate(860,100)
        crate.spawn_crate(860,781)
        barrel.spawn_barrel(440,414)
        barrel.spawn_barrel(520,414)
        barrel.spawn_barrel(480,454)
        barrel.spawn_barrel(440,494)
        barrel.spawn_barrel(520,494)
    elseif level == 8 then
        crate.spawn_crate(100,100)
        crate.spawn_crate(860,900)
        barrel.spawn_barrel(480,554)
        water.spawn_water(100,300)
        water.spawn_water(860,700)
    elseif level == 9 then
        barrel.spawn_barrel(100,100)
        crate.spawn_crate(100,250)
        crate.spawn_crate(250,250)
        crate.spawn_crate(100,700)
        crate.spawn_crate(300,900)
    elseif level == 10 then
        crate.spawn_crate(480,50)
        crate.spawn_crate(480,400)
        crate.spawn_crate(100,754)
        crate.spawn_crate(900,754)
        crate.spawn_crate(480,954)
        crate.spawn_crate(200,1150)
        crate.spawn_crate(800,1150)
        barrel.spawn_barrel(380,754)
        barrel.spawn_barrel(480,754)
        barrel.spawn_barrel(580,754)
        barrel.spawn_barrel(300,1200)
        barrel.spawn_barrel(480,1100)
        barrel.spawn_barrel(650,1200)
    elseif level == 11 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(100,200)
        barrel.spawn_barrel(480,950)
        crate.spawn_crate(200,150)
        crate.spawn_crate(600,300)
        crate.spawn_crate(480,600)
        crate.spawn_crate(480,954)
        water.spawn_water(480,754)
    elseif level == 12 then
        barrel.spawn_barrel(110,110)
        barrel.spawn_barrel(600,800)
        crate.spawn_crate(250,250)
        crate.spawn_crate(900,200)
        crate.spawn_crate(480,654)
        crate.spawn_crate(150,1100)
        crate.spawn_crate(700,1100)
        water.spawn_water(100,300)
        water.spawn_water(275,100)
        water.spawn_water(300,900)
        water.spawn_water(500,900)
    elseif level == 13 then
        barrel.spawn_barrel(150,250)
        barrel.spawn_barrel(600,200)
        barrel.spawn_barrel(400,500)
        barrel.spawn_barrel(300,600)
        barrel.spawn_barrel(550,700)
        crate.spawn_crate(250,400)
        crate.spawn_crate(475,375)
        crate.spawn_crate(275,800)
        crate.spawn_crate(500,650)
        crate.spawn_crate(450,950)
        crate.spawn_crate(850,950)
        water.spawn_water(600,1000)
        water.spawn_water(400,200)
    elseif level == 14 then
        barrel.spawn_barrel(200,200)
        barrel.spawn_barrel(500,700)
        water.spawn_water(150,375)
        water.spawn_water(315,360)
        water.spawn_water(350,200)
    elseif level == 15 then
        crate.spawn_crate(200,200)
        barrel.spawn_barrel(225,350)
        --crate.spawn_crate(400,200)
        barrel.spawn_barrel(350,400)
        barrel.spawn_barrel(350,600)
        crate.spawn_crate(175,625)
        crate.spawn_crate(225,900)
        barrel.spawn_barrel(175,1000)
        barrel.spawn_barrel(225,1000)
        barrel.spawn_barrel(300,1000)
        barrel.spawn_barrel(625,1000)
        crate.spawn_crate(700, 1000)
        barrel.spawn_barrel(800,250)
        crate.spawn_crate(800,400)
    elseif level == 16 then
        crate.spawn_crate(0, 0)
        buttons.win_screen:new()
    end
    if level~=16 then
        background:toBack()
        buttons.spawn_btn(display.contentWidth-150, 0)  
    end
end
