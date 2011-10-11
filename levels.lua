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
levels_capacity = {0, 700, 350, 500, 750, 400, 400,400,400,400,400,400}
level_pannable = {true, true, false, false, false, true, true, true, true, true, true}
background = display.newImage("background.png", 0, 0)
number_of_levels = 13
cur_level = 1
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
                mainDisplay:translate(0, 10)
                displacey = displacey + 10
            end
        elseif self.type == "bot" then
            if background.height + displacey > display.contentHeight then
                mainDisplay:translate(0, -10)
                displacey = displacey - 10
            end
        elseif self.type == "left" then
            if displacex < 0 then
                mainDisplay:translate(10, 0)
                displacex = displacex + 10
            end
        elseif self.type == "right" then
            --pan right if we can
            if background.width + displacex > display.contentWidth then
                mainDisplay:translate(-10, 0)
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
    
    gas.add_gas(event)
    
    if event.phase=="ended" or event.phase=="cancelled" then
        reset_edges()
    end

end

function scroll_update()
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
edges[1] = edge:new(0, 0, display.contentWidth, 30, "top")
edges[2] = edge:new(0, 0, 30, display.contentHeight, "left")
edges[3] = edge:new(display.contentWidth-30, 0, 30, display.contentHeight, "right")
edges[4] = edge:new(0, display.contentHeight-30, display.contentWidth, 30, "bot")

function reset_edges()
    for i=1, 4 do
        edges[i]:reset()
    end

end

function reset_level(event)
    if(event.isShake == true) then
        reset_lock = true
        mainDisplay:translate(-displacex, -displacey)
        kill_level()
        spawn_level(cur_level)
    end
end

function kill_level()
    barrel.barrel_lock = false
    scroll_lock = false
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
        background = display.newImage("background.png", 0, 0)
        mainDisplay:insert(background)
        barrel.spawn_barrel(100, 100)
        crate.spawn_crate(100, 200)
        crate.spawn_crate(100, 400)
    elseif level == 2 then
        background = display.newImage("background.png", 0, 0)
        mainDisplay:insert(background)
        barrel.spawn_barrel(100, 100)
        crate.spawn_crate(200,100)
        crate.spawn_crate(display.contentWidth-100, display.contentHeight-100)
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
    elseif level == 6 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(100,500)
        barrel.spawn_barrel(500,900)
        barrel.spawn_barrel(600,800)
        crate.spawn_crate(100,850)
        crate.spawn_crate(780,600)
        crate.spawn_crate(780,950)
    elseif level == 7 then
        crate.spawn_crate(100,100)
        crate.spawn_crate(100,1181)
        crate.spawn_crate(860,100)
        crate.spawn_crate(860,1181)
        barrel.spawn_barrel(440,814)
        barrel.spawn_barrel(520,814)
        barrel.spawn_barrel(480,854)
        barrel.spawn_barrel(440,894)
        barrel.spawn_barrel(520,894)
    elseif level == 8 then
        crate.spawn_crate(100,100)
        crate.spawn_crate(860,1200)
        barrel.spawn_barrel(480,854)
        water.spawn_water(100,300)
        water.spawn_water(860,1000)
    elseif level == 9 then
        barrel.spawn_barrel(100,100)
        crate.spawn_crate(100,300)
        crate.spawn_crate(300,300)
        crate.spawn_crate(100,900)
        crate.spawn_crate(300,1100)
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
        barrel.spawn_barrel(600,1200)
    elseif level == 11 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(100,200)
        barrel.spawn_barrel(480,1054)
        crate.spawn_crate(200,150)
        crate.spawn_crate(600,300)
        crate.spawn_crate(480,854)
        crate.spawn_crate(480,1154)
        water.spawn_water(480,954)
    elseif level == 12 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(600,1000)
        crate.spawn_crate(200,200)
        crate.spawn_crate(900,200)
        crate.spawn_crate(480,854)
        crate.spawn_crate(200,1200)
        crate.spawn_crate(800,1200)
        water.spawn_water(100,300)
        water.spawn_water(200,100)
        water.spawn_water(480,1100)
        water.spawn_water(600,1100)
    end
    buttons.spawn_btn(display.contentWidth-200, 0)  
end
