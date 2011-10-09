math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable = require "flammable"
barrel = require "explosives"
crate = require "crate"
water = require "water"

module(..., package.seeall)

function tutorial_level()
    crate.spawn_crate(100, 600)
    crate.spawn_crate(100, 100)
    crate.spawn_crate(200,300)
    explosives.spawn_barrel(150, 200)
    explosives.spawn_barrel(200, 600)
    explosives.spawn_barrel(200, 350)
    explosives.spawn_barrel(150, 400)
    water.load_water(300, 500)
    myText = display.newText("Draw a gas line between the crates", 0, 200, "Helvetica", 48)
    myText:setTextColor(255, 255, 255)
gas = require "gas"

module(..., package.seeall)

text = {}
levels_capacity = {0, 250, 250, 250}
level = 0

function kill_level()
    table_size = table.getn(text)
    for i=1, table_size do
        display.remove(text[i])
    end
    gas_nodes.capacity = 250
    gas_nodes.done = false
end

function tutorial_level()
    background = display.newImage("background.png")
    mainDisplay:insert(background)
    barrel.spawn_barrel(100, 100)
    crate.spawn_crate(100, 200)
    crate.spawn_crate(100, 400)
    text[1] = display.newText("Click on the\nbarrel to\ndetonate it", 
        200, 100, "Helvetica", 48)
    text[2] = display.newText("The force of\nthe explosion\n will move\n nearby objects",
        125, 400, "Helvetica", 48)
    
end

function level_one()
    background = display.newImage("background.png")
    mainDisplay:insert(background)

    barrel.spawn_barrel(100, 100)
    crate.spawn_crate(200,100)
    crate.spawn_crate(display.contentWidth-100, display.contentHeight-100)
    text[1]= display.newText("Draw a gas line \nbetween the crate\nand barrel", 0, 200, "Helvetica", 48)
    --background

end


function level_two()
    crate.spawn_crate(50, 50)
    crate.spawn_crate(50, 700)
    crate.spawn_crate(400, 300)
    barrel.spawn_barrel(100, 250)
    barrel.spawn_barrel(100, 300)
    barrel.spawn_barrel(100, 350)
    crate.spawn_crate(display.contentWidth-50, 200)
end



function level_three()
    crate.spawn_crate(400, 600)
    crate.spawn_crate(100, 100)
    barrel.spawn_barrel(150, 700)
    barrel.spawn_barrel(100, 800)

end

function level_four()


end

function level_five()

end