math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable_module = require "flammable"
barrel = require "explosives"
crate = require "crate"
water = require "water"
gas = require "gas"

module(..., package.seeall)

text = {}
levels_capacity = {0, 150, 150, 150}
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
end

function spawn_level(level)
    reset_lock = false
    cur_level = level
    gas.gas_nodes.capacity = levels_capacity[level]
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
        crate.spawn_crate(display.contentWidth-50, 200)
    elseif level == 4 then
        crate.spawn_crate(400, 600)
        crate.spawn_crate(100, 100)
        barrel.spawn_barrel(160, 650)
        barrel.spawn_barrel(100, 750)
        water.spawn_water(150, 570)
        water.spawn_water(200, 600)
        water.spawn_water(250, 630)
    elseif level == 5 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(100,500)
        barrel.spawn_barrel(500,900)
        barrel.spawn_barrel(600,800)
        crate.spawn_crate(100,850)
        crate.spawn_crate(780,600)
        crate.spawn_crate(780,950)
    elseif level == 6 then
        crate.spawn_crate(100,100)
        crate.spawn_crate(100,1181)
        crate.spawn_crate(860,100)
        crate.spawn_crate(860,1181)
        barrel.spawn_barrel(440,814)
        barrel.spawn_barrel(520,814)
        barrel.spawn_barrel(480,854)
        barrel.spawn_barrel(440,894)
        barrel.spawn_barrel(520,894)
    elseif level == 7 then
        crate.spawn_crate(100,100)
        crate.spawn_crate(860,1200)
        barrel.spawn_barrel(480,854)
        water.spawn_water(100,300)
        water.spawn_water(860,1000)
    elseif level == 8 then
        barrel.spawn_barrel(100,100)
        crate.spawn_crate(100,300)
        crate.spawn_crate(300,300)
        crate.spawn_crate(100,900)
        crate.spawn_crate(300,1100)
    elseif level == 9 then
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
    elseif level == 10 then
        barrel.spawn_barrel(100,100)
        barrel.spawn_barrel(100,200)
        barrel.spawn_barrel(480,1054)
        crate.spawn_crate(200,150)
        crate.spawn_crate(600,300)
        crate.spawn_crate(480,854)
        crate.spawn_crate(480,1154)
        water.spawn_water(480,954)
    elseif level == 11 then
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
end
