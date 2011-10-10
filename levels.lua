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
levels_capacity = {0, 150, 50, 100}
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
    
    water.remove_all_water()
end

function spawn_level(level)
    reset_lock = false
    cur_level = level
    gas.gas_nodes.capacity = levels_capacity[level]
    gas.gas_nodes.done = false
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
        water.spawn_water(150, 570)
        water.spawn_water(200, 600)
        water.spawn_water(250, 630)
    elseif level == 5 then
    
    end
end
